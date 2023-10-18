import { ethers } from "hardhat";
import * as dotenv from "dotenv";
dotenv.config();
const { utils } = require("ethers");
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

module.exports = {_getGasPrice}