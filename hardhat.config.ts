import { HardhatUserConfig } from "hardhat/config";
import "hardhat-preprocessor";
// import "@nomicfoundation/hardhat-toolbox";
// import * as tdly from "@tenderly/hardhat-tenderly";
import * as dotenv from "dotenv";
import fs from "fs";
import "hardhat-contract-sizer";
import '@openzeppelin/hardhat-upgrades';
import "hardhat-gas-reporter"
import "hardhat-tracer";
import "@nomicfoundation/hardhat-ethers";
// import "@tenderly/hardhat-tenderly"


dotenv.config();
// tdly.setup({ automaticVerifications: true })

const {
    POLYSCAN_API_KEY,
    MUMBAI_NODE_1,
    MUMBAI_NODE_2,
    POLYGON_NODE_1,
    POLYGON_NODE_2,
    POLYGON_NODE_3,
    SOLANA_DEV,
    TENDERLY_ACCESS_KEY,
    TENDERLY_PROJECT_SLUG,
    DEVNET_RPC_URL,
    MAINNET_NODE,
    MAINNET_DEPLOYER_PK,
    ETHERSCAN_API_KEY,
    GOERLI_NODE_1,
    GOERLI_NODE_2,
    GOERLI_NODE_3,
    ADMIN_TEST_KEY,
    MEMBERT_TEST_KEY,
    MEMBERT_2_TEST_KEY,
    REFERRAL_TEST_KEY,
    ARTISTI_TEST_KEY
} = process.env;

const config: HardhatUserConfig = {
    solidity: {
        compilers: [
            {
                version: "0.8.20",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                    outputSelection: {
                        "*": {
                            "*": ["storageLayout"],
                        },
                    },
                },
            },
        ],
    },
    networks: {
        localhost: {
            url: "http://127.0.0.1:8545/",
            accounts: [`0x8166f546bab6da521a8369cab06c5d2b9e46670292d85c875ee9ec20e84ffb61`,
                `0x${MEMBERT_TEST_KEY}`]
        },
        hardhat: {
            // forking: {
            //     url: MAINNET_NODE,
            //     blockNumber: 18378515
            // }
        },
        mainnet: {
            url: MAINNET_NODE,
            chainId: 1,
            accounts: [`${MAINNET_DEPLOYER_PK}`]
        },
        polygon: {
            url: POLYGON_NODE_1,
            chainId: 137,
            accounts: ['f94931ddb7b17c652d8eb2df7d76fdba76ce52d87e56d187199ce73c4a590944' ]
        },
        goerli_1: {
            url: GOERLI_NODE_1,
            chainId: 5,
            accounts: [
                `0x${ADMIN_TEST_KEY}`,
                `0x${MEMBERT_TEST_KEY}`,
                `0x${REFERRAL_TEST_KEY}`,
                `0x${ARTISTI_TEST_KEY}`,
                `0x${MEMBERT_2_TEST_KEY}`
            ]
        },
        goerli_2: {
            url: GOERLI_NODE_2,
            chainId: 5,
            accounts: [
                `0x${ADMIN_TEST_KEY}`,
                `0x${MEMBERT_TEST_KEY}`,
                `0x${REFERRAL_TEST_KEY}`,
                `0x${ARTISTI_TEST_KEY}`,
                `0x${MEMBERT_2_TEST_KEY}`
            ]
        },
        goerli_3: {
            url: GOERLI_NODE_3,
            chainId: 80001,
            accounts: [
                `0x${ADMIN_TEST_KEY}`,
                `0x${MEMBERT_TEST_KEY}`,
                `0x${REFERRAL_TEST_KEY}`,
                `0x${ARTISTI_TEST_KEY}`,
                `0x${MEMBERT_2_TEST_KEY}`
            ]
        },
        mumbai_1: {
            url: MUMBAI_NODE_1,
            chainId: 80001,
            accounts: [
                `0x${ADMIN_TEST_KEY}`,
                `0x${MEMBERT_TEST_KEY}`,
                `0x${REFERRAL_TEST_KEY}`,
                `0x${ARTISTI_TEST_KEY}`,
                `0x${MEMBERT_2_TEST_KEY}`
            ]
        },
        mumbai_2: {
            url: MUMBAI_NODE_1,
            chainId: 80001,
            accounts: [
                `0x${ADMIN_TEST_KEY}`,
                `0x${MEMBERT_TEST_KEY}`,
                `0x${REFERRAL_TEST_KEY}`,
                `0x${ARTISTI_TEST_KEY}`,
                `0x${MEMBERT_2_TEST_KEY}`
            ]
        },
        tenderly: {
            url: DEVNET_RPC_URL,
            chainId: 1,
        }
    },
    paths: {
        sources: "./src",
        cache: "./forge_hardhat",
    },
    contractSizer: {
        alphaSort: true,
        disambiguatePaths: false,
        runOnCompile: false,
        strict: true,
    },
    gasReporter: {
        enabled: true,
        currency: 'USD',
        gasPrice: 21,
        coinmarketcap: process.env.COIN_MARKET_CAP_KEY,
        token: 'MATIC',
        showMethodSig: true,
        gasPriceApi: `https://api.polygonscan.com/api?module=stats&action=maticprice&apikey=U5HPG45VAZXXSJJTR32ABXVHPCIKYPE347`
    },
    etherscan: {
        apiKey: {
            mainnet: ETHERSCAN_API_KEY,
            goerli: ETHERSCAN_API_KEY,
            polygonMumbai: POLYSCAN_API_KEY,
            polygon: POLYSCAN_API_KEY
        }
    },
    preprocess: {
        eachLine: (hre) => ({
            transform: (line: string) => {
                if (line.match(/^\s*import /i)) {
                    for (const [from, to] of getRemappings()) {
                        if (line.includes(from)) {
                            line = line.replace(from, to);
                            break;
                        }
                    }
                }
                return line;
            },
        }),
    },

};

function getRemappings() {
    return fs
        .readFileSync("remappings.txt", "utf8")
        .split("\n")
        .filter(Boolean) // remove empty lines
        .map((line) => line.trim().split("="));
}

export default config;