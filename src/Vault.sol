// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Vault is ERC20, IERC4626 {
    using SafeERC20 for IERC20;

    IERC20 private immutable _asset; // Definition of the asset token

    constructor(IERC20 assetToken_) ERC20("Share Vault Token", "SVT") {
        _asset = assetToken_;
    }

    function asset() external view override returns (address) {
        return address(_asset);
    }

    function totalAssets() external view override returns (uint256) {
        return _asset.balanceOf(address(this));
    }
}
