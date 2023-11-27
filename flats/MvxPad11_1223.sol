// SPDX-License-Identifier: MIT O
pragma solidity 0.8.20;

// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/Initializable.sol)

// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
     * constructor.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: setting the version to 255 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized != type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal onlyInitializing {
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal onlyInitializing {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/UUPSUpgradeable.sol)

// OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)

/**
 * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
 * proxy whose upgrades are fully controlled by the current implementation.
 */
interface IERC1822ProxiableUpgradeable {
    /**
     * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
     * address.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy.
     */
    function proxiableUUID() external view returns (bytes32);
}

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/ERC1967/ERC1967Upgrade.sol)

// OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeaconUpgradeable {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}

// OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC1967.sol)

/**
 * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
 *
 * _Available since v4.8.3._
 */
interface IERC1967Upgradeable {
    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Emitted when the beacon is changed.
     */
    event BeaconUpgraded(address indexed beacon);
}

// OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
 * _Available since v4.9 for `string`, `bytes`._
 */
library StorageSlotUpgradeable {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := store.slot
        }
    }
}

/**
 * @dev This abstract contract provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
 *
 * _Available since v4.1._
 */
abstract contract ERC1967UpgradeUpgradeable is Initializable, IERC1967Upgradeable {
    function __ERC1967Upgrade_init() internal onlyInitializing {
    }

    function __ERC1967Upgrade_init_unchained() internal onlyInitializing {
    }
    // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
    bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Returns the current implementation address.
     */
    function _getImplementation() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        require(AddressUpgradeable.isContract(newImplementation), "ERC1967: new implementation is not a contract");
        StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
    }

    /**
     * @dev Perform implementation upgrade
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
     * @dev Perform implementation upgrade with additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
        _upgradeTo(newImplementation);
        if (data.length > 0 || forceCall) {
            AddressUpgradeable.functionDelegateCall(newImplementation, data);
        }
    }

    /**
     * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCallUUPS(address newImplementation, bytes memory data, bool forceCall) internal {
        // Upgrades from old implementations will perform a rollback test. This test requires the new
        // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
        // this special case will break upgrade paths from old UUPS implementation to new ones.
        if (StorageSlotUpgradeable.getBooleanSlot(_ROLLBACK_SLOT).value) {
            _setImplementation(newImplementation);
        } else {
            try IERC1822ProxiableUpgradeable(newImplementation).proxiableUUID() returns (bytes32 slot) {
                require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
            } catch {
                revert("ERC1967Upgrade: new implementation is not UUPS");
            }
            _upgradeToAndCall(newImplementation, data, forceCall);
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Returns the current admin.
     */
    function _getAdmin() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        require(newAdmin != address(0), "ERC1967: new admin is the zero address");
        StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {AdminChanged} event.
     */
    function _changeAdmin(address newAdmin) internal {
        emit AdminChanged(_getAdmin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
     * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
     */
    bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    /**
     * @dev Returns the current beacon.
     */
    function _getBeacon() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the EIP1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        require(AddressUpgradeable.isContract(newBeacon), "ERC1967: new beacon is not a contract");
        require(
            AddressUpgradeable.isContract(IBeaconUpgradeable(newBeacon).implementation()),
            "ERC1967: beacon implementation is not a contract"
        );
        StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value = newBeacon;
    }

    /**
     * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
     * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
     *
     * Emits a {BeaconUpgraded} event.
     */
    function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
        _setBeacon(newBeacon);
        emit BeaconUpgraded(newBeacon);
        if (data.length > 0 || forceCall) {
            AddressUpgradeable.functionDelegateCall(IBeaconUpgradeable(newBeacon).implementation(), data);
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

/**
 * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
 * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
 *
 * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
 * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
 * `UUPSUpgradeable` with a custom implementation of upgrades.
 *
 * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
 *
 * _Available since v4.1._
 */
abstract contract UUPSUpgradeable is Initializable, IERC1822ProxiableUpgradeable, ERC1967UpgradeUpgradeable {
    function __UUPSUpgradeable_init() internal onlyInitializing {
    }

    function __UUPSUpgradeable_init_unchained() internal onlyInitializing {
    }
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
    address private immutable __self = address(this);

    /**
     * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
     * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
     * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
     * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
     * fail.
     */
    modifier onlyProxy() {
        require(address(this) != __self, "Function must be called through delegatecall");
        require(_getImplementation() == __self, "Function must be called through active proxy");
        _;
    }

    /**
     * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
     * callable on the implementing contract but not through proxies.
     */
    modifier notDelegated() {
        require(address(this) == __self, "UUPSUpgradeable: must not be called through delegatecall");
        _;
    }

    /**
     * @dev Implementation of the ERC1822 {proxiableUUID} function. This returns the storage slot used by the
     * implementation. It is used to validate the implementation's compatibility when performing an upgrade.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
     */
    function proxiableUUID() external view virtual override notDelegated returns (bytes32) {
        return _IMPLEMENTATION_SLOT;
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     *
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function upgradeTo(address newImplementation) public virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
     * encoded in `data`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     *
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, data, true);
    }

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
     * {upgradeTo} and {upgradeToAndCall}.
     *
     * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
     *
     * ```solidity
     * function _authorizeUpgrade(address) internal override onlyOwner {}
     * ```
     */
    function _authorizeUpgrade(address newImplementation) internal virtual;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    function __Pausable_init() internal onlyInitializing {
        __Pausable_init_unchained();
    }

    function __Pausable_init_unchained() internal onlyInitializing {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

struct Stages {
    uint88 ogMintPrice; 
    uint88 whitelistMintPrice;
    uint88 mintPrice;
    uint16 mintMaxPerUser; // up tp 65535
    uint16 ogMintMaxPerUser; // up tp 65535
    uint16 whitelistMintMaxPerUser; // up tp 65535
    uint40 mintStart; // up to 1099511627775
    uint40 mintEnd; // up to 1099511627775
    uint40 ogMintStart; // up to 1099511627775
    uint40 ogMintEnd; // up to 1099511627775
    uint40 whitelistMintStart; // up to 1099511627775
    uint40 whitelistMintEnd; // up to 1099511627775
    uint8 publicStageWeeks; // up to 255 number of weeks public stage end data can be updated
}

struct Collection {
    string name;
    string symbol;
    string baseURI;
    string baseExt;
    uint256 maxSupply;
    uint96 royaltyFee;
    address royaltyReceiver;
    bool isMaxSupplyUpdatable;
}

// address artist => Artist
struct Artist {
    address referral; // referral address
    uint256 referralBalance; // track referral balance
    address collection; // memeber of collection the referral is
}

// address collection => Partner
struct Partner {
    address collection; // partnering to give discounts from memebers of this collection
    address admin; // partner collection admin
    uint96 adminOwnPercent; // % variable per partnership
    uint96 referralOwnPercent; // % variable per partnership
    uint256 balance; // track partner balance (admin)
    uint96 discount; // variable per partnership
    uint256 expiration;
}

// address => Member
struct Member {
    address collection;
    uint256 deployFee;
    uint256 platformFee;
    uint96 discount;
    uint256 expiration;
}

interface IMvxCollection {
    function balanceOf(address) external returns (uint256);
    function supportsInterface(bytes4) external returns (bool);
    function initialize(
        uint256 platformFee,
        Collection calldata _nftData,
        Stages calldata _mintingStages,
        address[] calldata _ogs,
        address[] calldata _wls
    ) external;
}

library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1, "Math: mulDiv overflow");

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }
}

library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}

// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(msg.sender);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}



/// @notice Minimal proxy library.
/// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibClone.sol)
/// @author Minimal proxy by 0age (https://github.com/0age)
/// @author Clones with immutable args by wighawag, zefram.eth, Saw-mon & Natalie
/// (https://github.com/Saw-mon-and-Natalie/clones-with-immutable-args)
///
/// @dev Minimal proxy:
/// Although the sw0nt pattern saves 5 gas over the erc-1167 pattern during runtime,
/// it is not supported out-of-the-box on Etherscan. Hence, we choose to use the 0age pattern,
/// which saves 4 gas over the erc-1167 pattern during runtime, and has the smallest bytecode.
///
/// @dev Minimal proxy (PUSH0 variant):
/// This is a new minimal proxy that uses the PUSH0 opcode introduced during Shanghai.
/// It is optimized first for minimal runtime gas, then for minimal bytecode.
/// The PUSH0 clone functions are intentionally postfixed with a jarring "_PUSH0" as
/// many EVM chains may not support the PUSH0 opcode in the early months after Shanghai.
/// Please use with caution.
///
/// @dev Clones with immutable args (CWIA):
/// The implementation of CWIA here implements a `receive()` method that emits the
/// `ReceiveETH(uint256)` event. This skips the `DELEGATECALL` when there is no calldata,
/// enabling us to accept hard gas-capped `sends` & `transfers` for maximum backwards
/// composability. The minimal proxy implementation does not offer this feature.
library LibClone {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*           CLONES WITH IMMUTABLE ARGS OPERATIONS            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Deploys a minimal proxy with `implementation`,
    /// using immutable arguments encoded in `data`.
    ///
    /// Note: This implementation of CWIA differs from the original implementation.
    /// If the calldata is empty, it will emit a `ReceiveETH(uint256)` event and skip the `DELEGATECALL`.
    function clone(address implementation, bytes memory data) internal returns (address instance) {
        assembly {
            // Compute the boundaries of the data and cache the memory slots around it.
            let mBefore3 := mload(sub(data, 0x60))
            let mBefore2 := mload(sub(data, 0x40))
            let mBefore1 := mload(sub(data, 0x20))
            let dataLength := mload(data)
            let dataEnd := add(add(data, 0x20), dataLength)
            let mAfter1 := mload(dataEnd)

            // +2 bytes for telling how much data there is appended to the call.
            let extraLength := add(dataLength, 2)
            // The `creationSize` is `extraLength + 108`
            // The `runSize` is `creationSize - 10`.

            /**
             * ---------------------------------------------------------------------------------------------------+
             * CREATION (10 bytes)                                                                                |
             * ---------------------------------------------------------------------------------------------------|
             * Opcode     | Mnemonic          | Stack     | Memory                                                |
             * ---------------------------------------------------------------------------------------------------|
             * 61 runSize | PUSH2 runSize     | r         |                                                       |
             * 3d         | RETURNDATASIZE    | 0 r       |                                                       |
             * 81         | DUP2              | r 0 r     |                                                       |
             * 60 offset  | PUSH1 offset      | o r 0 r   |                                                       |
             * 3d         | RETURNDATASIZE    | 0 o r 0 r |                                                       |
             * 39         | CODECOPY          | 0 r       | [0..runSize): runtime code                            |
             * f3         | RETURN            |           | [0..runSize): runtime code                            |
             * ---------------------------------------------------------------------------------------------------|
             * RUNTIME (98 bytes + extraLength)                                                                   |
             * ---------------------------------------------------------------------------------------------------|
             * Opcode   | Mnemonic       | Stack                    | Memory                                      |
             * ---------------------------------------------------------------------------------------------------|
             *                                                                                                    |
             * ::: if no calldata, emit event & return w/o `DELEGATECALL` ::::::::::::::::::::::::::::::::::::::: |
             * 36       | CALLDATASIZE   | cds                      |                                             |
             * 60 0x2c  | PUSH1 0x2c     | 0x2c cds                 |                                             |
             * 57       | JUMPI          |                          |                                             |
             * 34       | CALLVALUE      | cv                       |                                             |
             * 3d       | RETURNDATASIZE | 0 cv                     |                                             |
             * 52       | MSTORE         |                          | [0..0x20): callvalue                        |
             * 7f sig   | PUSH32 0x9e..  | sig                      | [0..0x20): callvalue                        |
             * 59       | MSIZE          | 0x20 sig                 | [0..0x20): callvalue                        |
             * 3d       | RETURNDATASIZE | 0 0x20 sig               | [0..0x20): callvalue                        |
             * a1       | LOG1           |                          | [0..0x20): callvalue                        |
             * 00       | STOP           |                          | [0..0x20): callvalue                        |
             * 5b       | JUMPDEST       |                          |                                             |
             *                                                                                                    |
             * ::: copy calldata to memory :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: |
             * 36       | CALLDATASIZE   | cds                      |                                             |
             * 3d       | RETURNDATASIZE | 0 cds                    |                                             |
             * 3d       | RETURNDATASIZE | 0 0 cds                  |                                             |
             * 37       | CALLDATACOPY   |                          | [0..cds): calldata                          |
             *                                                                                                    |
             * ::: keep some values in stack :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: |
             * 3d       | RETURNDATASIZE | 0                        | [0..cds): calldata                          |
             * 3d       | RETURNDATASIZE | 0 0                      | [0..cds): calldata                          |
             * 3d       | RETURNDATASIZE | 0 0 0                    | [0..cds): calldata                          |
             * 3d       | RETURNDATASIZE | 0 0 0 0                  | [0..cds): calldata                          |
             * 61 extra | PUSH2 extra    | e 0 0 0 0                | [0..cds): calldata                          |
             *                                                                                                    |
             * ::: copy extra data to memory :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: |
             * 80       | DUP1           | e e 0 0 0 0              | [0..cds): calldata                          |
             * 60 0x62  | PUSH1 0x62     | 0x62 e e 0 0 0 0         | [0..cds): calldata                          |
             * 36       | CALLDATASIZE   | cds 0x62 e e 0 0 0 0     | [0..cds): calldata                          |
             * 39       | CODECOPY       | e 0 0 0 0                | [0..cds): calldata, [cds..cds+e): extraData |
             *                                                                                                    |
             * ::: delegate call to the implementation contract ::::::::::::::::::::::::::::::::::::::::::::::::: |
             * 36       | CALLDATASIZE   | cds e 0 0 0 0            | [0..cds): calldata, [cds..cds+e): extraData |
             * 01       | ADD            | cds+e 0 0 0 0            | [0..cds): calldata, [cds..cds+e): extraData |
             * 3d       | RETURNDATASIZE | 0 cds+e 0 0 0 0          | [0..cds): calldata, [cds..cds+e): extraData |
             * 73 addr  | PUSH20 addr    | addr 0 cds+e 0 0 0 0     | [0..cds): calldata, [cds..cds+e): extraData |
             * 5a       | GAS            | gas addr 0 cds+e 0 0 0 0 | [0..cds): calldata, [cds..cds+e): extraData |
             * f4       | DELEGATECALL   | success 0 0              | [0..cds): calldata, [cds..cds+e): extraData |
             *                                                                                                    |
             * ::: copy return data to memory ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: |
             * 3d       | RETURNDATASIZE | rds success 0 0          | [0..cds): calldata, [cds..cds+e): extraData |
             * 3d       | RETURNDATASIZE | rds rds success 0 0      | [0..cds): calldata, [cds..cds+e): extraData |
             * 93       | SWAP4          | 0 rds success 0 rds      | [0..cds): calldata, [cds..cds+e): extraData |
             * 80       | DUP1           | 0 0 rds success 0 rds    | [0..cds): calldata, [cds..cds+e): extraData |
             * 3e       | RETURNDATACOPY | success 0 rds            | [0..rds): returndata                        |
             *                                                                                                    |
             * 60 0x60  | PUSH1 0x60     | 0x60 success 0 rds       | [0..rds): returndata                        |
             * 57       | JUMPI          | 0 rds                    | [0..rds): returndata                        |
             *                                                                                                    |
             * ::: revert ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: |
             * fd       | REVERT         |                          | [0..rds): returndata                        |
             *                                                                                                    |
             * ::: return ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: |
             * 5b       | JUMPDEST       | 0 rds                    | [0..rds): returndata                        |
             * f3       | RETURN         |                          | [0..rds): returndata                        |
             * ---------------------------------------------------------------------------------------------------+
             */
            // Write the bytecode before the data.
            mstore(data, 0x5af43d3d93803e606057fd5bf3)
            // Write the address of the implementation.
            mstore(sub(data, 0x0d), implementation)
            // Write the rest of the bytecode.
            mstore(sub(data, 0x21), or(shl(0x48, extraLength), 0x593da1005b363d3d373d3d3d3d610000806062363936013d73))
            // `keccak256("ReceiveETH(uint256)")`
            mstore(sub(data, 0x3a), 0x9e4ac34f21c619cefc926c8bd93b54bf5a39c7ab2127a895af1cc0691d7e3dff)
            mstore(
                // Do a out-of-gas revert if `extraLength` is too big. 0xffff - 0x62 + 0x01 = 0xff9e.
                // The actual EVM limit may be smaller and may change over time.
                sub(data, add(0x59, lt(extraLength, 0xff9e))),
                or(shl(0x78, add(extraLength, 0x62)), 0xfd6100003d81600a3d39f336602c57343d527f)
            )
            mstore(dataEnd, shl(0xf0, extraLength))

            // Create the instance.
            instance := create(0, sub(data, 0x4c), add(extraLength, 0x6c))

            // If `instance` is zero, revert.
            if iszero(instance) {
                // Store the function selector of `DeploymentFailed()`.
                mstore(0x00, 0x30116425)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // Restore the overwritten memory surrounding `data`.
            mstore(dataEnd, mAfter1)
            mstore(data, dataLength)
            mstore(sub(data, 0x20), mBefore1)
            mstore(sub(data, 0x40), mBefore2)
            mstore(sub(data, 0x60), mBefore3)
        }
    }
}

//
// ███╗   ███╗██╗   ██╗██╗  ██╗ ██████╗  █████╗ ██████╗
// ████╗ ████║██║   ██║╚██╗██╔╝ ██╔══██╗██╔══██╗██╔══██╗
// ██╔████╔██║██║   ██║ ╚███╔╝  ██████╔╝███████║██║  ██║
// ██║╚██╔╝██║╚██╗ ██╔╝ ██╔██╗  ██╔═══╝ ██╔══██║██║  ██║
// ██║ ╚═╝ ██║ ╚████╔╝ ██╔╝ ██╗ ██║     ██║  ██║██████╔╝
// ╚═╝     ╚═╝  ╚═══╝  ╚═╝  ╚═╝ ╚═╝     ╚═╝  ╚═╝╚═════╝
//
/// @title MvxPad
/// @author Moonvera
/// @dev Handles Mvx Launchpad Partners
/// @dev Creates minimal proxies clones of ERC721A
contract MvxFactory is OwnableUpgradeable, UUPSUpgradeable, PausableUpgradeable {
    using Math for uint256;

    // Current IMvxCollection template
    address public collectionImpl;

    // nft collection deploy fee
    uint256 public collectionCount;

    mapping(address => Artist) public artists; // artists addr => Artist data, expires
    mapping(address => Partner) public partners; // collection addr => Collection data, expires
    mapping(address => Member) public members; // Members addr => Member data, expires

    error InvalidColletion();
    error Unathorized();
    error UpdatePartnerError();
    error AdminWithdrawError();
    error DiscountError(uint8);
    error GrantReferralError(uint8);
    error WithdrawPartnerError(uint8);
    error WithdrawReferralError(uint8);
    error UpdateMemberError(uint8);
    error CreateError(uint8);

    event WithdrawAdmin(uint256 amount);
    event CreateEvent(address indexed _sender, address _impl, address _cloneAddress);
    event MemberDiscount(address indexed _sender, uint256 _deployFee, uint256 _discountAmt);
    event ArtistDiscount(address indexed _sender, uint256 _deployFee, uint256 _discountAmt);
    event GrantReferralDiscount(address indexed _artist, address _sender, address _collection);
    event WithdrawPartner(address indexed _sender, address _collection, uint256 _balance);
    event WithdrawReferral(address indexed _sender, address _artist, uint256 _referralBalance);
    event ReferralBalanceUpdate(address indexed _referral, uint256 _amount);
    event PartnerBalanceUpdate(address indexed _partner, uint256 _balance);
    event UpdateCollectionImpl(address _newImpl);

    event UpdatePartner(Partner);
    event UpdateMember(Member);
    event FactoryBalanceUpdate(uint256);

    modifier auth() {
        if(msg.sender != owner() || members[msg.sender].expiration < block.timestamp) revert Unathorized();
        _;
    }

    function initialize() public initializer {
        __Ownable_init();
        __Pausable_init();
    }

    receive() external payable {}

    fallback() external payable {
        revert Unathorized();
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                     OWNER UPDATES
    ///0x0000000000000000000000000000000000000000000000000000000000000000

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice Grants create colletion rights to MVX member
    function updateMember(
        address _newMember,
        address _collection,
        uint256 _deployFee, // fixed amount
        uint96 _platformFee, // percent basis points
        uint96 _discount, // percent basis points
        uint256 _expirationDays
    ) external payable onlyOwner {
        if (_newMember == address(0x0)) revert UpdateMemberError(1);
        if(_platformFee > 10_000 && _discount > 10_000) revert UpdateMemberError(2);

        members[_newMember] = Member({
            collection: _collection,
            deployFee: _deployFee,
            platformFee: _platformFee,
            discount: _discount,
            expiration: block.timestamp + (_expirationDays * 60 * 60 * 24)
        });
        emit UpdateMember(members[_newMember]);
    }

    /// @notice All percentages are in bp
    function updatePartnership(
        address _collection,
        address _admin,
        uint96 _adminOwnPercent,
        uint96 _referralOwnPercent,
        uint96 _discountPercent,
        uint40 _expireDaysFromNow
    ) external onlyOwner {
        if (_admin == address(0x0)) revert UpdatePartnerError();
        partners[_collection] = Partner({
            collection: _collection,
            admin: _admin,
            adminOwnPercent: _adminOwnPercent,
            referralOwnPercent: _referralOwnPercent,
            balance: 0,
            discount: _discountPercent,
            expiration: block.timestamp + (_expireDaysFromNow * (60 * 60 * 24))
        });
        emit UpdatePartner(partners[_collection]);
    }

    /// @notice Access: only Owner
    /// @param _impl Clone's proxy implementation of IMvxCollection logic
    /// @dev payable for gas saving
    function updateCollectionImpl(address _impl) external payable onlyOwner {
        if (IMvxCollection(_impl).supportsInterface(0xc21b8f28)) {
            collectionImpl = _impl;
        } else {
            revert InvalidColletion();
        }
        emit UpdateCollectionImpl(collectionImpl);
    }

    function deletePartnership(address _collection) external onlyOwner {
        delete partners[_collection];
    }

    function deleteArtist(address _artist) external onlyOwner {
        delete artists[_artist];
    }

    function deleteMember(address _member) external onlyOwner {
        delete members[_member];
    }

    function withdraw() external payable onlyOwner {
        uint256 _balance = address(this).balance;
        (bool sent,) = payable(msg.sender).call{value: _balance}("");
        if (!sent) revert AdminWithdrawError();
        emit WithdrawAdmin(_balance);
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                         WITHDRAWS
    ///0x0000000000000000000000000000000000000000000000000000000000000000

    function withdrawPartner(address _collection) external whenNotPaused {
        address _sender = payable(msg.sender);
        Partner memory _partner = partners[_collection];
        uint256 _balance = _partner.balance;
        if (_partner.admin != _sender) revert WithdrawPartnerError(1);
        if (!(_balance > 0)) revert WithdrawPartnerError(2);
        _partner.balance = 0;
        (bool sent,) = _sender.call{value: _balance}("");
        if (!sent) revert WithdrawPartnerError(3);
        emit WithdrawPartner(_sender, _collection, _balance);
    }

    function withdrawReferral(address artist_) external whenNotPaused {
        address _sender = msg.sender;
        Artist memory _artist = artists[artist_];

        if (_artist.referral != _sender) revert WithdrawReferralError(1);
        uint256 _referralBalance = _artist.referralBalance;
        if (_referralBalance == 0) revert WithdrawReferralError(2);
        delete artists[artist_];
        (bool sent,) = _sender.call{value: _referralBalance}("");
        if (!sent) revert WithdrawReferralError(3);
        emit WithdrawReferral(_sender, artist_, _referralBalance);
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                      GRANT REFERRALS
    ///0x0000000000000000000000000000000000000000000000000000000000000000

    /// @notice Access: owner & members of any collection created with this launchpad contract
    /// @dev Only valid if there is a partnership/discount between the collection admin and Mvx
    /// @dev 10 days max to use referral discount
    function grantReferral(address _extCollection, address _artist) external whenNotPaused {
        address _referral = msg.sender;

        Partner memory partner = partners[_extCollection];
        // Check if the collection has a current partnership with mvx.
        bool hasDiscount = partner.discount > 0 && partner.expiration > block.timestamp;
        if (!hasDiscount) revert GrantReferralError(1);

        // Check if msg.sender is part of the Collection.
        bool isCollectionMember = IMvxCollection(_extCollection).balanceOf(_referral) > 0;
        if (!isCollectionMember) revert GrantReferralError(2);

        // If referral is artist - No need to use referral system, talk to mvx admin.
        if (_referral == _artist) revert GrantReferralError(3);

        // Check if artist has a referral already - only one referral allowed per artist per collection
        if (artists[_artist].referral != address(0x0)) revert GrantReferralError(4);

        artists[_artist] = Artist(_referral, 0, _extCollection); // 20% referrals
        emit GrantReferralDiscount(_artist, _referral, _extCollection);
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                      CREATE COLLECTION
    ///0x0000000000000000000000000000000000000000000000000000000000000000
    event Log(string, address);
    event Log(string, uint256);
    event Log(string);

    function createCollection(
        Collection calldata _nftsData,
        Stages calldata _mintingStages,
        address[] calldata _ogs,
        address[] calldata _wls
    ) external payable auth whenNotPaused returns (address _clone) {
        address _sender = msg.sender;
        uint256 _msgValue = msg.value;

        Artist memory _artist = artists[_sender];
        Member memory member = members[_sender];
        uint256 _deployFee = member.deployFee;

        // Apply member discount over Artist discount
        if (member.discount > 0) {
            uint256 _discountAmt = _percent(_deployFee, member.discount);
            if (_msgValue < _deployFee - _discountAmt) revert CreateError(1);
            emit MemberDiscount(_sender, _deployFee, _discountAmt);

            // Apply artist discount from Partnerhip agreement if has no Member discount
        } else if (_artist.referral != address(0)) {
            Partner memory _partner = partners[_artist.collection];
            uint256 _discountAmount = _percent(_deployFee, _partner.discount);
            if (_msgValue < _deployFee - _discountAmount) revert CreateError(2);
            _applyArtistDiscount(_artist, _partner, _sender, _msgValue, _discountAmount);
            emit ArtistDiscount(_sender, _deployFee, _discountAmount);

            // No discount
        } else {
            if (_msgValue < _deployFee) revert CreateError(3);
        }

        // encode seder to clone immutable arg
        bytes memory data = abi.encodePacked(_sender);

        // Lib clone minimal proxy with immutable args
        _clone = LibClone.clone(address(collectionImpl), data);
        if (_clone == address(0)) revert CreateError(4);

        // Member single time deploy - expiration is access control
        member.expiration = 0;
        member.collection = _clone;
        members[_sender] = member;

        unchecked {
            collectionCount = collectionCount + 1;
        }

        // Init Art collection minimal proxy clone
        IMvxCollection(_clone).initialize(
            member.platformFee, // set by MvxFactory owner
            _nftsData,
            _mintingStages,
            _ogs,
            _wls
        );

        emit CreateEvent(_sender, collectionImpl, _clone);
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                         UI VIEWS
    ///0x0000000000000000000000000000000000000000000000000000000000000000
    function getTime() public view returns (uint256 _time) {
        _time = block.timestamp;
    }

    /// @param _daysFromNow current timestamp plus days
    function getTime(uint256 _daysFromNow) public view returns (uint256 _time) {
        _time = block.timestamp + (_daysFromNow * 60 * 60 * 24);
    }

    function getPartnerBalance(address _collection) public view returns (uint256 _balance) {
        _balance = partners[_collection].balance;
    }

    function getReferralBalance(address _artist) public view returns (uint256 _balance) {
        _balance = artists[_artist].referralBalance;
    }

    ///0x0000000000000000000000000000000000000000000000000000000000000000
    ///                      INTERNAL LOGIC
    ///0x0000000000000000000000000000000000000000000000000000000000000000
    function _applyArtistDiscount(
        Artist memory _artist,
        Partner memory _partner,
        address _sender,
        uint256 _deployFee,
        uint256 _discountAmount
    ) internal {
        uint256 _deployFeeAfterDiscounts = _deployFee - _discountAmount; // - 20% == msg.value
        uint256 remain = _deployFeeAfterDiscounts;

        // Update Referral balance
        uint256 _referralAmount = _percent(_deployFeeAfterDiscounts, _partner.referralOwnPercent);
        remain = remain - _referralAmount;

        _artist.referralBalance = _referralAmount;
        artists[_sender] = _artist;
        emit ReferralBalanceUpdate(_artist.referral, _referralAmount);

        // Update Partner balance
        uint256 _partnerAmount = _percent(_deployFeeAfterDiscounts, _partner.adminOwnPercent);
        remain = remain - _partnerAmount;
        _partner.balance = _partner.balance + _partnerAmount;
        partners[_artist.collection] = _partner;
        emit PartnerBalanceUpdate(_partner.admin, _partnerAmount);

        if (remain + _partnerAmount + _referralAmount < _deployFeeAfterDiscounts) revert DiscountError(2);
        emit FactoryBalanceUpdate(remain);
    }

    function _percent(uint256 a, uint96 b) internal pure returns (uint256) {
        return a.mulDiv(b, 10_000);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function upgradeTo(address _newImplementation) public override onlyOwner {
        super.upgradeTo(_newImplementation);
    }
}

