// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol"

contract MockToken is ERC20 {  // Creating a mock toke for vault testing
    constructor() ERC20("MockToken", "MTK") {
        _mint(msg.sender, 1000000 * 10**decimals());
    }
}