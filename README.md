# Nft Launchpad & Marketplace

***Project from [MoonveraLabs](https://moonvera.io/) for the [Arab collectors club.](https://arabcc.io/)***
<br>
### Decentralized market and launchpad for minting, listing and trading of non-fungible assets.
#### Contract components
- Factory.sol:
    - Factory to create ERC721A clone contracts with immutable arguments, solady implementation
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

#### WIP
- per-stage merkleRoot
- crossmint support
