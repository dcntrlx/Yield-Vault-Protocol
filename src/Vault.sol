// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract Vault is ERC20, IERC4626 {
    using SafeERC20 for IERC20;
    using Math for uint256;

    IERC20 private immutable _asset; // Definition of the asset token

    constructor(IERC20 assetToken_) ERC20("Share Vault Token", "SVT") {
        _asset = assetToken_;
    }

    function asset() external view override returns (address assetTokenAddress) {
        assetTokenAddress = address(_asset);
    }

    function totalAssets() external view returns (uint256 totalManagedAssets) {
        totalManagedAssets = _asset.balanceOf(address(this)); // May be not correct if tokens during strategy are sent to different place
    }

    function convertToShares(uint256 assets) public view override returns (uint256 shares) {
        shares = _convertToShares(assets, Math.Rounding.Floor);
    }

    function convertToAssets(uint256 shares) public view override returns (uint256 assets) {
        assets = _convertToAssets(shares, Math.Rounding.Floor);
    }

    // Deposit block
    function maxDeposit(address receiver) public view override returns (uint256 maxAssets) {
        maxAssets = type(uint256).max;
    }

    function previewDeposit(uint256 assets) external view returns (uint256 shares) {
        shares = _convertToShares(assets, Math.Rounding.Floor);
    }

    function deposit(uint256 assets, address receiver) external returns (uint256 shares) {
        require(assets <= maxDeposit(receiver));
        shares = _convertToShares(assets, Math.Rounding.Floor);
        require(shares > 0, "Your assets is not enough to mint a single share"); // User protection. Not required by EIP4626
        _asset.safeTransferFrom(msg.sender, address(this), assets);
        _mint(receiver, shares);
        emit Deposit(msg.sender, receiver, assets, shares);
    }

    // Mint block
    function maxMint(address receiver) public view returns (uint256 maxShares) {
        maxShares = type(uint256).max;
    }

    function previewMint(uint256 shares) external view returns (uint256 assets) {
        assets = _convertToAssets(shares, Math.Rounding.Ceil);
    }

    function mint(uint256 shares, address receiver) external returns (uint256 assets) {
        require(shares <= maxMint(receiver), "Shares to be minted will exceed the limit");
        assets = _convertToAssets(shares, Math.Rounding.Ceil);
        _asset.safeTransferFrom(msg.sender, address(this), assets);
        _mint(receiver, shares);
        emit Deposit(msg.sender, receiver, assets, shares);
    }

    // Withdraw block
    function maxWithdraw(address owner) external view returns (uint256 maxAssets) {
        maxAssets = _convertToAssets(balanceOf(owner), Math.Rounding.Floor);
    }

    function previewWithdraw(uint256 assets) external view returns (uint256 shares) {
        shares = _convertToShares(assets, Math.Rounding.Ceil);
    }

    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256 shares) {
        shares = _convertToShares(assets, Math.Rounding.Ceil);
        if (owner != msg.sender) {
            _spendAllowance(owner, msg.sender, shares);
        }
        require(balanceOf(owner) >= shares, "You dont have enough shares to withdraw this amount of assets");
        _burn(owner, shares);
        _asset.safeTransfer(receiver, assets);
        emit Withdraw(msg.sender, receiver, owner, assets, shares);
    }

    // Redeem block
    function maxRedeem(address owner) external view returns (uint256 maxShares) {
        maxShares = balanceOf(owner);
    }

    function previewRedeem(uint256 shares) external view returns (uint256 assets) {
        assets = _convertToAssets(shares, Math.Rounding.Floor);
    }

    function redeem(uint256 shares, address receiver, address owner) external returns (uint256 assets) {
        if (msg.sender != owner) {
            _spendAllowance(owner, msg.sender, shares);
        }
        assets = _convertToAssets(shares, Math.Rounding.Floor);
        require(assets > 0, "You will not get any single share for this amount of assets");
        _burn(owner, shares);
        _asset.safeTransfer(receiver, assets);
        emit Withdraw(msg.sender, receiver, owner, assets, shares);
    }

    function _convertToShares(uint256 assets, Math.Rounding rounding) internal view returns (uint256 shares) {
        shares = assets.mulDiv(totalSupply() + 1, totalAssets() + 1, rounding);
    }

    function _convertToAssets(uint256 shares, Math.Rounding rounding) internal view returns (uint256 assets) {
        assets = shares.mulDiv(totalAssets() + 1, totalSupply() + 1, rounding);
    }
}
