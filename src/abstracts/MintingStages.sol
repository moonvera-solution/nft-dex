// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../../lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

abstract contract MintingStages is AccessControlUpgradeable, ReentrancyGuardUpgradeable {
    uint256 public constant ROYALTY_PERCENTAGE = 10; // 10% royalty fees forced on secondary sales

    /* ACCESS ROLES */
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    /* MINTER ROLES */
    bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");

    /* OG MINT DETAILS */
    uint256 public _ogMintPrice;
    uint256 public _ogMintMax;
    uint256 public _ogMintStart;
    uint256 public _ogMintEnd;

    /* WL MINT DETAILS */
    uint256 public _whitelistMintPrice;
    uint256 public _whitelistMintMax;
    uint256 public _whitelistMintStart;
    uint256 public _whitelistMintEnd;

    /* REGULAR MINT DETAILS*/
    uint256 public _mintPrice;
    uint256 public _mintMax;
    uint256 public _mintStart;
    uint256 public _mintEnd;

    event UpdateWLevent(address indexed sender, uint256 listLength);
    event UpdateOgEvent(address indexed sender, uint256 listLength);

    /// OG MINTING
    function updateOGMintPrice(uint256 price) external onlyRole(ADMIN_ROLE) {
        require(price > 0, "Invalid price amount");
        _ogMintPrice = price;
    }

    function updateOGMintTime(uint256 start, uint256 end) external onlyRole(ADMIN_ROLE) {
        require(end > start, "End not > start");
        _ogMintStart = start;
        _ogMintEnd = end;
    }

    function updateOGMintMax(uint256 ogMintMax) external onlyRole(ADMIN_ROLE) {
        require(ogMintMax > 0, "Invalid max amount");
        _ogMintMax = ogMintMax;
    }

    /// WL MINTING

    function updateWhitelistMintPrice(uint256 whitelistMintPrice) external onlyRole(ADMIN_ROLE) {
        require(whitelistMintPrice > 0, "Invalid price amount");
        _whitelistMintPrice = whitelistMintPrice;
    }

    function updateWLMintTime(uint256 start, uint256 end) external onlyRole(ADMIN_ROLE) {
        require(end > start, "End not > start");
        _whitelistMintStart = start;
        _whitelistMintEnd = end;
    }

    function updateWLMintMax(uint256 whitelistMintMax) external onlyRole(ADMIN_ROLE) {
        require(whitelistMintMax > 0, "Invalid max amount");
        _whitelistMintMax = whitelistMintMax;
    }

    // REGULAR MINTING

    function updateMintPrice(uint256 mintPrice) external onlyRole(ADMIN_ROLE) {
        require(mintPrice > 0, "Invalid price amount");
        _mintPrice = mintPrice;
    }

    function updateMintMax(uint256 mintMax) external onlyRole(ADMIN_ROLE) {
        require(mintMax > 0, "Invalid mint amount");
        _mintMax = mintMax;
    }

    function updateTime(uint256 start, uint256 end) external onlyRole(ADMIN_ROLE) {
        require(end > start, "End not > start");
        _mintStart = start;
        _mintEnd = end;
    }

    /// @param _minterList array of addresses
    /// @param _mintRole 0 = OG, 1 = WL
    /// @dev reverts if any address in the array is address zero
    function updateMinterRoles(address[] calldata _minterList, uint8 _mintRole) public onlyRole(ADMIN_ROLE) {
        require(_mintRole == 0 || _mintRole == 1, "Error only OG=0,WL=1");
        uint256 minters = _minterList.length;
        require(minters > 0, "Invalid minterList");
        for (uint256 i; i < minters;) {
            require(_minterList[i] != address(0x0), "Invalid Address");
            _mintRole == 0 ? _grantRole(OG_MINTER_ROLE, _minterList[i]) : _grantRole(WL_MINTER_ROLE, _minterList[i]);
            unchecked {
                ++i;
            }
        }
    }
}
