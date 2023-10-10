# Nft Launchpad & Marketplace

***Project from [MoonveraLabs] ***
<br>
### Decentralized market and launchpad for minting, listing and trading of non-fungible assets.
#### CONTRACT COMPONENTS
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


#### SECURITY REVIEW

- [Auditbase](https://app.auditbase.com/) report
- Static analysis report by [4naly3er](https://github.com/Picodes/4naly3er) tool from code4rena team
- Defender 2.0 (beta)
- Static analysis Slither github action through CI/CD | current issue:
    `https://github.com/crytic/slither/issues/2148`

#### MONITORING
- Forta bot
- Tenderly alerts to telegram
#### ROADMAP
- NFT collateral lending
- NFT Swap
- Per-stage merkleRoot
- Crossmint support
