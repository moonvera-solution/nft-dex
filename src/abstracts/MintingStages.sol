// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC2981, IERC165} from "@openzeppelin-contracts/interfaces/IERC2981.sol";

import "@src/libs/AccessControl.sol";
import {Stages, Collection} from "@src/libs/MvxStruct.sol";
import {Clone} from "@solady/utils/Clone.sol";
import {ERC721A, IERC721A} from "@src/tokens/ERC721A.sol";

abstract contract MintingStages is Clone, AccessControl, ERC721A, IERC2981 {
    /// sender => mintType => counter amount
    mapping(address => mapping(bytes4 => uint256)) public mintsPerWallet;

    /* ACCESS ROLES */
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    /* MINTER ROLES */
    bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");

    Stages public mintingStages;
    Collection public collectionData;
    address public platformFeeReceiver;
    uint72 public updateStageFee;
    
    uint16 public platformFee;
    uint8 public publicStageWeeks;
    bool public initalized = false;

    event UpdateWLevent(address indexed sender, uint256 listLength);
    event UpdateOgEvent(address indexed sender, uint256 listLength);

    modifier OnlyAdminOrOperator() {
        require(hasRole(ADMIN_ROLE, msg.sender) || hasRole(OPERATOR_ROLE, msg.sender), "Only Admin or Operator");
        _;
    }

    /// OG MINTING
    function updateOGMintPrice(uint72 _price) external OnlyAdminOrOperator {
        require(_price > 0, "Invalid price amount");
        mintingStages.ogMintPrice = _price;
    }

    function updateOGMintMax(uint16 _ogMintMax) external OnlyAdminOrOperator {
        require(_ogMintMax > 0, "Invalid max amount");
        mintingStages.ogMintMaxPerUser = _ogMintMax;
    }

    /// WL MINTING
    function updateWhitelistMintPrice(uint72 _whitelistMintPrice) external OnlyAdminOrOperator {
        require(_whitelistMintPrice > 0, "Invalid price amount");
        mintingStages.whitelistMintPrice = _whitelistMintPrice;
    }

    function updateWLMintMax(uint16 _whitelistMintMax) external OnlyAdminOrOperator {
        require(_whitelistMintMax > 0, "Invalid max amount");
        mintingStages.whitelistMintMaxPerUser = _whitelistMintMax;
    }

    // REGULAR MINTING
    function updateMintPrice(uint72 _mintPrice) external OnlyAdminOrOperator {
        require(_mintPrice > 0, "Invalid price amount");
        mintingStages.mintPrice = _mintPrice;
    }

    function updateMintMax(uint16 _mintMax) external OnlyAdminOrOperator {
        require(_mintMax > 0, "Invalid mint amount");
        mintingStages.mintMaxPerUser = _mintMax;
    }

    /// @param _minterList address array of OG's or WL's
    /// @param _mintRole 0 = OG, 1 = WL
    /// @dev reverts if any address in the array is address zero
    function updateMinterRoles(address[] calldata _minterList, uint8 _mintRole) public OnlyAdminOrOperator {
        require(_mintRole == 0 || _mintRole == 1, "Error only OG=0,WL=1");
        uint256 minters = _minterList.length;
        if (minters > 0) {
            for (uint256 i; i < minters;) {
                require(_minterList[i] != address(0x0), "Invalid Address");
                _mintRole == 0 ? _grantRole(OG_MINTER_ROLE, _minterList[i]) : _grantRole(WL_MINTER_ROLE, _minterList[i]);
                unchecked {
                    ++i;
                }
            }
        }
    }

    function supportsInterface(bytes4 _interfaceId) public view override(ERC721A, IERC165) returns (bool) {
        return _interfaceId == type(IERC721A).interfaceId || _interfaceId == type(IERC2981).interfaceId
            || super.supportsInterface(_interfaceId);
    }
}
