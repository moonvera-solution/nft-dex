// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
    Core invariants of ERC721
    From Trail of Bits testing properties
    Same properties as echidna fuzz harness
 */
import {ArtCollection} from "../../../src/ArtCollection.sol";
import {ERC721ExternalPropertyTests} from  "../../../lib/properties/contracts/ERC721/external/ERC721ExternalPropertyTests.sol";
import {MockReceiver} from "../../../lib/properties/contracts/ERC721/external/util/MockReceiver.sol";

 contract InvariantTestArtCollection is ERC721ExternalPropertyTests{
    constructor() {
        // Deploy ERC721
        token = IERC721Internal(address(new ArtCollection()));
        mockSafeReceiver = new MockReceiver(true);
        mockUnsafeReceiver = new MockReceiver(false);
    }
 }

