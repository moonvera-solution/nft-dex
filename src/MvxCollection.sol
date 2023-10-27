// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@src/abstracts/MintingStages.sol";

//
// ███╗   ███╗ ██████╗  ██████╗ ███╗   ██╗██╗   ██╗███████╗██████╗  █████╗
// ████╗ ████║██╔═══██╗██╔═══██╗████╗  ██║██║   ██║██╔════╝██╔══██╗██╔══██╗
// ██╔████╔██║██║   ██║██║   ██║██╔██╗ ██║██║   ██║█████╗  ██████╔╝███████║
// ██║╚██╔╝██║██║   ██║██║   ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██╔══██║
// ██║ ╚═╝ ██║╚██████╔╝╚██████╔╝██║ ╚████║ ╚████╔╝ ███████╗██║  ██║██║  ██║
// ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
//
/// @title Art Collection ERC721A Upgradable
/// @author MoonveraLabs
/// @dev ERC721A template for minimal proxy clones
contract MvxCollection is MintingStages {
    event WithdrawEvent(address  sender, uint256 balance, address feeReceiver, uint256 fee);
    event OGmintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 _ogMintPrice);
    event WLmintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 wlMintPrice);
    event MintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 mintPrice);
    event OwnerMintEvent(address indexed sender, address to, uint256 amount);
    event RoyaltyFeeUpdate(address indexed sender, address receiver, uint96 royaltyFee);
    event BurnEvent(address indexed sender, uint256 tokenId);

    error TokenNotExistsError();
    error WithdrawError(uint8 isPlaformCall); // 0 = yes, 1 = no, fail admin
    error MintForOwnerError(uint8);
    error MintError(string, uint8);

    /// @notice Called by MvxFactory on clone Deployment
    /// @param platformFee uint96 fee in basis points
    /// @param _nftData maxSupply,royaltyFee,name,symbol,baseURI,baseExt
    /// @param _ogs address[]og,
    /// @param _wls address[] wl
    function initialize(
        uint256 platformFee,
        Collection calldata _nftData,
        Stages calldata _mintingStages,
        address[] calldata _ogs,
        address[] calldata _wls
    ) external {
        require(!_initalized, "Already initialized");
        address _owner = _getArgAddress(0); // immutable arguments
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
        _platformFee = platformFee;
        _platformFeeReceiver = platformFee > 0 ? _mvxFactory : address(0x0);
        revokeRole(ADMIN_ROLE, _mvxFactory);
        _initalized = true;
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
        string memory mintType = "OG";
        if (!(msg.value >= (_amount * mintingStages.ogMintPrice))) revert MintError(mintType, 0); // Not enought eth
        _internalSafeMint(
            _to, _amount, mintingStages.ogMintMaxPerUser, mintingStages.ogMintStart, mintingStages.ogMintEnd, mintType
        );
        emit OGmintEvent(msg.sender, msg.value, _to, _amount, mintingStages.ogMintPrice);
    }

    /// @notice access: WL_MINTER_ROLE
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForWhitelist(address _to, uint256 _amount) external payable onlyRole(WL_MINTER_ROLE) {
        string memory mintType = "WL";
        if (!(msg.value >= (_amount * mintingStages.whitelistMintPrice))) revert MintError(mintType, 0); // Not enought eth
        _internalSafeMint(
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
        string memory mintType = "Regular";
        if (!(msg.value >= (_amount * mintingStages.mintPrice))) revert MintError(mintType, 0); // Not enought eth
        _internalSafeMint(
            _to, _amount, mintingStages.mintMaxPerUser, mintingStages.mintStart, mintingStages.mintEnd, mintType
        );
        emit MintEvent(msg.sender, msg.value, _to, _amount, mintingStages.mintPrice);
    }


    /// @notice Checks for ether sent to this contract before calling _safeMint

    function _internalSafeMint(
        address _mintTo,
        uint256 _mintAmount,
        uint256 _maxMintAmount,
        uint256 _mintStageStartsAt,
        uint256 _mintStageEndsAt,
        string memory mintType
    ) internal {
        if (mintsPerWallet[msg.sender][mintType] + _mintAmount > _maxMintAmount) revert MintError(mintType, 1); // Exceeds mint per wallet amount
        uint256 _currentTime = block.timestamp;
        if (_currentTime < _mintStageStartsAt) revert MintError(mintType, 2); // Stage mintType has not started
        if (_currentTime > _mintStageEndsAt) revert MintError(mintType, 3);   // Stage mint already end
        
        emit Log("totalSupply()::",totalSupply());
        emit Log("_mintAmount()::",_mintAmount);
        emit Log("collectionData.maxSupply()::",collectionData.maxSupply);

        if (totalSupply() + _mintAmount > collectionData.maxSupply) revert MintError(mintType, 4); // Mint amount exceeds supply

        unchecked {
            mintsPerWallet[msg.sender][mintType] += _mintAmount;
        }
        _safeMint(_mintTo, _mintAmount);
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
    function _updateRoyaltyInfo(address _receiver, uint96 _royaltyFee) internal {
        require(_royaltyFee < 10_000, "ERC2981: fee exceed salePrice");
        require(_receiver != address(0), "ERC2981: invalid receiver");
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

    function getMintCountOf(string calldata mintType, address _user) public view returns (uint256) {
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
    
        event Log(string, uint256);
            event Log(string, address);
    /// @notice access: only ADMIN withdraw royalties
    function withdraw() external payable onlyRole(ADMIN_ROLE) {
        address _sender = msg.sender;
        if (_platformFeeReceiver != address(0x0)) {
            uint256 platformFee = address(this).balance * _platformFee / 10_000;

            (bool feeSent,) = payable(_platformFeeReceiver).call{value: platformFee}("");
            if (!feeSent) revert WithdrawError(0);

            uint256 _balance = address(this).balance;
            (bool sent,) = payable(_sender).call{value: _balance}("");
            if (!sent) revert WithdrawError(1);
            emit WithdrawEvent(_sender, _balance - _platformFee, _platformFeeReceiver, _platformFee);
        } else {
            uint256 _balance = address(this).balance;
            (bool sent,) = payable(_sender).call{value: _balance}("");
            if (!sent) revert WithdrawError(2);
            emit WithdrawEvent(_sender,_balance, _platformFeeReceiver, _platformFee);
        }
    }

    function version() external pure returns (uint8 _version) {
        _version = 2;
    }
}
