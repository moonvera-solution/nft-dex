// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console2} from "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";


import "../src/Factory.sol";
import "../script/Deployer.sol";

contract Factorytest is Test, GasSnapshot{
    Factory public factory;
    ArtCollection public clone;

    uint160 public constant ALLOW_LAUNCH_PERIOD = 7 days;
    bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");
    address user1 = address(1);

    function setUp() public {
        clone = new ArtCollection();
        factory = new Factory(3000); // takes fee on mint
        factory.updateCollectionImpl(address(clone));
         snapSize("ArtCollection", address(clone));
        vm.deal(address(this), 10 ether);
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

    function test_createCollection() public {
        address newCollection = factory.createCollection{value: .5 ether}();
        address collectedCollection = factory.collections(address(this));
        // snap("test_createCollection:: new user collection",factory.collections(address(this)));
        assertTrue(
            factory.collections(address(this)) == address(newCollection)
        );
    }
}
