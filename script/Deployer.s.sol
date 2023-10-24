// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {MvxFactory} from "@src/MvxFactory.sol";
import {MvxCollection} from "@src/MvxCollection.sol";
import "@forge-std/Script.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Test, console} from "@forge-std/Test.sol";

import "./Utils.sol";

contract Deployer is Script {
    string internal GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");
    uint256 internal BLOCK_NUM = vm.envUint("BLOCK_NUM");
    address internal constant FACTORY_GOERLI = 0x335870163d9Bc397ADA314885478E13F1213BeC3;

    function run() external {}

    function deploy() external {
        address regularMinter = vm.addr(vm.envUint("REG_MINTER_KEY"));
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(deployerPrivateKey);
        MvxFactory factory = new MvxFactory(3000);
        MvxCollection template = new MvxCollection();

        factory.updateCollectionImpl(address(template));
        factory.updateMember(regularMinter, address(0x0), 0, 5); //
        vm.stopBroadcast();
    }

    /// @notice this is unic UUPS proxy of template not a minimal clone
    function deployTemplateProxy() internal {
        address implementation = address(new MvxCollection());
        address proxy = address(new ERC1967Proxy(0x1CB5908FCDAE2Ad5E628855cF25a30F8026F27df,""));
    }
}

/**
 */
