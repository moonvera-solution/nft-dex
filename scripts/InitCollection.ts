import { ethers } from "hardhat";
import * as dotenv from "dotenv";
dotenv.config();
import FactoryContract from "../out/MvxFactory.sol/MvxFactory.json";
const { utils } = require("ethers");
import { MvxFactory } from "../typechain-types";


const FACTORY_GOERLY: any = "0x4c1C3EC71fb11684ceFB350252122aA4e85C9068";
const FACTORY_MAINNET: any = "0x6A213cDDb2f5eD08ef3D27c66E7f6493970e9426";
const COLLECTION_GOERLY: any = "0x9aa968D0513F74456632Ef08A07c2c646869B149";
const OWNER = "0x37aa961D37F3513ae760ea7B704dAe3415f67B2F";



async function _getFactory(){
  return await ethers.getContractAt("MvxFactory", FACTORY_MAINNET);   
}

async function _initCollection(){
  const encoder = ethers.utils.defaultAbiCoder;

  const maxSupply = 6888;
  const royaltyFee = 1000;
  const tokenSymbol = "GGV2";
  const name = "GremGoyles V2"
  const uri = "ipfs://QmVjYK4hPdZ7Jn5GBuaMUsUAaGE6RpzHxaZVE29toYUrRZ/";
  const og = ['0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603', '0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889'];
  const wl = ['0x1716Dc946d9264126412feDE8264E50E9d21c37a', '0xCaF7DEF17e72fF1C9A298fB693899A5Ab3874117'];
  const stageDetails = [
    0,
    10, // max OG
    1697232600,
    1697320800,
    await ethers.BigNumber.from("30000000000000000"),
    5, // max WL
    1697320860,
    1697342340,
    await ethers.BigNumber.from("45000000000000000"),
    20, // Max reg
    1697342400,
    1698206400
  ];



  const data = await encoder.encode(["uint256", "uint256", "string", "string", "string"],
    [maxSupply, royaltyFee, name, tokenSymbol, uri]);

  // SEND Tx CREATE COLLECTION
  const tx = await Factory.createCollection(data, og, wl, stageDetails,);
  await tx.wait().then(function (receipt: any) {
    console.log(receipt);
  }).catch((e: any) => {
    console.log("ERROR", e);
  });
}
async function main() {
    _initCollection();
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});