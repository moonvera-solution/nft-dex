
const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat")
import * as dotenv from "dotenv";
import axios from 'axios';
dotenv.config();
import { MvxFactory, MvxCollection } from "../typechain-types/index";
import { Collection, Stages } from "../typechain/type-chains";
const _log = (a: any, b: any): any => console.log("\n", a, b, "\n");
const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
const _sleep = (ms: any) => new Promise(resolve => setTimeout(resolve, ms));

let ethPrice:any,maticPrice:any;

const _fetchNaticePrice = async (token: any) => {
  try {
    const response = await axios.get(token === "ETH" ? `https://api.etherscan.io/api?module=stats&action=ethprice&apikey=4PKTG97IJD2JS3BSZQTJ3BX4YS5W3BMP4G` :
      `https://api.polygonscan.com/api?module=stats&action=maticprice&apikey=U5HPG45VAZXXSJJTR32ABXVHPCIKYPE347`);
    const data = response.data && await response.data.result;
    token == "ETH" ? ethPrice = data.ethusd : maticPrice = data.maticusd;
  } catch (error) {
    console.error(error);
  }
  // ethPrice && _log("Eth price", ethPrice);
  // maticPrice && _log("matic price",maticPrice);
};

const _getCollectionParams = async (sender: any, collectionName:any) => {
  const block = { timestamp: (await ethers.provider.getBlock('latest')).timestamp };
  const stages: Stages = {
    "isMaxSupplyUpdatable": true,
    "ogMintPrice": 300000000000000n,
    "whitelistMintPrice": 300000000000000n,
    "mintPrice": 300000000000000n,
    "mintMaxPerUser": 100n,
    "ogMintMaxPerUser": 100n,
    "mintStart": block.timestamp + (60 * 60 * 24 * 4),
    "mintEnd": block.timestamp + (60 * 60 * 24 * 7),
    "ogMintStart": block.timestamp,
    "ogMintEnd": block.timestamp + (60 * 60 * 24 * 2),
    "whitelistMintStart": block.timestamp + (60 * 60 * 24 * 2),
    "whitelistMintEnd": block.timestamp + (60 * 60 * 24 * 4),
    "whitelistMintMaxPerUser": 100n
  };
  const nftData: Collection = {
    name: collectionName,
    symbol: collectionName.substring(0,3),
    baseURI: "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/",
    baseExt: ".json",
    royaltyReceiver: sender,
    maxSupply: 3333n,
    royaltyFee: 1000n
  };

  const ogs = [
"0x37aa961D37F3513ae760ea7B704dAe3415f67B2F",
"0x3dA11876878901b88D1cd8d44d9Fa2948B04e1E2",
"0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6",
"0x57511A8BDe2940229d3bddF20d0FC58097dDd771",
"0x43485E0c99f655daCe99d9D097a4972eef9B32A1",
"0x463D86D513C62f724f00c94E15330762b383dCb6"]
  const wls = [
    "0x37aa961D37F3513ae760ea7B704dAe3415f67B2F",
    "0x3dA11876878901b88D1cd8d44d9Fa2948B04e1E2",
    "0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6",
    "0x57511A8BDe2940229d3bddF20d0FC58097dDd771",
    "0x43485E0c99f655daCe99d9D097a4972eef9B32A1",
    "0x463D86D513C62f724f00c94E15330762b383dCb6"]
  return [stages,nftData,ogs,wls];
}
async function _upgradeFactory(FACTORY_PROXY_GOERLI: any) {
  const Factory: MvxFactory = await hre.ethers.getContractFactory("MvxFactory");
  const box = await upgrades.upgradeProxy(FACTORY_PROXY_GOERLI, Factory);
  console.log("Factory impl upgraded", box);

}

async function _deployFactory() {
  const Factory: MvxFactory = await hre.ethers.getContractFactory("MvxFactory");
  const FactoryProxy: MvxFactory = await upgrades.deployProxy(Factory, { initializer: "initialize", kind: 'uups' });
  await FactoryProxy.waitForDeployment();
  const FactoryAddress = await FactoryProxy.getAddress();

  // await Factory.initialize(_nftData,_mintingStages,_ogs,_wls);

  _log("FactoryProxy deployed to:", FactoryAddress);
  let bbImplAddress = await upgrades.erc1967.getImplementationAddress(FactoryAddress);

  _log("Impl deployed to:", bbImplAddress);
  await hre.run("verify:verify", { address: bbImplAddress });
}

async function _deployCollection() {
  // const Collection: any = await hre.ethers.getContractFactory("MvxCollection");
  // const CollectionInstance = await Collection.deploy();
  // const CollectionAddress = await CollectionInstance.getAddress();
  // _log("Collection 721A impl deployed to:", CollectionAddress);
  await hre.run("verify:verify", { address: "0x21E9137d1C541Fa0CA220f6Bef908d35CF6E8b45" });
}

async function _initFactory(FactoryProxyAddress: any, ImplAddr: any) {
  const deployer = await ethers.getSigner(ADMIN);
  const FactoryProxy: any = await ethers.getContractAt("MvxFactory", FactoryProxyAddress);
  const tx = await FactoryProxy.connect(deployer).updateCollectionImpl(ImplAddr);
  const receipt: any = await tx.wait();

  const setConfig = await FactoryProxy.connect(deployer).updateStageConfig(
    2, 7, 10000000000000000n);
  _log("Added impl...", receipt.logs);
}

async function _updateMember(FactoryProxyAddress: any, member: any, deployFee: any, platFee: any, discount: any) {
  const FactoryProxy: MvxFactory = await ethers.getContractAt("MvxFactory", FactoryProxyAddress);
  const deployer = await ethers.getSigner(ADMIN);
  _log("Adding Member...", member);
  const tx = await FactoryProxy.connect(deployer).updateMember(member, ZERO_ADDRESS, deployFee, platFee, discount, 10); // deployfee,platFee,discount,expiration
  const rc: any = await tx.wait();
  _log("Added Member", rc.logs);
}

async function _createCollection(FactoryProxyAddress: any, sender: any, collectionName:any, _deployFee:any) {
  const [stages,nftData,ogs,wls] = await _getCollectionParams(sender,collectionName);
  const FactoryProxy: MvxFactory = await ethers.getContractAt("MvxFactory", FactoryProxyAddress);
  const signer = await ethers.getSigner(sender);
  console.log(nftData, stages, ogs, wls)
  const tx = await FactoryProxy.connect(signer).createCollection(nftData, stages, ogs, wls, { value: _deployFee});//500000000000000000n });
  const rc: any = await tx.wait();
  _log("Collection1 clone address", rc.logs);
}

async function _updatePartnership(FactoryProxyAddress: any, collection: any, partner: any) {
  const FactoryProxy: MvxFactory = await ethers.getContractAt("MvxFactory", FactoryProxyAddress);
  const deployer = await ethers.getSigner(ADMIN);
  const tx = await FactoryProxy.connect(deployer).updatePartnership(collection, partner, 1000, 2000, 2000, 180); // admin%, ref%, disc%, exp days
  const rc: any = await tx.wait();
  _log("Added Partner", rc.logs);
}

async function _updatePublicEndTime(CloneAddress: any, sender: any, weeks: any) {
  const MvxCollectionInstance: any = await ethers.getContractAt("MvxCollection", CloneAddress);
  const signer = await ethers.getSigner(sender);
  const tx = await MvxCollectionInstance.connect(signer).updatePublicEndTime(weeks, { value: 10000000000000000n });
  const rc: any = await tx.wait();
  _log("Added Partner", rc.logs);
}

async function _grantReferral(FactoryProxyAddress: any, sender: any, artist: any, collection: any,) {
  const FactoryProxy: MvxFactory = await ethers.getContractAt("MvxFactory", FactoryProxyAddress);
  const signer = await ethers.getSigner(sender);
  const tx = await FactoryProxy.connect(signer).grantReferral(collection, artist);
  const rc: any = await tx.wait();
  _log("Added Member", rc.logs);
}

async function _mint(CloneAddress: any, stage: any, sender: any, to: any, amount: any, payment: any) {
  const MvxCollectionInstance: any = await ethers.getContractAt("MvxCollection", CloneAddress);
  const signer = await ethers.getSigner(sender);
  let tx;
  switch (stage) {
    case "OG":
      tx = await MvxCollectionInstance.connect(signer).mintForOG(to, amount, { value: payment })
    case "WL":
      tx = await MvxCollectionInstance.connect(signer).mintForWhitelist(to, amount, { value: payment })
    case "PUBLIC":
      tx = await MvxCollectionInstance.connect(signer).mintForRegular(to, amount, { value: payment })
    case "OWNER":
      tx = await MvxCollectionInstance.connect(signer).mintForOwner(to, amount, { value: payment })
  }
  const rc: any = await tx.wait();
  _log("Added Member", rc.logs);
}

async function _grantRole(CloneAddress: any, role: any, sender: any, to: any) {
  const MvxCollectionInstance: any = await ethers.getContractAt("MvxCollection", CloneAddress);
  const signer = await ethers.getSigner(sender);
  let tx;
  switch (role) {
    case "ADMIN":
      tx = await MvxCollectionInstance.connect(signer).grantRole("0xa49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775", to);
    case "OPERATOR":
      tx = await MvxCollectionInstance.connect(signer).grantRole("0x97667070c54ef182b0f5858b034beac1b6f3089aa2d3188bb1e8929f4fa9b929", to);
    case "OG":
      tx = await MvxCollectionInstance.connect(signer).grantRole("0xcb7e89b7eed8294d41c0215e2f4fe023e2166afcfa3d1f479c394274afe5f019", to);
    case "WL":
      tx = await MvxCollectionInstance.connect(signer).grantRole("0x9eb10b7eab35fabb5491c526a3cf39c3bb7ce2ee5d483e1558635d2c96c2085c", to);
  }
  const rc: any = await tx.wait();
  _log(`Granted ${role} Role to`, to);
}

const FACTORY_PROXY_GOERLI = "0x4e5869Fec55771Bd9E4Be38B9219c28b8dc7f8Bb"//"0x0f1eD4c89494fd16933fEA9518D9018f4a7EFb9e";
const FACTORY_PROXY_MUMBAI = "0x80B5867444B0a414642E30DF3e73ce2Ff33b4f7E";
//0x50E73FBbBB67126Bd684bA60D9Db4500C89E8222 

const CLONE_IMPL_GOERLI = "0x852d88D30CC00009248B29a2b5325204F4242Aa3";
const CLONE_IMPL_MUMBAI = "0x585821A83A5270364D6e5c5C2f050822D53a2c2e";


// Collections clones 721A
// latest = 0x7F98a9f44b848617347Caa2834318c8397E7dB4c
const CLONE_721A_GOERLI = "0x2766a74D583091F09dB14527e2A1C1Bed949d9ea"
//"0x6052C6baE8c1151d4f3562669F7C77f1b1ae2856"
//"0x9a50c53c62CA5bd1F6854b5884B1BA6C829bD36e";
// 0xDDCbF135D145C186CF424ADd657c0E92B39D739C
// 0xD2e2bb0Bba058aed8B4e28F1166fC915519518F0

const ADMIN = "0x37aa961D37F3513ae760ea7B704dAe3415f67B2F";
const MEMBER_2 = "0x3dA11876878901b88D1cd8d44d9Fa2948B04e1E2";
const REFERRAL = "0x2ff9cb5A21981e8196b09AD651470b41Ba28b9C6";
const ARTIST = "0x57511A8BDe2940229d3bddF20d0FC58097dDd771";
const GHALEB_MEMBER = "0x43485E0c99f655daCe99d9D097a4972eef9B32A1";
const GHALEB_MEMBER_2 = "0x463D86D513C62f724f00c94E15330762b383dCb6";

const DEPLOY_PRICE_USD = 1000;
async function main() {
  await _fetchNaticePrice("ETH");
  await _fetchNaticePrice("MATIC");
  const _deployFeeEth = ethers.parseEther(String(DEPLOY_PRICE_USD / ethPrice));
  const _deployFeeMatic = ethers.parseEther(String(DEPLOY_PRICE_USD / maticPrice));

  // await _upgradeFactory(FACTORY_PROXY_GOERLI);
  // await _deployFactory();
  // await _deployCollection();

  // await _initFactory(FACTORY_PROXY_GOERLI, CLONE_IMPL_GOERLI);
  // await _initFactory(FACTORY_PROXY_MUMBAI, CLONE_IMPL_MUMBAI);
  // const price = ethers.parseEther(String(DEPLOY_PRICE_USD / ethPrice));
  // await _updateMember(FACTORY_PROXY_GOERLI,ADMIN,price,0,0); // platformFee, discount
  // await _updateMember(FACTORY_PROXY_MUMBAI,ADMIN,price,0,2000);// deployFee, platformFee, discount
  // ethers.parseEther(String(DEPLOY_PRICE_USD / maticPrice))

  // await _createCollection(FACTORY_PROXY_GOERLI,"CODE4RENA", ADMIN);
  // await _createCollection(FACTORY_PROXY_MUMBAI,"7LOW4M3", ADMIN);

  // await _updatePartnership(FACTORY_PROXY_GOERLI,CLONE_721A_GOERLI,MEMBER_2);
  // await _grantRole(CLONE_721A_GOERLI,"OG",MEMBER_2,ARTIST);

  // await _mint(CLONE_721A_GOERLI,"OWNER",ADMIN,ADMIN,1,300000000000000n) // (CloneAddress, stage,sender,to,amount,payment) {

  // await _grantReferral(FACTORY_PROXY_GOERLI,ADMIN,ARTIST,CLONE_721A_GOERLI);

  // await _updateMember(FACTORY_PROXY_GOERLI,ARTIST,_deployFeeEth,2000,0); // deployfee,platFee,discount
  await _createCollection(FACTORY_PROXY_GOERLI, ARTIST,"SOLADY",_deployFeeEth);
  process.exit();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
