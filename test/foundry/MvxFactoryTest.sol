// SPDX-License-Identifier: MIT O
pragma solidity 0.8.20;

import {Test, console, console2, Vm} from "forge-std/Test.sol";
import {GasSnapshot} from "@forge-gas-snapshot/GasSnapshot.sol";
import {MvxFactory} from "@src/MvxFactory.sol";
import {MvxCollection} from "@src/MvxCollection.sol";
import "./helpers/BaseTest.sol";

contract MvxFactorytest is BaseTest, GasSnapshot {
    uint160 public constant ALLOW_LAUNCH_PERIOD = 7 days;

    function setUp() public {
        clone = new MvxCollection();
        factory = new MvxFactory(.3 ether); // takes fee on mint

        snapSize("MvxCollection", address(clone));
        vm.deal(address(this), 10 ether);
        factory.updateCollectionImpl(address(clone));
        // vm.warp(block.timestamp + 100 days);
    }

    function test_member_createCollection() public {
        Vm.Wallet memory member = vm.createWallet("member");
        factory.updateMember(member.addr, address(0x0), 0, 10);
        (,, uint256 expiration) = factory.members(member.addr);

        assert(expiration > 0);

        vm.startPrank(member.addr, member.addr);
        vm.deal(member.addr, 1 ether);
        _factoryCreate(factory, member.addr, 1 ether);
    }

    function test_artist_createCollection() public {
        Vm.Wallet memory member = vm.createWallet("member");
        Vm.Wallet memory referral = vm.createWallet("referral");
        Vm.Wallet memory artist = vm.createWallet("artist");

        // mvs team reviews application and grants member to create coll
        factory.updateMember(member.addr, address(0x0), 0, 10);

        // mvx member creates collection - NO DISCOUNT
        vm.startPrank(member.addr);
        vm.deal(member.addr, 2 ether);
        address _cloneAddress = _factoryCreate(factory, member.addr, 1 ether);
        vm.stopPrank();

        // Random Collection members buys NFT becomes referral
        vm.startPrank(referral.addr);
        vm.deal(referral.addr, 1 ether);
        MvxCollection(_cloneAddress).mintForRegular{value: 1 ether}(referral.addr, 1);
        assert(MvxCollection(_cloneAddress).balanceOf(referral.addr) > 0);
        vm.stopPrank();

        // Mvx team partners with Collection Admin
        // Member becomes partner
        factory.updatePartnership(
            _cloneAddress, // partner collection
            member.addr, // partner address
            1000, // 10% for Acc
            2000, // 20% referrals
            2000, // 20% discount on (deployFee .3 eth),
            10 // 10 days from today
        );

        // if NO partnership grant Referral Fails
        // mvx member grants referal AFTER creating collection & having balance on it
        vm.startPrank(referral.addr);
        factory.grantReferral(_cloneAddress, artist.addr);
        (,,, uint256 expiration) = factory.artists(artist.addr);
        assert(expiration > 0);
        vm.stopPrank();

        // Mvx grants member after Artist applies,
        factory.updateMember(artist.addr, address(0x0), 0, 10); // 10 days to Launch

        // Artist Launches Collection
        vm.startPrank(artist.addr);
        vm.deal(artist.addr, 1 ether);

        snapStart("init_clone V2"); // GAS tracking
        _factoryCreate(factory, artist.addr, 0.3 ether);
        snapEnd();
        vm.stopPrank();

        vm.startPrank(referral.addr);
        factory.withdrawReferral(artist.addr);
    }

    function test_fuzz_artist_createCollection(
        Vm.Wallet memory member,
        Vm.Wallet memory referral,
        Vm.Wallet memory artist,
        Vm.Wallet memory user1,
        Vm.Wallet memory user2
    ) public {
        vm.assume(member.addr != address(0x0));
        vm.assume(referral.addr != address(0x0));
        vm.assume(artist.addr != address(0x0));

        // mvs team reviews application and grants member to create coll
        factory.updateMember(member.addr, address(0x0), 5, 10);

        // mvx member creates collection - NO DISCOUNT
        vm.startPrank(member.addr);
        vm.deal(member.addr, 2 ether);
        address _cloneAddress = _factoryCreate(factory, member.addr, 1 ether);
        MvxCollection(_cloneAddress).grantRole(WL_MINTER_ROLE, user2.addr);
        MvxCollection(_cloneAddress).grantRole(OG_MINTER_ROLE, user1.addr);
        vm.stopPrank();

        // Random Collection members buys NFT becomes referral
        vm.startPrank(referral.addr);
        vm.deal(referral.addr, 20 ether);
        MvxCollection(_cloneAddress).mintForRegular{value: 20 ether}(referral.addr, 20);
        assert(MvxCollection(_cloneAddress).balanceOf(referral.addr) > 0);
        vm.stopPrank();

        // artist also buys
        vm.startPrank(artist.addr);
        vm.deal(artist.addr, 11 ether);
        MvxCollection(_cloneAddress).mintForRegular{value: 11 ether}(artist.addr, 11);
        assert(MvxCollection(_cloneAddress).balanceOf(artist.addr) > 0);
        vm.stopPrank();

        // user1 mints for OG
        vm.startPrank(user1.addr);
        vm.deal(user1.addr, 5 ether);
        MvxCollection(_cloneAddress).mintForOG{value: 5 ether}(user1.addr, 5);
        assert(MvxCollection(_cloneAddress).balanceOf(user1.addr) > 0);
        vm.stopPrank();

        // user2 mints for WL
        vm.startPrank(user2.addr);
        vm.deal(user2.addr, 11 ether);
        MvxCollection(_cloneAddress).mintForWhitelist{value: 10 ether}(user2.addr, 10);
        assert(MvxCollection(_cloneAddress).balanceOf(user2.addr) > 0);
        vm.stopPrank();

        // Mvx team partners with Collection Admin
        // Member becomes partner
        factory.updatePartnership(
            _cloneAddress, // partner collection
            member.addr, // partner address
            1000, // 10% for Acc
            2000, // 20% referrals
            2000, // 20% discount on (deployFee .3 eth),
            10 // 10 days expiration from now
        );

        // if NO partnership grant Referral Fails
        // mvx member grants referal AFTER creating collection & having balance on it
        vm.startPrank(referral.addr);
        factory.grantReferral(_cloneAddress, artist.addr);
        factory.grantReferral(_cloneAddress, user1.addr);
        factory.grantReferral(_cloneAddress, user2.addr);
        (,,, uint256 expiration) = factory.artists(artist.addr);
        assert(expiration > 0);
        vm.stopPrank();

        // Mvx grants member after Artist applies,
        factory.updateMember(artist.addr, address(0x0), 0, 10); // 10 days to Launch
        factory.updateMember(user1.addr, address(0x0), 0, 10);
        factory.updateMember(user2.addr, address(0x0), 0, 10);

        //user1 user1 Launches
        vm.startPrank(user1.addr);
        vm.deal(user1.addr, 1 ether);
        _factoryCreate(factory, user1.addr, 0.3 ether);
        vm.stopPrank();

        // user2 user2 Launches
        vm.startPrank(user2.addr);
        vm.deal(user2.addr, 1 ether);
        _factoryCreate(factory, user2.addr, 0.3 ether);
        vm.stopPrank();

        // Artist Launches
        vm.startPrank(artist.addr);
        vm.deal(artist.addr, 1 ether);
        snapStart("init_clone V2"); // GAS tracking
        _factoryCreate(factory, artist.addr, 0.3 ether);
        snapEnd();
        vm.stopPrank();

        // Artist Withdraws
        vm.startPrank(referral.addr);
        factory.withdrawReferral(artist.addr);
        vm.stopPrank();

        vm.startPrank(referral.addr);
        factory.withdrawReferral(user1.addr);
        vm.stopPrank();

        vm.startPrank(referral.addr);
        factory.withdrawReferral(user2.addr);
        vm.stopPrank();

        vm.startPrank(member.addr);
        factory.withdrawPartner(_cloneAddress);
        console.log("member balance: ", member.addr.balance);
        vm.stopPrank();
    }
}
