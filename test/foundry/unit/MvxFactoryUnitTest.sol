
// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;
import {Test, console, console2, Vm} from "forge-std/Test.sol";

import {Stages, Collection, Partner, Member} from "@src/libs/MvxStruct.sol";
import "../helpers/BaseTest.sol";
import {MvxFactory} from "@src/MvxFactory.sol";
import {Test, console2, Vm} from "@forge-std/Test.sol";

import {MvxCollection} from "@src/MvxCollection.sol";

error InvalidColletion(uint8);

contract MvxFactoryInternalsTest  is BaseTest{
    uint256 public immutable ALLOW_LAUNCH_PERIOD = 10;
    function setUp() public {
        clone = new MvxCollection();
        factory = new MvxFactory(); // takes fee on mint
        factory.initialize();

        vm.deal(address(this), 10 ether);

        factory.updateCollectionImpl(address(clone));
        factory.updateReferralExpiration(ALLOW_LAUNCH_PERIOD); // 10 days
    }

    function test_withdraw_referral()public {


    }

}
