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
            accounts:["e55667d2a94addaf9854613406976f032d7cf1f8a190c5ed36f1ff773bd92b5d"]
        },
        goerli:{
            url: GOERLY_NODE,
            chainId: 5,
            accounts:["7a3b2dc7d031efa7d9e7c5a069c5941f0488e2c7b44c188763be7300e0a907ec"]
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