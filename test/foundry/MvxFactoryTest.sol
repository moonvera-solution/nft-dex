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
        factory = new MvxFactory(.3 ether); // takes fee on mint
        factory.setCollectionImpl(address(clone));

        snapSize("MvxCollection", address(clone));
        vm.deal(address(this), 10 ether);
    }

    function test_member_createCollection() public {
        Vm.Wallet memory regularWallet = vm.createWallet("member");
        factory.updateMember(regularWallet.addr, 5);

        assert(factory.members(regularWallet.addr) > 0);

        vm.startPrank(regularWallet.addr, regularWallet.addr);
        vm.deal(regularWallet.addr, 1 ether);
        _factoryCreate(factory, regularWallet.addr, 1 ether);
    }

    function test_artist_createCollection() public {
        Vm.Wallet memory regularWallet = vm.createWallet("member");
        Vm.Wallet memory referral = vm.createWallet("referral");
        Vm.Wallet memory artist = vm.createWallet("artist");

        // mvs team reviews application and grants member to create coll
        factory.updateMember(regularWallet.addr, 5);

        // mvx member creates collection - NO DISCOUNT
        vm.startPrank(regularWallet.addr);
        vm.deal(regularWallet.addr, 2 ether);
        address _cloneAddress =  _factoryCreate(factory, regularWallet.addr, 1 ether );
        vm.stopPrank();

        // Random Collection members buys NFT becomes referral
        vm.startPrank(referral.addr);
        vm.deal(referral.addr,1 ether);
        MvxCollection(_cloneAddress).mintForRegular{value:1 ether}(referral.addr, 1);
        assert( MvxCollection(_cloneAddress).balanceOf(referral.addr) > 0);
        vm.stopPrank();


        // Mvx team partners with Collection Admin
        factory.setPartnership(
            _cloneAddress, // partner collection 
            regularWallet.addr, // partner address
            1000, // 10% for Acc
            2000, // 20% referrals
            2000 // 20% discount on (deployFee .3 eth),
        );


        // if no partnership set grantReferral Fails
        // mvx member grants referal AFTER creating collection & having balance on it
        vm.startPrank(referral.addr);
        factory.grantReferral(_cloneAddress, artist.addr);
        (,,,uint256 expiration) = factory.artists(artist.addr);
        assert(expiration > 0);
        vm.stopPrank();

        // Mvx grants member after Artist applies, 
        factory.updateMember(artist.addr, 10); // 10 days to Launch


        // Artist Launches Collection
        vm.startPrank(artist.addr);
         vm.deal(artist.addr, 1 ether);

        snapStart("init_clone V2"); // GAS tracking
         _factoryCreate(factory, artist.addr,1 ether);
         snapEnd();
        vm.stopPrank();

         vm.startPrank(referral.addr);
         factory.withdrawReferral(artist.addr);
    }


    // function test_owner() public {
    //     assertTrue(factory.owner() == address(this));
    // }

    // function test_addMember(address _member, uint256 _allowedPeriod) public {
    //     vm.assume(_member != address(0x0));
    //     vm.assume(_allowedPeriod > block.timestamp);
    //     factory.updateMember(address(this), block.timestamp + ALLOW_LAUNCH_PERIOD);
    //     assertTrue(factory.members(address(this)) > block.timestamp);
    // }

    // function test_getTime() public {
    //     assertEq(factory.getTime(), block.timestamp);
    //     vm.warp(block.timestamp);
    //     assertEq(factory.getTime(5), block.timestamp + (5 * 60 * 60 * 24));
    // }
}
