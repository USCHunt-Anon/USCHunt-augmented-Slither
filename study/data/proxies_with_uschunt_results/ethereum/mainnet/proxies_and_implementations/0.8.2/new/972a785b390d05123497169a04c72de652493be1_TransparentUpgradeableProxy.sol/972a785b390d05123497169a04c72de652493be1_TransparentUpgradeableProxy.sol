/**
 *Submitted for verification at Etherscan.io on 2021-08-11
*/

// File: .deps/npm/@openzeppelin/[email protected]/utils/StorageSlot.sol

pragma solidity ^0.8.0;

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```
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
 * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
 */
library StorageSlot {
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

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        assembly {
            r.slot := slot
        }
    }
}

// File: .deps/npm/@openzeppelin/[email protected]/utils/Address.sol

pragma solidity ^0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
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
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
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
        return functionCall(target, data, "Address: low-level call failed");
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
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
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
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
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
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
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: .deps/npm/@openzeppelin/[email protected]/proxy/beacon/IBeacon.sol

pragma solidity ^0.8.0;

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeacon {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}

// File: .deps/npm/@openzeppelin/[email protected]/proxy/ERC1967/ERC1967Upgrade.sol

pragma solidity ^0.8.2;




/**
 * @dev This abstract contract provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
 *
 * _Available since v4.1._
 *
 * @custom:oz-upgrades-unsafe-allow delegatecall
 */
abstract contract ERC1967Upgrade {
    // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
    bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Returns the current implementation address.
     */
    function _getImplementation() internal view returns (address) {
        return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
        StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
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
    function _upgradeToAndCall(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        _upgradeTo(newImplementation);
        if (data.length > 0 || forceCall) {
            Address.functionDelegateCall(newImplementation, data);
        }
    }

    /**
     * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCallSecure(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        address oldImplementation = _getImplementation();

        // Initial upgrade and setup call
        _setImplementation(newImplementation);
        if (data.length > 0 || forceCall) {
            Address.functionDelegateCall(newImplementation, data);
        }

        // Perform rollback test if not already in progress
        StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
        if (!rollbackTesting.value) {
            // Trigger rollback using upgradeTo from the new implementation
            rollbackTesting.value = true;
            Address.functionDelegateCall(
                newImplementation,
                abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
            );
            rollbackTesting.value = false;
            // Check rollback was effective
            require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
            // Finally reset to the new implementation and log the upgrade
            _upgradeTo(newImplementation);
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Returns the current admin.
     */
    function _getAdmin() internal view returns (address) {
        return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        require(newAdmin != address(0), "ERC1967: new admin is the zero address");
        StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
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
     * @dev Emitted when the beacon is upgraded.
     */
    event BeaconUpgraded(address indexed beacon);

    /**
     * @dev Returns the current beacon.
     */
    function _getBeacon() internal view returns (address) {
        return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the EIP1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
        require(
            Address.isContract(IBeacon(newBeacon).implementation()),
            "ERC1967: beacon implementation is not a contract"
        );
        StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
    }

    /**
     * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
     * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
     *
     * Emits a {BeaconUpgraded} event.
     */
    function _upgradeBeaconToAndCall(
        address newBeacon,
        bytes memory data,
        bool forceCall
    ) internal {
        _setBeacon(newBeacon);
        emit BeaconUpgraded(newBeacon);
        if (data.length > 0 || forceCall) {
            Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
        }
    }
}

// File: .deps/npm/@openzeppelin/[email protected]/proxy/Proxy.sol

pragma solidity ^0.8.0;

/**
 * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
 * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
 * be specified by overriding the virtual {_implementation} function.
 *
 * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
 * different contract through the {_delegate} function.
 *
 * The success and return data of the delegated call will be returned back to the caller of the proxy.
 */
abstract contract Proxy {
    /**
     * @dev Delegates the current call to `implementation`.
     *
     * This function does not return to its internall call site, it will return directly to the external caller.
     */
    function _delegate(address implementation) internal virtual {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    /**
     * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
     * and {_fallback} should delegate.
     */
    function _implementation() internal view virtual returns (address);

    /**
     * @dev Delegates the current call to the address returned by `_implementation()`.
     *
     * This function does not return to its internall call site, it will return directly to the external caller.
     */
    function _fallback() internal virtual {
        _beforeFallback();
        _delegate(_implementation());
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
     * function in the contract matches the call data.
     */
    fallback() external payable virtual {
        _fallback();
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
     * is empty.
     */
    receive() external payable virtual {
        _fallback();
    }

    /**
     * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
     * call, or as part of the Solidity `fallback` or `receive` functions.
     *
     * If overriden should call `super._beforeFallback()`.
     */
    function _beforeFallback() internal virtual {}
}

// File: .deps/npm/@openzeppelin/[email protected]/proxy/ERC1967/ERC1967Proxy.sol

pragma solidity ^0.8.0;



/**
 * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
 * implementation address that can be changed. This address is stored in storage in the location specified by
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
 * implementation behind the proxy.
 */
contract ERC1967Proxy is Proxy, ERC1967Upgrade {
    /**
     * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
     *
     * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
     * function call, and allows initializating the storage of the proxy like a Solidity constructor.
     */
    constructor(address _logic, bytes memory _data) payable {
        assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        _upgradeToAndCall(_logic, _data, false);
    }

    /**
     * @dev Returns the current implementation address.
     */
    function _implementation() internal view virtual override returns (address impl) {
        return ERC1967Upgrade._getImplementation();
    }
}

// File: .deps/npm/@openzeppelin/[email protected]/proxy/transparent/TransparentUpgradeableProxy.sol

pragma solidity ^0.8.0;


/**
 * @dev This contract implements a proxy that is upgradeable by an admin.
 *
 * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
 * clashing], which can potentially be used in an attack, this contract uses the
 * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
 * things that go hand in hand:
 *
 * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
 * that call matches one of the admin functions exposed by the proxy itself.
 * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
 * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
 * "admin cannot fallback to proxy target".
 *
 * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
 * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
 * to sudden errors when trying to call a function from the proxy implementation.
 *
 * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
 * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
 */
contract TransparentUpgradeableProxy is ERC1967Proxy {
    /**
     * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
     * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
     */
    constructor(
        address _logic,
        address admin_,
        bytes memory _data
    ) payable ERC1967Proxy(_logic, _data) {
        assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
        _changeAdmin(admin_);
    }

    /**
     * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
     */
    modifier ifAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    /**
     * @dev Returns the current admin.
     *
     * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
     *
     * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
     * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
     * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
     */
    function admin() external ifAdmin returns (address admin_) {
        admin_ = _getAdmin();
    }

    /**
     * @dev Returns the current implementation.
     *
     * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
     *
     * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
     * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
     * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
     */
    function implementation() external ifAdmin returns (address implementation_) {
        implementation_ = _implementation();
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {AdminChanged} event.
     *
     * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
     */
    function changeAdmin(address newAdmin) external virtual ifAdmin {
        _changeAdmin(newAdmin);
    }

    /**
     * @dev Upgrade the implementation of the proxy.
     *
     * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
     */
    function upgradeTo(address newImplementation) external ifAdmin {
        _upgradeToAndCall(newImplementation, bytes(""), false);
    }

    /**
     * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
     * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
     * proxied contract.
     *
     * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
     */
    function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
        _upgradeToAndCall(newImplementation, data, true);
    }

    /**
     * @dev Returns the current admin.
     */
    function _admin() internal view virtual returns (address) {
        return _getAdmin();
    }

    /**
     * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
     */
    function _beforeFallback() internal virtual override {
        require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
        super._beforeFallback();
    }
}

// : BUSL-1.1

pragma solidity 0.8.6;



// Part: IBetaBank

interface IBetaBank {
  /// @dev Returns the address of BToken of the given underlying token, or 0 if not exists.
  function bTokens(address _underlying) external view returns (address);

  /// @dev Returns the address of the underlying of the given BToken, or 0 if not exists.
  function underlyings(address _bToken) external view returns (address);

  /// @dev Returns the address of the oracle contract.
  function oracle() external view returns (address);

  /// @dev Returns the address of the config contract.
  function config() external view returns (address);

  /// @dev Returns the interest rate model smart contract.
  function interestModel() external view returns (address);

  /// @dev Returns the position's collateral token and AmToken.
  function getPositionTokens(address _owner, uint _pid)
    external
    view
    returns (address _collateral, address _bToken);

  /// @dev Returns the debt of the given position. Can't be view as it needs to call accrue.
  function fetchPositionDebt(address _owner, uint _pid) external returns (uint);

  /// @dev Returns the LTV of the given position. Can't be view as it needs to call accrue.
  function fetchPositionLTV(address _owner, uint _pid) external returns (uint);

  /// @dev Opens a new position in the Beta smart contract.
  function open(
    address _owner,
    address _underlying,
    address _collateral
  ) external returns (uint pid);

  /// @dev Borrows tokens on the given position.
  function borrow(
    address _owner,
    uint _pid,
    uint _amount
  ) external;

  /// @dev Repays tokens on the given position.
  function repay(
    address _owner,
    uint _pid,
    uint _amount
  ) external;

  /// @dev Puts more collateral to the given position.
  function put(
    address _owner,
    uint _pid,
    uint _amount
  ) external;

  /// @dev Takes some collateral out of the position.
  function take(
    address _owner,
    uint _pid,
    uint _amount
  ) external;

  /// @dev Liquidates the given position.
  function liquidate(
    address _owner,
    uint _pid,
    uint _amount
  ) external;
}

// Part: IBetaConfig

interface IBetaConfig {
  /// @dev Returns the risk level for the given asset.
  function getRiskLevel(address token) external view returns (uint);

  /// @dev Returns the rate of interest collected to be distributed to the protocol reserve.
  function reserveRate() external view returns (uint);

  /// @dev Returns the beneficiary to receive a portion interest rate for the protocol.
  function reserveBeneficiary() external view returns (address);

  /// @dev Returns the ratio of which the given token consider for collateral value.
  function getCollFactor(address token) external view returns (uint);

  /// @dev Returns the max amount of collateral to accept globally.
  function getCollMaxAmount(address token) external view returns (uint);

  /// @dev Returns max ltv of collateral / debt to allow a new position.
  function getSafetyLTV(address token) external view returns (uint);

  /// @dev Returns max ltv of collateral / debt to liquidate a position of the given token.
  function getLiquidationLTV(address token) external view returns (uint);

  /// @dev Returns the bonus incentive reward factor for liquidators.
  function getKillBountyRate(address token) external view returns (uint);
}

// Part: IBetaInterestModel

interface IBetaInterestModel {
  /// @dev Returns the initial interest rate per year (times 1e18).
  function initialRate() external view returns (uint);

  /// @dev Returns the next interest rate for the market.
  /// @param prevRate The current interest rate.
  /// @param totalAvailable The current available liquidity.
  /// @param totalLoan The current outstanding loan.
  /// @param timePast The time past since last interest rate rebase in seconds.
  function getNextInterestRate(
    uint prevRate,
    uint totalAvailable,
    uint totalLoan,
    uint timePast
  ) external view returns (uint);
}

// Part: IBetaOracle

interface IBetaOracle {
  /// @dev Returns the given asset price in ETH (wei), multiplied by 2**112.
  /// @param token The token to query for asset price
  function getAssetETHPrice(address token) external returns (uint);

  /// @dev Returns the given asset value in ETH (wei)
  /// @param token The token to query for asset value
  /// @param amount The amount of token to query
  function getAssetETHValue(address token, uint amount) external returns (uint);

  /// @dev Returns the conversion from amount of from` to `to`.
  /// @param from The source token to convert.
  /// @param to The destination token to convert.
  /// @param amount The amount of token for conversion.
  function convert(
    address from,
    address to,
    uint amount
  ) external returns (uint);
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Address

/**
 * @dev Collection of functions related to the address type
 */
library Address {
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
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
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
        return functionCall(target, data, "Address: low-level call failed");
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
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
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
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
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
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
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Context

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Counters

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */
library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ECDSA

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     *
     * Documentation for signature generation:
     * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
     * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        // - case 65: r,s,v signature (standard)
        // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return recover(hash, v, r, s);
        } else if (signature.length == 64) {
            bytes32 r;
            bytes32 vs;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            assembly {
                r := mload(add(signature, 0x20))
                vs := mload(add(signature, 0x40))
            }
            return recover(hash, r, vs);
        } else {
            revert("ECDSA: invalid signature length");
        }
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
     *
     * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
     *
     * _Available since v4.2._
     */
    function recover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address) {
        bytes32 s;
        uint8 v;
        assembly {
            s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            v := add(shr(255, vs), 27)
        }
        return recover(hash, v, r, s);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
     */
    function recover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        require(
            uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
            "ECDSA: invalid signature 's' value"
        );
        require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    /**
     * @dev Returns an Ethereum Signed Typed Data, created from a
     * `domainSeparator` and a `structHash`. This produces hash corresponding
     * to the one signed with the
     * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
     * JSON-RPC method as part of EIP-712.
     *
     * See {recover}.
     */
    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20Permit

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Initializable

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Math

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute.
        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a / b + (a % b == 0 ? 0 : 1);
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ReentrancyGuard

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/EIP712

/**
 * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
 *
 * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
 * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
 * they need in their contracts using a combination of `abi.encode` and `keccak256`.
 *
 * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
 * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
 * ({_hashTypedDataV4}).
 *
 * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
 * the chain id to protect against replay attacks on an eventual fork of the chain.
 *
 * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
 * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
 *
 * _Available since v3.4._
 */
abstract contract EIP712 {
    /* solhint-disable var-name-mixedcase */
    // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
    // invalidate the cached domain separator if the chain id changes.
    bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
    uint256 private immutable _CACHED_CHAIN_ID;

    bytes32 private immutable _HASHED_NAME;
    bytes32 private immutable _HASHED_VERSION;
    bytes32 private immutable _TYPE_HASH;

    /* solhint-enable var-name-mixedcase */

    /**
     * @dev Initializes the domain separator and parameter caches.
     *
     * The meaning of `name` and `version` is specified in
     * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
     *
     * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
     * - `version`: the current major version of the signing domain.
     *
     * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
     * contract upgrade].
     */
    constructor(string memory name, string memory version) {
        bytes32 hashedName = keccak256(bytes(name));
        bytes32 hashedVersion = keccak256(bytes(version));
        bytes32 typeHash = keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );
        _HASHED_NAME = hashedName;
        _HASHED_VERSION = hashedVersion;
        _CACHED_CHAIN_ID = block.chainid;
        _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
        _TYPE_HASH = typeHash;
    }

    /**
     * @dev Returns the domain separator for the current chain.
     */
    function _domainSeparatorV4() internal view returns (bytes32) {
        if (block.chainid == _CACHED_CHAIN_ID) {
            return _CACHED_DOMAIN_SEPARATOR;
        } else {
            return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
        }
    }

    function _buildDomainSeparator(
        bytes32 typeHash,
        bytes32 nameHash,
        bytes32 versionHash
    ) private view returns (bytes32) {
        return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
    }

    /**
     * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
     * function returns the hash of the fully encoded EIP712 message for this domain.
     *
     * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
     *
     * ```solidity
     * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
     *     keccak256("Mail(address to,string contents)"),
     *     mailTo,
     *     keccak256(bytes(mailContents))
     * )));
     * address signer = ECDSA.recover(digest, signature);
     * ```
     */
    function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
        return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20Metadata

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Pausable

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
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
    constructor() {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
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
        require(paused(), "Pausable: not paused");
        _;
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
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/SafeERC20

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ERC20

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ERC20Permit

/**
 * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 *
 * _Available since v3.4._
 */
abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
    using Counters for Counters.Counter;

    mapping(address => Counters.Counter) private _nonces;

    // solhint-disable-next-line var-name-mixedcase
    bytes32 private immutable _PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    /**
     * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
     *
     * It's a good idea to use the same `name` that is defined as the ERC20 token name.
     */
    constructor(string memory name) EIP712(name, "1") {}

    /**
     * @dev See {IERC20Permit-permit}.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual override {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));

        bytes32 hash = _hashTypedDataV4(structHash);

        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");

        _approve(owner, spender, value);
    }

    /**
     * @dev See {IERC20Permit-nonces}.
     */
    function nonces(address owner) public view virtual override returns (uint256) {
        return _nonces[owner].current();
    }

    /**
     * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view override returns (bytes32) {
        return _domainSeparatorV4();
    }

    /**
     * @dev "Consume a nonce": return the current value and increment.
     *
     * _Available since v4.1._
     */
    function _useNonce(address owner) internal virtual returns (uint256 current) {
        Counters.Counter storage nonce = _nonces[owner];
        current = nonce.current();
        nonce.increment();
    }
}

// Part: BToken

contract BToken is ERC20Permit, ReentrancyGuard {
  using SafeERC20 for IERC20;

  event Accrue(uint interest);
  event Mint(address indexed caller, address indexed to, uint amount, uint credit);
  event Burn(address indexed caller, address indexed to, uint amount, uint credit);

  uint public constant MINIMUM_LIQUIDITY = 10**6; // minimum liquidity to be locked in the pool when first mint occurs

  address public immutable betaBank; // BetaBank address
  address public immutable underlying; // the underlying token

  uint public interestRate; // current interest rate
  uint public lastAccrueTime; // last interest accrual timestamp
  uint public totalLoanable; // total asset amount available to be borrowed
  uint public totalLoan; // total amount of loan
  uint public totalDebtShare; // total amount of debt share

  /// @dev Initializes the BToken contract.
  /// @param _betaBank BetaBank address.
  /// @param _underlying The underlying token address for the bToken.
  constructor(address _betaBank, address _underlying)
    ERC20Permit('B Token')
    ERC20('B Token', 'bTOKEN')
  {
    require(_betaBank != address(0), 'constructor/betabank-zero-address');
    require(_underlying != address(0), 'constructor/underlying-zero-address');
    betaBank = _betaBank;
    underlying = _underlying;
    interestRate = IBetaInterestModel(IBetaBank(_betaBank).interestModel()).initialRate();
    lastAccrueTime = block.timestamp;
  }

  /// @dev Returns the name of the token.
  function name() public view override returns (string memory) {
    try IERC20Metadata(underlying).name() returns (string memory data) {
      return string(abi.encodePacked('B ', data));
    } catch (bytes memory) {
      return ERC20.name();
    }
  }

  /// @dev Returns the symbol of the token.
  function symbol() public view override returns (string memory) {
    try IERC20Metadata(underlying).symbol() returns (string memory data) {
      return string(abi.encodePacked('b', data));
    } catch (bytes memory) {
      return ERC20.symbol();
    }
  }

  /// @dev Returns the decimal places of the token.
  function decimals() public view override returns (uint8) {
    try IERC20Metadata(underlying).decimals() returns (uint8 data) {
      return data;
    } catch (bytes memory) {
      return ERC20.decimals();
    }
  }

  /// @dev Accrues interest rate and adjusts the rate. Can be called by anyone at any time.
  function accrue() public {
    // 1. Check time past condition
    uint timePassed = block.timestamp - lastAccrueTime;
    if (timePassed == 0) return;
    lastAccrueTime = block.timestamp;
    // 2. Check bank pause condition
    require(!Pausable(betaBank).paused(), 'BetaBank/paused');
    // 3. Compute the accrued interest value over the past time
    (uint totalLoan_, uint totalLoanable_, uint interestRate_) = (
      totalLoan,
      totalLoanable,
      interestRate
    ); // gas saving by avoiding multiple SLOADs
    IBetaConfig config = IBetaConfig(IBetaBank(betaBank).config());
    IBetaInterestModel model = IBetaInterestModel(IBetaBank(betaBank).interestModel());
    uint interest = (interestRate_ * totalLoan_ * timePassed) / (365 days) / 1e18;
    // 4. Update total loan and next interest rate
    totalLoan_ += interest;
    totalLoan = totalLoan_;
    interestRate = model.getNextInterestRate(interestRate_, totalLoanable_, totalLoan_, timePassed);
    // 5. Send a portion of collected interest to the beneficiary
    if (interest > 0) {
      uint reserveRate = config.reserveRate();
      if (reserveRate > 0) {
        uint toReserve = (interest * reserveRate) / 1e18;
        _mint(
          config.reserveBeneficiary(),
          (toReserve * totalSupply()) / (totalLoan_ + totalLoanable_ - toReserve)
        );
      }
      emit Accrue(interest);
    }
  }

  /// @dev Returns the debt value for the given debt share. Automatically calls accrue.
  function fetchDebtShareValue(uint _debtShare) external returns (uint) {
    accrue();
    if (_debtShare == 0) {
      return 0;
    }
    return Math.ceilDiv(_debtShare * totalLoan, totalDebtShare); // round up
  }

  /// @dev Mints new bToken to the given address.
  /// @param _to The address to mint new bToken for.
  /// @param _amount The amount of underlying tokens to deposit via `transferFrom`.
  /// @return credit The amount of bToken minted.
  function mint(address _to, uint _amount) external nonReentrant returns (uint credit) {
    accrue();
    uint amount;
    {
      uint balBefore = IERC20(underlying).balanceOf(address(this));
      IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
      uint balAfter = IERC20(underlying).balanceOf(address(this));
      amount = balAfter - balBefore;
    }
    uint supply = totalSupply();
    if (supply == 0) {
      credit = amount - MINIMUM_LIQUIDITY;
      // Permanently lock the first MINIMUM_LIQUIDITY tokens
      totalLoanable += credit;
      totalLoan += MINIMUM_LIQUIDITY;
      totalDebtShare += MINIMUM_LIQUIDITY;
      _mint(address(1), MINIMUM_LIQUIDITY); // OpenZeppelin ERC20 does not allow minting to 0
    } else {
      credit = (amount * supply) / (totalLoanable + totalLoan);
      totalLoanable += amount;
    }
    require(credit > 0, 'mint/no-credit-minted');
    _mint(_to, credit);
    emit Mint(msg.sender, _to, _amount, credit);
  }

  /// @dev Burns the given bToken for the proportional amount of underlying tokens.
  /// @param _to The address to send the underlying tokens to.
  /// @param _credit The amount of bToken to burn.
  /// @return amount The amount of underlying tokens getting transferred out.
  function burn(address _to, uint _credit) external nonReentrant returns (uint amount) {
    accrue();
    uint supply = totalSupply();
    amount = (_credit * (totalLoanable + totalLoan)) / supply;
    require(amount > 0, 'burn/no-amount-returned');
    totalLoanable -= amount;
    _burn(msg.sender, _credit);
    IERC20(underlying).safeTransfer(_to, amount);
    emit Burn(msg.sender, _to, amount, _credit);
  }

  /// @dev Borrows the funds for the given address. Must only be called by BetaBank.
  /// @param _to The address to borrow the funds for.
  /// @param _amount The amount to borrow.
  /// @return debtShare The amount of new debt share minted.
  function borrow(address _to, uint _amount) external nonReentrant returns (uint debtShare) {
    require(msg.sender == betaBank, 'borrow/not-BetaBank');
    accrue();
    IERC20(underlying).safeTransfer(_to, _amount);
    debtShare = Math.ceilDiv(_amount * totalDebtShare, totalLoan); // round up
    totalLoanable -= _amount;
    totalLoan += _amount;
    totalDebtShare += debtShare;
  }

  /// @dev Repays the debt using funds from the given address. Must only be called by BetaBank.
  /// @param _from The address to drain the funds to repay.
  /// @param _amount The amount of funds to call via `transferFrom`.
  /// @return debtShare The amount of debt share repaid.
  function repay(address _from, uint _amount) external nonReentrant returns (uint debtShare) {
    require(msg.sender == betaBank, 'repay/not-BetaBank');
    accrue();
    uint amount;
    {
      uint balBefore = IERC20(underlying).balanceOf(address(this));
      IERC20(underlying).safeTransferFrom(_from, address(this), _amount);
      uint balAfter = IERC20(underlying).balanceOf(address(this));
      amount = balAfter - balBefore;
    }
    require(amount <= totalLoan, 'repay/amount-too-high');
    debtShare = (amount * totalDebtShare) / totalLoan; // round down
    totalLoanable += amount;
    totalLoan -= amount;
    totalDebtShare -= debtShare;
    require(totalDebtShare >= MINIMUM_LIQUIDITY, 'repay/too-low-sum-debt-share');
  }

  /// @dev Recovers tokens in this contract. EMERGENCY ONLY. Full trust in BetaBank.
  /// @param _token The token to recover, can even be underlying so please be careful.
  /// @param _to The address to recover tokens to.
  /// @param _amount The amount of tokens to recover, or MAX_UINT256 if whole balance.
  function recover(
    address _token,
    address _to,
    uint _amount
  ) external nonReentrant {
    require(msg.sender == betaBank, 'recover/not-BetaBank');
    if (_amount == type(uint).max) {
      _amount = IERC20(_token).balanceOf(address(this));
    }
    IERC20(_token).safeTransfer(_to, _amount);
  }
}

// Part: BTokenDeployer

contract BTokenDeployer {
  /// @dev Deploys a new BToken contract for the given underlying token.
  function deploy(address _underlying) external returns (address) {
    bytes32 salt = keccak256(abi.encode(msg.sender, _underlying));
    return address(new BToken{salt: salt}(msg.sender, _underlying));
  }

  /// @dev Returns the deterministic BToken address for the given BetaBank + underlying.
  function bTokenFor(address _betaBank, address _underlying) external view returns (address) {
    bytes memory args = abi.encode(_betaBank, _underlying);
    bytes32 code = keccak256(abi.encodePacked(type(BToken).creationCode, args));
    bytes32 salt = keccak256(args);
    return address(uint160(uint(keccak256(abi.encodePacked(hex'ff', address(this), salt, code)))));
  }
}

// File: BetaBank.sol

contract BetaBank is IBetaBank, Initializable, Pausable {
  using Address for address;
  using SafeERC20 for IERC20;

  event Create(address indexed underlying, address bToken);
  event Open(address indexed owner, uint indexed pid, address bToken, address collateral);
  event Borrow(address indexed owner, uint indexed pid, uint amount, uint share, address borrower);
  event Repay(address indexed owner, uint indexed pid, uint amount, uint share, address payer);
  event Put(address indexed owner, uint indexed pid, uint amount, address payer);
  event Take(address indexed owner, uint indexed pid, uint amount, address to);
  event Liquidate(
    address indexed owner,
    uint indexed pid,
    uint amount,
    uint share,
    uint reward,
    address caller
  );
  event SelflessLiquidate(
    address indexed owner,
    uint indexed pid,
    uint amount,
    uint share,
    address caller
  );
  event SetGovernor(address governor);
  event SetPendingGovernor(address pendingGovernor);
  event SetOracle(address oracle);
  event SetConfig(address config);
  event SetInterestModel(address interestModel);
  event SetRunnerWhitelist(address indexed runner, bool ok);
  event SetOwnerWhitelist(address indexed owner, bool ok);
  event SetAllowPublicCreate(bool ok);

  struct Position {
    uint32 blockBorrowPut; // safety check
    uint32 blockRepayTake; // safety check
    address bToken;
    address collateral;
    uint collateralSize;
    uint debtShare;
  }

  uint private unlocked; // reentrancy variable
  address public deployer; // deployer address
  address public override oracle; // oracle address
  address public override config; // config address
  address public override interestModel; // interest rate model address
  address public governor; // current governor
  address public pendingGovernor; // pending governor
  bool public allowPublicCreate; // allow public to create pool status

  mapping(address => address) public override bTokens; // mapping from underlying to bToken
  mapping(address => address) public override underlyings; // mapping from bToken to underlying token
  mapping(address => bool) public runnerWhitelists; // whitelist of authorized routers
  mapping(address => bool) public ownerWhitelists; // whitelist of authorized owners

  mapping(address => mapping(uint => Position)) public positions; // mapping from user to the user's position id to Position info
  mapping(address => uint) public nextPositionIds; // mapping from user to next position id (position count)
  mapping(address => uint) public totalCollaterals; // mapping from token address to amount of collateral

  /// @dev Reentrancy guard modifier
  modifier lock() {
    require(unlocked == 1, 'BetaBank/locked');
    unlocked = 2;
    _;
    unlocked = 1;
  }

  /// @dev Only governor is allowed modifier.
  modifier onlyGov() {
    require(msg.sender == governor, 'BetaBank/onlyGov');
    _;
  }

  /// @dev Check if sender is allowed to perform action on behalf of the owner modifier.
  modifier isPermittedByOwner(address _owner) {
    require(isPermittedCaller(_owner, msg.sender), 'BetaBank/isPermittedByOwner');
    _;
  }

  /// @dev Check is pool id exist for the owner modifier.
  modifier checkPID(address _owner, uint _pid) {
    require(_pid < nextPositionIds[_owner], 'BetaBank/checkPID');
    _;
  }

  /// @dev Initializes this smart contract. No constructor to make this upgradable.
  function initialize(
    address _governor,
    address _deployer,
    address _oracle,
    address _config,
    address _interestModel
  ) external initializer {
    require(_governor != address(0), 'initialize/governor-zero-address');
    require(_deployer != address(0), 'initialize/deployer-zero-address');
    require(_oracle != address(0), 'initialize/oracle-zero-address');
    require(_config != address(0), 'initialize/config-zero-address');
    require(_interestModel != address(0), 'initialize/interest-model-zero-address');
    governor = _governor;
    deployer = _deployer;
    oracle = _oracle;
    config = _config;
    interestModel = _interestModel;
    unlocked = 1;
    emit SetGovernor(_governor);
    emit SetOracle(_oracle);
    emit SetConfig(_config);
    emit SetInterestModel(_interestModel);
  }

  /// @dev Sets the next governor, which will be in effect when they accept.
  /// @param _pendingGovernor The next governor address.
  function setPendingGovernor(address _pendingGovernor) external onlyGov {
    pendingGovernor = _pendingGovernor;
    emit SetPendingGovernor(_pendingGovernor);
  }

  /// @dev Accepts to become the next governor. Must only be called by the pending governor.
  function acceptGovernor() external {
    require(msg.sender == pendingGovernor, 'acceptGovernor/not-pending-governor');
    pendingGovernor = address(0);
    governor = msg.sender;
    emit SetGovernor(msg.sender);
  }

  /// @dev Updates the oracle address. Must only be called by the governor.
  function setOracle(address _oracle) external onlyGov {
    require(_oracle != address(0), 'setOracle/zero-address');
    oracle = _oracle;
    emit SetOracle(_oracle);
  }

  /// @dev Updates the config address. Must only be called by the governor.
  function setConfig(address _config) external onlyGov {
    require(_config != address(0), 'setConfig/zero-address');
    config = _config;
    emit SetConfig(_config);
  }

  /// @dev Updates the interest model address. Must only be called by the governor.
  function setInterestModel(address _interestModel) external onlyGov {
    require(_interestModel != address(0), 'setInterestModel/zero-address');
    interestModel = _interestModel;
    emit SetInterestModel(_interestModel);
  }

  /// @dev Sets the whitelist statuses for the given runners. Must only be called by the governor.
  function setRunnerWhitelists(address[] calldata _runners, bool ok) external onlyGov {
    for (uint idx = 0; idx < _runners.length; idx++) {
      runnerWhitelists[_runners[idx]] = ok;
      emit SetRunnerWhitelist(_runners[idx], ok);
    }
  }

  /// @dev Sets the whitelist statuses for the given owners. Must only be called by the governor.
  function setOwnerWhitelists(address[] calldata _owners, bool ok) external onlyGov {
    for (uint idx = 0; idx < _owners.length; idx++) {
      ownerWhitelists[_owners[idx]] = ok;
      emit SetOwnerWhitelist(_owners[idx], ok);
    }
  }

  /// @dev Pauses and stops money market-related interactions. Must only be called by the governor.
  function pause() external whenNotPaused onlyGov {
    _pause();
  }

  /// @dev Unpauses and allows again money market-related interactions. Must only be called by the governor.
  function unpause() external whenPaused onlyGov {
    _unpause();
  }

  /// @dev Sets whether anyone can create btoken of any token. Must only be called by the governor.
  function setAllowPublicCreate(bool _ok) external onlyGov {
    allowPublicCreate = _ok;
    emit SetAllowPublicCreate(_ok);
  }

  /// @dev Creates a new money market for the given underlying token. Permissionless.
  /// @param _underlying The ERC-20 that is borrowable in the newly created market contract.
  function create(address _underlying) external lock whenNotPaused returns (address bToken) {
    require(allowPublicCreate || msg.sender == governor, 'create/unauthorized');
    require(_underlying != address(this), 'create/not-like-this');
    require(_underlying.isContract(), 'create/underlying-not-contract');
    require(bTokens[_underlying] == address(0), 'create/underlying-already-exists');
    require(IBetaOracle(oracle).getAssetETHPrice(_underlying) > 0, 'create/no-price');
    bToken = BTokenDeployer(deployer).deploy(_underlying);
    bTokens[_underlying] = bToken;
    underlyings[bToken] = _underlying;
    emit Create(_underlying, bToken);
  }

  /// @dev Returns whether the given sender is allowed to interact with a position of the owner.
  function isPermittedCaller(address _owner, address _sender) public view returns (bool) {
    // ONE OF THE TWO CONDITIONS MUST HOLD:
    // 1. allow if sender is owner and owner is whitelisted.
    // 2. allow if owner is origin tx sender (for extra safety) and sender is globally accepted.
    return ((_owner == _sender && ownerWhitelists[_owner]) ||
      (_owner == tx.origin && runnerWhitelists[_sender]));
  }

  /// @dev Returns the position's collateral token and BToken.
  function getPositionTokens(address _owner, uint _pid)
    external
    view
    override
    checkPID(_owner, _pid)
    returns (address _collateral, address _bToken)
  {
    Position storage pos = positions[_owner][_pid];
    _collateral = pos.collateral;
    _bToken = pos.bToken;
  }

  /// @dev Returns the debt of the given position. Can't be view as it needs to call accrue.
  function fetchPositionDebt(address _owner, uint _pid)
    external
    override
    checkPID(_owner, _pid)
    returns (uint)
  {
    Position storage pos = positions[_owner][_pid];
    return BToken(pos.bToken).fetchDebtShareValue(pos.debtShare);
  }

  /// @dev Returns the LTV of the given position. Can't be view as it needs to call accrue.
  function fetchPositionLTV(address _owner, uint _pid)
    external
    override
    checkPID(_owner, _pid)
    returns (uint)
  {
    return _fetchPositionLTV(positions[_owner][_pid]);
  }

  /// @dev Opens a new position to borrow a specific token for a specific collateral.
  /// @param _owner The owner of the newly created position. Sender must be allowed to act for.
  /// @param _underlying The token that is allowed to be borrowed in this position.
  /// @param _collateral The token that is used as collateral in this position.
  function open(
    address _owner,
    address _underlying,
    address _collateral
  ) external override whenNotPaused isPermittedByOwner(_owner) returns (uint pid) {
    address bToken = bTokens[_underlying];
    require(bToken != address(0), 'open/bad-underlying');
    require(_underlying != _collateral, 'open/self-collateral');
    require(IBetaConfig(config).getCollFactor(_collateral) > 0, 'open/bad-collateral');
    require(IBetaOracle(oracle).getAssetETHPrice(_collateral) > 0, 'open/no-price');
    pid = nextPositionIds[_owner]++;
    Position storage pos = positions[_owner][pid];
    pos.bToken = bToken;
    pos.collateral = _collateral;
    emit Open(_owner, pid, bToken, _collateral);
  }

  /// @dev Borrows tokens on the given position. Position must still be safe.
  /// @param _owner The position owner to borrow underlying tokens.
  /// @param _pid The position id to borrow underlying tokens.
  /// @param _amount The amount of underlying tokens to borrow.
  function borrow(
    address _owner,
    uint _pid,
    uint _amount
  ) external override lock whenNotPaused isPermittedByOwner(_owner) checkPID(_owner, _pid) {
    // 1. pre-conditions
    Position memory pos = positions[_owner][_pid];
    require(pos.blockRepayTake != uint32(block.number), 'borrow/bad-block');
    // 2. perform the borrow and update the position
    uint share = BToken(pos.bToken).borrow(msg.sender, _amount);
    pos.debtShare += share;
    positions[_owner][_pid].debtShare = pos.debtShare;
    positions[_owner][_pid].blockBorrowPut = uint32(block.number);
    // 3. make sure the position is still safe
    uint ltv = _fetchPositionLTV(pos);
    require(ltv <= IBetaConfig(config).getSafetyLTV(underlyings[pos.bToken]), 'borrow/not-safe');
    emit Borrow(_owner, _pid, _amount, share, msg.sender);
  }

  /// @dev Repays tokens on the given position. Payer must be position owner or sender.
  /// @param _owner The position owner to repay underlying tokens.
  /// @param _pid The position id to repay underlying tokens.
  /// @param _amount The amount of underlying tokens to repay.
  function repay(
    address _owner,
    uint _pid,
    uint _amount
  ) external override lock whenNotPaused isPermittedByOwner(_owner) checkPID(_owner, _pid) {
    // 1. pre-conditions
    Position memory pos = positions[_owner][_pid];
    require(pos.blockBorrowPut != uint32(block.number), 'repay/bad-block');
    // 2. perform the repayment and update the position - no collateral check required
    uint share = BToken(pos.bToken).repay(msg.sender, _amount);
    pos.debtShare -= share;
    positions[_owner][_pid].debtShare = pos.debtShare;
    positions[_owner][_pid].blockRepayTake = uint32(block.number);
    emit Repay(_owner, _pid, _amount, share, msg.sender);
  }

  /// @dev Puts more collateral to the given position. Payer must be position owner or sender.
  /// @param _owner The position owner to put more collateral.
  /// @param _pid The position id to put more collateral.
  /// @param _amount The amount of collateral to put via `transferFrom`.
  function put(
    address _owner,
    uint _pid,
    uint _amount
  ) external override lock whenNotPaused isPermittedByOwner(_owner) checkPID(_owner, _pid) {
    // 1. pre-conditions
    Position memory pos = positions[_owner][_pid];
    require(pos.blockRepayTake != uint32(block.number), 'put/bad-block');
    // 2. transfer collateral tokens in
    uint amount;
    {
      uint balBefore = IERC20(pos.collateral).balanceOf(address(this));
      IERC20(pos.collateral).safeTransferFrom(msg.sender, address(this), _amount);
      uint balAfter = IERC20(pos.collateral).balanceOf(address(this));
      amount = balAfter - balBefore;
    }
    // 3. update the position and total collateral + check global collateral cap
    pos.collateralSize += amount;
    totalCollaterals[pos.collateral] += amount;
    require(
      totalCollaterals[pos.collateral] <= IBetaConfig(config).getCollMaxAmount(pos.collateral),
      'put/too-much-collateral'
    );
    positions[_owner][_pid].collateralSize = pos.collateralSize;
    positions[_owner][_pid].blockBorrowPut = uint32(block.number);
    emit Put(_owner, _pid, _amount, msg.sender);
  }

  /// @dev Takes some collateral out of the position and send it out. Position must still be safe.
  /// @param _owner The position owner to take collateral out.
  /// @param _pid The position id to take collateral out.
  /// @param _amount The amount of collateral to take via `transfer`.
  function take(
    address _owner,
    uint _pid,
    uint _amount
  ) external override lock whenNotPaused isPermittedByOwner(_owner) checkPID(_owner, _pid) {
    // 1. pre-conditions
    Position memory pos = positions[_owner][_pid];
    require(pos.blockBorrowPut != uint32(block.number), 'take/bad-block');
    // 2. update position collateral size and total collateral
    pos.collateralSize -= _amount;
    totalCollaterals[pos.collateral] -= _amount;
    positions[_owner][_pid].collateralSize = pos.collateralSize;
    positions[_owner][_pid].blockRepayTake = uint32(block.number);
    // 3. make sure the position is still safe
    uint ltv = _fetchPositionLTV(pos);
    require(ltv <= IBetaConfig(config).getSafetyLTV(underlyings[pos.bToken]), 'take/not-safe');
    // 4. transfer collateral tokens out
    IERC20(pos.collateral).safeTransfer(msg.sender, _amount);
    emit Take(_owner, _pid, _amount, msg.sender);
  }

  /// @dev Liquidates the given position. Can be called by anyone but must be liquidatable.
  /// @param _owner The position owner to be liquidated.
  /// @param _pid The position id to be liquidated.
  /// @param _amount The amount of debt to be repaid by caller. Must not exceed half debt (rounded up).
  function liquidate(
    address _owner,
    uint _pid,
    uint _amount
  ) external override lock whenNotPaused checkPID(_owner, _pid) {
    // 1. check liquidation condition
    Position memory pos = positions[_owner][_pid];
    address underlying = underlyings[pos.bToken];
    uint ltv = _fetchPositionLTV(pos);
    require(ltv >= IBetaConfig(config).getLiquidationLTV(underlying), 'liquidate/not-liquidatable');
    // 2. perform repayment
    uint debtShare = BToken(pos.bToken).repay(msg.sender, _amount);
    require(debtShare <= (pos.debtShare + 1) / 2, 'liquidate/too-much-liquidation');
    // 3. calculate reward and payout
    uint debtValue = BToken(pos.bToken).fetchDebtShareValue(debtShare);
    uint collValue = IBetaOracle(oracle).convert(underlying, pos.collateral, debtValue);
    uint payout = Math.min(
      collValue + (collValue * IBetaConfig(config).getKillBountyRate(underlying)) / 1e18,
      pos.collateralSize
    );
    // 4. update the position and total collateral
    pos.debtShare -= debtShare;
    positions[_owner][_pid].debtShare = pos.debtShare;
    pos.collateralSize -= payout;
    positions[_owner][_pid].collateralSize = pos.collateralSize;
    totalCollaterals[pos.collateral] -= payout;
    // 5. transfer the payout out
    IERC20(pos.collateral).safeTransfer(msg.sender, payout);
    emit Liquidate(_owner, _pid, _amount, debtShare, payout, msg.sender);
  }

  /// @dev onlyGov selfless liquidation if collateral size = 0
  /// @param _owner The position owner to be liquidated.
  /// @param _pid The position id to be liquidated.
  /// @param _amount The amount of debt to be repaid by caller.
  function selflessLiquidate(
    address _owner,
    uint _pid,
    uint _amount
  ) external onlyGov lock checkPID(_owner, _pid) {
    // 1. check positions collateral size
    Position memory pos = positions[_owner][_pid];
    require(pos.collateralSize == 0, 'selflessLiquidate/positive-collateral');
    // 2. perform debt repayment
    uint debtValue = BToken(pos.bToken).fetchDebtShareValue(pos.debtShare);
    _amount = Math.min(_amount, debtValue);
    uint debtShare = BToken(pos.bToken).repay(msg.sender, _amount);
    pos.debtShare -= debtShare;
    positions[_owner][_pid].debtShare = pos.debtShare;
    emit SelflessLiquidate(_owner, _pid, _amount, debtShare, msg.sender);
  }

  /// @dev Recovers lost tokens by the governor. This function is extremely powerful so be careful.
  /// @param _bToken The BToken to propagate this recover call.
  /// @param _token The ERC20 token to recover.
  /// @param _amount The amount of tokens to recover.
  function recover(
    address _bToken,
    address _token,
    uint _amount
  ) external onlyGov lock {
    require(underlyings[_bToken] != address(0), 'recover/not-bToken');
    BToken(_bToken).recover(_token, msg.sender, _amount);
  }

  /// @dev Returns the current LTV of the given position.
  function _fetchPositionLTV(Position memory pos) internal returns (uint) {
    if (pos.debtShare == 0) {
      return 0; // no debt means zero LTV
    }

    address oracle_ = oracle; // gas saving
    uint collFactor = IBetaConfig(config).getCollFactor(pos.collateral);
    require(collFactor > 0, 'fetch/bad-collateral');
    uint debtSize = BToken(pos.bToken).fetchDebtShareValue(pos.debtShare);
    uint debtValue = IBetaOracle(oracle_).getAssetETHValue(underlyings[pos.bToken], debtSize);
    uint collCred = (pos.collateralSize * collFactor) / 1e18;
    uint collValue = IBetaOracle(oracle_).getAssetETHValue(pos.collateral, collCred);

    if (debtValue >= collValue) {
      return 1e18; // 100% LTV is very very bad and must always be liquidatable and unsafe
    }
    return (debtValue * 1e18) / collValue;
  }
}

}
