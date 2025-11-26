//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {MockToken} from "../src/MockToken.sol";

contract MockTokenTest is Test {
    MockToken public token;

    function setUp() public {
        token = new MockToken();
    }

    function test_constructing() public view {
        // Initial token constructing test
        assertEq(token.name(), "MockToken");
        uint256 creator_balance = token.balanceOf(address(this));
        assertEq(creator_balance, 1000000 * 10 ** token.decimals());
    }

    function test_transfer() public {
        // Test standard transfer function
        uint256 summ = 100;
        address receiver = address(0x123);
        uint256 inititalBalance = token.balanceOf(address(this));
        bool success = token.transfer(receiver, summ);
        assertTrue(success, "Transfer returned not True");

        assertEq(token.balanceOf(receiver), summ, "Receiver balance must increase");

        assertEq(token.balanceOf(address(this)), inititalBalance - summ, "Sender's balance should decrease");
    }

    function test_mint() public {
        // Verify mint
        address user = makeAddr("user");
        uint256 amount = 20000;

        token.mint(user, amount);
        assertEq(token.balanceOf(user), amount);
    }

    function test_transferFrom() public {
        // Verify transferFrom and allowance
        uint256 summ = 100;
        address spender = makeAddr("spender");
        address owner = address(this);
        address receiver = makeAddr("receiver");

        bool success = token.approve(spender, summ);
        assertTrue(success, "Allowance opetation should be succesful");

        uint256 allowance = token.allowance(owner, spender);
        assertEq(allowance, summ, "Allowance summ is not equal to approved one");

        vm.prank(spender);
        success = token.transferFrom(owner, receiver, summ);
        assertTrue(success, "Transfer from operation must be succesfull");
        assertEq(token.balanceOf(receiver), summ);
        assertEq(token.allowance(owner, spender), 0, "Allowance should be spend");
    }

    function testRevert_transferToZeroAddress() public {
        // Verify revert on transfer to addres(0)
        vm.expectRevert(abi.encodeWithSignature("ERC20InvalidReceiver(address)", address(0)));
        token.transfer(address(0), 100);
    }
}
