// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {Test, console, console2, Vm} from "@forge-std/Test.sol";
import "@solady/utils/LibString.sol";
import {GasSnapshot} from "@forge-gas-snapshot/GasSnapshot.sol";
import "@src/MvxFactory.sol";
import "@src/MvxCollection.sol";
import {Stages, Collection} from "@src/libs/MvxStruct.sol";

import "./helpers/BaseTest.sol";

error InvalidColletion(uint8);

contract MvxCollectionTest is Test, BaseTest, GasSnapshot {
    using LibString for string;

    MvxCollection private _nftCollection;
    MvxCollectionNotERC721A private mvxCollectionNotERC721A;
    uint96 _platformFee;

    function setUp() public {
        _platformFee = 1000; // 10%
        clone = new MvxCollection();
        mvxCollectionNotERC721A = new MvxCollectionNotERC721A();
        factory = new MvxFactory(0); // takes fee on mint 3%
        factory.setCollectionImpl(address(clone));

        factory.updateMember(wallet1.addr, block.timestamp + 5 days);
        factory.updatePlatformFee(_platformFee);

        vm.deal(wallet1.addr, 100 ether);
        vm.deal(address(this), 100 ether);

        vm.startPrank(wallet1.addr, wallet1.addr);

        _setStages();
        _setCollectionDetails(wallet1.addr);

        (address[] memory _ogs, address[] memory _wls) = _getMinters();

        snapStart("init_clone"); // GAS tracking
        address collectionAddress = factory.createCollection{value: 0}(nftData, stages, _ogs, _wls);
        snapEnd();

        _nftCollection = MvxCollection(collectionAddress);

        // grant ADMIN role to address(this) for minting fuzz
        _nftCollection.grantRole(ADMIN_ROLE, address(this));
        _nftCollection.grantRole(ADMIN_ROLE, wallet5.addr);
    }

    function test_updateRoyaltyInfo(address receiver, uint96 royaltyFee) external {
        vm.assume(receiver != address(0x0));
        vm.assume(royaltyFee > 0 && royaltyFee < 10_000);

        _nftCollection.updateRoyaltyInfo(receiver, royaltyFee);

        (,,,,, uint96 _royaltyFee, address _receiver) = _nftCollection.collectionData();
        assertEq(_receiver, receiver);
        assertEq(royaltyFee, _royaltyFee);
    }

    function test_royaltyInfoFuzz(uint256 salePrice, uint96 royaltyFee) external {
        vm.assume(royaltyFee > 0 && royaltyFee < 10_000);

        _nftCollection.updateRoyaltyInfo(address(this), royaltyFee);
        vm.assume(salePrice > 0 && salePrice < 10 ether);

        (,,,,, uint96 _royaltyFee,) = _nftCollection.collectionData();
        (, uint256 royaltyAmount) = _nftCollection.royaltyInfo(1, salePrice);
        assertEq(royaltyAmount, salePrice * _royaltyFee / 10_000);
    }

    function test_royaltyInfo() external {
        _nftCollection.updateRoyaltyInfo(address(this), 1000); // 10%
        (,,,,, uint96 royaltyFee, address royaltyReceiver) = _nftCollection.collectionData();
        (address receiver, uint256 royaltyAmount) = _nftCollection.royaltyInfo(1, 1 ether);
        assertEq(royaltyAmount, 1 ether * 1000 / 10_000);
    }

    function test_fail_setCollectionImpl() public {
        vm.expectRevert(abi.encodeWithSelector(InvalidColletion.selector, 2));
        vm.startPrank(address(this));
        factory.setCollectionImpl(address(mvxCollectionNotERC721A));
    }

    /// @notice deployer is Clone/Art Collection Admin
    function test_initialize() external {
        assert((_nftCollection).hasRole(ADMIN_ROLE, wallet1.addr));
    }

    function test_mintForOwner(address to, uint256 amount, uint256 tokenId) public {
        vm.assume(to != address(0x0));
        (,,,, uint256 ogMintMaxPerUser,,,,,,,) = _nftCollection.mintingStages();
        vm.assume(amount > 0 && amount <= ogMintMaxPerUser);
        vm.assume(tokenId > 0 && tokenId < amount);
        _nftCollection.mintForOwner(to, amount);
        assert(_nftCollection.balanceOf(to) > 0);
        string memory uri = _nftCollection.tokenURI(tokenId);
        string memory baeURI = ("ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/");
        assertEq(
            string(abi.encodePacked(_nftCollection.baseURI(), LibString.toString(tokenId))),
            string(abi.encodePacked(baeURI.concat(LibString.toString(tokenId))))
        );
    }

    function test_mintForRegular(address to, uint256 mintAmount) public {
        (,,, uint256 mintMaxPerUser,,,,,,,,) = _nftCollection.mintingStages();
        vm.assume(mintAmount > 0 && mintAmount <= mintMaxPerUser);
        _nftCollection.updateMintPrice(5 wei);
        _nftCollection.mintForRegular{value: 1 ether}(to, mintAmount);
        assert(_nftCollection.balanceOf(to) > 0);
    }

    function test_mintForWhitelist(address to, uint256 mintAmount) public {
        Vm.Wallet memory WLmember = vm.createWallet("WL-member");
        vm.deal(WLmember.addr, 10 ether);
        vm.assume(to != address(0x0));
        (,,,,, uint256 whitelistMintMaxPerUser,,,,,,) = _nftCollection.mintingStages();
        vm.assume(mintAmount > 0 && mintAmount <= whitelistMintMaxPerUser);

        _nftCollection.grantRole(WL_MINTER_ROLE, WLmember.addr); // OG=0, WL=1
        _nftCollection.updateWhitelistMintPrice(5 wei);
        assertTrue(_nftCollection.hasRole(WL_MINTER_ROLE, WLmember.addr));

        vm.startPrank(WLmember.addr, WLmember.addr);
        // paying one eth to mint as WL
        _nftCollection.mintForWhitelist{value: 1 ether}(to, mintAmount);
        string memory uri = _nftCollection.tokenURI(mintAmount);
        assert(_nftCollection.balanceOf(to) > 0);
    }

    function test_mintForOG(address to, uint256 mintAmount) public {
        Vm.Wallet memory OGmember = vm.createWallet("OG-member");
        vm.deal(OGmember.addr, 10 ether);
        vm.assume(to != address(0x0));
        (,,,, uint256 maxOgmint,,,,,,,) = _nftCollection.mintingStages();
        vm.assume(mintAmount > 0 && mintAmount <= maxOgmint);
        _nftCollection.grantRole(OG_MINTER_ROLE, OGmember.addr); // OG=0, WL=1
        _nftCollection.updateOGMintPrice(5 wei);
        assertTrue(_nftCollection.hasRole(OG_MINTER_ROLE, OGmember.addr));

        vm.startPrank(OGmember.addr, OGmember.addr);
        // paying one eth to mint as OG
        _nftCollection.mintForOG{value: 1 ether}(to, mintAmount);
        assert(_nftCollection.balanceOf(to) > 0);
        string memory uri = _nftCollection.tokenURI(1);
        console.log("uri", uri);
    }

    /* 
    Fuzz Test Abstract Minting Stages Contract
    */
    // OG MINTING
    function test_updateOGMintPrice(uint256 price) public {
        vm.assume(price > 0);
        _nftCollection.updateOGMintPrice(price);
        (uint256 ogMintPrice,,,,,,,,,,,) = _nftCollection.mintingStages();
        assert(ogMintPrice == price);
    }

    function test_updateOGMintMax(uint256 price) public {
        vm.assume(price > 0);
        _nftCollection.updateOGMintMax(price);
        (,,,, uint256 ogMintMaxPerUser,,,,,,,) = _nftCollection.mintingStages();
        assert(ogMintMaxPerUser == price);
    }

    // WL MINTING
    function test_updateWhitelistMintPrice(uint256 price) public {
        vm.assume(price > 0);
        _nftCollection.updateWhitelistMintPrice(price);
        (, uint256 whitelistMintPrice,,,,,,,,,,) = _nftCollection.mintingStages();
        assert(whitelistMintPrice == price);
    }

    function test_updateWLMintMax(uint256 mintMax) public {
        vm.assume(mintMax > 0);
        (,,,, uint256 _maxSupply,,) = _nftCollection.collectionData();
        vm.assume(mintMax > _maxSupply);
        _nftCollection.updateWLMintMax(mintMax);
        (,,,,, uint256 whitelistMintMaxPerUser,,,,,,) = _nftCollection.mintingStages();
        assert(whitelistMintMaxPerUser == mintMax);
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
        (,, uint256 mintPrice,,,,,,,,,) = _nftCollection.mintingStages();
        assert(mintPrice == price);
    }

    function test_updateMintMax(uint256 mintMax) public {
        vm.assume(mintMax > 0);
        (,,,, uint256 _maxSupply,,) = _nftCollection.collectionData();
        vm.assume(mintMax < _maxSupply);
        _nftCollection.updateMintMax(mintMax);
        (,,, uint256 mintMaxPerUser,,,,,,,,) = _nftCollection.mintingStages();
        assert(mintMaxPerUser == mintMax);
    }

    function test_updateTime(uint256 start, uint256 end) public {
        vm.assume(start > block.timestamp);
        vm.assume(end > start && end < block.timestamp + 5 days);
        _nftCollection.updateTime(start, end);
        (,,,,,, uint256 mintStart, uint256 mintEnd,,,,) = _nftCollection.mintingStages();
        assert(mintStart > block.timestamp);
        assert(mintEnd > mintStart);
    }

    function test_addOgRole() public {
        _nftCollection.grantRole(OG_MINTER_ROLE, wallet1.addr);
        assert(_nftCollection.hasRole(OG_MINTER_ROLE, wallet1.addr));
    }

    function test_tokenURI(uint256 tokenId) public {
        vm.assume(tokenId > 0 && tokenId < stages.mintMaxPerUser);
        _nftCollection.mintForRegular{value: 5 ether}(address(1), tokenId);
        string memory uri = _nftCollection.tokenURI(tokenId);
        console.log("uri", uri);
        string memory baeURI = ("ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/");
        assertEq(
            string(abi.encodePacked(_nftCollection.baseURI(), LibString.toString(tokenId))),
            string(abi.encodePacked(baeURI.concat(LibString.toString(tokenId))))
        );
    }

    function test_withdraw() public {
        vm.startPrank(address(wallet5.addr));
        uint256 ethAmount = stages.mintPrice * 5;
        vm.deal(address(wallet5.addr), ethAmount);
        _nftCollection.mintForRegular{value: ethAmount}(wallet5.addr, 5);
        uint256 balanceB4Withdraw = address(_nftCollection).balance;
        _nftCollection.withdraw();

        (,,,, uint256 _maxSupply,,) = _nftCollection.collectionData();
        assert(wallet5.addr.balance > address(_nftCollection).balance);
        assert(address(factory).balance >= address(_nftCollection).balance * _platformFee / 10_000);
        assert(address(wallet5.addr).balance + address(factory).balance == balanceB4Withdraw);
    }

    fallback() external payable {}
}

contract MvxCollectionNotERC721A {
    function supportsInterface(bytes4 id) external returns (bool) {
        return false;
    }
}
