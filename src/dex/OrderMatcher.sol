// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin-contracts/security/ReentrancyGuard.sol";
import "@openzeppelin-contracts/access/Ownable.sol";
import "@openzeppelin-contracts/token/ERC721/IERC721.sol";
import "@openzeppelin-contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin-contracts/token/ERC721/ERC721.sol";
import "@openzeppelin-contracts/interfaces/IERC2981.sol";
import "@openzeppelin-contracts/security/Pausable.sol";
import "@openzeppelin-contracts/utils/introspection/ERC165Checker.sol";

interface ERC2981 is IERC721 {
    // ERC2981 is a standard for royalty payments, allowing smart contracts to pay royalty fees to the creator whener their is a sale on secondary market
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount);
}

contract SwapperByMoonveratest3 is ReentrancyGuard, Ownable, Pausable, IERC721Receiver {
    struct Offer {
        // Offer struct is to store details of each individual offer made to any trade.
        address payable offerer;
        uint256 token;
        ERC721 contractAddress;
        uint256 ethAmount;
        bool isApproved;
        bool isCancelled;
        uint256 offerEndsAt;
    }

    struct Trade {
        address payable trader;
        uint256 token;
        ERC721 contractAddress;
        uint256 tradeEndsAt;
        bool isCancelled;
        uint256 offersCounter;
        uint256 acceptedOfferId;
        mapping(uint256 => Offer) offers;
    }

    address public platformFeeRecipient;

    uint256 public tradeCounter = 0;
    uint256 public totalTradesEverMade = 0;
    uint256 public platformFeeBasisPoints = 100; // 1% fee (this fee is deducted in case their is additional eth in the swapping)
    uint256 public platformFeeFixed = 0; // 0 ETH fixed fee in case we want to put a fixed fees espacially if we have our own erc20 to be used as fees later
    mapping(uint256 => Trade) public trades;
    mapping(uint256 => bool) public activeTrades;

    event TradeCreated(uint256 tradeId, address trader, uint256 token);
    event TradeCancelled(uint256 tradeId);
    event OfferCreated(uint256 tradeId, uint256 offerId, address offerer, uint256 token, uint256 ethAmount);
    event OfferApproved(uint256 tradeId, uint256 offerId);
    event OfferCancelled(uint256 tradeId, uint256 offerId);
    event TradeExecuted(uint256 tradeId, uint256 offerId);

    constructor() {
        platformFeeRecipient = msg.sender; // or some other address
    }

    function createTrade(uint256 token, ERC721 contractAddress, uint256 duration) public whenNotPaused nonReentrant {
        require(contractAddress.ownerOf(token) == msg.sender, "Must be the owner of the token"); // Require that the sender owns the token.
            // Set approval for the contract to transfer the token
        contractAddress.setApprovalForAll(msg.sender, true);
        // Lazy cleanup
        if (activeTrades[tradeCounter]) {
            Trade storage oldTrade = trades[tradeCounter];
            require(oldTrade.isCancelled || oldTrade.acceptedOfferId != 0, "Previous trade is still active");
            delete trades[tradeCounter];
            delete activeTrades[tradeCounter];
        }

        tradeCounter++;
        totalTradesEverMade++;

        Trade storage newTrade = trades[tradeCounter];
        newTrade.trader = payable(msg.sender);
        newTrade.token = token;
        newTrade.contractAddress = contractAddress;
        newTrade.tradeEndsAt = block.timestamp + duration;
        newTrade.isCancelled = false;
        newTrade.offersCounter = 0;
        newTrade.acceptedOfferId = 0;

        activeTrades[tradeCounter] = true;

        contractAddress.safeTransferFrom(msg.sender, address(this), token);

        emit TradeCreated(tradeCounter, msg.sender, token);
    }

    function cancelTrade(uint256 tradeId) public whenNotPaused nonReentrant {
        require(activeTrades[tradeId], "Trade doesn't exist or has been cleaned up");
        Trade storage trade = trades[tradeId];
        require(msg.sender == trade.trader, "Only the trader can cancel the trade");

        trade.contractAddress.safeTransferFrom(address(this), trade.trader, trade.token);

        trade.isCancelled = true;
        activeTrades[tradeId] = false;

        emit TradeCancelled(tradeId);
    }

    function createOffer(
        uint256 tradeId,
        uint256 offeredToken,
        ERC721 offeredTokenContract,
        uint256 ethAmount,
        uint256 offerDuration
    ) public payable whenNotPaused nonReentrant {
        require(activeTrades[tradeId], "Trade doesn't exist or has been cleaned up");
        Trade storage trade = trades[tradeId];
        require(msg.sender != trade.trader, "Trader cannot make an offer on their own trade");
        require(!trade.isCancelled, "Trade has been cancelled");
        require(offeredTokenContract.ownerOf(offeredToken) == msg.sender, "Must be the owner of the token offered");
        require(block.timestamp <= trade.tradeEndsAt, "Trade duration has expired");
        require(
            offerDuration <= (trade.tradeEndsAt - block.timestamp),
            "Offer duration cannot exceed remaining trade duration"
        );

        trade.offersCounter++;

        require(msg.value <= ethAmount, "Sent Ether does not match the total cost");

        Offer memory newOffer = Offer({
            offerer: payable(msg.sender),
            token: offeredToken,
            contractAddress: offeredTokenContract,
            ethAmount: ethAmount,
            isApproved: false,
            isCancelled: false,
            offerEndsAt: block.timestamp + offerDuration
        });

        trade.offers[trade.offersCounter] = newOffer;

        emit OfferCreated(tradeId, trade.offersCounter, msg.sender, offeredToken, ethAmount);
    }

    function extendTradeDuration(uint256 tradeId, uint256 additionalDuration) public whenNotPaused {
        require(activeTrades[tradeId], "Trade doesn't exist or has been cleaned up");
        Trade storage trade = trades[tradeId];
        require(msg.sender == trade.trader, "Only the trader can extend the trade duration");

        trade.tradeEndsAt += additionalDuration;

        // not sure if i emit an event here
    }

    function approveOffer(uint256 tradeId, uint256 offerId) public whenNotPaused nonReentrant {
        require(activeTrades[tradeId], "Trade doesn't exist or has been cleaned up");
        Trade storage trade = trades[tradeId];
        Offer storage offer = trade.offers[offerId];

        require(msg.sender == trade.trader, "Only the trader can approve an offer");
        require(!offer.isCancelled, "Offer has been cancelled");

        trade.acceptedOfferId = offerId;

        emit OfferApproved(tradeId, offerId);

        // Execute the trade immediately
        _executeTrade(tradeId, offerId);
    }

    function cancelOffer(uint256 tradeId, uint256 offerId) public whenNotPaused nonReentrant {
        require(activeTrades[tradeId], "Trade doesn't exist or has been cleaned up");
        Trade storage trade = trades[tradeId];
        Offer storage offer = trade.offers[offerId];

        require(msg.sender == offer.offerer, "Only the offerer can cancel an offer");

        if (offer.ethAmount > 0) {
            offer.offerer.transfer(offer.ethAmount);
        }

        offer.isCancelled = true;

        emit OfferCancelled(tradeId, offerId);
    }

    function _executeTrade(uint256 tradeId, uint256 offerId) internal nonReentrant {
        Trade storage trade = trades[tradeId];
        Offer storage offer = trade.offers[offerId];

        require(msg.sender == trade.trader, "Only the trader can execute the trade");
        require(block.timestamp <= trade.tradeEndsAt, "Trade duration expired");
        require(block.timestamp <= offer.offerEndsAt, "Offer duration expired");
        require(trade.acceptedOfferId > 0, "No offer has been accepted yet");
        require(!offer.isCancelled, "Offer has been cancelled");

        // Verify that the offerer still holds the NFT
        require(offer.contractAddress.ownerOf(offer.token) == offer.offerer, "Offerer must still own the NFT");

        uint256 ethAmount = offer.ethAmount;
        uint256 platformFee = 0; // Declare the platformFee variable here.

        offer.contractAddress.safeTransferFrom(offer.offerer, trade.trader, offer.token);

        if (ethAmount > 0) {
            platformFee = ethAmount * platformFeeBasisPoints / 10000 + platformFeeFixed;

            // Deduct royalties (if any)
            uint256 royalties = 0;
            if (ERC165Checker.supportsInterface(address(trade.contractAddress), type(IERC2981).interfaceId)) {
                (address receiver, uint256 royaltyAmount) =
                    IERC2981(address(trade.contractAddress)).royaltyInfo(trade.token, ethAmount);
                royalties = royaltyAmount;
                if (royalties > 0) {
                    payable(receiver).transfer(royalties);
                }
            }

            uint256 remaining = ethAmount - platformFee - royalties;

            // Transfer remaining ETH to the trader
            payable(trade.trader).transfer(remaining);
        }

        // Transfer NFT to the offerer
        trade.contractAddress.safeTransferFrom(address(this), offer.offerer, trade.token);

        // Mark the trade as no longer active
        activeTrades[tradeId] = false;

        // Transfer platform fee to the contract owner
        if (platformFee > 0) {
            payable(platformFeeRecipient).transfer(platformFee);
        }

        emit TradeExecuted(tradeId, offerId);
    }

    // Overriding IERC721Receiver's function
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        public
        virtual
        override
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

    function setPlatformFeeBasisPoints(uint256 _platformFeeBasisPoints) external onlyOwner {
        platformFeeBasisPoints = _platformFeeBasisPoints;
    }

    function setPlatformFeeFixed(uint256 _platformFeeFixed) external onlyOwner {
        platformFeeFixed = _platformFeeFixed;
    }
    // Pause contract function

    function pause() public onlyOwner {
        _pause();
    }

    // Unpause contract function
    function unpause() public onlyOwner {
        _unpause();
    }
}
