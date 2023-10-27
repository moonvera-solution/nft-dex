// SPDX-License-Identifier: MIT O
pragma solidity 0.8.20;

import "@openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

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
} from "./libs/FactoryLibs.sol";

//
// ███╗   ███╗██╗   ██╗██╗  ██╗ ██████╗  █████╗ ██████╗
// ████╗ ████║██║   ██║╚██╗██╔╝ ██╔══██╗██╔══██╗██╔══██╗
// ██╔████╔██║██║   ██║ ╚███╔╝  ██████╔╝███████║██║  ██║
// ██║╚██╔╝██║╚██╗ ██╔╝ ██╔██╗  ██╔═══╝ ██╔══██║██║  ██║
// ██║ ╚═╝ ██║ ╚████╔╝ ██╔╝ ██╗ ██║     ██║  ██║██████╔╝
// ╚═╝     ╚═╝  ╚═══╝  ╚═╝  ╚═╝ ╚═╝     ╚═╝  ╚═╝╚═════╝
//
/// @title MvxPad
/// @author Moonvera
/// @dev Handles Mvx Launchpad Partners
/// @dev Creates minimal proxies clones of ERC721A
contract MvxFactory is OwnableUpgradeable, UUPSUpgradeable {
    using Math for uint256;

    // Current IMvxCollection template
    address public collectionImpl;

    // nft collection deploy fee
    uint256 public collectionCount;
    uint256 private _referralExpiration;

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
    event ReferralBalanceUpdate(address, uint256);
    event PartnerBalanceUpdate(address, uint256);

    event Log(string, uint256);

    modifier auth() {
        require(msg.sender == owner() || members[msg.sender].expiration > block.timestamp, "Auth");
        _;
    }

    function initialize() public initializer {
        __Ownable_init_unchained();
    }

    receive() external payable {}

    fallback() external payable {
        revert Unathorized(0);
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                     OWNER UPDATES
    ///0x0000000000000000000000000000000000000000000000000000000000000000

    function updateReferralExpiration(uint256 _expirationInDays) external payable onlyOwner {
        _referralExpiration = _expirationInDays * (60 * 60 * 24);
    }
    /// @notice Grants create colletion rights to MVX member

    function updateMember(
        address _newMember,
        address _collection,
        uint256 _deployFee, // fixed amount
        uint96 _platformFee, // percent basis points
        uint96 _discount, // percent basis points
        uint256 _expirationDays
    ) external payable onlyOwner {
        if (_newMember == address(0x0)) revert UpdateMemberError(1);
        if (members[_newMember].expiration != 0) revert UpdateMemberError(2);
        require(_platformFee < 10_000 && _discount < 10_000);

        members[_newMember] = Member({
            collection: _collection,
            deployFee: _deployFee,
            platformFee: _platformFee,
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
        emit UpdatePartnerEvent(partners[_collection]);
    }

event UpdatePartnerEvent(Partner);

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

    function deleteArtist(address _artist) external onlyOwner {
        delete artists[_artist];
    }

    function deleteMember(address _member) external onlyOwner {
        delete members[_member];
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                         WITHDRAWS
    ///0x0000000000000000000000000000000000000000000000000000000000000000

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

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                      GRANT REFERRALS
    ///0x0000000000000000000000000000000000000000000000000000000000000000

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

        artists[_artist] = Artist(_referral, 0, _extCollection, _referralExpiration); // 20% referrals
        emit ReferralDiscount(_artist, _referral, _extCollection);
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                      CREATE COLLECTION
    ///0x0000000000000000000000000000000000000000000000000000000000000000

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
        Member memory member = members[_sender];
        uint256 _deployFee = member.deployFee;

        if (_artist.expiration >= block.timestamp) _applyDiscount(_artist, _sender, _msgValue,_deployFee);
        else if (_msgValue < _deployFee) revert CreateError(1);

        // encode seder to clone immutable arg
        bytes memory data = abi.encodePacked(_sender);

        // Lib clone minimal proxy with immutable args
        _clone = LibClone.clone(address(collectionImpl), data);
        if (_clone == address(0x0)) revert CreateError(1);

        // Init Art collection minimal proxy clone
        IMvxCollection(_clone).initialize(
            member.platformFee, // set by MvxFactory owner
            _nftsData,
            _mintingStages,
            _ogs,
            _wls
        );

        // Member single time deploy
        member.expiration = 0;
        member.collection = _clone;
        members[_sender] = member;
        unchecked {
            collectionCount = collectionCount + 1;
        }
        emit CreateEvent(_sender, collectionImpl, _clone);
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                         UI VIEWS
    ///0x0000000000000000000000000000000000000000000000000000000000000000
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

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                      INTERNAL LOGIC
    ///0x0000000000000000000000000000000000000000000000000000000000000000

    function _applyDiscount(Artist memory _artist, address _sender, uint256 _msgValue,uint256 _deployFee) internal returns (bool) {
        Partner memory _partner = partners[_artist.collection];
        uint256 _discountAmount = _percent(_deployFee, _partner.discount); // 20% discount
        
        emit Log("_deployFee - _discountAmount: ",_deployFee - _discountAmount);
        emit Log("_msgValue: ",_msgValue);
        
        if (_msgValue < _deployFee - _discountAmount) revert DiscountError(100);

        // here we start deducting from msg.value
        uint256 _referralAmount = _percent(_deployFee, _partner.referralOwnPercent);

        _msgValue = _msgValue - _referralAmount; // -20% update
        _artist.referralBalance = _referralAmount;
        emit ReferralBalanceUpdate(_artist.referral, _referralAmount);
        _artist.expiration = 0;
        artists[_sender] = _artist;

        uint256 _partnerAmount = _percent(_deployFee, _partner.adminOwnPercent);
        if (_msgValue < _partnerAmount) revert DiscountError(2);

        _msgValue = _msgValue - _partnerAmount; // -10% update
        _partner.balance = _partner.balance + _partnerAmount;
        emit PartnerBalanceUpdate(_partner.admin, _partnerAmount);
        partners[_artist.collection] = _partner;
        if (address(this).balance < msg.value - (_partnerAmount + _referralAmount)) revert DiscountError(3);
        return true;
    }

    function _percent(uint256 a, uint96 b) public pure returns (uint256) {
        return a.mulDiv(b, 10_000);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function upgradeTo(address _newImplementation) public override onlyOwner {
        super.upgradeTo(_newImplementation);
    }
}
