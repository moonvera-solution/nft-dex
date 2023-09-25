// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "openzeppelin-contracts-upgradeable/contracts/utils/StringsUpgradeable.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import "openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";
import "solady/src/utils/Clone.sol";
import "./abstracts/MintingStages.sol";
import "./tokens/ERC721A.sol";

/// @title Art Collection
/// @author MoonveraLabs
/// @dev This contract is made only for the Arab Collectors Club
contract ArtCollection is Clone, ERC721A, IERC2981, MintingStages {
    using StringsUpgradeable for uint256;

    string public baseURI;
    string public _baseExtension;
    uint256 public _maxSupply;
    uint256 public _mintFee; // basis points divided by 100%
    uint256 public _royaltyFee; // basis points divided by 100%

    // Cap number of mint per user
    mapping(address => uint256) public _mintsPerWallet;

    event OGmintEvent(address indexed sender, uint256 tokenId);
    event WLmintEvent(address indexed sender, uint256 tokenId);
    event MintEvent(address indexed sender, uint256 tokenId);
    event BurnEvent(address indexed sender, uint256 tokenId);


    /// @notice Init Collection ERC721A
    /// @notice clone with Immutable arg has access predefined intialized storage
    /// @dev feeOnMint = _getArgUint256(0); Unique Immutable argument
    /// @dev mintStageDetails array[] memory layout. index: 0-3:Og,4-7:WL,8-11:Reg
    function initialize(
        string memory name,
        string memory symbol,
        string memory initBaseURI,
        string memory baseExtension,
        uint256 maxSupply,
        uint256 royaltyFee,
        address[] calldata initialOGMinters,
        address[] calldata initialWLMinters,
        uint256[] calldata mintStageDetails
    ) external initializer {
        __ERC721A_init(name, symbol);
        __AccessControl_init();
        _setRoleAdmin(OG_MINTER_ROLE,ADMIN_ROLE); // set ADMIN_ROLE as admin of OG's
        _setRoleAdmin(WL_MINTER_ROLE,ADMIN_ROLE); // set ADMIN_ROLE as admin of WL's
        _grantRole(ADMIN_ROLE, msg.sender);

        setBaseURI(initBaseURI);
        _baseExtension = _baseExtension;
        _maxSupply = maxSupply;
        _royaltyFee = royaltyFee;

        // OG minting stage details
        _ogMintPrice = mintStageDetails[0];
        _ogMintMax = mintStageDetails[1];
        _ogMintStart = mintStageDetails[2];
        _ogMintEnd = mintStageDetails[3];

        // WL minting stage details
        _whitelistMintPrice = mintStageDetails[4];
        _whitelistMintMax = mintStageDetails[5];
        _whitelistMintStart = mintStageDetails[6];
        _whitelistMintEnd = mintStageDetails[7];

        // Regular minting stage details
        _mintPrice = mintStageDetails[8];
        _mintMax = mintStageDetails[9];
        _mintStart = mintStageDetails[10];
        _mintEnd = mintStageDetails[11];

        // init minting roles OG=0, WL=1
        updateMinterRoles(initialOGMinters,0);
        updateMinterRoles(initialWLMinters,1);
        // Clone with Immutable arg has access predefined intialized storage
        _mintFee = _getArgUint256(0);
    }

    function _baseURI()
        internal
        view
        override
        returns (string memory baseURI)
    {
        baseURI = _baseURI();
    }

    function mintForOwner(
        address to,
        uint256 mintAmount
    ) external payable nonReentrant onlyRole(ADMIN_ROLE) {
        require(totalSupply() + mintAmount <= _maxSupply, "Over mintMax error");
        _safeMint(to, mintAmount);
    }

    function mintForOG(
        address to,
        uint256 mintAmount
    ) external payable nonReentrant onlyRole(OG_MINTER_ROLE) {
        uint256 currentTime = block.timestamp;
        require(totalSupply() + mintAmount <= _maxSupply, "Over mintMax error");
        require(
            currentTime >= _ogMintStart && currentTime <= _ogMintEnd,
            "Not OG mint time"
        );
        _internalSafeMint(msg.value, to, _ogMintPrice, mintAmount, _ogMintMax);
    }

    function mintForWhitelist(
        address to,
        uint256 mintAmount
    ) external payable onlyRole(WL_MINTER_ROLE) nonReentrant {
        uint256 currentTime = block.timestamp;
        require(totalSupply() + mintAmount <= _maxSupply, "Over mintMax error");
        require(
            currentTime >= _whitelistMintStart &&
                currentTime <= _whitelistMintEnd,
            "Not OG mint time"
        );
        _internalSafeMint(
            msg.value,
            to,
            _whitelistMintPrice,
            mintAmount,
            _ogMintMax
        );
    }

    function mintForRegular(
        address to,
        uint256 mintAmount
    ) external payable nonReentrant {
        uint256 currentTime = block.timestamp;
        require(totalSupply() + mintAmount <= _maxSupply, "Over mintMax error");
        require(
            currentTime >= _mintStart && currentTime <= _mintEnd,
            "Not Regular minTime"
        );
        _internalSafeMint(msg.value, to, _mintPrice, mintAmount, _mintMax);
    }

    /// @notice Checks for ether sent to this contract before calling _safeMint
    function _internalSafeMint(
        uint256 msgValue,
        address mintTo,
        uint256 mintPrice,
        uint256 mintAmount,
        uint256 maxMintAmount
    ) internal {
        require(
            _mintsPerWallet[msg.sender] + mintAmount <= maxMintAmount,
            "Exceeds maxMint"
        );

        uint256 price = mintAmount * mintPrice;
        uint256 mintFee = _calculateFee(price, _mintFee);

        require(
            msgValue >= (price + mintFee),
            "Insufficient mint payment"
        );

        _mintsPerWallet[msg.sender] += mintAmount;
        _safeMint(mintTo, mintAmount);
    }

    /// @notice Using basis Points as measurement units.
    /// @dev feeOnMint is on basis points
    function _calculateFee(
        uint256 price,
        uint256 feeOnMint
    ) internal pure returns (uint256 mintFee) {
        mintFee = price * feeOnMint;
        require(mintFee >= 10_000, "Invalid Price");
        // A basis point is one hundredth of 1 percentage point
        // ex: (300 * 500) / 10_000 is the same as 500 * .03
        mintFee = mintFee / 10_000;
    }

    /// @notice Using basis Points as measurement units.
    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) external view override returns (address receiver, uint256 royaltyAmount) {
        // The receiver will be the contract owner
        receiver = msg.sender;

        // Calculate the royalty amount using the specified ROYALTY_PERCENTAGE in basis points
        royaltyAmount = (salePrice * _royaltyFee) / 10_000;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory current_baseURI = _baseURI();
        return
            bytes(current_baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        current_baseURI,
                        tokenId.toString(),
                        _baseExtension
                    )
                )
                : "";
    }

    function setBaseURI(string memory newBaseURI) public {
        baseURI = newBaseURI;
    }

    function getMintCountOf(address user) public view returns (uint256) {
        return _mintsPerWallet[user];
    }

    function setBaseExtension(string memory newBaseExtension) public {
        _baseExtension = newBaseExtension;
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not Owner");

        _burn(tokenId);

        emit BurnEvent(_msgSender(), tokenId);
    }

    /// @notice only ADMIN access withdraw royalties
    function withdraw() external onlyRole(ADMIN_ROLE) {
        payable(msg.sender).transfer(address(this).balance);
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
