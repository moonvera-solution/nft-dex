import * as dotenv from "dotenv";
import  BigNumber from 'bignumber.js';
BigNumber.config({ DECIMAL_PLACES: 20, ROUNDING_MODE: 4 })

const { ethers, upgrades} = require("hardhat");


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
dotenv.config();
const axios = require('axios');


function _getGasPrice() {
    const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

    let response = null;
    return new Promise(async (resolve, reject) => {
        try {
            response = await axios.get(`https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=${ETHERSCAN_API_KEY}`, {
            });
        } catch (ex) {
            response = null;
            console.log(ex);
            reject(ex);
        }
        if (response) {
            // success
            const json = response.data;
            console.log(json);
            resolve(json);
        }
    });
}


async function _getColletionData(royaltyReceiver:any){
    return {
        name: "MVX ART",
        symbol: "MVX",
        baseURI: "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/",
        baseExt: ".json",
        maxSupply: 3333n,
        royaltyFee: 1000n,
        royaltyReceiver: royaltyReceiver
      };
      
}
async function _getStageData() {
    const block = {timestamp: (await ethers.provider.getBlock('latest')).timestamp  };
    const _getTime = (num:any) => block.timestamp + (60 * 60 * 24 * num);
    return {
        "isMaxSupplyUpdatable": true,
        "ogMintPrice" :300000000000000n,
        "whitelistMintPrice" :300000000000000n,
        "mintPrice" :300000000000000n,
        "mintMaxPerUser" :100n,
        "ogMintMaxPerUser" :100n,
        "whitelistMintMaxPerUser" :100n,
        "ogMintStart" :_getTime(0),
        "ogMintEnd" :_getTime(1),
        "whitelistMintStart" :_getTime(2),
        "whitelistMintEnd" :_getTime(3),
        "mintStart" : _getTime(3),
        "mintEnd" :_getTime(7),
    };
}
function _getMinters() {
    const og = [
        '0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603',
        '0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889',
        '0x269b4c5537445ad08EBF6eA6D848a4866856778b',
        '0x8919Bc879C595c4F5a699A870d5211a5436cDF7E',
        '0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA',
        '0xc7468B7D4086D15bf13D025A663E46E38d945446',
        '0x40f0D8104ae5C9b9D7185Dbf1d65c2d40CA1565f',
        '0x897f1569a22Ab89ED2ED363acAF9b8613EDd27a7',
        '0x173f6e69efA3Ed13bC5b8fFa48b80cfaD5b55260',
        '0x172e1D59AEBe8fc5d0BAc93B9E9a1ABddCc767ea',
        '0x63c65c86cB9D25a252635c73f90516D21E344ED4'
    ]
    const wl = [
        '0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603',
        '0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889',
        '0x269b4c5537445ad08EBF6eA6D848a4866856778b',
        '0x8919Bc879C595c4F5a699A870d5211a5436cDF7E',
        '0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA',
        '0xc7468B7D4086D15bf13D025A663E46E38d945446',
        '0x40f0D8104ae5C9b9D7185Dbf1d65c2d40CA1565f',
        '0x897f1569a22Ab89ED2ED363acAF9b8613EDd27a7',
        '0x173f6e69efA3Ed13bC5b8fFa48b80cfaD5b55260',
        '0x172e1D59AEBe8fc5d0BAc93B9E9a1ABddCc767ea',
        '0x63c65c86cB9D25a252635c73f90516D21E344ED4'
    ]
   return [og,wl]
}
module.exports = { _getGasPrice, _getMinters ,_getStageData,_getColletionData}