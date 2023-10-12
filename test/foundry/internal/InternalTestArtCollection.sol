// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {Test, console, console2, Vm} from "@forge-std/Test.sol";
import {GasSnapshot} from "@forge-gas-snapshot/GasSnapshot.sol";
import "@src/MvxFactory.sol";
import "@src/MvxCollection.sol";

error InvalidColletion(uint8);

contract MvxCollectionInternalsTest is Test, MvxCollection {
    /// @notice Using basis Points as measurement units.
    /// @dev FullMath: core uniswap v3 to mittigate phantom overflow
    function test_calculateFee(uint256 price, uint256 feeOnMint) external {
        vm.assume(price > 0 && price < 5 ether); // upper bound of 5 ether price
        vm.assume(feeOnMint > 0 && feeOnMint < 10000); // less than 10%
        uint256 fee = super._calculateFee(2 ether, 3000);
        assertEq(fee + price, price + 1994000000000000000);
        uint256 a = super._calculateFee(price, feeOnMint);
        uint256 b = FullMath.mulDiv(uint256(price), 1e6 - feeOnMint, 1e6);
        assertEq(a, b);
    }
}
