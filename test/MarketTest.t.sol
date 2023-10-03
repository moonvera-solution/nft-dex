// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "../lib/forge-std/src/Test.sol";
import {Market} from "../src/Market.sol";
//import {Exchange} from "../src/Exchange";
import "../lib/solmate/src/tokens/ERC721.sol";
import "../lib/solmate/src/tokens/ERC20.sol";

/**
 * Functional Test
 *
 *     1.- Deploy 6 init Market & Exchange
 *     2.- List market item
 *     3.- Fetch market item with Lens
 *     4.- Generate order
 *         Sell side exchange Input obj
 *         Buy side exchange Input obj
 *     5.- Generate Signatures
 *     6.- Execute order
 */

contract MarketTest is Test {
    Market public market;
    ERC721Mock public nft;
    ERC20Mock public usdc;

    address payable trader1 = payable(address(0x1));
    uint256 listingPrice;

    function setUp() public {
        market = new Market();
        listingPrice = 0.025 ether;
        market.initialize(listingPrice);

        nft = new ERC721Mock("CyberPunks", "NFPunks");
        usdc = new ERC20Mock("USDCMock", "USDC");
    }

    function _generateMarketItem(uint256 _tokenId, address _quoteAsset)
        internal
        returns (Market.MarketItem memory item)
    {
        item = Market.MarketItem({
            itemId: 0, // uint
            collection: address(nft), // address
            tokenId: _tokenId, // uint256
            seller: trader1, // address
            owner: trader1, // address
            quoteAsset: _quoteAsset,
            price: 1 ether, // int256
            listingTime: 0
        });
    }

    function _listItem(Market.MarketItem memory item, uint256 _tokenId) public payable {
        vm.startPrank(trader1);
        vm.deal(trader1, 10 ether);
        nft.mint(trader1, _tokenId);
        nft.approve(address(market), _tokenId);
        market.listItem{value: listingPrice}(item);
    }

    function test_listItem(uint256 _tokenId) public {
        Market.MarketItem memory item = _generateMarketItem(_tokenId, address(0x0));
        _listItem(item, _tokenId);
        // assert market asset ownership
        assert(nft.balanceOf(address(market)) > 0);
        assert(nft.ownerOf(_tokenId) == address(market));

        // verify data integrity
        (, address collection,,,,, uint256 price,) = market.idToMarketItem(1);
        assert(collection == address(nft));
        assert(1 ether == price);
    }

    function test_buyItem_with_ERC20(uint256 _tokenId) public {
        // list new item
        Market.MarketItem memory item = _generateMarketItem(_tokenId, address(usdc));
        _listItem(item, _tokenId);

        // buy listed item with USDC
        usdc.mint(trader1, 10 ether);
        usdc.approve(address(market), type(uint256).max);
        market.buyItem(1);
        assert(nft.ownerOf(_tokenId) == trader1);
    }

    function test_buyItem_with_Ether(uint256 _tokenId) public {
        Market.MarketItem memory item = _generateMarketItem(_tokenId, address(0x0));
        _listItem(item, _tokenId);

        // buy listed item with Ether
        market.buyItem{value: 5 ether}(1);
        assert(nft.ownerOf(_tokenId) == trader1);
    }
}

contract ERC20Mock is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol, 18) {}

    function mint(address _to, uint256 amount) external {
        super._mint(_to, amount);
    }
}

contract ERC721Mock is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(address _to, uint256 _tokenId) external {
        super._mint(_to, _tokenId);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "";
    }
}
