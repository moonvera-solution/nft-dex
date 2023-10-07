// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console2, Vm} from "forge-std/Test.sol";
import "../lib/forge-std/src/Script.sol";

contract Encoder is Script {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");

    function run() public {
        console2.logBytes(_encodeNftDetails());
        console.log("ADMIN_ROLE: ");
        console2.logBytes32(ADMIN_ROLE);

        console.log("WL_MINTER_ROLE: ");
        console2.logBytes32(WL_MINTER_ROLE);

        console.log("OG_MINTER_ROLE: ");
        console2.logBytes32(OG_MINTER_ROLE);
    }

    function _encodeNftDetails() internal pure returns (bytes memory _data) {
        _data = abi.encode(50, 3000, "TestName", "SYMBOL", "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/");
    }
}
