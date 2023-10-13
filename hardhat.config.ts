import { HardhatUserConfig } from "hardhat/config";
import "hardhat-preprocessor";
import "@nomicfoundation/hardhat-toolbox";
import * as tdly from "@tenderly/hardhat-tenderly";
import * as dotenv from "dotenv";
import fs from "fs";
import "hardhat-contract-sizer";


dotenv.config();
tdly.setup({ automaticVerifications: true })

const {
    TENDERLY_ACCESS_KEY,
    TENDERLY_PROJECT_SLUG,
    DEVNET_RPC_URL,
    MAINNET_NODE,
    GOERLY_NODE,
    MAINNET_DEPLOYER_PK,
    TES_DEPLOYER
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
        mainnet:{
            url: MAINNET_NODE,
            chainId: 1,
            accounts:[`${MAINNET_DEPLOYER_PK}`]
        },
        goerli:{
            url: GOERLY_NODE,
            chainId: 5,
            accounts:[`${TES_DEPLOYER}`]
        },
        tenderly: {
            url: DEVNET_RPC_URL,
            chainId: 1,
        }
    },
    tenderly: {
        project: TENDERLY_PROJECT_SLUG || "devnet-example",
        username: "danielleseng",
        accessKey: TENDERLY_ACCESS_KEY,
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