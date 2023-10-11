import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as tdly from "@tenderly/hardhat-tenderly";
import * as dotenv from "dotenv";

dotenv.config();
tdly.setup({ automaticVerifications: true })

const {
    TENDERLY_ACCESS_KEY,
    TENDERLY_PROJECT_SLUG,
    DEVNET_RPC_URL,
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
    }
    networks: {
        tenderly: {
            url: DEVNET_RPC_URL,
            chainId: 1,
        }
    },
    tenderly: {
        project: TENDERLY_PROJECT_SLUG || "devnet-example",
        username: "danielleseng",
        accessKey: TENDERLY_ACCESS_KEY,
    }
};

export default config;