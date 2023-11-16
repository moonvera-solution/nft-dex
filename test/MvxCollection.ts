// import {
//   time,
//   loadFixture,
// } from "@nomicfoundation/hardhat-toolbox/network-helpers";
// import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import "@nomicfoundation/hardhat-ethers";


import { _getGasPrice, _getMinters ,_getStageData,_getColletionData} from "./Utils.ts";


describe("NftCollection", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  
  // async function deployContracts() {


  //   return { FactoryInstance, CollectionInstance ,EncoderInstance};
  // }

  describe("Quote create collection", function () {
    let FactoryInstance:any;
    let CollectionInstance:any;
  
    before(async function () {

  
    })

    it("Deployment Quote", async function () {
      // Fixture
      const signers = await ethers.getSigners();
      const deployer = signers[0];
      const Mvx: any = await ethers.getContractFactory("MvxFactory");
      const FactoryInstance = await Mvx.deploy({ from: deployer });
      await FactoryInstance.initialize();
  
      const MvxColl: any = await ethers.getContractFactory("MvxCollection");
      const CollectionInstance = await MvxColl.deploy({ from: deployer });

      const newImpl = CollectionInstance.target;
      await FactoryInstance.updateCollectionImpl(newImpl);
      const actualImpl = await FactoryInstance.collectionImpl();
      await expect(actualImpl).to.be.equals(newImpl);

      const [Ogs, Wls] = await _getMinters();
      const  CollectionStruct = await _getColletionData(deployer.address);
      const StageStruct = await _getStageData();
      await FactoryInstance.createCollection(CollectionStruct,StageStruct,Ogs,Wls);


    });
  });


  // describe("Withdrawals", function () {
  //   describe("Validations", function () {
  //     it("Should revert with the right error if called too soon", async function () {
  //       const { lock } = await loadFixture(deployOneYearLockFixture);

  //       await expect(lock.withdraw()).to.be.revertedWith(
  //         "You can't withdraw yet"
  //       );
  //     });

  //     it("Should revert with the right error if called from another account", async function () {
  //       const { lock, unlockTime, otherAccount } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       // We can increase the time in Hardhat Network
  //       await time.increaseTo(unlockTime);

  //       // We use lock.connect() to send a transaction from another account
  //       await expect(lock.connect(otherAccount).withdraw()).to.be.revertedWith(
  //         "You aren't the owner"
  //       );
  //     });

  //     it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
  //       const { lock, unlockTime } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       // Transactions are sent using the first signer by default
  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw()).not.to.be.reverted;
  //     });
  //   });

  //   describe("Events", function () {
  //     it("Should emit an event on withdrawals", async function () {
  //       const { lock, unlockTime, lockedAmount } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw())
  //         .to.emit(lock, "Withdrawal")
  //         .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
  //     });
  //   });

  //   describe("Transfers", function () {
  //     it("Should transfer the funds to the owner", async function () {
  //       const { lock, unlockTime, lockedAmount, owner } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw()).to.changeEtherBalances(
  //         [owner, lock],
  //         [lockedAmount, -lockedAmount]
  //       );
  //     });
  //   });
  // });
});