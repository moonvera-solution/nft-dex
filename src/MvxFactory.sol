// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {LibClone} from "@solady/utils/LibClone.sol";
import {Clone} from "@solady/utils/Clone.sol";
import {IERC721A} from "./interfaces/IERC721A.sol";
import {MvxCollection} from "./MvxCollection.sol";
import {Stages, Collection} from "@src/libs/MvxStruct.sol";

/**
 * @title MvxFactory contract to create erc721's clones with immutable arguments
 * @author MoonveraLabs
 */
contract MvxFactory {
    // Keep track of collections/clones per user
    mapping(address => address) public collections;

    // MvxFactory  address(user) => validUntil;
    mapping(address => uint256) public members;

    // Current MvxCollection template
    address public collectionImpl;

    // ownable by deployer
    address public owner;

    // nft collection deploy fee
    uint256 public deployFee;

    // Minting fee
    uint96 public platformFee;

    // count of total number of collections
    uint256 collectionCount;

    error CreateCloneError();
    error InvalidColletion(uint8);

    event CreateCloneEvent(address indexed sender, address impl, address cloneAddress);
    event InitOwnerEvent(address sender);
    event InitCollectionEvent(address sender, address collection);
    event CreateCollectionEvent(address sender, address template, address clone);

    constructor(uint96 _platformFee) {
        owner = payable(msg.sender);
        platformFee = _platformFee;
        emit InitOwnerEvent(owner);
    }

    receive() external payable {}

    fallback() external payable {
        revert("Unsupported");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender] >= block.timestamp, "Only members");
        _;
    }

    modifier auth() {
        require(msg.sender == owner || members[msg.sender] >= block.timestamp, "Only Auth");
        _;
    }

    /// @notice Access: only Owner
    /// @param _fee new fee on mint
    /// @dev payable for gas saving
    function updatePlatformFee(uint96 _fee) external payable onlyOwner {
        platformFee = _fee;
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
    function transferOwnerShip(address _newOner) external payable onlyOwner {
        require(_newOner != address(0x0), "Zero address");
        owner = _newOner;
    }

    /// @notice Access: only Owner
    /// @dev payable for gas saving
    function withdraw() external payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @notice Access: only Owner
    /// @dev payable for gas saving
    function updateDeployFee(uint256 _newFee) external payable onlyOwner {
        require(_newFee > 0, "Invalid Fee");
        deployFee = _newFee;
    }

    /// @notice Access: only Owner
    /// @param user only Owner
    /// @param expire days from today to membership expired
    /// @dev payable for gas saving
    function updateMember(address user, uint256 expire) external payable onlyOwner {
        uint256 validUntil = block.timestamp + (expire * 60 * 60 * 24);
        require(block.timestamp < validUntil, "Invalid valid until");
        members[user] = validUntil;
    }

    /// @param _nftsData collection name, symbol baseuri, max supply etc..
    /// @param _mintingStages mint times per stage og wl reg
    /// @param _ogs address[]og,
    /// @param _wls address[] wl
    function createCollection(
        Collection calldata _nftsData,
        Stages calldata _mintingStages,
        address[] calldata _ogs,
        address[] calldata _wls
    ) external payable auth returns (address _clone) {
        require(msg.value >= deployFee, "Missing deploy fee");

        // encode seder to clone immutable arg
        bytes memory data = abi.encodePacked(msg.sender);

        // Lib clone minimal proxy with immutable args
        _clone = LibClone.clone(address(collectionImpl), data);

        if (_clone == address(0x0)) revert CreateCloneError();

        // set clone address to member mapping
        collections[msg.sender] = _clone;
        emit CreateCollectionEvent(msg.sender, collectionImpl, _clone);

        // return dust
        uint256 dust = msg.value - deployFee;
        if (dust > 0) {
            payable(msg.sender).transfer(dust);
        }
        delete members[msg.sender]; // only one time create clone

        // Init Art collection minimal proxy clone
        MvxCollection(_clone).initialize(
            platformFee, // set by MvxFactory owner
            _nftsData,
            _mintingStages,
            _ogs,
            _wls
        );

        unchecked {
            collectionCount = collectionCount + 1;
        }
        emit InitCollectionEvent(msg.sender, _clone);
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
