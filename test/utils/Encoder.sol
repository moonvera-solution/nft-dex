// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console2, Vm} from "forge-std/Test.sol";

contract Encoder {
    function _encodeNftDetails() internal pure returns (bytes memory _data) {
        _data = abi.encode(50, 3000, "TestName", "SYMBOL", "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/");
    }
}
