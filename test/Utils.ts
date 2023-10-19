import * as ethers from "ethers";
import * as dotenv from "dotenv";
dotenv.config();
const axios = require('axios');


function _getGasPrice() {
    const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

    let response = null;
    return new Promise(async (resolve, reject) => {
        try {
            response = await axios.get(`https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=${ETHERSCAN_API_KEY}`, {
                // headers: {
                //     'X-CMC_PRO_API_KEY': 'b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c',
                // },
            });
        } catch (ex) {
            response = null;
            // error
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


async function _getColletionData(){
    const encoder = ethers.utils.defaultAbiCoder; 
    return encoder.encode(
        [
            "string",
            "string",
            "string",
            "string",
            "uint256",
            "uint96",
            "address"
        ],[
            "MVX", // name
            "mvx", // symbol
            "ipfs://QmVjYK4hPdZ7Jn5GBuaMUsUAaGE6RpzHxaZVE29toYUrRZ/", // baseURI
            ".json", // baseExt
            "10", // maxSupply
            "300", // royaltyFee
            "0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6", // royaltyReceiver
        ]
    );
}
async function _getStageData() {
    const encoder = ethers.utils.defaultAbiCoder; 
    return encoder.encode(
        [
            "uint256",
            "uint256",
            "uint256",
            "uint256",
            "uint256",
            "uint256",
            "uint256",
            "uint256",
            "uint256",
            "uint256",
            "uint256",
            "uint256",
        ], [
        await ethers.BigNumber.from("30000000000000000") ,// ogMintPrice;
        await ethers.BigNumber.from("30000000000000000"), // whitelistMintPrice;
        await ethers.BigNumber.from("30000000000000000"), // mintPrice;
        20, // mintMaxPerUser;
        10, // ogMintMaxPerUser;
        10, // whitelistMintMaxPerUser;
         await ethers.block.timestamp, //  ;
         await ethers.block.timestamp + await ethers.block.timestamp + 500, //  ;
         await ethers.block.timestamp, //  ;
         await ethers.block.timestamp + await ethers.block.timestamp + 500, //  ;
         await ethers.block.timestamp, //  ;
         await ethers.block.timestamp + await ethers.block.timestamp + 500 //  ;
]);
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
        '0x63c65c86cB9D25a252635c73f90516D21E344ED4',
    ]
   return {og,wl}
}
module.exports = { _getGasPrice, _getMinters ,_getStageData,_getColletionData}