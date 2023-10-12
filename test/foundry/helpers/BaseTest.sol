// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console2, Vm} from "@forge-std/Test.sol";
import "@src/MvxFactory.sol";

contract BaseTest is Test {
    MvxFactory public factory;
    MvxCollection public clone;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");

    Vm.Wallet public wallet1 = vm.createWallet("wallet::user1");
    address public user2 = address(2);
    address public user3 = address(3);
    address public user4 = address(4);
    address public user5 = address(5);
    address public user6 = address(6);
    address public user7 = address(7);
    address public user8 = address(8);
    address public user9 = address(9);
    address public user10 = address(10);

    function _initCollectionFromMvxFactory(MvxFactory factory) internal {
        (address[] memory _initialOGMinters, address[] memory _initialWLMinters) = _getMintingUserLists();
        bytes memory nftData = abi.encode("TestName", "SYMBOL", "https://moonvera.io/nft/{id}", ".json");
        factory.createCollection{value: 0.05 ether}(nftData, _initialOGMinters, _initialWLMinters, _getMintingStages()); // createCollection fee
    }

    function _initCollection(address _collection, uint256 mintFee) internal returns (bytes memory _data) {
        bytes memory nftData = abi.encode("TestName", "SYMBOL", "https://moonvera.io/nft/{id}", ".json");
        (address[] memory _initialOGMinters, address[] memory _initialWLMinters) = _getMintingUserLists();
        MvxCollection(_collection).initialize(
            mintFee, nftData, _initialOGMinters, _initialWLMinters, _getMintingStages()
        );
    }

    function _getMintingUserLists()
        internal
        returns (address[] memory _initialOGMinters, address[] memory _initialWLMinters)
    {
        _initialOGMinters = new address[](2);
        _initialOGMinters[0] = user5;
        _initialOGMinters[1] = user6;
        _initialWLMinters = new address[](2);
        _initialWLMinters[1] = user7;
        _initialWLMinters[0] = user8;
    }

    function _getMintingStages() public returns (uint256[] memory _mintStageDetails) {
        _mintStageDetails = new uint256[](12);
        _mintStageDetails[0] = 1; //_ogMintPrice
        _mintStageDetails[1] = 50; //_ogMintMax
        _mintStageDetails[2] = block.timestamp; //_ogMintStart
        _mintStageDetails[3] = block.timestamp + 5 * 60 * 60 * 24; //_ogMintEnd
        _mintStageDetails[4] = 1; //_whitelistMintPrice
        _mintStageDetails[5] = 50; //_whitelistMintMax
        _mintStageDetails[6] = block.timestamp; //_whitelistMintStart
        _mintStageDetails[7] = block.timestamp + 5 * 60 * 60 * 24; //_whitelistMintEnd
        _mintStageDetails[8] = 1; //_mintPrice
        _mintStageDetails[9] = 50; //_mintMax
        _mintStageDetails[10] = block.timestamp; //_mintStart
        _mintStageDetails[11] = block.timestamp + 5 * 60 * 60 * 24; //_mintEnd
    }

    function _encodeNftDetails() internal pure returns (bytes memory _data) {
        _data = abi.encode(50, 3000, "TestName", "SYMBOL", "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/");
    }

    function _encodeNftDetails(
        uint256 maxSupply,
        uint256 royaltyFee,
        string memory name,
        string memory symbol,
        string memory initBaseURI
    ) internal pure returns (bytes memory _data) {
        _data = abi.encode(maxSupply, royaltyFee, name, symbol, initBaseURI);
    }
}
