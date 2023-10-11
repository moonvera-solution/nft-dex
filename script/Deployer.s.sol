// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {Factory} from "../src/Factory.sol";
import {ArtCollection} from "../src/ArtCollection.sol";
import "../lib/forge-std/src/Script.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "./Utils.sol";

contract Deployer is Script, Utils {
    string internal GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");
    uint256 internal BLOCK_NUM = vm.envUint("BLOCK_NUM");

    function run() external {
        address regularMinter = vm.addr(vm.envUint("REG_MINTER_KEY"));
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Factory factory = new Factory(3000);
        ArtCollection template = new ArtCollection();

        factory.setCollectionImpl(address(template));
        factory.updateMember(regularMinter, 5); //
        vm.stopBroadcast();
    }

    /// @notice this is unic UUPS proxy of template not a minimal clone
    function deployTemplateProxy() internal {
        address implementation = address(new ArtCollection());
        address proxy = address(new ERC1967Proxy(0x1CB5908FCDAE2Ad5E628855cF25a30F8026F27df,""));
    }
}
