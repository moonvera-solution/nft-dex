import { HardhatUserConfig } from "hardhat/config";
import fs from "fs";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-preprocessor";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          viaIR: true,
          optimizer: {
            enabled: true,
            runs: 2000,
          },
        },
      },
      {
        version: "0.8.19",
      },
      {
        version: "0.8.4",
        settings: {
          viaIR: false,
          optimizer: {
            enabled: true,
            runs: 2000,
          },
        },
      },
    ],
  },

};
export default config;
