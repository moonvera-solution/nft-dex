 // SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;


import {Script, console2} from "forge-std/Script.sol";
import {Factory} from "../src/Factory.sol";
import {ArtCollection} from "../src/ArtCollection.sol";

contract Deployer is Script {
    function _deployCollection(address _sender) internal returns(address _collection) {
        Factory newFactory = new Factory(3000);
        newFactory.updateMember(_sender, block.timestamp + 1 days);
        ArtCollection impl = new ArtCollection();

    }

    function _deployFactory() internal returns(address _factory) {
        Factory newFactory = new Factory(3000);
        _factory = address(newFactory);
    }
}
