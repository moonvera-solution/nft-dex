// SPDX-License-Identifier: MIT O
pragma solidity 0.8.20;

import {Test, console, console2, Vm} from "forge-std/Test.sol";
import {GasSnapshot} from "@forge-gas-snapshot/GasSnapshot.sol";
import {MvxFactory, Math} from "@src/MvxFactory.sol";
import {MvxCollection} from "@src/MvxCollection.sol";
import "../helpers/BaseTest.sol";

contract MvxFactoryMemberDiscountTest is BaseTest, GasSnapshot {
    using Math for uint72;

    uint16 internal constant ALLOW_LAUNCH_PERIOD = 10;
    uint72 internal constant DEPLOY_FEE = 0.5 ether;
    uint16 internal constant PLATFORM_FEE = 200; //bp 2%
    uint16 internal constant MEMBER_DISCOUNT = 2000; //bp 20%

    event MemberDiscount(address indexed _sender, uint256 _deployFee, uint256 _discountAmt);

    function setUp() public {
        clone = new MvxCollection();
        factory = new MvxFactory(); // takes fee on mint
        factory.initialize();

        vm.deal(address(this), 10 ether);
        snapSize("MvxCollection", address(clone));
        factory.updateCollectionImpl(address(clone));
    }

    /// @dev Expect to create collection sending -20% of deployfee (member discount)
    function test_member_discount() public {
        Vm.Wallet memory member = vm.createWallet("member");
        uint16 _memberDiscount = 2000; // 20% discount
        uint72 _deployFee = 0.5 ether;
        uint256 _feeAfterDiscount = _deployFee - _deployFee.mulDiv(_memberDiscount, 10_000); // basis points
        factory.updateMember(member.addr, address(0x0), _deployFee, 0, _memberDiscount, ALLOW_LAUNCH_PERIOD);

        vm.startPrank(member.addr);
        vm.deal(member.addr, 1 ether);
        address _clone = _factoryCreate(factory, member.addr, _feeAfterDiscount);
        vm.stopPrank();

        assert(_clone != address(0x0));
        assert(address(factory).balance < _deployFee);
        assertEq(address(factory).balance, _feeAfterDiscount);
    }
    /// @dev Up to 255 members get the discount

    function test_fuzz_member_discount(Vm.Wallet memory member, uint16 _memberDiscount, uint72 _deployFee) public {
        vm.assume(_memberDiscount > 0 && _memberDiscount < 5000); // discount bound up to 50%
        vm.assume(_deployFee > 0 && _deployFee < 10 ether);

        uint256 _discountAmt = _deployFee.mulDiv(_memberDiscount, 10_000); // basis points
        uint256 _feeAfterDiscount = _deployFee - _discountAmt;
        factory.updateMember(member.addr, address(0x0), _deployFee, 0, _memberDiscount, ALLOW_LAUNCH_PERIOD);

        vm.startPrank(member.addr);
        vm.deal(member.addr, _deployFee);
        vm.expectEmit(true, true, true, false);
        emit MemberDiscount(member.addr, _deployFee, _discountAmt);
        address _clone = _factoryCreate(factory, member.addr, _feeAfterDiscount);
        assert(_clone != address(0x0));
        vm.stopPrank();
    }
}
