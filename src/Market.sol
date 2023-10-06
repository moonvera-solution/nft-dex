// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Market is OwnableUpgradeable, IERC721Receiver, ReentrancyGuardUpgradeable {
    uint256 public _itemIds;
    uint256 public _itemsSold;
    uint256 public _listingPrice; // cost of NFT listing

    struct MarketItem {
        uint256 itemId;
        address collection;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        address quoteAsset;
        uint256 price;
        uint256 listingTime;
    }

    event ListItem(MarketItem _marketItem);

    error ListItemError(uint8 _rule);

    event BuyItem(MarketItem _marketItem);

    error BuyItemError(uint8 _rule);

    mapping(uint256 => MarketItem) public idToMarketItem;

    function initialize(uint256 _initListingPrice) public initializer {
        __Ownable_init(_msgSender());
        updateListingPrice(_initListingPrice);
    }

    function updateListingPrice(uint256 minListingPrice_) public onlyOwner {
        _listingPrice = minListingPrice_;
    }

    /// @notice ItemId is set to 0 When Item is sold
    /// @dev We are not checking if collection item is IErc721 compliant
    // @audit  support auction listings
    // @audit  TODO only whitelisted ERC20 accepted as payment
    function listItem(MarketItem calldata marketItem) public payable nonReentrant {
        // verify Item
        if (_listingPrice < msg.value) revert ListItemError(1);

        address nftContract = marketItem.collection;
        if (nftContract == address(0x0)) revert ListItemError(2);
        if (!(marketItem.price > 0)) revert ListItemError(3);

        if (marketItem.itemId == 0) {
            //  new market item
            ERC721(nftContract).safeTransferFrom(
                _msgSender(), address(this), marketItem.tokenId, abi.encode(marketItem)
            );
        }
    }

    /// @notice Get triggered on this contrcat receiving any NFT
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        unchecked {
            ++_itemIds;
        }
        MarketItem memory _newItem = abi.decode(data, (MarketItem));
        _newItem.itemId = _itemIds;
        _newItem.listingTime = block.timestamp;
        idToMarketItem[_itemIds] = _newItem; // set new item
        emit ListItem(_newItem);
        return Market.onERC721Received.selector;
    }

    uint256 _buyFee = 300;
    /// @notice

    function buyItem(uint256 _itemId) external payable nonReentrant {
        MarketItem memory item = idToMarketItem[_itemId];
        address _quoteAsset = item.quoteAsset;
        uint256 _priceWithFee = item.price + _buyFee;
        if (_quoteAsset == address(0x0)) {
            if (msg.value < _priceWithFee) revert BuyItemError(1);
            ERC721(item.collection).transferFrom(address(this), _msgSender(), item.tokenId);
            delete idToMarketItem[_itemId];

            // TODO return dust
        } else {
            require(IERC20(_quoteAsset).transferFrom(_msgSender(), address(this), _priceWithFee), "buyItem::1");
            ERC721(item.collection).transferFrom(address(this), _msgSender(), item.tokenId);
            delete idToMarketItem[_itemId];
        }
    }
}
