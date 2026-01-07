# UUPS Upgradeable Proxy Pattern

A production-ready implementation of the UUPS (Universal Upgradeable Proxy Standard) pattern using OpenZeppelin contracts and Foundry for testing and deployment.

## 🎯 Overview

This project demonstrates how to build upgradeable smart contracts using the UUPS proxy pattern. Unlike traditional smart contracts that are immutable once deployed, this pattern allows you to upgrade your contract logic while preserving the contract's address and state.

### Key Features

- ✅ **State Preservation**: Data persists across upgrades
- ✅ **Gas Efficient**: UUPS is more gas-efficient than Transparent Proxy
- ✅ **Access Control**: Only authorized addresses can upgrade
- ✅ **Battle-Tested**: Uses OpenZeppelin's audited implementations
- ✅ **Comprehensive Tests**: Full test coverage for deployment and upgrades

## 🏗️ Architecture

### Components

```
┌─────────────┐
│   Proxy     │ ← Your users interact here (fixed address)
│ ERC1967Proxy│
└──────┬──────┘
       │ delegatecall
       ▼
┌─────────────┐      Upgrade      ┌─────────────┐
│   BoxV1     │ ─────────────────▶ │   BoxV2     │
│(Implementation)│                  │(Implementation)│
└─────────────┘                    └─────────────┘
```

### Contract Breakdown

1. **BoxV1** - Initial implementation with basic storage
2. **BoxV2** - Upgraded version (same storage layout)
3. **BoxV3** - Example of adding new storage variables
4. **DeployBox.s.sol** - Deployment script
5. **UpgradeBox.s.sol** - Upgrade script with DevOps tools integration

## 🚀 Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/)

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd <repo-name>

# Install dependencies
forge install

# Build the project
forge build
```

### Running Tests

```bash
# Run all tests
forge test

# Run with verbose output
forge test -vv

# Run specific test
forge test --match-test testUpgrade -vvvv
```

## 📖 Usage

### Deploying the Initial Proxy

```bash
forge script script/DeployBox.s.sol:DeployBox --rpc-url <your_rpc_url> --broadcast
```

This will:
1. Deploy the BoxV1 implementation
2. Deploy an ERC1967Proxy pointing to BoxV1
3. Initialize the proxy with ownership

### Upgrading to BoxV2

```bash
forge script script/UpgradesBox.s.sol:UpgradeBox --rpc-url <your_rpc_url> --broadcast
```

This will:
1. Find the most recently deployed proxy using DevOps tools
2. Deploy the new BoxV2 implementation
3. Upgrade the proxy to point to BoxV2
4. **State is preserved!**

## 🧪 Test Coverage

### `testUpgrade()`
Tests the basic upgrade functionality:
- Deploys BoxV1 through proxy
- Upgrades to BoxV2
- Verifies version change (1 → 2)
- Tests new functionality works

### `test_UpgradeKeepsData()`
**The most important test** - demonstrates state persistence:
```solidity
1. Store value (777) in BoxV1
2. Upgrade to BoxV2
3. Verify data still exists (777) ✓
4. Use new V2 functions (set 888)
5. Verify backward compatibility
```

## 🔑 Key Concepts

### Storage Layout

**Critical**: When upgrading, you must maintain the storage layout!

✅ **Safe (BoxV2)**:
```solidity
uint256 internal number;  // Same position as V1
```

✅ **Safe (BoxV3)**:
```solidity
uint256 internal number;       // Keep existing
uint256 internal otherNumber;  // Add new at the end
```

❌ **Dangerous**:
```solidity
uint256 internal otherNumber;  // New variable BEFORE existing
uint256 internal number;       // This will corrupt data!
```

### UUPS vs Transparent Proxy

| Feature | UUPS | Transparent |
|---------|------|-------------|
| Upgrade logic | In implementation | In proxy |
| Gas cost | Lower | Higher |
| Complexity | Slightly higher | Lower |
| Risk | Must implement correctly | More forgiving |

### Access Control

The `_authorizeUpgrade` function is crucial:
```solidity
function _authorizeUpgrade(address newImplementation) 
    internal 
    override 
    onlyOwner {}  // Only owner can upgrade
```

**Warning**: If you remove `onlyOwner` in an upgrade, anyone can upgrade your contract!

## 🔍 Code Walkthrough

### BoxV1 Features
- `setNumber(uint256)` - Store a number
- `getNumber()` - Retrieve the number
- `version()` - Returns 1
- Owner-controlled upgrades

### BoxV2 Improvements
- Same storage layout
- `version()` - Returns 2
- Ready for future enhancements

### BoxV3 Storage Extension
- Adds `otherNumber` variable
- Demonstrates safe storage expansion
- Maintains backward compatibility

## 🛡️ Security Considerations

1. **Always test upgrades on testnet first**
2. **Verify storage layout compatibility**
3. **Use OpenZeppelin's upgrade safety validations**
4. **Keep `_authorizeUpgrade` protected**
5. **Never delete state variables**
6. **Don't change the order of existing variables**
7. **Use initializers instead of constructors**

## 📚 Resources

- [OpenZeppelin UUPS Documentation](https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable)
- [EIP-1822: Universal Upgradeable Proxy Standard](https://eips.ethereum.org/EIPS/eip-1822)
- [Foundry Book](https://book.getfoundry.sh/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## ⚠️ Disclaimer

This code is for educational purposes. Always conduct thorough audits before deploying upgradeable contracts to production.

---

**Built with ❤️ using Foundry and OpenZeppelin**
