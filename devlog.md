1. MockToken was established as underlying token for tests in Vault.sol
2. Vault.sol implemented IERC4626 as an interfaces declaring how tokenized vault are supposed to be established. IERC4626 from OpenZeppelin was chosen because of its popularity, verification and massive audits. 
3. All function of IERC4626 were implemented. Also two private functions _convertToShares and _convertToAssets were implemented to convert assets to shares and opposite and to prevent code duplication.
4. EIP4626 requires rounding to different values in different functions. Math.Rounding enum was used to implement this. ROunding parameter was added to _convertToShares and _convertToAssets functions.
5. Also Ive used mulDiv from Math library because it is prevent overflow when multiply and divide near infinity numbers.
6. For MockToken was added safeERC20.sol library to make possible to use any version of underlying token for tokenized vault.
7. For testing developing puposes Foundry was chosen  because it's most actual and popular these days
8. For MoclToken were added mint function and onlyOwner function to make an interface to mint tokens for vault testing purposes
9. For both MockToken and Vault test were written to test their functionality
10. Tokenized vault instanse was designed to be vulnerable to an inflational attack. However vault will not allow user to deposit assets if user will get less shares than 1 for these assets just to make vault more user-friendly(that's not required in EIP4626)
11. To mitigate inflation attack ProtectedVault was created. It is a vault that is protected from inflation attack by adding virtualOffset not allowing to get low amount of shares, preventing from making their price near infinity.
12. ProtectedVault.t.sol was created to test protected vault functionality
13. Project was documented througout code and docs to make it more concise.