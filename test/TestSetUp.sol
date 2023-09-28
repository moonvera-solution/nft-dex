// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console2, Vm} from "forge-std/Test.sol";
import "../src/Factory.sol";
import "../script/Deployer.sol";

contract TestSetUp is Test {
    Factory public factory;
    ArtCollection public clone;

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

    // function _initCollection(
    //     address _implAddress,
    //     address[] memory _initialOGMinters,
    //     address[] memory _initialWLMinters
    // ) internal {
    //     ArtCollection(_implAddress).initialize(
    //         wallet1.addr,
    //         "TestName", //string memory _name,
    //         "SYMBOL", // string memory _symbol,
    //         "https://moonvera.io/nft/{id}", // string memory _initBaseURI,
    //         ".json", // base extension
    //         50, //max Supply
    //         3000, // royalty fee 3% in basis points
    //         _initialOGMinters,
    //         _initialWLMinters,
    //         _getMintStageDetails()
    //     );
    // }
    function _getEncodeInitParams() internal returns (bytes memory _data) {
        (
            address[] memory _initialOGMinters,
            address[] memory _initialWLMinters
        ) = _getMintingUserLists();

        uint256[] memory _mintStageDetails = _getMintStageDetails();

        _data = abi.encode(
            "TestName", //string memory _name,
            "SYMBOL", // string memory _symbol,
            "https://moonvera.io/nft/{id}", // string memory _initBaseURI,
            ".json", // base extension
            uint256(50), //max Supply
            uint256(3000), // royalty fee 3% in basis points
            _initialOGMinters,
            _initialWLMinters,
            _mintStageDetails
        );
    }

    function _getMintingUserLists()
        internal
        returns (
            address[] memory _initialOGMinters,
            address[] memory _initialWLMinters
        )
    {
        _initialOGMinters = new address[](2);
        _initialOGMinters[0] = user5;
        _initialOGMinters[1] = user6;
        _initialWLMinters = new address[](2);
        _initialWLMinters[1] = user7;
        _initialWLMinters[0] = user8;
    }

    /**
            mintStageDetails array content
            0 initOgMintPrice
            1 ogMintStartTime
            2 ogMintEndTime
            3 initWLmintPrice
            4 wlMintStartTime
            5 wlMintEndTime
            6 initRegMintprice
            7 regMintStartTime
            8 regMintEndTime
     */
    function _getMintStageDetails()
        internal
        returns (uint256[] memory _mintStageDetails)
    {
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
