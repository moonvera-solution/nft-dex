// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console, console2, Vm} from "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";

import "../src/Factory.sol";
import "../src/ArtCollection.sol";
import "./TestSetUp.sol";

contract ArtCollectionTest is Test, TestSetUp, GasSnapshot {
    ArtCollection private _nftCollection;

    function setUp() public {
        clone = new ArtCollection();
        factory = new Factory(3000); // takes fee on mint 3%
        factory.setCollectionImpl(address(clone));
        factory.updateMember(wallet1.addr, block.timestamp + 5 days);

        vm.deal(wallet1.addr, 10 ether);

        (
            address[] memory _initialOGMinters,
            address[] memory _initialWLMinters
        ) = _getMintingUserLists();

        bytes memory data = _getEncodeInitParams();

        vm.startPrank(wallet1.addr, wallet1.addr);
        bytes memory nftData = abi.encode(
            "TestName",
            "SYMBOL",
            "https://moonvera.io/nft/{id}",
            ".json"
        );

        snapStart("init_clone");
        address collectionAddress = factory.createCollection{value: .5 ether}(
            50, //max Supply
            0, // royalty fee 3% in basis points
            nftData,
            _initialOGMinters,
            _initialWLMinters,
            _getMintStageDetails()
        );
        snapEnd();
        _nftCollection = ArtCollection(collectionAddress);
        _nftCollection.grantRole(ADMIN_ROLE, address(this));
    }

    /// @notice deployer is Clone/Art Collection Admin
    function test_initialize() external {
        assert((_nftCollection).hasRole(ADMIN_ROLE, wallet1.addr));
        console.log("_mintFee:: ", (_nftCollection)._mintFee()); // test immutable arg
    }

    /**
        Fuzz Test Abstract Minting Stages Contract
    */
    // OG MINTING
    function test_updateOGMintPrice(uint256 price) public {
        vm.assume(price > 0);
        _nftCollection.updateOGMintPrice(price);
        assert(_nftCollection._ogMintPrice() == price);
    }

    function test_updateOGMintTime(uint256 start, uint256 end) public {
        vm.assume(start > block.timestamp);
        vm.assume(end > start && end < block.timestamp + 5 days);
        _nftCollection.updateOGMintTime(start, end);
        assert(_nftCollection._ogMintStart() > block.timestamp);
        assert(_nftCollection._ogMintEnd() > _nftCollection._ogMintStart());
    }

    function test_updateOGMintMax(uint256 price) public {
        vm.assume(price > 0);
        _nftCollection.updateOGMintMax(price);
        assert(_nftCollection._ogMintMax() == price);
    }

    // WL MINTING
    function test_updateWhitelistMintPrice(uint256 price) public {
        vm.assume(price > 0);
        _nftCollection.updateWhitelistMintPrice(price);
        assert(_nftCollection._whitelistMintPrice() == price);
    }

    function test_updateWLMintTime(uint256 start, uint256 end) public {
        vm.assume(start > block.timestamp);
        vm.assume(end > start && end < block.timestamp + 5 days);
        _nftCollection.updateWLMintTime(start, end);
        assert(_nftCollection._whitelistMintStart() > block.timestamp);
        assert(
            _nftCollection._whitelistMintEnd() >
                _nftCollection._whitelistMintStart()
        );
    }

    function test_updateWLMintMax(uint256 mintMax) public {
        vm.assume(mintMax > 0);
        vm.assume(mintMax > _nftCollection._maxSupply());
        _nftCollection.updateWLMintMax(mintMax);
        assert(_nftCollection._whitelistMintMax() == mintMax);
    }

    function test_updateOGList(address[] calldata ogList) public {}

    // REGULAR MINTING

    function test_mintPrice(uint256 price) public {
        vm.assume(price > 0);
        _nftCollection.updateMintPrice(price);
        assert(_nftCollection._mintPrice() == price);
    }

    function test_updateMintMax(uint256 mintMax) public {
        vm.assume(mintMax > 0);
        vm.assume(mintMax < _nftCollection._maxSupply());
        _nftCollection.updateMintMax(mintMax);
        assert(_nftCollection._mintMax() == mintMax);
    }

    function test_updateTime(uint256 start, uint256 end) public {
        vm.assume(start > block.timestamp);
        vm.assume(end > start && end < block.timestamp + 5 days);
        _nftCollection.updateTime(start, end);
        assert(_nftCollection._mintStart() > block.timestamp);
        assert(_nftCollection._mintEnd() > _nftCollection._mintStart());
    }

    function test_addOgRole() public {
        _nftCollection.grantRole(OG_MINTER_ROLE, wallet1.addr);
        assert(_nftCollection.hasRole(OG_MINTER_ROLE, wallet1.addr));
    }
}
