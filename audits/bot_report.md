# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Using bools for storage incurs overhead | 1 |
| [GAS-2](#GAS-2) | For Operations that will not overflow, you could use unchecked | 230 |
| [GAS-3](#GAS-3) | Use Custom Errors | 32 |
| [GAS-4](#GAS-4) | Long revert strings | 1 |
| [GAS-5](#GAS-5) | Functions guaranteed to revert when called by normal users can be marked `payable` | 2 |
| [GAS-6](#GAS-6) | `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too) | 4 |
| [GAS-7](#GAS-7) | Using `private` rather than `public` for constants, saves gas | 4 |
| [GAS-8](#GAS-8) | Splitting require() statements that use && saves gas | 3 |
| [GAS-9](#GAS-9) | Use != 0 instead of > 0 for unsigned integer comparison | 13 |
### <a name="GAS-1"></a>[GAS-1] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (1)*:
```solidity
File: tokens/ERC721A.sol

131:     mapping(address => mapping(address => bool)) private _operatorApprovals;

```

### <a name="GAS-2"></a>[GAS-2] For Operations that will not overflow, you could use unchecked

*Instances (230)*:
```solidity
File: MvxCollection.sol

3: import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

3: import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

3: import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

3: import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

4: import "@openzeppelin/contracts/interfaces/IERC2981.sol";

4: import "@openzeppelin/contracts/interfaces/IERC2981.sol";

4: import "@openzeppelin/contracts/interfaces/IERC2981.sol";

5: import "solady/src/utils/Clone.sol";

5: import "solady/src/utils/Clone.sol";

5: import "solady/src/utils/Clone.sol";

6: import "./lib/FullMath.sol";

6: import "./lib/FullMath.sol";

7: import "./abstracts/MintingStages.sol";

7: import "./abstracts/MintingStages.sol";

8: import "./tokens/ERC721A.sol";

8: import "./tokens/ERC721A.sol";

30:     uint256 public _mintFee; // basis points

30:     uint256 public _mintFee; // basis points

31:     uint256 public _royaltyFee; // basis points

31:     uint256 public _royaltyFee; // basis points

71:         _setRoleAdmin(OG_MINTER_ROLE, ADMIN_ROLE); // set ADMIN_ROLE as admin of OG's

71:         _setRoleAdmin(OG_MINTER_ROLE, ADMIN_ROLE); // set ADMIN_ROLE as admin of OG's

72:         _setRoleAdmin(WL_MINTER_ROLE, ADMIN_ROLE); // set ADMIN_ROLE as admin of WL's

72:         _setRoleAdmin(WL_MINTER_ROLE, ADMIN_ROLE); // set ADMIN_ROLE as admin of WL's

109:         require(totalSupply() + amount <= _maxSupply, "Over mintMax error");

119:         require(totalSupply() + amount <= _maxSupply, "Over mintMax error");

130:         require(totalSupply() + amount <= _maxSupply, "Over mintMax error");

141:         require(totalSupply() + amount <= _maxSupply, "Over mintMax error");

160:         require(_mintsPerWallet[msg.sender] + mintAmount <= maxMintAmount, "Exceeds maxMint");

162:         uint256 price = mintAmount * mintPrice;

165:         require(msgValue >= (price + mintFee), "Insufficient mint payment");

167:         _mintsPerWallet[msg.sender] += mintAmount;

174:         uint256 price = _ogMintPrice * amount;

175:         quote = price + (_mintFee != 0 ? _calculateFee(price, _mintFee) : 0);

181:         uint256 price = _whitelistMintPrice * amount;

182:         quote = price + (_mintFee != 0 ? _calculateFee(price, _mintFee) : 0);

188:         uint256 price = _mintPrice * amount;

189:         quote = price + (_mintFee != 0 ? _calculateFee(price, _mintFee) : 0);

196:         _fee = FullMath.mulDiv(uint256(price), 1e6 - mintFee, 1e6);

209:         royaltyAmount = FullMath.mulDiv(uint256(salePrice), 1e6 - _royaltyFee, 1e6);

```

```solidity
File: MvxFactory.sol

4: import {LibClone} from "solady/src/utils/LibClone.sol";

4: import {LibClone} from "solady/src/utils/LibClone.sol";

4: import {LibClone} from "solady/src/utils/LibClone.sol";

5: import "./interfaces/IERC721A.sol";

5: import "./interfaces/IERC721A.sol";

6: import {Clone} from "solady/src/utils/Clone.sol";

6: import {Clone} from "solady/src/utils/Clone.sol";

6: import {Clone} from "solady/src/utils/Clone.sol";

7: import {MvxCollection} from "./MvxCollection.sol";

113:         uint256 validUntil = block.timestamp + (expire * 60 * 60 * 24);

113:         uint256 validUntil = block.timestamp + (expire * 60 * 60 * 24);

113:         uint256 validUntil = block.timestamp + (expire * 60 * 60 * 24);

113:         uint256 validUntil = block.timestamp + (expire * 60 * 60 * 24);

139:         if (msg.value - _deployFee > 0) {

140:             payable(msg.sender).transfer(msg.value - _deployFee);

142:         delete members[msg.sender]; // only one time create clone

142:         delete members[msg.sender]; // only one time create clone

146:             _mintFee, // set by MvxFactory owner

146:             _mintFee, // set by MvxFactory owner

154:             _totalCollections = _totalCollections + 1;

165:         _time = block.timestamp + (_daysFromNow * 60 * 60 * 24);

165:         _time = block.timestamp + (_daysFromNow * 60 * 60 * 24);

165:         _time = block.timestamp + (_daysFromNow * 60 * 60 * 24);

165:         _time = block.timestamp + (_daysFromNow * 60 * 60 * 24);

```

```solidity
File: Market.sol

4: import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

4: import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

4: import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

4: import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

5: import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

5: import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

5: import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

5: import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

6: import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

6: import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

6: import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

6: import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

7: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

7: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

7: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

7: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

8: import "@openzeppelin/contracts/interfaces/IERC20.sol";

8: import "@openzeppelin/contracts/interfaces/IERC20.sol";

8: import "@openzeppelin/contracts/interfaces/IERC20.sol";

13:     uint256 public _listingPrice; // cost of NFT listing

13:     uint256 public _listingPrice; // cost of NFT listing

72:             ++_itemIds;

72:             ++_itemIds;

77:         idToMarketItem[_itemIds] = _newItem; // set new item

77:         idToMarketItem[_itemIds] = _newItem; // set new item

88:         uint256 _priceWithFee = item.price + _buyFee;

```

```solidity
File: abstracts/MintingStages.sol

4: import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

4: import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

4: import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

4: import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

5: import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

5: import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

5: import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

5: import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

106:                     ++i;

106:                     ++i;

```

```solidity
File: interfaces/IDutchAuction.sol

14:         uint216 contribution; // cumulative sum of Wei bids

14:         uint216 contribution; // cumulative sum of Wei bids

15:         uint32 tokensBidded; // cumulative sum of bidded tokens

15:         uint32 tokensBidded; // cumulative sum of bidded tokens

16:         bool refundClaimed; // has user been refunded yet

16:         bool refundClaimed; // has user been refunded yet

```

```solidity
File: lib/FullMath.sol

20:         uint256 prod0; // Least significant 256 bits of the product

20:         uint256 prod0; // Least significant 256 bits of the product

21:         uint256 prod1; // Most significant 256 bits of the product

21:         uint256 prod1; // Most significant 256 bits of the product

61:         uint256 twos = uint256(-int256(denominator)) & denominator;

78:         prod0 |= prod1 * twos;

85:         uint256 inv = (3 * denominator) ^ 2;

89:         inv *= 2 - denominator * inv; // inverse mod 2**8

89:         inv *= 2 - denominator * inv; // inverse mod 2**8

89:         inv *= 2 - denominator * inv; // inverse mod 2**8

89:         inv *= 2 - denominator * inv; // inverse mod 2**8

89:         inv *= 2 - denominator * inv; // inverse mod 2**8

89:         inv *= 2 - denominator * inv; // inverse mod 2**8

89:         inv *= 2 - denominator * inv; // inverse mod 2**8

90:         inv *= 2 - denominator * inv; // inverse mod 2**16

90:         inv *= 2 - denominator * inv; // inverse mod 2**16

90:         inv *= 2 - denominator * inv; // inverse mod 2**16

90:         inv *= 2 - denominator * inv; // inverse mod 2**16

90:         inv *= 2 - denominator * inv; // inverse mod 2**16

90:         inv *= 2 - denominator * inv; // inverse mod 2**16

90:         inv *= 2 - denominator * inv; // inverse mod 2**16

91:         inv *= 2 - denominator * inv; // inverse mod 2**32

91:         inv *= 2 - denominator * inv; // inverse mod 2**32

91:         inv *= 2 - denominator * inv; // inverse mod 2**32

91:         inv *= 2 - denominator * inv; // inverse mod 2**32

91:         inv *= 2 - denominator * inv; // inverse mod 2**32

91:         inv *= 2 - denominator * inv; // inverse mod 2**32

91:         inv *= 2 - denominator * inv; // inverse mod 2**32

92:         inv *= 2 - denominator * inv; // inverse mod 2**64

92:         inv *= 2 - denominator * inv; // inverse mod 2**64

92:         inv *= 2 - denominator * inv; // inverse mod 2**64

92:         inv *= 2 - denominator * inv; // inverse mod 2**64

92:         inv *= 2 - denominator * inv; // inverse mod 2**64

92:         inv *= 2 - denominator * inv; // inverse mod 2**64

92:         inv *= 2 - denominator * inv; // inverse mod 2**64

93:         inv *= 2 - denominator * inv; // inverse mod 2**128

93:         inv *= 2 - denominator * inv; // inverse mod 2**128

93:         inv *= 2 - denominator * inv; // inverse mod 2**128

93:         inv *= 2 - denominator * inv; // inverse mod 2**128

93:         inv *= 2 - denominator * inv; // inverse mod 2**128

93:         inv *= 2 - denominator * inv; // inverse mod 2**128

93:         inv *= 2 - denominator * inv; // inverse mod 2**128

94:         inv *= 2 - denominator * inv; // inverse mod 2**256

94:         inv *= 2 - denominator * inv; // inverse mod 2**256

94:         inv *= 2 - denominator * inv; // inverse mod 2**256

94:         inv *= 2 - denominator * inv; // inverse mod 2**256

94:         inv *= 2 - denominator * inv; // inverse mod 2**256

94:         inv *= 2 - denominator * inv; // inverse mod 2**256

94:         inv *= 2 - denominator * inv; // inverse mod 2**256

102:         result = prod0 * inv;

115:             result++;

115:             result++;

```

```solidity
File: tokens/ERC721A.sol

7: import "../interfaces/IERC721A.sol";

7: import "../interfaces/IERC721A.sol";

44:     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;

56:     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;

74:     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;

77:     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;

171:             return _currentIndex - _burnCounter - _startTokenId();

171:             return _currentIndex - _burnCounter - _startTokenId();

182:             return _currentIndex - _startTokenId();

258:         return interfaceId == 0x01ffc9a7 // ERC165 interface ID for ERC165.

258:         return interfaceId == 0x01ffc9a7 // ERC165 interface ID for ERC165.

259:             || interfaceId == 0x80ac58cd // ERC165 interface ID for ERC721.

259:             || interfaceId == 0x80ac58cd // ERC165 interface ID for ERC721.

260:             || interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.

260:             || interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.

369:                         packed = _packedOwnerships[--tokenId];

369:                         packed = _packedOwnerships[--tokenId];

487:                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;

487:                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;

578:             --_packedAddressData[from]; // Updates: `balance -= 1`.

578:             --_packedAddressData[from]; // Updates: `balance -= 1`.

578:             --_packedAddressData[from]; // Updates: `balance -= 1`.

578:             --_packedAddressData[from]; // Updates: `balance -= 1`.

578:             --_packedAddressData[from]; // Updates: `balance -= 1`.

579:             ++_packedAddressData[to]; // Updates: `balance += 1`.

579:             ++_packedAddressData[to]; // Updates: `balance += 1`.

579:             ++_packedAddressData[to]; // Updates: `balance += 1`.

579:             ++_packedAddressData[to]; // Updates: `balance += 1`.

579:             ++_packedAddressData[to]; // Updates: `balance += 1`.

591:                 uint256 nextTokenId = tokenId + 1;

608:                 0, // Start of data (0, since no data).

608:                 0, // Start of data (0, since no data).

609:                 0, // End of data (0, since no data).

609:                 0, // End of data (0, since no data).

610:                 _TRANSFER_EVENT_SIGNATURE, // Signature.

610:                 _TRANSFER_EVENT_SIGNATURE, // Signature.

611:                 from, // `from`.

611:                 from, // `from`.

612:                 toMasked, // `to`.

612:                 toMasked, // `to`.

613:                 tokenId // `tokenId`.

613:                 tokenId // `tokenId`.

758:             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);

758:             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);

765:             uint256 end = startTokenId + quantity;

772:                         0, // Start of data (0, since no data).

772:                         0, // Start of data (0, since no data).

773:                         0, // End of data (0, since no data).

773:                         0, // End of data (0, since no data).

774:                         _TRANSFER_EVENT_SIGNATURE, // Signature.

774:                         _TRANSFER_EVENT_SIGNATURE, // Signature.

775:                         0, // `address(0)`.

775:                         0, // `address(0)`.

776:                         toMasked, // `to`.

776:                         toMasked, // `to`.

777:                         tokenId // `tokenId`.

777:                         tokenId // `tokenId`.

782:             } while (++tokenId != end);

782:             } while (++tokenId != end);

827:             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);

827:             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);

837:             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);

837:             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);

839:             _currentIndex = startTokenId + quantity;

863:                 uint256 index = end - quantity;

865:                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {

865:                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {

976:             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;

976:             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;

990:                 uint256 nextTokenId = tokenId + 1;

1007:             _burnCounter++;

1007:             _burnCounter++;

```

### <a name="GAS-3"></a>[GAS-3] Use Custom Errors
[Source](https://blog.soliditylang.org/2021/04/21/custom-errors/)
Instead of using error strings, to reduce deployment and runtime cost, you should use Custom Errors. This would save both deployment and runtime cost.

*Instances (32)*:
```solidity
File: MvxCollection.sol

109:         require(totalSupply() + amount <= _maxSupply, "Over mintMax error");

119:         require(totalSupply() + amount <= _maxSupply, "Over mintMax error");

120:         require(currentTime >= _ogMintStart && currentTime <= _ogMintEnd, "Not OG mint time");

130:         require(totalSupply() + amount <= _maxSupply, "Over mintMax error");

131:         require(currentTime >= _whitelistMintStart && currentTime <= _whitelistMintEnd, "Not OG mint time");

141:         require(totalSupply() + amount <= _maxSupply, "Over mintMax error");

142:         require(currentTime >= _mintStart && currentTime <= _mintEnd, "Not Regular minTime");

160:         require(_mintsPerWallet[msg.sender] + mintAmount <= maxMintAmount, "Exceeds maxMint");

165:         require(msgValue >= (price + mintFee), "Insufficient mint payment");

213:         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

235:         require(ownerOf(tokenId) == msg.sender, "Not Owner");

```

```solidity
File: MvxFactory.sol

53:         revert("Unsupported");

57:         require(msg.sender == _owner, "Only owner");

62:         require(members[msg.sender] >= block.timestamp, "Only members");

67:         require(msg.sender == _owner || members[msg.sender] >= block.timestamp, "Only Auth");

91:         require(newOner != address(0x0), "Zero address");

104:         require(_newFee > 0, "Invalid Fee");

114:         require(block.timestamp < validUntil, "Invalid valid until");

131:         require(msg.value >= _deployFee, "Missing deploy fee");

```

```solidity
File: Market.sol

96:             require(IERC20(_quoteAsset).transferFrom(_msgSender(), address(this), _priceWithFee), "buyItem::1");

```

```solidity
File: abstracts/MintingStages.sol

38:         require(hasRole(ADMIN_ROLE, msg.sender) || hasRole(OPERATOR_ROLE, msg.sender), "Only Admin or Operator");

44:         require(price > 0, "Invalid price amount");

49:         require(end > start, "End not > start");

55:         require(ogMintMax > 0, "Invalid max amount");

62:         require(whitelistMintPrice > 0, "Invalid price amount");

67:         require(end > start, "End not > start");

73:         require(whitelistMintMax > 0, "Invalid max amount");

80:         require(mintPrice > 0, "Invalid price amount");

85:         require(mintMax > 0, "Invalid mint amount");

90:         require(end > start, "End not > start");

99:         require(_mintRole == 0 || _mintRole == 1, "Error only OG=0,WL=1");

103:                 require(_minterList[i] != address(0x0), "Invalid Address");

```

### <a name="GAS-4"></a>[GAS-4] Long revert strings

*Instances (1)*:
```solidity
File: MvxCollection.sol

213:         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

```

### <a name="GAS-5"></a>[GAS-5] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (2)*:
```solidity
File: MvxCollection.sol

243:     function withdraw() external onlyRole(ADMIN_ROLE) {

```

```solidity
File: Market.sol

41:     function updateListingPrice(uint256 minListingPrice_) public onlyOwner {

```

### <a name="GAS-6"></a>[GAS-6] `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too)
*Saves 5 gas per loop*

*Instances (4)*:
```solidity
File: lib/FullMath.sol

115:             result++;

```

```solidity
File: tokens/ERC721A.sol

782:             } while (++tokenId != end);

865:                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {

1007:             _burnCounter++;

```

### <a name="GAS-7"></a>[GAS-7] Using `private` rather than `public` for constants, saves gas
If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (4)*:
```solidity
File: abstracts/MintingStages.sol

9:     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

10:     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

13:     bytes32 public constant WL_MINTER_ROLE = keccak256("WL_MINTER_ROLE");

14:     bytes32 public constant OG_MINTER_ROLE = keccak256("OG_MINTER_ROLE");

```

### <a name="GAS-8"></a>[GAS-8] Splitting require() statements that use && saves gas

*Instances (3)*:
```solidity
File: MvxCollection.sol

120:         require(currentTime >= _ogMintStart && currentTime <= _ogMintEnd, "Not OG mint time");

131:         require(currentTime >= _whitelistMintStart && currentTime <= _whitelistMintEnd, "Not OG mint time");

142:         require(currentTime >= _mintStart && currentTime <= _mintEnd, "Not Regular minTime");

```

### <a name="GAS-9"></a>[GAS-9] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (13)*:
```solidity
File: MvxCollection.sol

217:         return bytes(current_baseURI).length > 0

```

```solidity
File: MvxFactory.sol

104:         require(_newFee > 0, "Invalid Fee");

139:         if (msg.value - _deployFee > 0) {

```

```solidity
File: Market.sol

55:         if (!(marketItem.price > 0)) revert ListItemError(3);

```

```solidity
File: abstracts/MintingStages.sol

44:         require(price > 0, "Invalid price amount");

55:         require(ogMintMax > 0, "Invalid max amount");

62:         require(whitelistMintPrice > 0, "Invalid price amount");

73:         require(whitelistMintMax > 0, "Invalid max amount");

80:         require(mintPrice > 0, "Invalid price amount");

85:         require(mintMax > 0, "Invalid mint amount");

101:         if (minters > 0) {

```

```solidity
File: lib/FullMath.sol

30:             require(denominator > 0);

113:         if (mulmod(a, b, denominator) > 0) {

```


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Return values of `approve()` not checked | 2 |
| [NC-2](#NC-2) | Constants should be defined rather than using magic numbers | 1 |
### <a name="NC-1"></a>[NC-1] Return values of `approve()` not checked
Not all IERC20 implementations `revert()` when there's a failure in `approve()`. The function signature has a boolean return value and they indicate errors that way instead. By not checking the return value, operations that should have marked as failed, may potentially go through without actually approving anything

*Instances (2)*:
```solidity
File: tokens/ERC721A.sol

433:         _approve(to, tokenId, true);

890:         _approve(to, tokenId, false);

```

### <a name="NC-2"></a>[NC-2] Constants should be defined rather than using magic numbers

*Instances (1)*:
```solidity
File: tokens/ERC721A.sol

1095:                 mstore8(str, add(48, mod(temp, 10)))

```


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Empty Function Body - Consider commenting why | 5 |
| [L-2](#L-2) | Initializers could be front-run | 9 |
| [L-3](#L-3) | Unsafe ERC20 operation(s) | 6 |
### <a name="L-1"></a>[L-1] Empty Function Body - Consider commenting why

*Instances (5)*:
```solidity
File: MvxFactory.sol

50:     receive() external payable {}

```

```solidity
File: tokens/ERC721A.sol

673:     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}

691:     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}

1044:     function _extraData(address from, address to, uint24 previousExtraData) internal view virtual returns (uint24) {}

1091:             for { let temp := value } 1 {} {

```

### <a name="L-2"></a>[L-2] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (9)*:
```solidity
File: MvxCollection.sol

49:     function initialize(

55:     ) public initializer {

59:         __ERC721A_init(name, symbol);

60:         __AccessControl_init();

```

```solidity
File: MvxFactory.sol

145:         MvxCollection(_clone).initialize(

```

```solidity
File: Market.sol

36:     function initialize(uint256 _initListingPrice) public initializer {

36:     function initialize(uint256 _initListingPrice) public initializer {

37:         __Ownable_init(_msgSender());

```

```solidity
File: tokens/ERC721A.sol

137:     function __ERC721A_init(string memory name_, string memory symbol_) internal {

```

### <a name="L-3"></a>[L-3] Unsafe ERC20 operation(s)

*Instances (6)*:
```solidity
File: MvxCollection.sol

244:         payable(msg.sender).transfer(address(this).balance);

```

```solidity
File: MvxFactory.sol

98:         payable(msg.sender).transfer(address(this).balance);

140:             payable(msg.sender).transfer(msg.value - _deployFee);

```

```solidity
File: Market.sol

91:             ERC721(item.collection).transferFrom(address(this), _msgSender(), item.tokenId);

96:             require(IERC20(_quoteAsset).transferFrom(_msgSender(), address(this), _priceWithFee), "buyItem::1");

97:             ERC721(item.collection).transferFrom(address(this), _msgSender(), item.tokenId);

```


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 10 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (10)*:
```solidity
File: MvxCollection.sol

117:     function mintForOG(address to, uint256 amount) external payable nonReentrant onlyRole(OG_MINTER_ROLE) {

128:     function mintForWhitelist(address to, uint256 amount) external payable onlyRole(WL_MINTER_ROLE) nonReentrant {

243:     function withdraw() external onlyRole(ADMIN_ROLE) {

```

```solidity
File: MvxFactory.sol

74:     function updateMintFee(uint256 fee) external payable onlyOwner {

81:     function setCollectionImpl(address impl) external payable onlyOwner {

90:     function transferOwnerShip(address newOner) external payable onlyOwner {

97:     function withdraw() external payable onlyOwner {

103:     function updateDeployFee(uint256 _newFee) external payable onlyOwner {

112:     function updateMember(address user, uint256 expire) external payable onlyOwner {

```

```solidity
File: Market.sol

41:     function updateListingPrice(uint256 minListingPrice_) public onlyOwner {

```

