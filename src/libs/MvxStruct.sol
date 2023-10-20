// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct Stages {
    uint256 ogMintPrice;
    uint256 whitelistMintPrice;
    uint256 mintPrice;
    uint256 mintMaxPerUser;
    uint256 ogMintMaxPerUser;
    uint256 whitelistMintMaxPerUser;
    uint256 mintStart;
    uint256 mintEnd;
    uint256 ogMintStart;
    uint256 ogMintEnd;
    uint256 whitelistMintStart;
    uint256 whitelistMintEnd;
}

struct Collection {
    string name;
    string symbol;
    string baseURI;
    string baseExt;
    uint256 maxSupply;
    uint96 royaltyFee;
    address royaltyReceiver;
}

// address artist => Artist
struct Artist {
    address referral; // referral address
    uint256 referralBalance; // track referral balance
    address collection; // memeber of collection the referral is
    uint256 expiration;
}

// address collection => MvxCollection
struct Partner {
    address admin; // partner collection admin
    uint96 adminOwnPercent; // % variable per partnership
    uint96 referralOwnPercent; // % variable per partnership
    uint256 adminBalance; // track partner balance (admin)
    uint96 discount; // variable per partnership
}