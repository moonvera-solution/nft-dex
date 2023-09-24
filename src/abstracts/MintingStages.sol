// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

abstract contract MintingStages is AccessControlUpgradeable,ReentrancyGuardUpgradeable{
    
    uint256 public constant ROYALTY_PERCENTAGE = 10; // 10% royalty fees forced on secondary sales

    /* ACCESS ROLES */
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    /* MINTER ROLES */
    bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");

    /* OG MINT DETAILS */
    uint256 public ogMintingStart;
    uint256 public ogMintingEnd;
    uint256 public maxOGMint;

    /* WL MINT DETAILS */
    uint256 public whitelistMintingStart;
    uint256 public whitelistMintingEnd;
    uint256 public maxWLMint;

    /* REGULAR MINT DETAILS*/
    uint256 public regularMintingStart;
    uint256 public regularMintingEnd;
    uint256 public maxRegularMint;

    // DELETE and use internal update function
    address[] public whitelistMinters;
    address[] public ogMinters;

    uint256 public mintPrice;
    uint256 public ogMintPrice;
    uint256 public whitelistMintPrice;

    function setOGMintTime(
        uint256 _start,
        uint256 _end
    ) external onlyRole(ADMIN_ROLE) {
        ogMintingStart = _start;
        ogMintingEnd = _end;
    }

    function setOGMintMax(
        uint256 _maxOGMintAllowed
    ) external onlyRole(ADMIN_ROLE) {
        maxOGMint = _maxOGMintAllowed;
    }

    function setWLMintTime(
        uint256 _start,
        uint256 _end
    ) external onlyRole(ADMIN_ROLE) {
        whitelistMintingStart = _start;
        whitelistMintingEnd = _end;
    }

    function setWLMintMax(
        uint256 _maxWLMintAllowed
    ) external onlyRole(ADMIN_ROLE) {
        maxWLMint = _maxWLMintAllowed;
    }

    function setRegularMintingTime(uint256 _start, uint256 _end) external {
        regularMintingStart = _start;
        regularMintingEnd = _end;
    }

    function setRegularMintMax(
        uint256 _maxRegularMintAllowed
    ) external onlyRole(ADMIN_ROLE) {
        maxRegularMint = _maxRegularMintAllowed;
    }

    function setRegularMintPrice(uint256 _newMintPrice) public nonReentrant() {
        mintPrice = _newMintPrice;
    }

    function setWhitelistMintPrice(
        uint256 _newWhitelistMintPrice
    ) public nonReentrant {
        whitelistMintPrice = _newWhitelistMintPrice;
    }
}