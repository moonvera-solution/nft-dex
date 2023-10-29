// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {Test, console, console2, Vm} from "forge-std/Test.sol";

import {Stages, Collection, Partner, Member, Artist} from "@src/libs/MvxStruct.sol";
import {MvxFactory} from "@src/MvxFactory.sol";
import {Test, console2, Vm} from "@forge-std/Test.sol";

import {MvxFactory} from "@src/MvxFactory.sol";

error InvalidColletion(uint8);

contract MvxFactoryInternalsTest is MvxFactory, Test {
    Vm.Wallet public partner = vm.createWallet("partner");
    Vm.Wallet public artist = vm.createWallet("artist");
    Vm.Wallet public referral = vm.createWallet("referral");
    // event Log(string, uint256);

    function test_fuzz_applyDiscount(
        uint256 deployFee,
        address collection,
        uint256 msgValue,
        uint96 _referralOwnPercent,
        uint96 _adminOwnPercent,
        uint96 _discount
    ) public {
        vm.assume(deployFee > 0 && deployFee < 5 ether);
        vm.assume(collection != address(0x0));
        vm.assume(msgValue > deployFee);
        vm.assume(_referralOwnPercent > 0 && _referralOwnPercent < 5000);
        vm.assume(_adminOwnPercent > 0 && _adminOwnPercent < 5000);
        vm.assume(_discount > 0 && _discount < 5000);

        address sender = artist.addr;

        // get artist by artist address
        Artist memory artistObj = Artist({referral: referral.addr, referralBalance: 0, collection: collection});
        artists[artist.addr] = artistObj;

        // get partner by collection
        Partner memory partnerObj = Partner({
            admin: partner.addr,
            adminOwnPercent: _adminOwnPercent,
            referralOwnPercent: _referralOwnPercent,
            balance: 0,
            discount: _discount,
            expiration: 10
        });

        uint256 _discountAmount = _percent(deployFee, partnerObj.discount);
        uint256 _deployFeeAfterDiscounts = deployFee - _discountAmount;

        partners[artistObj.collection] = partnerObj;
        super._applyArtistDiscount(artistObj,partnerObj, sender, msgValue, deployFee,_discountAmount);
        partnerObj = partners[artistObj.collection];

        uint256 _referalDiscount = _percent(_deployFeeAfterDiscounts, partnerObj.referralOwnPercent);
        assertEq(artistObj.referralBalance, _referalDiscount);
        uint256 _partnerDiscount = _percent(_deployFeeAfterDiscounts, partnerObj.adminOwnPercent);
        assertEq(partnerObj.balance, _partnerDiscount);
        uint256 remain = _deployFeeAfterDiscounts - (_referalDiscount + _partnerDiscount);
        assertEq(remain, (_deployFeeAfterDiscounts - (artistObj.referralBalance + partnerObj.balance)));
    }
}
