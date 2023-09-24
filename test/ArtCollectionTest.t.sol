
// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console,console2} from "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";

import "../src/Factory.sol";
import "../src/ArtCollection.sol";
import "./TestSetUp.sol";

contract ArtCollectionTest is Test,TestSetUp, GasSnapshot{

    function setUp() public{
        vm.deal(user1, 10 ether);
        clone = new ArtCollection();
    }

    /// @notice deployer is Admin
    function test_initialAdminRole() external {
        vm.startPrank(user1,user1);
        Factory factory = new Factory(3000); // takes fee on mint
        factory.updateMember(user1, block.timestamp + 5 days );

        _initialOGMinters = new address[](2);
        _initialOGMinters[0] = user8;
        _initialOGMinters[1] = user9;

        _initialWLMinters = new address[](2);
        _initialWLMinters[0] = user8;
        _initialWLMinters[1] = user9;

        address collection = factory.createCollection{value:.5 ether}(address(clone));
        
        // profiling variants gas cost of ArtCollection::initialize()
        snapStart("INIT CLONE");
        _initCollection(
            _initialOGMinters,
            _initialWLMinters,
            collection
        );
        snapEnd();


        assert(ArtCollection(collection).hasRole(ADMIN_ROLE,user1));
    }

    // function test_initialize() public{
        
    //     _deployInitCollection(user);
    // }

    // function test_getImmutableFee() public{
    //     vm.startPrank(user5,user5);
    //     vm.deal(user5, 10 ether);
    //     Factory newFactory = new Factory(3000);
    //     newFactory.updateMember(user5, block.timestamp + 1 days);
    //     newFactory.updateFeeOnMint(300);

    //     uint256 platformFee = .5 ether;

    //     address newCollection = newFactory.createCollection{value:platformFee}(address(clone));
    //     _initCollection(newCollection);

    // }
}