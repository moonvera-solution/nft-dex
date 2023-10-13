// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {Test, console, console2, Vm} from "@forge-std/Test.sol";
import {GasSnapshot} from "@forge-gas-snapshot/GasSnapshot.sol";
import "@solady/utils/LibString.sol";

import "@src/MvxFactory.sol";
import "@src/MvxCollection.sol";

error InvalidColletion(uint8);

contract MvxCollectionInternalsTest is Test, MvxCollection {
    using LibString for string;
    function test_internalSafeMint(
        uint256 _msgValue,
        address _mintTo,
        uint256 _mintPrice,
        uint256 _mintAmount) public {
            uint256 _maxMintAmount = 100;
            vm.assume(_mintTo != address(0x0));
            vm.assume(_mintPrice > 0 && _mintPrice < 5 ether);
            vm.assume(_mintAmount > 0 && _mintAmount < _maxMintAmount);
            vm.assume(_msgValue >_maxMintAmount * _mintPrice  && _msgValue < 5000 ether);
        super._internalSafeMint(
            _msgValue,
            _mintTo,
            _mintPrice,
            _mintAmount,
            _maxMintAmount
        );
        assertEq(mintsPerWallet[msg.sender],_mintAmount);
        assert(balanceOf(_mintTo) == _mintAmount);
    }
}
