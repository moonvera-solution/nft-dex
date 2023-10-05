// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console, console2, Vm} from "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";

import "../src/Factory.sol";
import "../src/ArtCollection.sol";
import "./TestSetUp.sol";
import "./utils/Encoder.sol";
error InvalidColletion(uint8);

contract ArtCollectionInternalsTest is ArtCollection {
    function calculateFee(uint256 price, uint256 feeOnMint) external returns (uint256 _mintFee) {
        _mintFee = _calculateFee(price, feeOnMint);
    }

    function internalSafeMint(
        uint256 msgValue,
        address mintTo,
        uint256 mintPrice,
        uint256 mintAmount,
        uint256 maxMintAmount
    ) external {
        _internalSafeMint(msgValue, mintTo, mintPrice, mintAmount, maxMintAmount);
    }
}

contract ArtCollectionTest is Test, TestSetUp, GasSnapshot, Encoder {
    ArtCollection private _nftCollection;
    ArtCollectionInternalsTest private artCollectionInternalsTest;
    ArtCollectionNotERC721A private artCollectionNotERC721A;

    function setUp() public {
        clone = new ArtCollection();
        artCollectionNotERC721A = new ArtCollectionNotERC721A();
        artCollectionInternalsTest = new ArtCollectionInternalsTest();
        factory = new Factory(3000); // takes fee on mint 3%
        factory.setCollectionImpl(address(clone));
        factory.updateMember(wallet1.addr, block.timestamp + 5 days);
        factory.updateMintFee(0 wei);

        vm.deal(wallet1.addr, 10 ether);
        vm.deal(address(this), 100 ether);

        (address[] memory _initialOGMinters, address[] memory _initialWLMinters) = _getMintingUserLists();

        vm.startPrank(wallet1.addr, wallet1.addr);
        bytes memory nftData =
            abi.encode(50, 3000, "TestName", "SYMBOL", "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/");

        snapStart("init_clone");
        address collectionAddress = factory.createCollection{value: 0.5 ether}(
            nftData, _initialOGMinters, _initialWLMinters, _getMintingStages()
        );
        snapEnd();
        _nftCollection = ArtCollection(collectionAddress);

        // grant ADMIN role to address(this) for minting fuzz
        _nftCollection.grantRole(ADMIN_ROLE, address(this));
    }

    function test_fail_setCollectionImpl() public {
        vm.expectRevert(abi.encodeWithSelector(InvalidColletion.selector, 2));
        vm.startPrank(address(this));
        factory.setCollectionImpl(address(artCollectionNotERC721A));
    }

    function test_calculateFee() external {
        uint256 fee = artCollectionInternalsTest.calculateFee(2 ether, 3000);
        assertEq(fee, 1994000000000000000);
    }

    function test_printEncode() external {
        bytes memory data = _encodeNftDetails();
        // console2.logBytes(data);
    }

    /// @notice deployer is Clone/Art Collection Admin
    function test_initialize() external {
        assert((_nftCollection).hasRole(ADMIN_ROLE, wallet1.addr));
    }

    function test_mintForRegular(address to, uint256 mintAmount) public {
        vm.assume(mintAmount > 0 && mintAmount <= _nftCollection._maxSupply());
        _nftCollection.updateMintPrice(5 wei);
        _nftCollection.mintForRegular{value: 1 ether}(to, mintAmount);
        assert(_nftCollection.balanceOf(to) > 0);
    }

    function test_mintForWhitelist(address to, uint256 mintAmount) public {
        Vm.Wallet memory WLmember = vm.createWallet("WL-member");
        vm.deal(WLmember.addr, 10 ether);
        vm.assume(to != address(0x0));
        vm.assume(mintAmount > 0 && mintAmount <= _nftCollection._maxSupply());
        _nftCollection.grantRole(WL_MINTER_ROLE, WLmember.addr); // OG=0, WL=1
        _nftCollection.updateWhitelistMintPrice(5 wei);
        assertTrue(_nftCollection.hasRole(WL_MINTER_ROLE, WLmember.addr));

        vm.startPrank(WLmember.addr, WLmember.addr);

        // paying one eth to mint as WL
        _nftCollection.mintForWhitelist{value: 1 ether}(to, mintAmount);
        string memory uri = _nftCollection.tokenURI(mintAmount);
        console.log("uri:", mintAmount);
        assert(_nftCollection.balanceOf(to) > 0);
    }

    function test_mintForOG(address to, uint256 mintAmount) public {
        Vm.Wallet memory OGmember = vm.createWallet("OG-member");
        vm.deal(OGmember.addr, 10 ether);
        vm.assume(to != address(0x0));
        vm.assume(mintAmount > 0 && mintAmount <= _nftCollection._maxSupply());
        _nftCollection.grantRole(OG_MINTER_ROLE, OGmember.addr); // OG=0, WL=1
        _nftCollection.updateOGMintPrice(5 wei);
        assertTrue(_nftCollection.hasRole(OG_MINTER_ROLE, OGmember.addr));

        vm.startPrank(OGmember.addr, OGmember.addr);
        // paying one eth to mint as OG
        _nftCollection.mintForOG{value: 1 ether}(to, mintAmount);
        assert(_nftCollection.balanceOf(to) > 0);
    }

    /* 
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
        assert(_nftCollection._whitelistMintEnd() > _nftCollection._whitelistMintStart());
    }

    function test_updateWLMintMax(uint256 mintMax) public {
        vm.assume(mintMax > 0);
        vm.assume(mintMax > _nftCollection._maxSupply());
        _nftCollection.updateWLMintMax(mintMax);
        assert(_nftCollection._whitelistMintMax() == mintMax);
    }

    function test_updateMinterRoles(uint256 index, address[] calldata minterList, uint8 role) public {
        vm.assume(role == 1 || role == 0);
        vm.assume(minterList.length > 0);
        vm.assume(index > 0 && index < minterList.length);
        _nftCollection.updateMinterRoles(minterList, role);
        assertTrue(
            _nftCollection.hasRole(OG_MINTER_ROLE, minterList[index])
                || _nftCollection.hasRole(WL_MINTER_ROLE, minterList[index])
        );
    }

    // REGULAR MINTING

    function test_updateMintPrice(uint256 price) public {
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

    // function test_tokenURI(uint256 tokenId) public{
    //     _nftCollectio.tokenURI(5);
    // }
}

contract ArtCollectionNotERC721A {
    function supportsInterface(bytes4 id) external returns (bool) {
        return false;
    }
}
