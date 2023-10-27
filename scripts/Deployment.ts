
const { ethers, upgrades} = require("hardhat");
const hre = require("hardhat")
import * as dotenv from "dotenv";
dotenv.config();
import FactoryContract from "../out/MvxFactory.sol/MvxFactory.json";
import { MvxFactory, MvxCollection } from "../typechain-types";
import {CollectionStruct,StagesStruct} from "../typechain-types/src/MvxFactory";

const _log = (a:any,b:any):any => console.log("\n",a,b,"\n");
const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000' 
const MEMBER = "0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146";
const _sleep = (ms:any) => new Promise(resolve => setTimeout(resolve, ms));

async function _deployFactory(){
  // const Factory: MvxFactory = await hre.ethers.getContractFactory("MvxFactory");
  // const FactoryProxy: MvxFactory = await upgrades.deployProxy(Factory, {initializer: "initialize",kind: 'uups'});
  // await FactoryProxy.waitForDeployment();

  // const FactoryAddress = await FactoryProxy.getAddress();
  // _log("FactoryProxy deployed to:", FactoryAddress);
  let bbImplAddress = await upgrades.erc1967.getImplementationAddress("0x98bC15a0c26eBCcDc923AF7eDA18b6F9f912878c");
  _log("Impl deployed to:", bbImplAddress);
  await hre.run("verify:verify", {address: bbImplAddress});
}

async function _deployCollection(){
  const Collection: any = await hre.ethers.getContractFactory("MvxCollection");
  const CollectionInstance = await Collection.deploy();
  const CollectionAddress = await CollectionInstance.getAddress();
  _log("Collection 721A impl deployed to:",CollectionAddress);
  await hre.run("verify:verify", {address: "0xe84F8D961Ac2F73a214e6D9398Cd019bE29b45A7"});
}

async function _initFactory(FactoryProxyAddress: any){
  const deployer = await ethers.getSigner("0x37aa961D37F3513ae760ea7B704dAe3415f67B2F");
  const FactoryProxy:MvxFactory = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  // await FactoryProxy.connect(deployer).updateCollectionImpl("0xe84F8D961Ac2F73a214e6D9398Cd019bE29b45A7");
  // _log("Added impl...",0);
  // _log("Adding Member...",MEMBER);
  // await FactoryProxy.connect(deployer).updateMember(MEMBER,ZERO_ADDRESS,0,200,0,10);
  // const newMember = await FactoryProxy.members(MEMBER);
  // _log("Added Member", newMember);


  const block = {timestamp:9936206};
  const stages : StagesStruct = {
    "ogMintPrice" :30000000000000000n,
    "whitelistMintPrice" :30000000000000000n,
    "mintPrice" :30000000000000000n,
    "mintMaxPerUser" :10n,
    "ogMintMaxPerUser" :10n,
    "whitelistMintMaxPerUser" :10n,
    "mintStart" :block.timestamp,
    "mintEnd" :block.timestamp + 5 * 60 * 60 * 24,
    "ogMintStart" :block.timestamp,
    "ogMintEnd" :block.timestamp + 5 * 60 * 60 * 24,
    "whitelistMintStart" :block.timestamp,
    "whitelistMintEnd" :block.timestamp + 5 * 60 * 60 * 24
  };
  const nftData :CollectionStruct= {
    name: "MVX ART",
    symbol: "MVX",
    baseURI: "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/",
    baseExt: ".json",
    maxSupply: 300n,
    royaltyFee: 1000n,
    royaltyReceiver: "0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6"
  };
  
  const ogs = ["0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146","0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6"]
  const wls = ["0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146","0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6"]

  const signer = await ethers.getSigner(MEMBER);
  const tx = await FactoryProxy.connect(signer).createCollection(nftData,stages,ogs,wls,{value:0});
  const rc :any = await tx.wait();  
  _log("Collection1 clone address",rc.logs);

}

async function main() {
  // _deployFactory();
  // _deployCollection();
  _initFactory("0x98bC15a0c26eBCcDc923AF7eDA18b6F9f912878c");
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
