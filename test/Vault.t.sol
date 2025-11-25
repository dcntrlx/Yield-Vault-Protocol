// SPDX-Licence-Identifier MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {MockToken} from "../src/MockToken.sol";
import {Vault} from "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;
    MockToken public token;
    address public tokenDeployer = makeAddr("tokenDeployer");

    function _createUnderlyingToken() internal {
        vm.prank(tokenDeployer);
        token = new MockToken();
    }

    function setUp() public {
        _createUnderlyingToken();
        vault = new Vault(token);
    }

    function test_convertToShares() public {
        uint256 assets = 100000;
        uint256 shares = vault.convertToShares(assets);
        assertEq(shares, assets);
    }

    function test_convertToAssets() public {
        uint256 shares = 100000;
        uint256 assets = vault.convertToAssets(shares);
        assertEq(assets, shares);
    }

    function test_isAssetCorrect() public {
        assertEq(vault.asset(), address(token));
        console.log("Token: ", address(token));
    }

    function _deposit(uint256 amount) internal returns (address depositor, uint256 shares) {
        uint256 assets = amount;
        depositor = makeAddr("Depositor");

        vm.prank(tokenDeployer);
        token.mint(depositor, assets);

        vm.startPrank(depositor);
        token.approve(address(vault), amount);
        shares = vault.deposit(assets, depositor);
        assertEq(shares, assets, "Assets deposited on new contract must be equal to shares");

        assertEq(shares, vault.balanceOf(depositor), "Shares must be acquired");
        vm.stopPrank();
    }

    function test_deposit() public {
        (address depositor, uint256 shares) = _deposit(10000);
    }

    function test_withdraw() public {
        uint256 assets = 100000;
        (address depositor, uint256 shares) = _deposit(assets);
        vm.startPrank(depositor);
        uint256 sharesWithdrown = vault.withdraw(assets, depositor, depositor);
        console.log(assets, shares, sharesWithdrown);
        assertEq(sharesWithdrown, shares, "Shares before and after loop must be the same value(here)");
        vm.stopPrank();
    }
}
