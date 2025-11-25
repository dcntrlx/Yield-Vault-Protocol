1. I have to write override keyword when implementing an interface's function
2.  adopting error CustomError() instead of string revert messages (cheaper gas).
3. I m supposed to use safeERC20 for any tokens not developed by me(not determinated)
4. throw keyword in Solidity is deprecated and was removed in version 0.5.0. In older versions of Solidity, throw was used to stop the execution of a contract, revert all state changes, and consume all remaining transaction gas.
5. SafeERC20 is a wrapper library by OpenZeppelin designed to handle non-compliant ERC-20 tokens safely
6 safeERC20 also provides trySafeTransfer and trySafeTransferFrom functions that return a boolean instead of reverting if the operation is not successful, thats useful for distributing e.g. operations where one ffailure is appropriate
7. ERC1363 allows contract to receive a callback function with transfer or approval

8. Standard Solidity style is to place using directives inside the contract, at the very top, before any state variables or functions.
9 foundry.toml allows to configure editors settings also using fmt directive
10. Events when implementing an interface dont need to be reimplemented
11. In EIP4626 we are checking for limits e.g maxMint, maxDeposit only in execution functions, not in preview functions
12. Visibility of functions realized from interface implemented can become more accessible e.g. external -> public, but not in the other direction
13 It's reccommende to use uint256 instead of uint for explicity and style. if fact uint = uint256
14. type(uint256).max must be used to get max of type. It's more clear and optimized and the only correct such 2**256 is not correct at all