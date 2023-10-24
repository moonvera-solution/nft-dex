// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {
    IMvxCollection,
    Ownable,
    Math,
    LibClone,
    Stages,
    Member,
    Collection,
    Artist,
    Partner
} from "@src/libs/FactoryLibs.sol";

/**
 * @title MvxFactory
 * @author Moonvera
 * @dev Handles Mvx partnerships with artists
 * @dev Creates uups and minimal proxies of erc721A
 */
contract MvxFactory is Ownable {
    using Math for uint256;

    // Current IMvxCollection template
    address public collectionImpl;

    // nft collection deploy fee
    uint256 public deployFee;
    uint96 public platformFee;
    uint16 public collectionCount;

    mapping(address => Artist) public artists; // artists addr => Artist data, expires
    mapping(address => Partner) public partners; // collection addr => Collection data, expires
    mapping(address => Member) public members; // Members addr => Member data, expires

    error InvalidColletion(uint8);
    error Unathorized(uint8);
    error DiscountError(uint8);
    error GrantReferralError(uint8);
    error WithdrawPartnerError(uint8);
    error WithdrawReferralError(uint8);
    error UpdateMemberError(uint8);
    error CreateError(uint8);

    event CreateEvent(address indexed sender, address impl, address cloneAddress);
    event InitCollectionEvent(address sender, address collection);
    event CreateCollectionEvent(address sender, address template, address clone);
    event ReferralDiscount(address indexed _artist, address indexed _sender, address indexed _collection);
    event CollectionDiscount(address indexed _collection, uint96 indexed _discount);
    event WithdrawPartner(address indexed _sender, address indexed _collection, uint256 _balance);
    event WithdrawReferral(address indexed _sender, address indexed _artist, uint256 _referralBalance);

    event Log(string, uint256);

    modifier auth() {
        require(msg.sender == owner() || members[msg.sender].expiration > block.timestamp, "Auth");
        _;
    }

    constructor(uint256 _deployFee) Ownable() {
        deployFee = _deployFee;
    }

    receive() external payable {}

    fallback() external payable {
        revert Unathorized(0);
    }

    /**
     *
     */
    /**
     *          OnlyOwner          **
     */
    /**
     *
     */

    /// @notice Grants create colletion rights to MVX_MEMBER
    function updateMember(address _newMember, address _collection, uint96 _discount, uint256 _expirationDays)
        external
        payable
        onlyOwner
    {
        if (_newMember == address(0x0)) revert UpdateMemberError(1);
        if (members[_newMember].expiration != 0) revert UpdateMemberError(2);
        require(_discount < 10_000); // discount can be zero

        members[_newMember] = Member({
            collection: _collection,
            discount: _discount,
            expiration: block.timestamp + (_expirationDays * 60 * 60 * 24)
        });
    }

    /// @notice All percentages are in bp
    function updatePartnership(
        address _collection,
        address _admin,
        uint96 _adminOwnPercent,
        uint96 _referralOwnPercent,
        uint96 _discountPercent,
        uint40 _expireDaysFromNow
    ) external onlyOwner {
        require(_admin != address(0x0));
        require(partners[_collection].admin == address(0x0));
        partners[_collection] = Partner({
            admin: _admin,
            adminOwnPercent: _adminOwnPercent,
            referralOwnPercent: _referralOwnPercent,
            balance: 0,
            discount: _discountPercent,
            expiration: uint40(block.timestamp + (_expireDaysFromNow * (60 * 60 * 24)))
        });
    }

    /// @notice Access: only Owner
    /// @param _fee new fee on mint
    function updatePlatformFee(uint96 _fee) external payable onlyOwner {
        platformFee = _fee;
    }

    /// @notice Access: only Owner
    /// @param _impl Clone's proxy implementation of IMvxCollection logic
    /// @dev payable for gas saving
    function updateCollectionImpl(address _impl) external payable onlyOwner {
        if (!IMvxCollection(_impl).supportsInterface(0xc21b8f28)) {
            // ERC721A interface Id
            revert InvalidColletion(1);
        }
        collectionImpl = _impl;
    }

    /// @notice Access: only Owner
    /// @dev in basis points
    function updateDeployFee(uint96 _newFee) external payable onlyOwner {
        require(_newFee > 0 && _newFee < 10_000);
        deployFee = _newFee;
    }

    function deleteArtist(address _artist) external onlyOwner {
        delete artists[_artist];
    }

    function deleteMember(address _member) external onlyOwner {
        delete members[_member];
    }

    /**
     *
     */
    /**
     *      Withdraw Functions     **
     */
    /**
     *
     */

    function withdraw() external payable onlyOwner {
        (bool sent,) = owner().call{value: address(this).balance}("");
        require(!sent);
    }

    function withdrawPartner(address _collection) external {
        address _sender = payable(msg.sender);
        Partner memory _partner = partners[_collection];
        uint256 _balance = _partner.balance;
        if (_partner.admin != _sender) revert WithdrawPartnerError(1);
        if (!(_balance > 0)) revert WithdrawPartnerError(2);
        _partner.balance = 0;
        (bool sent,) = _sender.call{value: _balance}("");
        if (!sent) revert WithdrawPartnerError(3);
        emit WithdrawPartner(_sender, _collection, _balance);
    }

    function withdrawReferral(address artist_) external {
        address _sender = msg.sender;
        Artist memory _artist = artists[artist_];
        uint256 _referralBalance = _artist.referralBalance;
        if (_artist.referral != _sender) revert WithdrawReferralError(1);
        emit Log("_referralBalance", _referralBalance);
        if (!(_referralBalance > 0)) revert WithdrawReferralError(2);
        delete artists[artist_];
        (bool sent,) = _sender.call{value: _referralBalance}("");
        if (!sent) revert WithdrawReferralError(3);
        emit WithdrawReferral(_sender, artist_, _referralBalance);
    }

    /**
     *
     */
    /**
     *        Grant Referrals      **
     */
    /**
     *
     */

    /// @notice Access: owner & members of any collection created with this launchpad contract
    /// @dev Only valid if there is a partnership/discount between the collection admin and Mvx
    /// @dev 10 days max to use referral discount
    function grantReferral(address _extCollection, address _artist) external {
        // check msg.sender is part of the Collection
        address _referral = msg.sender;
        bool isCollectionMember = IMvxCollection(_extCollection).balanceOf(_referral) > 0;
        if (!isCollectionMember) revert GrantReferralError(1);

        // check called collection has a discount, set by MVX only
        bool hasDiscount =
            partners[_extCollection].discount > 0 && partners[_extCollection].expiration > block.timestamp;
        if (!hasDiscount) revert GrantReferralError(2);

        // check _artist has not a referral already
        if (artists[_artist].referral != address(0x0)) revert GrantReferralError(3);

        uint256 _expiration = 10 * (60 * 60 * 24); // set up Artist Info, valid for 10 days

        artists[_artist] = Artist(_referral, 0, _extCollection, _expiration); // 20% referrals
        emit ReferralDiscount(_artist, _referral, _extCollection);
    }

    /**
     *
     */
    /**
     *      Launch Collection      **
     */
    /**
     *
     */
    event Log(string, bool);

    function createCollection(
        Collection calldata _nftsData,
        Stages calldata _mintingStages,
        address[] calldata _ogs,
        address[] calldata _wls
    ) external payable auth returns (address _clone) {
        address _sender = msg.sender;
        uint256 _msgValue = msg.value;
        Artist memory _artist = artists[_sender];

        // check artist discount
        if (_artist.expiration >= block.timestamp) _applyDiscount(_artist, _sender, _msgValue);
        else if (_msgValue < deployFee) revert CreateError(1);

        // encode seder to clone immutable arg
        bytes memory data = abi.encodePacked(_sender);

        // Lib clone minimal proxy with immutable args
        _clone = LibClone.clone(address(collectionImpl), data);
        if (_clone == address(0x0)) revert CreateError(1);

        // Init Art collection minimal proxy clone
        IMvxCollection(_clone).initialize(
            platformFee, // set by MvxFactory owner
            _nftsData,
            _mintingStages,
            _ogs,
            _wls
        );

        members[_sender] = Member({collection: _clone, discount: 0, expiration: 0});
        unchecked {
            collectionCount = collectionCount + 1;
        }
        emit CreateEvent(_sender, collectionImpl, _clone);
    }

    event ReferralBalanceUpdate(address, uint256);
    event PartnerBalanceUpdate(address, uint256);

    function _applyDiscount(Artist memory _artist, address _sender, uint256 _msgValue) internal returns (bool) {
        emit Log("applying discount", 0);
        Partner memory _partner = partners[_artist.collection];
        uint256 _discountAmount = _percent(deployFee, _partner.discount); // 20% discount
        if (_msgValue < deployFee - _discountAmount) revert DiscountError(1);

        // here we start deducting from msg.value
        uint256 _referralAmount = _percent(deployFee, _partner.referralOwnPercent);

        _msgValue = _msgValue - _referralAmount; // -20% update
        _artist.referralBalance = _referralAmount;
        emit ReferralBalanceUpdate(_artist.referral, _referralAmount);
        _artist.expiration = 0;
        artists[_sender] = _artist;

        uint256 _partnerAmount = _percent(deployFee, _partner.adminOwnPercent);
        if (_msgValue < _partnerAmount) revert DiscountError(2);

        _msgValue = _msgValue - _partnerAmount; // -10% update
        _partner.balance = _partner.balance + _partnerAmount;
        emit PartnerBalanceUpdate(_partner.admin, _partnerAmount);
        partners[_artist.collection] = _partner;
        if (address(this).balance < msg.value - (_partnerAmount + _referralAmount)) revert DiscountError(3);
        return true;
    }

    function getTime() public view returns (uint256 _time) {
        _time = block.timestamp;
    }

    /// @param _daysFromNow current timestamp plus days
    function getTime(uint256 _daysFromNow) public view returns (uint256 _time) {
        _time = block.timestamp + (_daysFromNow * 60 * 60 * 24);
    }

    function getPartnerBalance(address _collection) public view returns (uint256 _balance) {
        _balance = partners[_collection].balance;
    }

    function getReferralBalance(address _artist) public view returns (uint256 _balance) {
        _balance = artists[_artist].referralBalance;
    }

    function totalCollections() external view returns (uint256 _total) {
        _total = collectionCount;
    }

    function _percent(uint256 a, uint96 b) internal pure returns (uint256) {
        return a.mulDiv(b, 10_000);
    }
}
