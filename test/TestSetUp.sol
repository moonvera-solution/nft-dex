// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console2} from "forge-std/Test.sol";
import "../src/Factory.sol";
import "../script/Deployer.sol";

contract TestSetUp is Test {

    Factory public factory;
    ArtCollection public clone;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");

    address[] public _initialOGMinters;
    address[] public _initialWLMinters;
    address public user1 = address(1);
    address public user2 = address(2);
    address public user3 = address(3);
    address public user4 = address(4);
    address public user5 = address(5);
    address public user6 = address(6);
    address public user7 = address(7);
    address public user8 = address(8);
    address public user9 = address(9);
    address public user10 = address(10);

    function _initCollection(address _implAddress) internal { 
        ArtCollection(_implAddress).initialize(
            "TestName", //string memory _name,
            "SYMBOL", // string memory _symbol,
            "https://moonvera.io/nft/{id}", // string memory _initBaseURI,
            ".json", // base extension
            _initialOGMinters,
            _initialWLMinters,
            1 ether, // uint256 _initWhitelistMintPrice,
            1 ether, // uint256 _initMintPrice,
            1 ether, // uint256 _initOGMintPrice
            50 // mintMax
        );
    }


    function _initCollection(
        address[] memory _initialOGMintersList,
        address[] memory _initialWLMintersList,
        address _implAddress
    ) internal {
        ArtCollection(_implAddress).initialize(
            "TestName", //string memory _name,
            "SYMBOL", // string memory _symbol,
            "https://moonvera.io/nft/{id}", // string memory _initBaseURI,
            ".json", // base extension
            _initialOGMintersList,
            _initialWLMintersList,
            1 ether, // uint256 _initWhitelistMintPrice,
            1 ether, // uint256 _initMintPrice,
            1 ether, // uint256 _initOGMintPrice
            50 // mintMax
        );
    }
    
}
