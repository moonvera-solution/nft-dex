// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
/// @notice This contract is made only for the Arab Collectors Club ACC
/// @author MoonveraLabs
contract MvxCollection is MintingStages {

    // Cap number of mint per user msg.sender => 0 => amountMinted
    mapping(address => uint256) public mintsPerWallet;
    mapping(address => uint256) public mintsPerWallet;


    event WithdrawEvent(address indexed, uint256, address, uint256);
    event OGmintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 _ogMintPrice);
    event WLmintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 wlMintPrice);
    event MintEvent(address indexed sender, uint256 value, address to, uint256 amount, uint256 mintPrice);
    event OwnerMintEvent(address indexed sender, address to, uint256 amount);
    event RoyaltyFeeUpdate(address indexed sender, address receiver, uint96 royaltyFee);
    event BurnEvent(address indexed sender, uint256 tokenId);

    /// @notice Called by MvxFactory on clone Deployment
    /// @param platformFee uint96 fee in basis points
    /// @param _nftData maxSupply,royaltyFee,name,symbol,baseURI,baseExt
    /// @param _ogs address[]og,
    /// @param _wls address[] wl
    function initialize(bytes caldata)
        uint96 platformFee,
        Collection calldata _nftData,
        Stages calldata _mintingStages,
        address[] calldata _ogs,
        address[] calldata _wls
    ) public initializer {
        address _owner = _getArgAddress(0); // immutable arguments
        address _mvxFactory = msg.sender;

        __ERC721A_init(_nftData.name, _nftData.symbol);
        __AccessControl_init();
        __ReentrancyGuard_init();

        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
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
        _platformFeeReceiver = _mvxFactory;
        revokeRole(ADMIN_ROLE, _mvxFactory);
    }

    /// @notice access: ADMIN_ROLE
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForOwner(address _to, uint256 _amount) external payable nonReentrant OnlyAdminOrOperator {
        require(totalSupply() + _amount <= collectionData.maxSupply, "Over mintMax error");
        _safeMint(_to, _amount);
        emit OwnerMintEvent(msg.sender, _to, _amount);
    }

    /// @notice access: OG_MINTER_ROLE
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForOG(address _to, uint256 _amount) external payable nonReentrant onlyRole(OG_MINTER_ROLE) {
        uint256 _currentTime = block.timestamp;
        require(
            _currentTime <= mintingStages.ogMintEnd && _currentTime >= mintingStages.ogMintStart, "Not OG mint time"
        );
        require(totalSupply() + _amount <= collectionData.maxSupply, "Over mintMax error");
        _internalSafeMint(msg.value, _to, mintingStages.ogMintPrice, _amount, mintingStages.ogMintMaxPerUser);
        emit OGmintEvent(msg.sender, msg.value, _to, _amount, mintingStages.ogMintPrice);
    }

    /// @notice access: WL_MINTER_ROLE
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForWhitelist(address _to, uint256 _amount) external payable onlyRole(WL_MINTER_ROLE) nonReentrant {
        uint256 _currentTime = block.timestamp;
        require(
            _currentTime <= mintingStages.whitelistMintEnd && _currentTime >= mintingStages.whitelistMintStart,
            "Not OG mint time"
        );
        require(totalSupply() + _amount <= collectionData.maxSupply, "Over mintMax error");
        _internalSafeMint(
            msg.value, _to, mintingStages.whitelistMintPrice, _amount, mintingStages.whitelistMintMaxPerUser
        );
        emit WLmintEvent(msg.sender, msg.value, _to, _amount, mintingStages.whitelistMintPrice);
    }

    /// @notice access: any
    /// @param _to address to mint to
    /// @param _amount amount to mint (batch minting)
    function mintForRegular(address _to, uint256 _amount) external payable nonReentrant {
        uint256 _currentTime = block.timestamp;
        require(_currentTime <= mintingStages.mintEnd && _currentTime >= mintingStages.mintStart, "Not Regular minTime");
       
        require(totalSupply() + _amount <= collectionData.maxSupply, "Over mintMax error");
        
        _internalSafeMint(msg.value, _to, mintingStages.mintPrice, _amount, mintingStages.mintMaxPerUser);
        emit MintEvent(msg.sender, msg.value, _to, _amount, mintingStages.mintPrice);
    }

    /// @notice Checks for ether sent to this contract before calling _safeMint
    function _internalSafeMint(
        uint256 _msgValue,
        address _mintTo,
        uint256 _mintPrice,
        uint256 _mintAmount,
        uint256 _maxMintAmount,
        
    ) internal {
        require(mintsPerWallet[msg.sender] + _mintAmount <= _maxMintAmount, "Exceeds maxMint");
        require(_msgValue >= (_mintAmount * _mintPrice), "Insufficient mint payment");
        unchecked {
            mintsPerWallet[msg.sender] += _mintAmount;
        }
        _safeMint(_mintTo, _mintAmount);
    }

    /// @notice access: only ADMIN ROLE
    function updateRoyaltyInfo(address _receiver, uint96 _royaltyFee) external onlyRole(ADMIN_ROLE) {
        _updateRoyaltyInfo(_receiver, _royaltyFee);
        emit RoyaltyFeeUpdate(msg.sender, _receiver, _royaltyFee);
    }

    function _updateRoyaltyInfo(address _receiver, uint96 _royaltyFee) internal {
        require(_royaltyFee <= _feeDenominator(), "ERC2981: fee exceed salePrice");
        require(_receiver != address(0), "ERC2981: invalid receiver");
        collectionData.royaltyReceiver = _receiver;
        collectionData.royaltyFee = _royaltyFee;
    }

    // @dev Inherits IERC2981
    function royaltyInfo(uint256 tokenId, uint256 _salePrice) external view override returns (address, uint256) {
        return (collectionData.royaltyReceiver, (_salePrice * collectionData.royaltyFee) / _feeDenominator());
    }

    /// @notice The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
    /// fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
    /// override.
    function _feeDenominator() internal pure virtual returns (uint96) {
        return 10_000;
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function _baseURI() internal view override returns (string memory) {
        return collectionData.baseURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory currentBaseURI = baseURI();

        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId), collectionData.baseExt))
            : "";
    }

    function setBaseURI(string memory _newBaseURI) public {
        collectionData.baseURI = _newBaseURI;
    }

    function getMintCountOf(address _user) public view returns (uint256) {
        return mintsPerWallet[_user];
    }

    function setBaseExtension(string memory _newBaseExtension) public {
        collectionData.baseExt = _newBaseExtension;
    }

    function burn(uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "Not Owner");
        _burn(_tokenId);
        emit BurnEvent(_msgSender(), _tokenId);
    }

    /// @notice only ADMIN access withdraw royalties
    function withdraw() external payable nonReentrant onlyRole(ADMIN_ROLE) {
        uint256 _balance = address(this).balance;
        uint256 platformFee = _balance * _platformFee / _feeDenominator();
        uint256 _balanceAfterFee = _balance - platformFee;

        (bool feeSent,) = payable(_platformFeeReceiver).call{value: platformFee}("");
        require(feeSent, "Withdraw _platformFee fail");

        (bool sent,) = payable(msg.sender).call{value: _balanceAfterFee}("");
        require(sent, "Withdraw _balanceAfterFee fail");
        emit WithdrawEvent(msg.sender, _balanceAfterFee, _platformFeeReceiver, _platformFee);
    }

    function version() external pure returns (uint8 _version) {
        _version = 2;
    }
}
