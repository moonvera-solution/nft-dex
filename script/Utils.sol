// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import "../src/Factory.sol";
import {Test, console2} from "../lib/forge-std/src/Test.sol";

contract Utils is Test {
    Factory public factory;
    ArtCollection public clone;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");

    function _initCollection(Factory _factory) internal returns (address _collection) {
        (address[] memory _initialOGMinters, address[] memory _initialWLMinters) = _getMintingUserLists();
        bytes memory nftData = abi.encode("TestName", "SYMBOL", "https://moonvera.io/nft/{id}", ".json");
        _collection = _factory.createCollection{value: 0.05 ether}( // createCollection fee
        nftData, _initialOGMinters, _initialWLMinters, _getMintingStages());
    }

    function _getMintingUserLists()
        internal
        returns (address[] memory _initialOGMinters, address[] memory _initialWLMinters)
    {
        _initialOGMinters = new address[](2);
        _initialOGMinters[0] = address(5);
        _initialOGMinters[1] = address(6);
        _initialWLMinters = new address[](2);
        _initialWLMinters[1] = address(7);
        _initialWLMinters[0] = address(8);
    }

    /**
     * mintStageDetails array content
     *         0 initOgMintPrice
     *         1 ogMintStartTime
     *         2 ogMintEndTime
     *         3 initWLmintPrice
     *         4 wlMintStartTime
     *         5 wlMintEndTime
     *         6 initRegMintprice
     *         7 regMintStartTime
     *         8 regMintEndTime
     */
    function _getMintingStages() public returns (uint256[] memory _mintStageDetails) {
        _mintStageDetails = new uint256[](12);
        _mintStageDetails[0] = 500; //_ogMintPrice
        _mintStageDetails[1] = 500; //_ogMintMax
        _mintStageDetails[2] = block.timestamp + 5 days; //_ogMintStart
        _mintStageDetails[3] = block.timestamp + 5 days; //_ogMintEnd
        _mintStageDetails[4] = 500; //_whitelistMintPrice
        _mintStageDetails[5] = 500; //_whitelistMintMax
        _mintStageDetails[6] = block.timestamp + 5 days; //_whitelistMintStart
        _mintStageDetails[7] = block.timestamp + 5 days; //_whitelistMintEnd
        _mintStageDetails[8] = 500; //_mintPrice
        _mintStageDetails[9] = 500; //_mintMax
        _mintStageDetails[10] = block.timestamp + 5 days; //_mintStart
        _mintStageDetails[11] = block.timestamp + 5 days; //_mintEnd
    }

    fallback() external payable {}
}
