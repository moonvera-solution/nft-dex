// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {Test, console, console2, Vm} from "@forge-std/Test.sol";
import "@solady/utils/LibString.sol";
import {GasSnapshot} from "@forge-gas-snapshot/GasSnapshot.sol";
import "@src/MvxFactory.sol";
// import "@src/MvxCollection.sol";
import {Stages, Collection} from "@src/libs/MvxStruct.sol";

import "../helpers/BaseTest.sol";

error InvalidColletion();

contract MvxCollectionTest is Test, BaseTest, GasSnapshot {
    using LibString for string;
    using Math for uint256;

    MvxCollection private _nftCollection;
    MvxCollectionNotERC721A private mvxCollectionNotERC721A;
    uint16 _platformFee;
    address private constant ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;

    event Log(string, uint256);
    event Log(string, Collection);
    event Log(string, Stages);
    event Log(string, address[]);

    function setUp() public {
        vm.warp(block.timestamp + 1 weeks);
        _platformFee = 1000; // 10%
        clone = new MvxCollection();
        mvxCollectionNotERC721A = new MvxCollectionNotERC721A();
        factory = new MvxFactory(); // takes fee on mint 3%
        factory.initialize();
        factory.updateCollectionImpl(address(clone));

        factory.updateMember(wallet1.addr, address(0x0), 0.5 ether, 0, 0, 10);
        factory.updateMember(address(this), address(0x0), 0.5 ether, 0, 0, 10);

        factory.updateStageConfig(
            2, /* _publicStageWeeks */ 7, /* _stageTimeCapInDays */ 0.1 ether /* _updateStageFee */
        );

        vm.deal(wallet1.addr, 100 ether);
        vm.deal(address(this), 100 ether);

        vm.startPrank(wallet1.addr, wallet1.addr);

        _setStages();
        _setCollectionDetails(wallet1.addr);

        (address[] memory _ogs, address[] memory _wls) = _getMinters();
        emit Log("_ogs : ", _ogs);
        emit Log("_wls : ", _wls);

        snapStart("init_clone"); // GAS tracking
        address collectionAddress = factory.createCollection{value: 0.5 ether}(nftData, stages, _ogs, _wls);
        snapEnd();

        _nftCollection = MvxCollection(collectionAddress);

        // // grant ADMIN role to address(this) for minting fuzz
        _nftCollection.grantRole(ADMIN_ROLE_TEST, address(this));
        _nftCollection.grantRole(OG_MINTER_ROLE_TEST, address(this));
        _nftCollection.grantRole(ADMIN_ROLE_TEST, wallet5.addr);
    }

    function test_initClone() public {
        assert(address(_nftCollection) != address(0x0));
    }

    function test_fuzz_updateRoyaltyInfo(uint256 price, address receiver, uint96 royaltyFee) external {
        price = bound(price, 0, 3 ether);
        vm.assume(receiver != address(0x0));
        vm.assume(royaltyFee > 0 && royaltyFee < 10_000);

        _nftCollection.updateRoyaltyInfo(receiver, royaltyFee);

        (address rec, uint256 amt) = _nftCollection.royaltyInfo(1, price);
        assertEq(receiver, rec);
    }

    function test_fail_updateCollectionImpl() public {
        vm.startPrank(address(this));
        vm.expectRevert(abi.encodeWithSelector(InvalidColletion.selector));
        factory.updateCollectionImpl(address(mvxCollectionNotERC721A));
    }

    /// @notice deployer is Clone/Art Collection Admin
    function test_initialize() external {
        assert((_nftCollection).hasRole(ADMIN_ROLE_TEST, wallet1.addr));
    }

    function test_mintForOwner(address to, uint256 amount, uint256 tokenId) public {
        vm.assume(to != address(0x0));
        vm.assume(amount > 0 && amount <= 60);
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

    function test_fuzz_mintForRegular(address to, uint256 mintAmount) public {
        vm.assume(mintAmount > 0 && mintAmount <= 60);
        _nftCollection.updateMintPrice(5 wei);
        vm.warp(_getTime(4));
        _nftCollection.mintForRegular{value: 1 ether}(to, mintAmount);
        assert(_nftCollection.balanceOf(to) > 0);
    }

    function test_fuzz_mintForWhitelist(address to, uint256 mintAmount) public {
        Vm.Wallet memory WLmember = vm.createWallet("WL-member");
        vm.deal(WLmember.addr, 10 ether);
        vm.assume(to != address(0x0));
        vm.assume(mintAmount > 0 && mintAmount <= 50);

        _nftCollection.grantRole(WL_MINTER_ROLE_TEST, WLmember.addr); // OG=0, WL=1
        _nftCollection.updateWhitelistMintPrice(5 wei);
        assertTrue(_nftCollection.hasRole(WL_MINTER_ROLE_TEST, WLmember.addr));

        vm.startPrank(WLmember.addr, WLmember.addr);
        // paying one eth to mint as WL
        vm.warp(_getTime(2));
        _nftCollection.mintForWhitelist{value: 1 ether}(to, mintAmount);
        string memory uri = _nftCollection.tokenURI(mintAmount);
        assert(_nftCollection.balanceOf(to) > 0);
    }

    function test_fuzz_mintForOG(address to, uint256 mintAmount) public {
        Vm.Wallet memory OGmember = vm.createWallet("OG-member");
        vm.deal(OGmember.addr, 10 ether);
        vm.assume(to != address(0x0));
        vm.assume(mintAmount > 0 && mintAmount <= 60);
        _nftCollection.grantRole(OG_MINTER_ROLE_TEST, OGmember.addr); // OG=0, WL=1
        _nftCollection.updateOGMintPrice(5 wei);
        assertTrue(_nftCollection.hasRole(OG_MINTER_ROLE_TEST, OGmember.addr));

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
    error MintError(bytes4, uint8);

    function test_fuzz_updateOGMintPrice(uint72 price) public {
        vm.assume(price > 1 ether && price < 30 ether);
        _nftCollection.updateOGMintPrice(price);
        vm.startPrank(wallet1.addr);
        _nftCollection.grantRole(WL_MINTER_ROLE_TEST, address(this));
        vm.stopPrank();
        vm.deal(address(this), 300 ether);
        vm.expectRevert(
            abi.encodeWithSelector(
                MintError.selector, 0x4f47000000000000000000000000000000000000000000000000000000000000, 0
            )
        );
        _nftCollection.mintForOG{value: 1 ether}(address(this), 1);
    }

    function test_fuzz_updateOGMintMax(uint16 mintMax) public {
        vm.assume(mintMax > 0 && mintMax < 200);
        _nftCollection.updateOGMintMax(mintMax);
        vm.startPrank(wallet1.addr);
        _nftCollection.grantRole(WL_MINTER_ROLE_TEST, address(this));
        vm.stopPrank();
        vm.expectRevert(
            abi.encodeWithSelector(
                MintError.selector, 0x4f47000000000000000000000000000000000000000000000000000000000000, 0
            )
        );
        _nftCollection.mintForOG{value: 1 ether}(address(this), mintMax + 500);
    }

    // WL MINTING
    function test_fuzz_updateWhitelistMintPrice(uint72 price) public {
        vm.assume(price > 0 && price < 10 ether);
        vm.startPrank(wallet1.addr);
        _nftCollection.grantRole(WL_MINTER_ROLE_TEST, address(this));
        vm.stopPrank();
        _nftCollection.updateWhitelistMintPrice(price);
        vm.expectRevert(
            abi.encodeWithSelector(
                MintError.selector, 0x574c000000000000000000000000000000000000000000000000000000000000, 0
            )
        );
        _nftCollection.mintForWhitelist{value: price - 1}(address(this), 1);
    }

    function test_fuzz_updateWLMintMax(uint16 mintMax) public {
        vm.assume(mintMax > 0 && mintMax < 60);
        _nftCollection.updateWLMintMax(mintMax);
        vm.startPrank(wallet1.addr);
        _nftCollection.grantRole(WL_MINTER_ROLE_TEST, address(this));
        vm.stopPrank();
        vm.expectRevert(
            abi.encodeWithSelector(
                MintError.selector, 0x574c000000000000000000000000000000000000000000000000000000000000, 1
            )
        );
        _nftCollection.mintForWhitelist{value: 100 ether}(address(this), mintMax + 1);
    }

    function test_fuzz_updateMinterRoles(uint256 index, address[] calldata minterList, uint8 role) public {
        vm.assume(role == 1 || role == 0);
        vm.assume(minterList.length > 0);
        vm.assume(index > 0 && index < minterList.length);
        _nftCollection.updateMinterRoles(minterList, role);
        assertTrue(
            _nftCollection.hasRole(OG_MINTER_ROLE_TEST, minterList[index])
                || _nftCollection.hasRole(WL_MINTER_ROLE_TEST, minterList[index])
        );
    }

    // REGULAR MINTING
    function test_fuzz_updateMintPrice(uint72 price) public {
        vm.assume(price > 0 && price < 30 ether);
        _nftCollection.updateMintPrice(price);
        vm.warp(_getTime(4));
        _nftCollection.mintForRegular{value: price}(address(this), 1);
        vm.expectRevert(
            abi.encodeWithSelector(
                MintError.selector, 0x5247000000000000000000000000000000000000000000000000000000000000, 0
            )
        );
        _nftCollection.mintForRegular{value: price - 1}(address(this), 1);
    }

    function test_fuzz_updateMintMax(uint16 mintMax) public {
        vm.deal(address(this), 1 ether);
        uint128 oldMax = uint128(2000);
        vm.assume(mintMax > oldMax && mintMax < uint128(oldMax) + 1000);
        _nftCollection.updateMintMax(mintMax);
        _nftCollection.updateMintPrice(1);
        _nftCollection.updateMaxSupply(mintMax);
        vm.expectRevert(
            abi.encodeWithSelector(
                MintError.selector, 0x5247000000000000000000000000000000000000000000000000000000000000, 1
            )
        );
        vm.warp(_getTime(4));
        _nftCollection.mintForRegular{value: 1 ether}(address(this), 2000 + 1001);
    }

    function test_fuzz_updateTime(uint40 start, uint40 end) public {
        vm.assume(start > block.timestamp);
        // vm.assume(end > start && end < block.timestamp + 5 days);

        // (,,,,,, uint256 mintStart, uint256 mintEnd,,,,uint8 publicStageWeeks ) = _nftCollection.mintingStages();
        // assert(mintStart > block.timestamp);
        // assert(mintEnd > mintStart);
    }

    function test_addOgRole() public {
        _nftCollection.grantRole(OG_MINTER_ROLE_TEST, wallet1.addr);
        assert(_nftCollection.hasRole(OG_MINTER_ROLE_TEST, wallet1.addr));
    }

    function test_tokenURI() public {
        uint256 tokenId = 5;
        vm.warp(_getTime(4));
        _nftCollection.mintForRegular{value: 5 ether}(address(1), tokenId);
        string memory uri = _nftCollection.tokenURI(tokenId);
        console.log("uri", uri);
        string memory baeURI = ("ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/");
        assertEq(
            string(abi.encodePacked(_nftCollection.baseURI(), LibString.toString(tokenId))),
            string(abi.encodePacked(baeURI.concat(LibString.toString(tokenId))))
        );
    }

    function test_withdraw_no_platform_fee() public {
        vm.startPrank(address(wallet5.addr));
        uint256 ethAmount = stages.mintPrice * 5;
        vm.deal(address(wallet5.addr), ethAmount);
        vm.warp(_getTime(4));

        _nftCollection.mintForRegular{value: ethAmount}(wallet5.addr, 5);
        assertEq(address(wallet5.addr).balance, 0);

        uint256 balanceB4Withdraw = address(wallet5.addr).balance;
        _nftCollection.withdraw();
        assertGt(address(wallet5.addr).balance, balanceB4Withdraw);
    }

    function test_withdraw_with_platform_fee() public {
        uint16 _platformFee = 200; // bp 2%
        vm.startPrank(address(this));
        factory.updateMember(wallet3.addr, ZERO_ADDRESS, 0.5 ether, _platformFee, 0, 10);
        vm.stopPrank();

        vm.startPrank(address(wallet3.addr));
        vm.deal(address(wallet3.addr), 10 ether);
        (address[] memory _ogs, address[] memory _wls) = _getMinters();
        address collectionAddress = factory.createCollection{value: 0.5 ether}(nftData, stages, _ogs, _wls);
        MvxCollection _clone721A = MvxCollection(collectionAddress);
        vm.stopPrank();

        vm.startPrank(wallet3.addr);
        uint256 amount = 5 ether;
        vm.deal(address(wallet3.addr), amount);
        vm.warp(_getTime(4));
        _clone721A.mintForRegular{value: amount}(wallet3.addr, 5);
        assertEq(_clone721A.balanceOf(wallet3.addr), 5);
        vm.stopPrank();

        uint256 _thisBalanceB4withdraw = address(factory).balance;

        vm.startPrank(wallet3.addr);
        uint256 _cloneBalance = address(_clone721A).balance;
        uint256 _cloneAdminBalance = ((_cloneBalance * _platformFee) / 10_000);
        _clone721A.withdraw();
        assertEq(address(wallet3.addr).balance, _cloneBalance - _cloneAdminBalance);
        assertEq(address(factory).balance, _thisBalanceB4withdraw + _cloneAdminBalance);
        vm.stopPrank();
    }

    function test_break_minting_logic() public {
        Vm.Wallet memory hacker = vm.createWallet("hacker");
        vm.deal(hacker.addr, 200 ether);

        _nftCollection.grantRole(WL_MINTER_ROLE_TEST, hacker.addr); // OG=0, WL=1
        _nftCollection.grantRole(OG_MINTER_ROLE_TEST, hacker.addr); // OG=0, WL=1

        vm.startPrank(hacker.addr, hacker.addr);
        _nftCollection.mintForOG{value: 60 ether}(hacker.addr, 60);

        vm.warp(_getTime(2));
        _nftCollection.mintForWhitelist{value: 60 ether}(hacker.addr, 50);

        vm.warp(_getTime(4));
        _nftCollection.mintForRegular{value: 60 ether}(hacker.addr, 60);

        // one more should break the logic
        vm.expectRevert(
            abi.encodeWithSelector(
                MintError.selector, 0x5247000000000000000000000000000000000000000000000000000000000000, 1
            )
        );
        _nftCollection.mintForRegular{value: 1 ether}(hacker.addr, 1);
        assert(_nftCollection.balanceOf(hacker.addr) == 60 + 60 + 50);
    }

    function test_fuzz_updateMaxSupply(uint128 _newMaxSupply) public {
        vm.assume(_newMaxSupply > 2000 && _newMaxSupply < 3000);
        vm.startPrank(address(this));
        vm.deal(address(this), 600 ether);
        (address[] memory _ogs, address[] memory _wls) = _getMinters();
        address collectionAddress = factory.createCollection{value: 0.5 ether}(nftData, stages, _ogs, _wls);
        vm.warp(_getTime(4));
        MvxCollection(collectionAddress).mintForRegular{value: 60 ether}(address(this), 60);
        MvxCollection(collectionAddress).updateMaxSupply(_newMaxSupply);
        vm.expectRevert(
            abi.encodeWithSelector(
                MintError.selector, 0x5247000000000000000000000000000000000000000000000000000000000000, 0
            )
        );
        _nftCollection.mintForRegular{value: 1 ether}(address(this), _newMaxSupply + 1);
    }

    function test_updatePublicEndTime() public {
        _nftCollection.updatePublicEndTime{value: 0.1 ether}(2);
    }

    fallback() external payable {}
}

contract MvxCollectionNotERC721A {
    function supportsInterface(bytes4 id) external returns (bool) {
        return false;
    }
}

/**
 * stage
 * fee
 * update
 */
