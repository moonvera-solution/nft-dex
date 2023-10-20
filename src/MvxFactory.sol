// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {LibClone} from "@solady/utils/LibClone.sol";
import {Clone} from "@solady/utils/Clone.sol";
import {IERC721A} from "./interfaces/IERC721A.sol";
import {MvxCollection} from "./MvxCollection.sol";
import {Stages, Collection, Artist, Partner} from "@src/libs/MvxStruct.sol";
import {AccessControl, Math} from "@src/libs/AccessControl.sol";
import {Ownable} from "@src/libs/Ownable.sol";

/**
 * @title MvxFactory contract to create erc721's clones with immutable arguments
 * @author MoonveraLabs
 */
contract MvxFactory is Ownable {
    using Math for uint256;

    // Current MvxCollection template
    address public collectionImpl;

    // nft collection deploy fee
    uint256 public deployFee;
    uint96 public platformFee;

    mapping(address => Artist) public artists; // artists expire
    mapping(address => Partner) public partners; // collection addr => Collection data
    mapping(address => address) public collections; // creator => collection address
    mapping(address => uint256) public members;
    uint256 public collectionCount;

    error CreateCloneError();
    error InvalidColletion(uint8);
    error Unathorized(uint8);
    error DiscountError(uint8);
    error WithdrawPartnerError(uint8);
    error WithdrawReferralError(uint8);

    event CreateCloneEvent(address indexed sender, address impl, address cloneAddress);
    event InitOwnerEvent(address sender);
    event InitCollectionEvent(address sender, address collection);
    event CreateCollectionEvent(address sender, address template, address clone);
    event DiscountGranted(
        address indexed _artist, address indexed _sender, address indexed _collection, uint96 _discount
    );
    event CollectionDiscount(address indexed _collection, uint96 indexed _discount);
    event WithdrawPartner(address indexed _sender, address indexed _collection, uint256 _adminBalance);
    event WithdrawReferral(address indexed _sender, address indexed _artist, uint256 _referralBalance);

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
            adminBalance: 0,
            discount: _discountPercent
        });
    }
    /// @notice Access: only Owner
    /// @param _fee new fee on mint

    function updatePlatformFee(uint96 _fee) external payable onlyOwner {
        // platformFee = _fee;
    }

    /// @notice Access: only Owner
    /// @param _impl Clone's proxy implementation of MvxCollection logic
    /// @dev payable for gas saving
    function setCollectionImpl(address _impl) external payable onlyOwner {
        if (!MvxCollection(_impl).supportsInterface(type(IERC721A).interfaceId)) {
            revert InvalidColletion(2);
        }
        collectionImpl = _impl;
    }

    /// @notice Access: only Owner
    /// @dev payable for gas saving
    function updateDeployFee(uint256 _newFee) external payable onlyOwner {
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
        (bool sent,) = owner().call{value: address(this).balance}("");
        require(sent, "withdraw Fail");
    }

    /**
     * WITHDRAW PARTNER *************************
     */

    function withdrawPartner(address _collection) external {
        address _sender = msg.sender;
        if(partners[_collection].admin != _sender) revert WithdrawPartnerError(1);
        uint256 _adminBalance = getPartnerBalance(_collection);
        if (!(_adminBalance > 0)) revert WithdrawPartnerError(2);
        (bool sent,) = _sender.call{value: _adminBalance}("");
        if (!sent) revert WithdrawPartnerError(3);
        emit WithdrawPartner(_sender, _collection, _adminBalance);
    }

    function updateArtist(address artist) external onlyOwner(){
        delete artists[artist];
    }

    function getPartnerBalance(address _collection) public view returns (uint256 _balance) {
        _balance = partners[_collection].adminBalance;
    }

    /**
     * WITHDRAW REFERRAL *************************
     */

    function withdrawReferral(address _artist) external {
        address _sender = msg.sender;
        if (artists[_artist].referral != _sender) revert WithdrawReferralError(1);
        uint256 _referralBalance = getReferralBalance(_artist);
        if (!(_referralBalance > 0)) revert WithdrawReferralError(2);
        (bool sent,) = _sender.call{value: _referralBalance}("");
        if (!sent) revert WithdrawReferralError(3);
        delete artists[_artist];
        emit WithdrawReferral(_sender, _artist, _referralBalance);
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
        if (!(MvxCollection(_extCollection).balanceOf(_referral) > 0)) revert DiscountError(1);

        // check called collection has a discount, set by MVX only
        uint96 _discount = partners[_extCollection].discount; // in basis points
        if (!(_discount > 0)) revert DiscountError(2);

        // check _artist has not a referral already
        if (!(artists[_artist].referral == address(0x0))) revert DiscountError(3);

        uint256 _expiration = 10 * (60 * 60 * 24); // set up Artist Info, valid for 10 days

        artists[_artist] = Artist(_referral, 0, _extCollection, _expiration); // 20% referrals
        emit DiscountGranted(_artist, _referral, _extCollection, _discount);
    }

    /**
     * CREATE COLLECTION *************************
     */

    function _percent(uint256 a, uint96 b) internal pure returns (uint256) {
        return a.mulDiv(b, 10_000);
    }

    modifier auth() {
        require(msg.sender == owner() || members[msg.sender] > block.timestamp, "Unathorized");
        _;
    }

    event Log(string,uint);
    function createCollection(
        Collection calldata _nftsData,
        Stages calldata _mintingStages,
        address[] calldata _ogs,
        address[] calldata _wls
    ) external payable auth returns (address _clone) {
        address _sender = msg.sender;
        uint256 _msgValue = msg.value;
        Artist memory _artist = artists[_sender];

        // we check partnership discount exists before setting _artist
        if (_artist.expiration > block.timestamp) {
            Partner memory _partner = partners[_artist.collection];

            uint256 _discountAmount = _percent(deployFee, _partner.discount); // 20% discount
            emit Log("_discountAmount:: ",_discountAmount);
            require(_msgValue >= deployFee - _discountAmount, "1");

            // here we start deducting from msg.value
            uint256 _referralAmount = _percent(deployFee, _partner.referralOwnPercent);

            _msgValue = _msgValue - _referralAmount; // -20% update
            _artist.referralBalance = _referralAmount;
            _artist.expiration = 0;
            artists[_sender] = _artist;
            emit Log("referralBalance:: ",_artist.referralBalance);

            uint256 _adminAmount = _percent(deployFee, _partner.adminOwnPercent);
            require(_msgValue > _adminAmount, "2");

            _msgValue = _msgValue - _adminAmount; // -10% update
            _partner.adminBalance = _adminAmount;
            partners[_artist.collection] = _partner;


            emit Log("adminBalance:: ",_partner.adminBalance);
            emit Log("mvx:: ",address(this).balance);

            require(_msgValue > 0, "3");
        } else {
            require(_msgValue >= deployFee, "4");
        }

        // encode seder to clone immutable arg
        bytes memory data = abi.encodePacked(_sender);

        // Lib clone minimal proxy with immutable args
        _clone = LibClone.clone(address(collectionImpl), data);
        if (_clone == address(0x0)) revert CreateCloneError();

        // Init Art collection minimal proxy clone
        MvxCollection(_clone).initialize(
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
        emit CreateCollectionEvent(_sender, collectionImpl, _clone);
    }

    function getTime() public view returns (uint256 _time) {
        _time = block.timestamp;
    }

    /// @param _daysFromNow current timestamp plus days
    function getTime(uint256 _daysFromNow) public view returns (uint256 _time) {
        _time = block.timestamp + (_daysFromNow * 60 * 60 * 24);
    }

    function totalCollections() external view returns (uint256 _total) {
        _total = collectionCount;
    }
}
