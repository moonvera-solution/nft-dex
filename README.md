## NFT Collections

### Contracts:
    - Factory: allow art collection deployment to members
    - ArtCollection: ERC721A template clone
    - Auth: Simple authentication pattern rely/deny address

### Minting Stages
- Minting Stages
- Permenent BaseURI Support
- Non-incresing Max Total Supply Support
- Per-stage Max Supply
- Global and Per-stage Limit
- Native TypeScript and Typechain-Types Support

### TODO
    - Per-stage WL Merkle Tree
    - deployment scripts

### Foundry
**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

***Foundry consists of:***

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.



# User Factory Flow

1.- Deploy Factory
2.- Deploy Template ArtCollection

2.1 Option to quote cost of its collection deployment
    Deployment Fixed gas cost
    initialize cost = 
    Quote = deploy cost + ${initialize}

3.- User sends approval form
4.- Approve assign MEMBER_ROLL & ALLOW_LAUNCH_PERIOD

5.- MEMBER will deploy ArtCollection(clone)
    Initialize de art collection
....


<br>

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
