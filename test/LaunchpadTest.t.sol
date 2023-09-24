// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import {ArtCollection } from "../src/ArtCollection.sol";
import {Test, console2} from "forge-std/Test.sol";
import "solmate/tokens/ERC721.sol";
import "solmate/tokens/ERC20.sol";

contract LaunchpadTest is Test {
    ArtCollection public collection;
    address[] public _initialOGMinters;
    address[] public _initialRegularMinters;
    string _initBaseURI;

    function setUp() public {
        _initBaseURI = "ipfs://localhost:8545";
        // collection = new Collection(
        //     "MoonveraLaunchpad",
        //     "MLP",
        //     _initBaseURI,
        //     1 ether, // _initMintPrice,
        //     1 ether, //_initOGMintPrice,
        //     _initialOGMinters,
        //     _initialRegularMinters,
        //     1 ether // _initWhitelistMintPrice
        // );
    }

    function test_getBaseURI() public {

    }

    function test_mintForRegular(address _to, uint256 _mintAmount) public {
        //launchPath.mintForRegular(_to,_mintAmount);
    }

    /*╔══════════════════════════════╗
      ║         TEST UTILS           ║
      ╚══════════════════════════════╝*/
    function _setMinters()
        public
        returns (
            address[] memory _initialOGMinters,
            address[] memory _initialRegularMinters
        )
    {
        address ogMinter1 = address(0x1);
        address ogMinter2 = address(0x2);
        address ogMinter3 = address(0x3);
        address ogMinter4 = address(0x4);
        address ogMinter5 = address(0x5);

        address regMinter1 = address(0x01);
        address regMinter2 = address(0x02);
        address regMinter3 = address(0x03);
        address regMinter4 = address(0x04);
        address regMinter5 = address(0x05);

        _initialOGMinters = new address[](6);

        _initialOGMinters[1] = ogMinter1;
        _initialOGMinters[2] = ogMinter2;
        _initialOGMinters[3] = ogMinter3;
        _initialOGMinters[4] = ogMinter4;
        _initialOGMinters[5] = ogMinter5;

        _initialRegularMinters = new address[](5);

        _initialRegularMinters[1] = regMinter1;
        _initialRegularMinters[2] = regMinter2;
        _initialRegularMinters[3] = regMinter3;
        _initialRegularMinters[4] = regMinter4;
        _initialRegularMinters[5] = regMinter5;
    }
}
