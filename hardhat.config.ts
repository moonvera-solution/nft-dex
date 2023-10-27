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



dotenv.config();
// tdly.setup({ automaticVerifications: true })

const {
    TENDERLY_ACCESS_KEY,
    TENDERLY_PROJECT_SLUG,
    DEVNET_RPC_URL,
    MAINNET_NODE,
    GOERLY_NODE,
    MAINNET_DEPLOYER_PK,
    TES_DEPLOYER,
    ETHERSCAN_API_KEY,
    MEMBERT_TEST_KEY,
    GOERLY_NODE_2
} = process.env;

const config: HardhatUserConfig = {
    solidity: {
        compilers: [
            {
                version: "0.8.20",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 100000,
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
        localhost:{
            url:"http://127.0.0.1:8545/",
            accounts:[`0x8166f546bab6da521a8369cab06c5d2b9e46670292d85c875ee9ec20e84ffb61`,
            `0x${MEMBERT_TEST_KEY}`]
        },
        hardhat: {
            forking: {
              url: MAINNET_NODE,
              blockNumber:18378515
            }
          },
        mainnet:{
            url: MAINNET_NODE,
            chainId: 1,
            accounts:[`${MAINNET_DEPLOYER_PK}`]
        },
        goerli:{
            url: GOERLY_NODE_2,
            chainId: 5,
            accounts:[`0x${TES_DEPLOYER}`,`0x${MEMBERT_TEST_KEY}`]
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
        token: 'ETH',
        showMethodSig: true,
        gasPriceApi: `https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=${ETHERSCAN_API_KEY}`
      },
      etherscan: {
        apiKey: {
            goerli: ETHERSCAN_API_KEY
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