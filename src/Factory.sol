// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {LibClone} from "solady/src/utils/LibClone.sol";
import {Clone} from "solady/src/utils/Clone.sol";
import {ArtCollection} from "./ArtCollection.sol";

import {Test, console, console2, Vm} from "forge-std/Test.sol";

/**
 * @title Factory contract to create erc721's clones with immutable arguments
 * @author MoonveraLabs
 */
contract Factory {
    // Keep track of collections/clones per user
    mapping(address => address) public collections;

    // Factory  address(user) => validUntil;
    mapping(address => uint256) public members;

    // Current ArtCollection template
    address public _collectionImpl;

    // ownable by deployer
    address public _owner;

    // default art collection deploy fee
    uint256 public _deployFee;

    // Fee to charge for any mint
    uint256 public _mintFee;

    // count of total number of collections
    uint256 _totalCollections;

    error CreateCloneError();

    event CreateCloneEvent(address indexed sender, address impl, address cloneAddress);

    event InitOwnerEvent(address sender);
    event InitCollectionEvent(address sender, address collection);
    event CreateCollectionEvent(address sender, address template, address clone);

    constructor(uint256 freeOnMint) {
        _owner = payable(msg.sender);
        _mintFee = freeOnMint;
        emit InitOwnerEvent(_owner);
    }

    receive() external payable {}

    fallback() external payable {
        revert("Unsupported");
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner");
        _;
    }

    // only members
    modifier onlyMember() {
        require(members[msg.sender] >= block.timestamp, "Only members");
        _;
    }

    modifier auth() {
        require(msg.sender == _owner || members[msg.sender] >= block.timestamp, "Only Auth");
        _;
    }

    function updateDeployFee(uint256 _newFee) external onlyOwner {
        require(_newFee > 0, "Invalid Fee");
        _deployFee = _newFee;
    }

    function updateMember(address user, uint256 daysValidUntil) external onlyOwner {
        uint256 validUntil = block.timestamp + (daysValidUntil * 60 * 60 * 24);
        require(block.timestamp < validUntil, "Invalid valid until");
        members[user] = validUntil;
    }

    function createCollection(
        bytes memory nftsData,
        address[] calldata initialOGMinters,
        address[] calldata initialWLMinters,
        uint256[] calldata mintingStages
    ) external payable auth returns (address _clone) {
        require(msg.value >= _deployFee, "Missing deploy fee");

        bytes memory data = abi.encodePacked(msg.sender);
        _clone = LibClone.clone(address(_collectionImpl), data);
        if (_clone == address(0x0)) revert CreateCloneError();
        collections[msg.sender] = _clone;
        emit CreateCollectionEvent(msg.sender, _collectionImpl, _clone);

        if (msg.value - _deployFee > 0) {
            payable(msg.sender).transfer(msg.value - _deployFee);
        }
        delete members[msg.sender]; // only one time create clone

        // Init Art collection proxy clone
        ArtCollection(_clone).initialize(
            _mintFee, // set by factory owner
            nftsData,
            initialOGMinters,
            initialWLMinters,
            mintingStages
        );

        unchecked {
            _totalCollections = _totalCollections + 1;
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

    function updateMintFee(uint256 _newFeeOnMint) external onlyOwner {
        _mintFee = _newFeeOnMint;
    }

    function setCollectionImpl(address _impl) external onlyOwner {
        _collectionImpl = _impl;
    }

    function transferOwnerShip(address newOner) external onlyOwner {
        require(newOner != address(0x0), "Zero address");
        _owner = newOner;
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function totalCollections() external view returns (uint256 _total) {
        _total = _totalCollections;
    }
}
