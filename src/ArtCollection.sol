// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "openzeppelin-contracts-upgradeable/contracts/utils/math/SafeMathUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/utils/StringsUpgradeable.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import "openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";
import "solady/src/utils/Clone.sol";
import "./abstracts/MintingStages.sol";


import "./ERC721A.sol";

/** 
    @title
    //this contract is made only for the Arab Collectors Club and it's done by the ACC devs.
    // Any other contract under the ACC name could be a scam.
    // /\((
 */
contract ArtCollection is
    Clone,
    ERC721A,
    IERC2981,
    MintingStages
{
    using SafeMathUpgradeable for uint256;
    using StringsUpgradeable for uint256;

    string public baseURI;
    string public baseExtension;
    uint256 public maxSupply;
    uint256 public feeOnMint;


    // Cap number of mint per user
    mapping(address => uint256) public mintsPerWallet;

    event RoyaltyFee(
        address indexed receiver,
        uint256 indexed tokenId,
        uint256 amount
    );

    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        string memory _baseExtension,
        address[] calldata _initialOGMinters,
        address[] calldata _initialWLMinters,
        uint256 _initWhitelistMintPrice,
        uint256 _initMintPrice,
        uint256 _initOGMintPrice,
        uint256 _maxSupply
    ) external initializer {
        __ERC721A_init(_name, _symbol);
        __AccessControl_init();
        _grantRole(ADMIN_ROLE, msg.sender);
        setBaseURI(_initBaseURI);

        ogMintPrice = _initOGMintPrice;
        whitelistMintPrice = _initWhitelistMintPrice;
        mintPrice = _initMintPrice;

        ogMinters = _initialOGMinters;
        whitelistMinters =  _initialWLMinters;
    
        ogMintingStart = block.timestamp;
        ogMintingEnd = ogMintingStart + 2 days;
        regularMintingStart = ogMintingEnd; // Start right after OG minting ends
        regularMintingEnd = regularMintingStart + 30 days; // For example
        whitelistMintingStart = block.timestamp;
        whitelistMintingEnd = whitelistMintingStart + 1 days; // For example, 1 day for whitelist
        maxSupply = _maxSupply;
        baseExtension = _baseExtension;

        // Clone with Immutable arg has access predefined intialized storage
        feeOnMint = _getArgUint256(0);
        // {
        //     updateMinterRoles(_initialOGMinters,0);
        //     updateMinterRoles(_initialWLMinters,1);
        // }
    }

    /// @param _minterList array of addresses
    /// @param _mintRole 0 = OG, 1 = WL
    function updateMinterRoles(
        address[] calldata _minterList,
        uint8 _mintRole
    ) public onlyRole(ADMIN_ROLE) {
        uint256 minters = _minterList.length;
        require(minters > 0, "Invalid minterList");
        for (uint256 i = 0; i < minters; ++i) {
            require(_minterList[i] != address(0x0), "Invalid Address");
            _mintRole == 0
                ? _grantRole(OG_MINTER_ROLE, _minterList[i])
                : _grantRole(WL_MINTER_ROLE, _minterList[i]);
        }
    }

    function updateWL(address[] calldata _ogMinters) external{
                uint256 minters = _ogMinters.length;
        require(minters > 0, "Invalid minterList");
        for (uint256 i = 0; i < minters; ++i) {
            require(_ogMinters[i] != address(0x0), "Invalid Address");
            ogMinters[i] = _ogMinters[i];
        }
    }


    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function mintForOwner(
        address _to,
        uint256 _mintAmount
    ) external payable nonReentrant onlyRole(ADMIN_ROLE) {
        require(totalSupply() + _mintAmount <= maxSupply, "Over mintMax error");
        _safeMint(_to, _mintAmount);
    }

    function mintForOG(
        address _to,
        uint256 _mintAmount
    ) external payable onlyRole(OG_MINTER_ROLE) nonReentrant {
        uint256 currentTime = block.timestamp;
        require(totalSupply() + _mintAmount <= maxSupply, "Over mintMax error");
        require(
            currentTime >= ogMintingStart && currentTime <= ogMintingEnd,
            "Not OG mint time"
        );
        _internalSafeMint(msg.value, _to, ogMintPrice, _mintAmount, maxOGMint);
    }

    function mintForWhitelist(
        address _to,
        uint256 _mintAmount
    ) external payable onlyRole(WL_MINTER_ROLE) nonReentrant {
        uint256 currentTime = block.timestamp;
        require(totalSupply() + _mintAmount <= maxSupply, "Over mintMax error");
        require(
            currentTime >= whitelistMintingStart &&
                currentTime <= whitelistMintingEnd,
            "Not OG mint time"
        );
        _internalSafeMint(msg.value, _to, ogMintPrice, _mintAmount, maxOGMint);
    }

    function mintForRegular(
        address _to,
        uint256 _mintAmount
    ) external payable nonReentrant {
        uint256 currentTime = block.timestamp;
        require(totalSupply() + _mintAmount <= maxSupply, "Over mintMax error");
        require(
            currentTime >= regularMintingStart &&
                currentTime <= regularMintingEnd,
            "Not Regular minTime"
        );
        _internalSafeMint(
            msg.value,
            _to,
            mintPrice,
            _mintAmount,
            maxRegularMint
        );
    }

    /// @notice Checks for ether sent before calling _safeMint
    function _internalSafeMint(
        uint256 _msgValue,
        address _mintTo,
        uint256 _mintPrice,
        uint256 _mintAmount,
        uint256 _maxMintAmount
    ) internal {
        require(
            mintsPerWallet[msg.sender] + _mintAmount <= _maxMintAmount,
            "Exceeds maxMint"
        );

        uint256 priceWithFee = _applyMintFee(_mintAmount * mintPrice);
        
        require(
            _msgValue >= priceWithFee,
            "Insufficient mint payment"
        );
        
        mintsPerWallet[msg.sender] += _mintAmount;
        _safeMint(_mintTo, _mintAmount);
    }

    /// @notice Using basis Points as measurement units.
    function _applyMintFee(uint256 _price) internal returns(uint256 _priceWithFee){
        _priceWithFee = _price * feeOnMint;
        require(_priceWithFee >= 10_000, "Invalid Price");
        // A basis point is one hundredth of 1 percentage point
        // ex: (300 * 500) / 10_000 is the same as 500 * .03
        _priceWithFee = _priceWithFee / 10_000;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    function setBaseURI(string memory _newBaseURI) public {
        baseURI = _newBaseURI;
    }

    function getMintCountOf(address _address) public view returns (uint256) {
        return mintsPerWallet[_address];
    }

    function setBaseExtension(string memory _newBaseExtension) public {
        baseExtension = _newBaseExtension;
    }


    function withdraw() public nonReentrant {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function royaltyInfo(
        uint256 _tokenId,
        uint256 _salePrice
    ) external view override returns (address receiver, uint256 royaltyAmount) {
        // The receiver will be the contract owner
        receiver = msg.sender;

        // Calculate the royalty amount using the specified ROYALTY_PERCENTAGE
        royaltyAmount = (_salePrice.mul(ROYALTY_PERCENTAGE)).div(100);
    }

    event Burned(address indexed operator, uint256 tokenId);

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not Owner");

        _burn(tokenId);

        // Emit the 'Burned' event
        emit Burned(_msgSender(), tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721A, AccessControlUpgradeable, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC2981).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
