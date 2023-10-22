// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {IMvxCollection, Ownable, Math, LibClone, Stages, Collection, Artist, Partner} from "@src/libs/FactoryLibs.sol";

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
  uint96 public deployFee;
  uint96 public platformFee;
  uint16 public collectionCount;

  mapping(address => Artist) public artists; // artists expire
  mapping(address => Partner) public partners; // collection addr => Collection data
  mapping(address => address) public collections; // creator => collection address
  mapping(address => uint256) public members;

  error InvalidColletion(uint8);
  error Unathorized(uint8);
  error DiscountError(uint8);
  error WithdrawPartnerError(uint8);
  error WithdrawReferralError(uint8);
  error CreateError(uint8);

  event CreateEvent(address indexed sender, address impl, address cloneAddress);
  event InitOwnerEvent(address sender);
  event InitCollectionEvent(address sender, address collection);
  event CreateCollectionEvent(address sender, address template, address clone);
  event DiscountGranted(address indexed _artist, address indexed _sender, address indexed _collection);
  event CollectionDiscount(address indexed _collection, uint96 indexed _discount);
  event WithdrawPartner(address indexed _sender, address indexed _collection, uint256 _balance);
  event WithdrawReferral(address indexed _sender, address indexed _artist, uint256 _referralBalance);

  modifier auth() {
    require(msg.sender == owner() || members[msg.sender] > block.timestamp, "Unathorized");
    _;
  }

  constructor(uint96 _deployFee) Ownable() {
    deployFee = _deployFee;
  }

  receive() external payable {}

  fallback() external payable {
    revert("Unsupported");
  }

  function setPartnership(
    address _collection,
    address _admin,
    uint96 _adminOwnPercent,
    uint96 _referralOwnPercent,
    uint96 _discountPercent
  ) external onlyOwner {
    partners[_collection] = Partner({
      admin: _admin,
      adminOwnPercent: _adminOwnPercent,
      referralOwnPercent: _referralOwnPercent,
      balance: 0,
      discount: _discountPercent
    });
  }

  /// @notice Access: only Owner
  /// @param _fee new fee on mint

  function updatePlatformFee(uint96 _fee) external payable onlyOwner {
    // platformFee = _fee;
  }

  event Log(string, bytes4);

  /// @notice Access: only Owner
  /// @param _impl Clone's proxy implementation of IMvxCollection logic
  /// @dev payable for gas saving
  function setCollectionImpl(address _impl) external payable onlyOwner {
    if (!IMvxCollection(_impl).supportsInterface(0xc21b8f28)) {
      // ERC721A interface Id
      revert InvalidColletion(2);
    }
    collectionImpl = _impl;
  }

  /// @notice Access: only Owner
  /// @dev payable for gas saving
  function updateDeployFee(uint96 _newFee) external payable onlyOwner {
    require(_newFee > 0, "Invalid Fee");
    deployFee = _newFee;
  }

  /// @notice Grants create colletion rights to MVX_MEMBER
  function updateMember(address _newMember, uint256 _expirationDays) external payable onlyOwner {
    uint256 validUntil = block.timestamp + (_expirationDays * 60 * 60 * 24);
    require(block.timestamp < validUntil, "Invalid valid until");
    members[_newMember] = _expirationDays;
  }

  /**
   * WITHDRAW ADMIN *************************
   */

  function withdraw() external payable onlyOwner {
    (bool sent, ) = owner().call{value: address(this).balance}("");
    require(sent, "withdraw Fail");
  }

  /**
   * WITHDRAW PARTNER *************************
   */

  function withdrawPartner(address _collection) external {
    address _sender = msg.sender;
    Partner memory _partner = partners[_collection];
    uint256 _balance = _partner.balance;
    require(_partner.admin != _sender, "WP:1");
    require(_balance > 0, "WP:2");
    _partner.balance = 0;
    (bool sent, ) = _sender.call{value: _balance}("");
    require(sent, "WP:1");
    emit WithdrawPartner(_sender, _collection, _balance);
  }

  function updateArtist(address artist) external onlyOwner {
    delete artists[artist];
  }

  function getPartnerBalance(address _collection) public view returns (uint256 _balance) {
    _balance = partners[_collection].balance;
  }

  /**
   * WITHDRAW REFERRAL *************************
   */

  function withdrawReferral(address artist_) external {
    address _sender = msg.sender;
    Artist memory _artist = artists[artist_];
    uint256 _referralBalance = _artist.referralBalance;
    require(_artist.referral == _sender, "WR:1");
    require(_referralBalance > 0, "WR:2");
    delete artists[artist_];
    (bool sent, ) = _sender.call{value: _referralBalance}("");
    require(sent, "WR:3");
    emit WithdrawReferral(_sender, artist_, _referralBalance);
  }

  function getReferralBalance(address _artist) public view returns (uint256 _balance) {
    _balance = artists[_artist].referralBalance;
  }

  /// @notice Access: owner & members of any collection created with this launchpad contract
  /// @dev Only valid if there is a partnership/discount between the collection admin and Mvx
  /// @dev 10 days max to use referral discount
  function grantReferral(address _extCollection, address _artist) external {
    // check msg.sender is part of the Collection
    address _referral = msg.sender;
    bool isCollectionMember = (IMvxCollection(_extCollection).balanceOf(_referral)) > 0;
    if (!isCollectionMember) revert DiscountError(1);

    // check called collection has a discount, set by MVX only
    bool hasDiscount = partners[_extCollection].discount > 0;
    if (!hasDiscount) revert DiscountError(2);

    // check _artist has not a referral already
    if (artists[_artist].referral != address(0x0)) revert DiscountError(3);

    uint256 _expiration = 10 * (60 * 60 * 24); // set up Artist Info, valid for 10 days

    artists[_artist] = Artist(_referral, 0, _extCollection, _expiration); // 20% referrals
    emit DiscountGranted(_artist, _referral, _extCollection);
  }

  /**
   * CREATE COLLECTION *************************
   */

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
    if (_artist.expiration > block.timestamp) _applyDiscount(_artist, _sender, _msgValue);
    else if (_msgValue < deployFee) revert CreateError(1);

    // encode seder to clone immutable arg
    bytes memory data = abi.encodePacked(_sender);

    // Lib clone minimal proxy with immutable args
    _clone = LibClone.clone(address(collectionImpl), data);
    if (_clone == address(0x0)) revert CreateError(1);

    // Init Art collection minimal proxy clone
    IMvxCollection(_clone).initialize(
      0, //platformFee, // set by MvxFactory owner
      _nftsData,
      _mintingStages,
      _ogs,
      _wls
    );

    collections[_sender] = _clone;
    unchecked {
      collectionCount = collectionCount + 1;
    }
    emit CreateEvent(_sender, collectionImpl, _clone);
  }

  function _applyDiscount(Artist memory _artist, address _sender, uint256 _msgValue) internal returns (bool) {
    Partner memory _partner = partners[_artist.collection];
    uint256 _discountAmount = _percent(deployFee, _partner.discount); // 20% discount
    if (_msgValue < deployFee - _discountAmount) revert DiscountError(1);

    // here we start deducting from msg.value
    uint256 _referralAmount = _percent(deployFee, _partner.referralOwnPercent);

    _msgValue = _msgValue - _referralAmount; // -20% update
    _artist.referralBalance = _referralAmount;
    _artist.expiration = 0;
    artists[_sender] = _artist;

    uint256 _adminAmount = _percent(deployFee, _partner.adminOwnPercent);
    if (_msgValue < _adminAmount) revert DiscountError(2);

    _msgValue = _msgValue - _adminAmount; // -10% update
    _partner.balance = _adminAmount;
    partners[_artist.collection] = _partner;
    if (address(this).balance < msg.value - (_adminAmount + _referralAmount)) revert DiscountError(3);
    return true;
  }

  function getTime() public view returns (uint256 _time) {
    _time = block.timestamp;
  }

  function _percent(uint256 a, uint96 b) internal pure returns (uint256) {
    return a.mulDiv(b, 10_000);
  }

  /// @param _daysFromNow current timestamp plus days
  function getTime(uint256 _daysFromNow) public view returns (uint256 _time) {
    _time = block.timestamp + (_daysFromNow * 60 * 60 * 24);
  }

  function totalCollections() external view returns (uint256 _total) {
    _total = collectionCount;
  }
}
