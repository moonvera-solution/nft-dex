import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect } from "chai";
  import { ethers } from "hardhat";
  
  describe("NvxCollections", function () {
    describe("Deployment", function () {
        it("Should only deploy MvxCollection::", async function () {
          const Factory = await ethers.deployContract("MvxFactory",[0]);
          await Factory.deployed();
          const Collection = await ethers.deployContract("MvxCollection",[]);
          await Collection.deployed();

          console.log("wtf");
          await Factory.setCollectionImpl(Collection.address);
          // expect(await lock.unlockTime()).to.equal(unlockTime);
        });
      });
  });