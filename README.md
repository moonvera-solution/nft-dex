# Nft Launchpad & Marketplace
Decentralized market and launchpad for minting, listing and trading of non-fungible assets.

Project for [Moonvera](https://moonvera.io/)
- [Launchpad](https://mvx-beta-version.netlify.app/)
- Factory [ethereum mainnet](https://etherscan.io/address/0x6A213cDDb2f5eD08ef3D27c66E7f6493970e9426)
- Colletions:
    - GremGoyles [ethereum mainnet](https://etherscan.io/address/0x881dC9f60B4Dec6196d9368520F458cdAA8f245c)
<br>

#### CONTRACT COMPONENTS
- MvxFactory.sol:
    - MvxFactory to create ERC721A clone contracts with immutable arguments, solady implementation
- MvxCollection.sol: ERC721AUpgradable Azuki ERC721 like implementation, supports the following features
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
