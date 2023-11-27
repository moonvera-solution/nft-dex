
const Stages = {
    isMaxSupplyUpdatable: false,
    ogMintPrice: "",
    whitelistMintPrice: " ",
    mintPrice: " ",
    mintMaxPerUser: " ",
    ogMintMaxPerUser: " ",
    mintStart: " ",
    mintEnd: " ",
    ogMintStart: " ",
    ogMintEnd: " ",
    whitelistMintStart: " ",
    whitelistMintEnd: " ",
    whitelistMintMaxPerUser: " "
};
const Collection = {
    name: "",
    symbol: "",
    baseURI: "",
    baseExt: "",
    royaltyReceiver: "",
    maxSupply: "",
    royaltyFee: "",
};

const Member = {
    collection: "",
    deployFee: "",
    platformFee: "",
    discount: "",
    expiration: ""
};

const Artist = {
    referral: "",
    referralBalance: "",
    collection: ""
};

const Partner = {
    collection: "",
    admin: "",
    adminOwnPercent: "",
    referralOwnPercent: "",
    discount: "",
    balance: "",
    expiration: ""
};


const addressZero = "0x0000000000000000000000000000000000000000";

module.exports ={
    addressZero,
    Partner,
    Member,
    Stages,
    Artist,Collection
}