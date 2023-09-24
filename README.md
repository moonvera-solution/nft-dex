# Nft Launchpad & Marketplace

***MoonveraLabs***
<br>
Decentralized market and launchpad for minting, listing and trading of non-fungible assets.
### Contract components
- Factory.sol:
    - Factory to create ERC721A clone contracts with immutable arguments
- ArtCollection.sol: ERC721AUpgradable Azuki ERC721 like implementation, supports the following features
    - per-stage price
    - per-stage walletLimit
    - per-stage maxStageSupply
    - multi stage minting
    - multi role minting access
    - artist royalties
- Market.sol
    - Nft listing
    - Nft buy/sell with ERC20's & Eth
- MarketLens.sol
    - Contract to query Internal and 3rd Party market statistics

### WIP
- per-stage merkleRoot
- crossmint support

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
