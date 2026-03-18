# EF Sub-Multisig Verification

> **Note:** This repo redirects to the primary verification repo at [cartoonitunes/ef-multisig-verification](https://github.com/cartoonitunes/ef-multisig-verification).

Bytecode verification for `0x209711382eaeb6c1e021e0fc81acc5afa9b23d25` — an Ethereum Foundation internal sub-multisig contract deployed August 11, 2015 (block 72,142).

## Contract Details

| Field | Value |
|-------|-------|
| Address | `0x209711382eaeb6c1e021e0fc81acc5afa9b23d25` |
| Deployed | Block 72,142 (~Aug 11, 2015) |
| Deploy TX | `0x13cba3a6c151c19cce0778688fa644edec2f01dede3939512eb5dba185e37ccd` |
| Deployer | `0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f` (labeled "EF 1" on Etherscan) |
| Language | Serpent |
| Runtime | 738 bytes (EXACT MATCH — first 738 of 742 compiled bytes) |

## Verification Result

✅ **EXACT BYTECODE MATCH** — First 738 of 742 compiled bytes match on-chain runtime bytecode byte-for-byte.

## What It Does

A 3-signer Ethereum Foundation internal multisig:
- `createMotion(addr, data:bytes32)` — queues proposals
- `signMotion(slot, proposal_id)` — votes; majority (>num_signers/2) triggers LOG event and clears proposal

**Signers:**
- Slot 0: `0x23a1bada327be1da636cf6c31f71349e3ea0ba00`
- Slot 1: `0x288bbeb76a509947f3ea8c56e9b86d81f3b41897`
- Slot 2: `0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f` (deployer)

## Compiler

Serpent (`ethereum/serpent`, Python 2, pre-Solidity era)

## Source

See `ef1-multisig.se`

## Full Verification Details

See the primary repo: [cartoonitunes/ef-multisig-verification](https://github.com/cartoonitunes/ef-multisig-verification)

EthereumHistory: https://www.ethereumhistory.com/contract/0x209711382eaeb6c1e021e0fc81acc5afa9b23d25
