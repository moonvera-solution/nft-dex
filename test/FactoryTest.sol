// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console} from "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";
import "./TestSetUp.sol";

import "../src/Factory.sol";
import "../script/Deployer.sol";

contract Factorytest is Test, TestSetUp, GasSnapshot{

    uint160 public constant ALLOW_LAUNCH_PERIOD = 7 days;

    function setUp() public {
        clone = new ArtCollection();
        factory = new Factory(3000); // takes fee on mint
        factory.setCollectionImpl(address   (clone));
        
         snapSize("ArtCollection", address(clone));
        vm.deal(address(this), 10 ether);

        vm.warp(9771973 + 20 days);
        console.log("block.timestamp::::::  ",block.timestamp);
    }

    function test_owner() public {
        assertTrue(factory._owner() == address(this));
    }

    function test_addMember(address _member, uint256 _allowedPeriod) public {
        vm.assume(_member != address(0x0));
        vm.assume(_allowedPeriod > block.timestamp);
        factory.updateMember(address(this), block.timestamp + ALLOW_LAUNCH_PERIOD);
        assertTrue(factory.members(address(this)) > block.timestamp);
    }

    // function test_createCollection() public {
    //         (
    //         address[] memory _initialOGMinters,
    //         address[] memory _initialWLMinters
    //     ) = _getMintingUserLists();
    //     address newCollection = factory.createCollection{value: .5 ether}(
    //         "TestName", //string memory _name,
    //         "SYMBOL", // string memory _symbol,
    //         "https://moonvera.io/nft/{id}", // string memory _initBaseURI,
    //         ".json", // base extension
    //         50, //max Supply
    //         3000, // royalty fee 3% in basis points
    //         _initialOGMinters,
    //         _initialWLMinters,
    //         _getMintStageDetails()
    //     );
    //     address collectedCollection = factory.collections(address(this));
    //     // snap("test_createCollection:: new user collection",factory.collections(address(this)));
    //     assertTrue(
    //         factory.collections(address(this)) == address(newCollection)
    //     );
    // }
}
