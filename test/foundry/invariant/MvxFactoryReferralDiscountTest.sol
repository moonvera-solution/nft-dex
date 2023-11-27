// SPDX-License-Identifier: MIT O
pragma solidity 0.8.20;

import {Test, console, console2, Vm} from "forge-std/Test.sol";
import {GasSnapshot} from "@forge-gas-snapshot/GasSnapshot.sol";
import {MvxFactory} from "@src/MvxFactory.sol";
import {MvxCollection} from "@src/MvxCollection.sol";
import "../helpers/BaseTest.sol";

contract MvxFactoryReferralDiscountTest is BaseTest, GasSnapshot {
    uint16 internal constant ALLOW_LAUNCH_PERIOD = 10;
    uint72 internal constant DEPLOY_FEE = uint72(0.5 ether);
    uint16 internal constant PLATFORM_FEE = 200; //bp 2%
    uint16 internal constant MEMBER_DISCOUNT = 0; //bp 20%

    function setUp() public {
        clone = new MvxCollection();
        factory = new MvxFactory(); // takes fee on mint
        factory.initialize();

        vm.deal(address(this), 10 ether);
        snapSize("MvxCollection", address(clone));
        factory.updateCollectionImpl(address(clone));
        factory.updateStageConfig(2,7, 1 ether);
        vm.warp(block.timestamp + 10056739);
    }

    function test_member_createCollection() public {
        Vm.Wallet memory member = vm.createWallet("member");
        factory.updateMember(member.addr, address(0x0), 0.5 ether, 0, 0, ALLOW_LAUNCH_PERIOD);

        (,,,, uint256 expiration) = factory.members(member.addr);

        assert(expiration > 0);

        vm.startPrank(member.addr, member.addr);
        vm.deal(member.addr, 1 ether);
        snapStart("CreateClone No discount"); // GAS tracking
        _factoryCreate(factory, member.addr, 1 ether);
        snapEnd();
    }

    function test_artist_createCollection() public {
        Vm.Wallet memory member = vm.createWallet("member");
        Vm.Wallet memory referral = vm.createWallet("referral");
        Vm.Wallet memory artist = vm.createWallet("artist");

        // mvs team reviews application and grants member to create collection
        factory.updateMember(member.addr, address(0x0), 0.5 ether, 0, 0, ALLOW_LAUNCH_PERIOD);

        // mvx member creates collection - NO DISCOUNT
        vm.startPrank(member.addr);
        vm.deal(member.addr, 2 ether);
        address _cloneAddress = _factoryCreate(factory, member.addr, 1 ether);
        vm.stopPrank();

        // Random Collection members buys NFT becomes referral
        vm.startPrank(referral.addr);
        vm.deal(referral.addr, 1 ether);
        vm.warp(_getTime(4));
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
        vm.stopPrank();

        // Mvx grants member after Artist applies,
        factory.updateMember(artist.addr, address(0x0), 0.5 ether, 0, 0, 10); // 10 days to Launch

        // Artist Launches Collection
        vm.startPrank(artist.addr);
        vm.deal(artist.addr, 1 ether);

        _factoryCreate(factory, artist.addr, 0.4 ether);
        vm.stopPrank();

        vm.startPrank(referral.addr);
        factory.withdrawReferral();
        assertEq(factory.referralBalances(referral.addr),0);
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
        vm.assume(user1.addr != address(0x0));
        vm.assume(user2.addr != address(0x0));

        ///0x0000000000000000000000000000000000000000000000000000000000000000
        ///                     INIT MAIN COLLECTION
        ///0x0000000000000000000000000000000000000000000000000000000000000000

        // mvs team reviews application and grants member to create coll
        factory.updateMember(member.addr, address(0x0), DEPLOY_FEE, 0, 0, 10);

        // mvx member creates collection - NO DISCOUNT
        vm.startPrank(member.addr);
        vm.deal(member.addr, 2 ether);
        address _cloneAddress = _factoryCreate(factory, member.addr, 1 ether);
        MvxCollection(_cloneAddress).grantRole(keccak256("WL_MINTER_ROLE"), user2.addr);
        MvxCollection(_cloneAddress).grantRole(keccak256("OG_MINTER_ROLE"), user1.addr);
        vm.stopPrank();

        ///0x0000000000000000000000000000000000000000000000000000000000000000
        ///                         USER MINTINGS
        ///0x0000000000000000000000000000000000000000000000000000000000000000

        // Random Collection members buys NFT to become referrals

        /**
         * OG  *
         */
        vm.startPrank(user1.addr);
        vm.deal(user1.addr, 5 ether);
        MvxCollection(_cloneAddress).mintForOG{value: 5 ether}(user1.addr, 5);
        assert(MvxCollection(_cloneAddress).balanceOf(user1.addr) > 0);
        vm.stopPrank();

        /**
         * WL *
         */
        vm.warp(_getTime(2));
        vm.startPrank(user2.addr);
        vm.deal(user2.addr, 11 ether);
        MvxCollection(_cloneAddress).mintForWhitelist{value: 10 ether}(user2.addr, 10);
        assert(MvxCollection(_cloneAddress).balanceOf(user2.addr) > 0);
        vm.stopPrank();

        /**
         * REGULAR  *
         */
        vm.startPrank(referral.addr);
        vm.deal(referral.addr, 20 ether);
        vm.warp(_getTime(4));
        MvxCollection(_cloneAddress).mintForRegular{value: 20 ether}(referral.addr, 20);
        assert(MvxCollection(_cloneAddress).balanceOf(referral.addr) > 0);
        vm.stopPrank();

        // artist also buys
        vm.startPrank(artist.addr);
        vm.deal(artist.addr, 11 ether);
        MvxCollection(_cloneAddress).mintForRegular{value: 11 ether}(artist.addr, 11);
        assert(MvxCollection(_cloneAddress).balanceOf(artist.addr) > 0);
        vm.stopPrank();
        vm.warp(_getTime(0));

        ///0x0000000000000000000000000000000000000000000000000000000000000000
        ///                      MVX PARTNERS
        ///0x0000000000000000000000000000000000000000000000000000000000000000

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

        ///0x0000000000000000000000000000000000000000000000000000000000000000
        ///                      GRANT REFERRALS
        ///0x0000000000000000000000000000000000000000000000000000000000000000

        // if NO partnership grant Referral Fails
        // mvx member grants referal AFTER creating collection & having balance on it
        vm.startPrank(referral.addr);

        factory.grantReferral(_cloneAddress, user1.addr);
        factory.grantReferral(_cloneAddress, user2.addr);
        vm.stopPrank();

        ///0x0000000000000000000000000000000000000000000000000000000000000000
        ///                      ADD MEMBERS
        ///0x0000000000000000000000000000000000000000000000000000000000000000

        // Mvx grants member after Artist applies,
        factory.updateMember(artist.addr, address(0x0), DEPLOY_FEE, PLATFORM_FEE, MEMBER_DISCOUNT, ALLOW_LAUNCH_PERIOD); // 10 days to Launch
        factory.updateMember(user1.addr, address(0x0), DEPLOY_FEE, PLATFORM_FEE, MEMBER_DISCOUNT, ALLOW_LAUNCH_PERIOD);
        factory.updateMember(user2.addr, address(0x0), DEPLOY_FEE, PLATFORM_FEE, MEMBER_DISCOUNT, ALLOW_LAUNCH_PERIOD);

        ///0x0000000000000000000000000000000000000000000000000000000000000000
        ///                   CREATE COLLECTIONS BY ARTISTS
        ///0x0000000000000000000000000000000000000000000000000000000000000000

        // user1 Launches
        vm.startPrank(user1.addr);
        vm.deal(user1.addr, 1 ether);
        _factoryCreate(factory, user1.addr, 0.4 ether);
        vm.stopPrank();

        // user2 Launches
        vm.startPrank(user2.addr);
        vm.deal(user2.addr, 1 ether);
        _factoryCreate(factory, user2.addr, 0.4 ether);
        vm.stopPrank();

        // Artist Launches
        vm.startPrank(artist.addr);
        vm.deal(artist.addr, 1 ether);
        snapStart("CreateClone Artist Discount"); // GAS tracking
        _factoryCreate(factory, artist.addr, 0.56 ether); // feploy fee = .5 eth - referral discount 20% = .4 eth
        snapEnd();
        vm.stopPrank();

        ///0x0000000000000000000000000000000000000000000000000000000000000000
        ///                      WITHDRAWS
        ///0x0000000000000000000000000000000000000000000000000000000000000000

        /// REFERRALS

        vm.startPrank(referral.addr);
        factory.withdrawReferral();
        vm.stopPrank();

        /// PARTNER
        vm.startPrank(member.addr);
        (,
            address admin,,,,
            uint72 balance,
                    ) = factory.partners(_cloneAddress);
        assertEq(admin,member.addr);
        uint256 _balanceB4withdraw = member.addr.balance;
        uint256 _factoryBalanceB4Withdraw = address(factory).balance;
        factory.withdrawPartner(_cloneAddress);
        assertEq(member.addr.balance, _balanceB4withdraw + balance);
        assertEq(address(factory).balance, _factoryBalanceB4Withdraw - balance);
        (,,,,,uint72 _balance,) = factory.partners(_cloneAddress);
         assertEq(_balance,0);
        vm.stopPrank();

        factory.withdraw();
    }

    function test_withdrawAdmin() public {
        vm.deal(address(factory), 10 ether);
        assert(address(factory).balance > 0);
        factory.withdraw();
        assert(address(factory).balance == 0);
    }

    fallback() external payable {}
}
