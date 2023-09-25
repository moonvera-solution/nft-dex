// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;
import {LibClone} from "solady/src/utils/LibClone.sol";
import {Clone} from "solady/src/utils/Clone.sol";
import {ArtCollection} from "./ArtCollection.sol";

/**
    @title Factory contract to create erc721's clones with immutable arguments
    @author MoonveraLabs
 */
contract Factory {
    // Keep track of collections/clones per user
    mapping(address => address) public collections;

    // Factory  address(user) => validUntil;
    mapping(address => uint256) public members;

    // ownable by deployer
    address public _owner;

    // default art collection deploy fee
    uint256 private _deployFee = .5 ether;

    // Fee to charge for any mint
    uint256 private _feeOnMint;

    error CreateCloneError();
    event CreateCloneEvent(
        address indexed sender,
        address impl,
        address cloneAddress
    );

    event InitOwnerEvent(address sender);
    constructor(uint256 freeOnMint) {
        _owner = payable(msg.sender);
        _feeOnMint = freeOnMint;
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
        require(
            msg.sender == _owner || members[msg.sender] >= block.timestamp,
            "Only Auth"
        );
        _;
    }

    function updateDeployFee(uint256 _newFee) external onlyOwner {
        require(_newFee > 0, "Invalid Fee");
        _deployFee = _newFee;
    }

    function updateMember(address user, uint256 validUntil) external onlyOwner {
        emit InitOwnerEvent(msg.sender);
        require(block.timestamp < validUntil, "Invalid valid until");
        members[user] = validUntil;
    }

    function updateFeeOnMint(uint256 _newFeeOnMint) external onlyOwner {
        _feeOnMint = _newFeeOnMint;
    }

    function createCollection(
        address _impl
    ) external payable auth returns (address _clone) {
        require(msg.value >= _deployFee, "Missing deploy fee");

        _clone = LibClone.clone(address(_impl), abi.encode(_feeOnMint));
        if (_clone == address(0x0)) revert CreateCloneError();
        collections[msg.sender] = _clone;
        uint256 _dust = msg.value - _deployFee;
        if (_dust > 0) {
            payable(msg.sender).transfer(_dust);
        }
        delete members[msg.sender];
        emit CreateCloneEvent(msg.sender, _impl, _clone);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
/**
ArtCollectionTest:test_initialAdminRole() (gas:  1268925)
                                           diff: 31740
 */