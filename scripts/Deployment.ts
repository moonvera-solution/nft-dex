
const { ethers, upgrades} = require("hardhat");
const hre = require("hardhat")
import * as dotenv from "dotenv";
dotenv.config();
import { MvxFactory, MvxCollection } from "../typechain-types/index";
import {Collection,Stages} from "../typechain/type-chains";
const _log = (a:any,b:any):any => console.log("\n",a,b,"\n");
const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000' 
const _sleep = (ms:any) => new Promise(resolve => setTimeout(resolve, ms));

async function _upgradeFactory(FACTORY_PROXY_GOERLI:any){
  const Factory: MvxFactory = await hre.ethers.getContractFactory("MvxFactory");
  const box = await upgrades.upgradeProxy(FACTORY_PROXY_GOERLI, Factory);
  console.log("Factory impl upgraded",box);

}

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
  // const Collection: any = await hre.ethers.getContractFactory("MvxCollection");
  // const CollectionInstance = await Collection.deploy();
  // const CollectionAddress = await CollectionInstance.getAddress();
  // _log("Collection 721A impl deployed to:",CollectionAddress);
  await hre.run("verify:verify", {address: "0xad706BF0FFa071D7c99592630425384605668080"});
}

async function _initFactory(FactoryProxyAddress: any, ImplAddr:any){
  const deployer = await ethers.getSigner(ADMIN);
  const FactoryProxy:any = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  const tx = await FactoryProxy.connect(deployer).updateCollectionImpl(ImplAddr);
  const receipt:any = await tx.wait();


  const setConfig = await FactoryProxy.connect(deployer).updateStageConfig(
    2, 7,10000000000000000n);
  _log("Added impl...",receipt.logs);
}

async function _updateMember(FactoryProxyAddress:any, member:any, platFee:any, discount:any){
  const FactoryProxy:MvxFactory = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  const deployer = await ethers.getSigner(ADMIN);
  _log("Adding Member...",member);
  const tx = await FactoryProxy.connect(deployer).updateMember(member,ZERO_ADDRESS,500000000000000000n,platFee,discount,10); // deployfee,platFee,discount,expiration
  const rc : any  = await tx.wait();
  _log("Added Member", rc.logs);
}

async function _createCollection(FactoryProxyAddress:any,sender:any){
  console.log("_createCollection ---")
  const FactoryProxy:MvxFactory = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  const block = {timestamp: (await ethers.provider.getBlock('latest')).timestamp  };
  const stages : Stages = {
    "isMaxSupplyUpdatable": true,
    "ogMintPrice" :300000000000000n,
    "whitelistMintPrice" :300000000000000n,
    "mintPrice" :300000000000000n,
    "mintMaxPerUser" :100n,
    "ogMintMaxPerUser" :100n,
    "mintStart" :block.timestamp,
    "mintEnd" :block.timestamp + 10 * 60 * 60 * 24,
    "ogMintStart" :block.timestamp,
    "ogMintEnd" :block.timestamp + 10 * 60 * 60 * 24,
    "whitelistMintStart" :block.timestamp,
    "whitelistMintEnd" :block.timestamp + 10 * 60 * 60 * 24,
    "whitelistMintMaxPerUser" :100n
  };
  const nftData : Collection= {
    name: "MVX ART",
    symbol: "MVX",
    baseURI: "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/",
    baseExt: ".json",
    royaltyReceiver: sender,
    maxSupply: 3333n,
    royaltyFee: 1000n
  };
  
  const ogs = ["0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146","0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6"]
  const wls = ["0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146","0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6"]

  const signer = await ethers.getSigner(sender);
  console.log(nftData,stages,ogs,wls)
  const tx = await FactoryProxy.connect(signer).createCollection(nftData,stages,ogs,wls,{value:500000000000000000n});
  const rc :any = await tx.wait();  
  _log("Collection1 clone address",rc.logs);
}

async function _updatePartnership(FactoryProxyAddress:any, collection:any,partner:any){
  const FactoryProxy:MvxFactory = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  const deployer = await ethers.getSigner(ADMIN);
  const tx = await FactoryProxy.connect(deployer).updatePartnership(collection,partner,1000,2000,2000,10); // admin%, ref%, disc%, exp days

  const rc : any  = await tx.wait();
  _log("Added Partner", rc.logs);
}

async function _mint(CloneAddress:any,sender:any){
  const MvxCollectionInstance : MvxCollection = await ethers.getContractAt("MvxCollection",CloneAddress);
  const signer = await ethers.getSigner(sender);
  const tx = await MvxCollectionInstance.connect(signer).mintForRegular(sender,1,{value: 300000000000000n});
  const rc : any  = await tx.wait();
  _log("Added Member", rc.logs);

}
async function _grantReferral(FactoryProxyAddress:any, sender:any, artist:any, collection:any,){
  const FactoryProxy:MvxFactory = await ethers.getContractAt("MvxFactory",FactoryProxyAddress);
  const signer = await ethers.getSigner(sender);
  const tx = await FactoryProxy.connect(signer).grantReferral(collection,artist);
  const rc : any  = await tx.wait();
  _log("Added Member", rc.logs);
}

const FACTORY_PROXY_GOERLI = "0xBcB3380Abea0d02523Da897b0D1130F0A792BCBb";

const FACTORY_PROXY_GOERLI_2 = "";

const CLONE_IMPL_GOERLI = "0xad706BF0FFa071D7c99592630425384605668080";
const CLONE_721A= "";

const ADMIN = "0x37aa961D37F3513ae760ea7B704dAe3415f67B2F";
const MEMBER = "0x985Ec7d924Fc4e18ab99C2c7F1Bb83f7898cA146";
const REFERRAL = "0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6";
const ARTIST = "0x57511A8BDe2940229d3bddF20d0FC58097dDd771";

async function main() {
  // _upgradeFactory(FACTORY_PROXY_GOERLI);
  // _deployFactory();
  // _deployCollection();
  // _initFactory(FACTORY_PROXY_GOERLI, CLONE_IMPL_GOERLI);
  // _updateMember(FACTORY_PROXY_GOERLI,MEMBER,0,0);// platformFee, discount
  _createCollection(FACTORY_PROXY_GOERLI, MEMBER);
  // _updatePartnership(FACTORY_PROXY_GOERLI,CLONE_721A,MEMBER);
  // _mint(CLONE_721A,MEMBER);
  // _grantReferral(FACTORY_PROXY_GOERLI,REFERRAL,ARTIST,CLONE_721A);
  //  _updateMember(FACTORY_PROXY_GOERLI,MEMBER,0,0); /// platformFee, discount
  // _createCollection(FACTORY_PROXY_GOERLI, ARTIST); //bingo!
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
