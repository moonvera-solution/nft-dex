import { ethers } from "hardhat";
import * as dotenv from "dotenv";
dotenv.config();
import FactoryContract from "../out/MvxFactory.sol/MvxFactory.json";
const { utils } = require("ethers");
import { MvxFactory, MvxCollection } from "../typechain-types";
import { upgrades } from '@openzeppelin/hardhat-upgrades';
import { _getGasPrice } from './Utils.ts';

async function upgrade() {
  const Factory: MvxFactory = await ethers.getContractFactory("MvxFactory");
  const FactoryProxy = await upgrades.deployProxy(Factory, [0], { kind: 'uups' }); // platform fee = 0
  const upgraded = await upgrades.upgradeProxy(await FactoryProxy.getAddress(), FactoryProxy);
}

async function _deploy() {
    const deploy = await ethers.deployContract("MvxCollection",[]);
    const tx = ethers.utils.parseTransaction(deploy);
    tx.wait();
  // await hre.run("verify:verify", {
  //   address: aeroStrategy.address,
  // });
}

async function deploy() {
  // Deploying
  // const Factory: MvxFactory = await ethers.getContractFactory("MvxFactory");
  // const Collection: MvxCollection = await ethers.getContractFactory("MvxCollection");

  // const FactoryProxy = await upgrades.deployProxy(Factory, [0], { kind: 'uups' }); // platform fee = 0
  // const CollectionProxy = await upgrades.deployProxy(Collection, { kind: 'uups' });

  // await FactoryProxy.waitForDeployment();
  // await CollectionProxy.waitForDeployment();
}
async function _quoteCreateCollection(){
  const tx = await ethers.deployContract("MvxFactory", [0]);
  // await tx.estimateGas.createCollection(
  //   (string,string,string,string,uint256,uint96,address),
  //   (uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256),address[],address[]
  // );
}

async function main() {
  // _getGasPrice();
  _deploy();
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
