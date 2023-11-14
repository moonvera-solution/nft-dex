// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@src/abstracts/MintingStages.sol";

//
// ███╗   ███╗ ██████╗  ██████╗ ███╗   ██╗██╗   ██╗███████╗██████╗  █████╗
// ████╗ ████║██╔═══██╗██╔═══██╗████╗  ██║██║   ██║██╔════╝██╔══██╗██╔══█╗
// ██╔████╔██║██║   ██║██║   ██║██╔██╗ ██║██║   ██║█████╗  ██████╔╝███████║
// ██║╚██╔╝██║██║   ██║██║   ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██╔══██║
// ██║ ╚═╝ ██║╚██████╔╝╚██████╔╝██║ ╚████║ ╚████╔╝ ███████╗██║  ██║██║  ██║
// ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
//
/// @title Art Collection
/// @author MoonveraLabs
/// @dev   Minimal proxy clones for ERC721A
contract MvxCollection is MintingStages {
    event WithdrawEvent(address sender, uint256 balance, address feeReceiver, uint256 fee);
    event OGmintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 _ogMintPrice);
    event WLmintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 wlMintPrice);
    event MintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 mintPrice);
    event OwnerMintEvent(address indexed sender, address to, uint256 amount);
    event RoyaltyFeeUpdate(address indexed sender, address receiver, uint96 royaltyFee);
    event BurnEvent(address indexed sender, uint256 tokenId);
    // event Log(string, uint8);
    event Log(string,address);
    event Log(string, uint256);


    error TokenNotExistsError();
    error FixedMaxSupply();
    error WithdrawError(uint8 isPlaformCall); // 0 = yes, 1 = no, fail admin
    error MintForOwnerError(uint8);
    error MintError(bytes4, uint8);
    error RoyaltyFeeError(uint8);

    /// @notice Called by MvxFactory on clone Deployment
    /// @param _nftData maxSupply,royaltyFee,name,symbol,baseURI,baseExt
    /// @param _ogs address[]og,
    /// @param _wls address[] wl
    function initialize(
        Collection calldata _nftData,
        Stages calldata _mintingStages,
        address[] calldata _ogs,
        address[] calldata _wls
    ) external {
        require(!initalized, "Already initialized");
        address _owner = _getArgAddress(0); // immutable arguments
        publicStageWeeks = _getArgUint8(20); // immutable arguments
        platformFee = _getArgUint16(21); // 21 - 23
        updateStageFee = _getArgUint72(30);

        address _mvxFactory = msg.sender;

        __ERC721A_init(_nftData.name, _nftData.symbol);

        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
        _setRoleAdmin(OPERATOR_ROLE, ADMIN_ROLE);
        _setRoleAdmin(OG_MINTER_ROLE, ADMIN_ROLE);
        _setRoleAdmin(WL_MINTER_ROLE, ADMIN_ROLE);

        _grantRole(ADMIN_ROLE, _mvxFactory);
        _grantRole(ADMIN_ROLE, _owner);
        updateMinterRoles(_ogs, 0); // OG = 0
        updateMinterRoles(_wls, 1); // WL = 1

        _updateRoyaltyInfo(_owner, _nftData.royaltyFee);

        collectionData = _nftData;
        mintingStages = _mintingStages;
        platformFeeReceiver = _mvxFactory;
        initalized = true;
        revokeRole(ADMIN_ROLE, _mvxFactory);
    }

    error PublicStageUpdateError(uint8);
    event PublicStageUpdate();
    function updatePublicEndTime(uint8 _weeks) external payable OnlyAdminOrOperator {
        uint8 _publicStageWeeks = publicStageWeeks;
        if(_weeks > _publicStageWeeks) revert PublicStageUpdateError(1);
        uint256 _value = msg.value;
        if(_value < updateStageFee) revert PublicStageUpdateError(2);
        (bool succ,) = platformFeeReceiver.call{value: _value}("");
        if(!succ) revert PublicStageUpdateError(3);
         uint40 _newEnd;
         unchecked {
             _newEnd = uint40(mintingStages.mintEnd + (60 * 60 * 24 * (7 * _weeks))); // one week update
            publicStageWeeks = _publicStageWeeks - _weeks;
        }
        mintingStages.mintEnd = _newEnd;
        emit PublicStageUpdate();
    }

    /// @notice access: ADMIN_ROLE
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForOwner(address _to, uint256 _amount) external payable OnlyAdminOrOperator {
        if (totalSupply() + _amount > collectionData.maxSupply) revert MintForOwnerError(1);
        _safeMint(_to, _amount);
        emit OwnerMintEvent(msg.sender, _to, _amount);
    }

    /// @notice access: OG_MINTER_ROLE
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForOG(address _to, uint256 _amount) external payable onlyRole(OG_MINTER_ROLE) {
        bytes4 mintType = "OG";
        if (msg.value < (_amount * mintingStages.ogMintPrice)) revert MintError(mintType, 0); // Not enought eth
        _internalMint(
            _to, _amount, mintingStages.ogMintMaxPerUser, mintingStages.ogMintStart, mintingStages.ogMintEnd, mintType
        );
        emit OGmintEvent(msg.sender, msg.value, _to, _amount, mintingStages.ogMintPrice);
    }

    /// @notice access: WL_MINTER_ROLE
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForWhitelist(address _to, uint256 _amount) external payable onlyRole(WL_MINTER_ROLE) {
        bytes4 mintType = "WL";
        if (msg.value < (_amount * mintingStages.whitelistMintPrice)) revert MintError(mintType, 0); // Not enought eth
        _internalMint(
            _to,
            _amount,
            mintingStages.whitelistMintMaxPerUser,
            mintingStages.whitelistMintStart,
            mintingStages.whitelistMintEnd,
            mintType
        );
        emit WLmintEvent(msg.sender, msg.value, _to, _amount, mintingStages.whitelistMintPrice);
    }

    /// @notice access: any
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForRegular(address _to, uint256 _amount) external payable {
        bytes4 mintType = "RG";
        if (msg.value < (_amount * mintingStages.mintPrice)) revert MintError(mintType, 0); // Not enought eth
        _internalMint(
            _to, _amount, mintingStages.mintMaxPerUser, mintingStages.mintStart, mintingStages.mintEnd, mintType
        );
        emit MintEvent(msg.sender, msg.value, _to, _amount, mintingStages.mintPrice);
    }

    /// @notice Checks for ether sent to this contract before calling _mint
    function _internalMint(
        address _mintTo,
        uint256 _mintAmount,
        uint256 _maxMintAmount,
        uint256 _mintStageStartsAt,
        uint256 _mintStageEndsAt,
        bytes4 _mintType
    ) internal {
        emit Log("_maxMintAmount: ", _maxMintAmount);
        if (mintsPerWallet[msg.sender][_mintType] + _mintAmount > _maxMintAmount) revert MintError(_mintType, 1); // Exceeds mint per wallet amount
        uint256 _currentTime = block.timestamp;
        if (_currentTime < _mintStageStartsAt) revert MintError(_mintType, 2); // Stage mintType has not started
        if (_currentTime > _mintStageEndsAt) revert MintError(_mintType, 3); // Stage mint ended already
        if (totalSupply() + _mintAmount > collectionData.maxSupply) revert MintError(_mintType, 4); // Mint amount exceeds supply

        unchecked {
            mintsPerWallet[msg.sender][_mintType] += _mintAmount;
        }
        // Expect EOA to call this
        _mint(_mintTo, _mintAmount);
    }

    /// @notice access: only ADMIN ROLE
    function updateRoyaltyInfo(address _receiver, uint96 _royaltyFee) external onlyRole(ADMIN_ROLE) {
        _updateRoyaltyInfo(_receiver, _royaltyFee);
        emit RoyaltyFeeUpdate(msg.sender, _receiver, _royaltyFee);
    }

    /// @notice variable fee rate in basis points
    /// @param _receiver royalty fee recipient address
    /// @param _royaltyFee basis points rate 1% = 100
    /// @dev updateRoyaltyInfo(...) access onlyRole(ADMIN_ROLE)
    function _updateRoyaltyInfo(address _receiver, uint128 _royaltyFee) internal {
        if (_royaltyFee > 10_000) revert RoyaltyFeeError(1);
        if (_receiver == address(0)) revert RoyaltyFeeError(2);
        collectionData.royaltyReceiver = _receiver;
        collectionData.royaltyFee = _royaltyFee;
    }

    // @dev Inherits IERC2981
    function royaltyInfo(uint256 tokenId, uint256 _salePrice) external view override returns (address, uint256) {
        return (collectionData.royaltyReceiver, (_salePrice * collectionData.royaltyFee) / 10_000);
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function _baseURI() internal view override returns (string memory) {
        return collectionData.baseURI;
    }

    ///@dev Sequential generation of Token Id
    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        if (!_exists(_tokenId)) revert TokenNotExistsError();

        string memory currentBaseURI = baseURI();

        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId), collectionData.baseExt))
            : "";
    }

    function setBaseURI(string memory _newBaseURI) public {
        collectionData.baseURI = _newBaseURI;
    }

    function getMintCountOf(bytes4 mintType, address _user) public view returns (uint256) {
        return mintsPerWallet[_user][mintType];
    }

    function setBaseExtension(string memory _newBaseExtension) public {
        collectionData.baseExt = _newBaseExtension;
    }

    function burn(uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "Not Owner");
        _burn(_tokenId);
        emit BurnEvent(msg.sender, _tokenId);
    }

    /// @notice access: only ADMIN withdraw royalties

    function withdraw() external payable onlyRole(ADMIN_ROLE) {
        address _sender = msg.sender;
        address _platformFeeReceiver = platformFeeReceiver;
        uint96 _platformFee = platformFee;
        if (_platformFee > 0) {
            uint256 fee = address(this).balance * platformFee / 10_000;

            (bool sent,) = payable(_platformFeeReceiver).call{value: fee}("");
            if (!sent) revert WithdrawError(0);

            uint256 _balance = address(this).balance;
            (bool feeSent,) = payable(_sender).call{value: _balance}("");
            if (!feeSent) revert WithdrawError(1);
            emit WithdrawEvent(_sender, _balance - fee, _platformFeeReceiver, _platformFee);
        } else {
            uint256 _balance = address(this).balance;
            (bool sent,) = payable(_sender).call{value: _balance}("");
            if (!sent) revert WithdrawError(2);
            emit WithdrawEvent(_sender, _balance, _platformFeeReceiver, _platformFee);
        }
    }

    event NewMaxSupply(uint256);

    error UpdateMaxSupplyError(uint8);

    function updateMaxSupply(uint128 _newMax) external onlyRole(ADMIN_ROLE) {
        // new max is more than already minted amount max minted
        if (!mintingStages.isMaxSupplyUpdatable) revert UpdateMaxSupplyError(1);
        if (_newMax < collectionData.maxSupply) revert UpdateMaxSupplyError(2);
        if (_newMax < totalSupply()) revert UpdateMaxSupplyError(3);

        collectionData.maxSupply = _newMax;
        emit NewMaxSupply(collectionData.maxSupply);
    }

    function version() external pure returns (uint8 _version) {
        _version = 2;
    }
}
