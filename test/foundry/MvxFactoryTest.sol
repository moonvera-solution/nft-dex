// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console, console2, Vm} from "forge-std/Test.sol";
import {GasSnapshot} from "@forge-gas-snapshot/GasSnapshot.sol";
import {MvxFactory} from "@src/MvxFactory.sol";
import {MvxCollection} from "@src/MvxCollection.sol";
import {BaseTest} from "./helpers/BaseTest.sol";

contract MvxFactorytest is BaseTest, GasSnapshot {
    uint160 public constant ALLOW_LAUNCH_PERIOD = 7 days;

    function setUp() public {
        clone = new MvxCollection();
        factory = new MvxFactory(3000); // takes fee on mint
        factory.setCollectionImpl(address(clone));

        snapSize("MvxCollection", address(clone));
        vm.deal(address(this), 10 ether);
    }

    function test_createCollection() public {
        (address[] memory _initialOGMinters, address[] memory _initialWLMinters) = _getMintingUserLists();

        Vm.Wallet memory regularWallet = vm.createWallet("member");
        factory.updateMember(regularWallet.addr, 5);

        assert(factory.members(regularWallet.addr) > 0);

        vm.startPrank(regularWallet.addr, regularWallet.addr);
        vm.deal(regularWallet.addr, 1 ether);

        address MvxCollectionAddr = factory.createCollection{value: 0.5 ether}(
            _encodeNftDetails(), _initialOGMinters, _initialWLMinters, _getMintingStages()
        );
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

    function test_getTime() public {
        assertEq(factory.getTime(), block.timestamp);
        vm.warp(block.timestamp);
        assertEq(factory.getTime(5), block.timestamp + (5 * 60 * 60 * 24));
    }
}