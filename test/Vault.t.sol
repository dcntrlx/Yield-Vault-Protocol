// SPDX-Licence-Identifier MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {MockToken} from "../src/MockToken.sol";
import {Vault} from "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;
    MockToken public token;

    function _createUnderlyingToken() internal {
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
}
