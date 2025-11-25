//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ProtectedVault} from "../src/ProtectedVault.sol";
import {MockToken} from "../src/MockToken.sol";
import {console} from "forge-std/console.sol";

contract ProtectedVaultTest is Test {
    ProtectedVault public vault;
    MockToken public token;
    address public tokenDeployer = makeAddr("tokenDeployer");

    function _createUnderlyingToken() internal {
        vm.prank(tokenDeployer);
        token = new MockToken();
    }

    function setUp() public {
        _createUnderlyingToken();
        vault = new ProtectedVault(token);
    }

    function test_inflationAttack() public {
        // simulating an inflation attack on protected vault
        address attacker = makeAddr("Attacker");
        address victim = makeAddr("Victim");

        vm.prank(tokenDeployer);
        token.mint(attacker, 10 ** 18);

        vm.startPrank(attacker);
        token.approve(address(vault), 1);
        uint256 shares = vault.deposit(1, attacker);
        token.transfer(address(vault), 10 ** 17);
        uint256 tokensPerShare = vault.convertToAssets(1);
        console.log("Tokens per share", tokensPerShare);
        vm.stopPrank();

        vm.prank(tokenDeployer);
        uint256 assetsToDeposit = 10 ** 15;
        token.mint(victim, assetsToDeposit);

        vm.startPrank(victim);
        token.approve(address(vault), assetsToDeposit);

        uint256 assets = vault.convertToAssets(1);
        console.log(assets);

        uint256 sharesForDepositedAssets = vault.deposit(assetsToDeposit, victim); // inflation attack prevented.
        // Note: inflational attack is still possible and attacker still can make an inflational attack
        // multypliyng assetts which are donated by 10**virtual_offset, but attacker will no able because he will never that amount of money
    }
}
