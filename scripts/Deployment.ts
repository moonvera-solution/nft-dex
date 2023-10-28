
const { ethers, upgrades} = require("hardhat");
const hre = require("hardhat")
import * as dotenv from "dotenv";
dotenv.config();
import FactoryContract from "../out/MvxFactory.sol/MvxFactory.json";
import { MvxFactory, MvxCollection } from "../typechain-types";
import {CollectionStruct,StagesStruct} from "../typechain-types/src/MvxFactory";

const _log = (a:any,b:any):any => console.log("\n",a,b,"\n");
const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000' 
const _sleep = (ms:any) => new Promise(resolve => setTimeout(resolve, ms));

async function _deployFactory(){
  const Factory: MvxFactory = await hre.ethers.getContractFactory("MvxFactory");
  const FactoryProxy: MvxFactory = await upgrades.deployProxy(Factory, {initializer: "initialize",kind: 'uups'});
  await FactoryProxy.waitForDeployment();

  const FactoryAddress = await FactoryProxy.getAddress();
  _log("FactoryProxy deployed to:", FactoryAddress);
  let bbImplAddress = await upgrades.erc1967.getImplementationAddress(FactoryAddress);
  _log("Impl deployed to:", bbImplAddress);
  await hre.run("verify:verify", {address: bbImplAddress});
}

async function _deployCollection(){
  const Collection: any = await hre.ethers.getContractFactory("MvxCollection");
  const CollectionInstance = await Collection.deploy();
  const CollectionAddress = await CollectionInstance.getAddress();
  _log("Collection 721A impl deployed to:",CollectionAddress);
  await hre.run("verify:verify", {address: "0x7e65bA841b8B63E42e4bd9CF0BFd3c4a4d5Ba388"});
}

async function _initFactory(FactoryProxyAddress: any, ImplAddr:any){
  const deployer = await ethers.getSigner(ADMIN);
  const FactoryProxy:MvxFactory = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  const tx = await FactoryProxy.connect(deployer).updateCollectionImpl(ImplAddr);
  const receipt:any = await tx.wait();
  _log("Added impl...",receipt.logs);
}

async function _updateMember(FactoryProxyAddress:any, member:any){
  const FactoryProxy:MvxFactory = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  const deployer = await ethers.getSigner(ADMIN);
  _log("Adding Member...",member);
  const tx = await FactoryProxy.connect(deployer).updateMember(member,ZERO_ADDRESS,500000000000000000n,0,0,10);
  const rc : any  = await tx.wait();
  _log("Added Member", rc.logs);
}

async function _createCollection(FactoryProxyAddress:any,sender:any){
  const FactoryProxy:MvxFactory = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  const block = {timestamp: (await ethers.provider.getBlock('latest')).timestamp  };
  const stages : StagesStruct = {
    "ogMintPrice" :30000000000000000n,
    "whitelistMintPrice" :30000000000000000n,
    "mintPrice" :30000000000000000n,
    "mintMaxPerUser" :100n,
    "ogMintMaxPerUser" :100n,
    "whitelistMintMaxPerUser" :100n,
    "mintStart" :block.timestamp,
    "mintEnd" :block.timestamp + 10 * 60 * 60 * 24,
    "ogMintStart" :block.timestamp,
    "ogMintEnd" :block.timestamp + 10 * 60 * 60 * 24,
    "whitelistMintStart" :block.timestamp,
    "whitelistMintEnd" :block.timestamp + 10 * 60 * 60 * 24
  };
  const nftData :CollectionStruct= {
    name: "MVX ART",
    symbol: "MVX",
    baseURI: "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/",
    baseExt: ".json",
    maxSupply: 3333n,
    royaltyFee: 1000n,
    royaltyReceiver: sender
  };
  
  const ogs = ["0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146","0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6"]
  const wls = ["0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146","0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6"]

  const signer = await ethers.getSigner(sender);
  const tx = await FactoryProxy.connect(signer).createCollection(nftData,stages,ogs,wls,{value:500000000000000000n});
  const rc :any = await tx.wait();  
  _log("Collection1 clone address",rc.logs);
}

async function _grantReferral(FactoryProxyAddress:any, sender:any, artist:any){

}

async function _updatePartnership(FactoryProxyAddress:any, partner:any){

}

const FACTORY_PROXY_GOERLI = "0x4D2cc8B6FeF51A95Ea78F0C9EE49Bc2620bA038C";
const CLONE_IMPL_GOERLI = "0x5ff2B4d7fE3Bac7e7aC20E3a05a85D291c04970E";

const ADMIN = "0x37aa961D37F3513ae760ea7B704dAe3415f67B2F";
const MEMBER = "0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146";
const REFERRAL = "0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6";
const ARTIST = "0x57511A8BDe2940229d3bddF20d0FC58097dDd771";

async function main() {
  // _deployFactory();
  // _deployCollection();
  // _initFactory(FACTORY_PROXY_GOERLI, CLONE_IMPL_GOERLI);
  _createCollection(FACTORY_PROXY_GOERLI, MEMBER);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
