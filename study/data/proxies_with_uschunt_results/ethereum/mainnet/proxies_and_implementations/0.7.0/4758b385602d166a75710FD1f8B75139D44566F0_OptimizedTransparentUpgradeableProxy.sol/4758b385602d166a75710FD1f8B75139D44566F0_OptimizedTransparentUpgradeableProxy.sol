/**
 *  SourceUnit: Protonauts-monorepo/contracts/node_modules/.pnpm/[email protected]_yvvssclfcbeff5cufonczletku/node_modules/hardhat-deploy/solc_0.7/proxy/OptimizedTransparentUpgradeableProxy.sol
 */

////// ////-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity ^0.7.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
	/**
	 * @dev Returns true if `account` is a contract.
	 *
	 * [////IMPORTANT]
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
		// According to EIP-1052, 0x0 is the value returned for not-yet created accounts
		// and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
		// for accounts without code, i.e. `keccak256('')`
		bytes32 codehash;
		bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
		// solhint-disable-next-line no-inline-assembly
		assembly {
			codehash := extcodehash(account)
		}
		return (codehash != accountHash && codehash != 0x0);
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
	 * ////IMPORTANT: because control is transferred to `recipient`, care must be
	 * taken to not create reentrancy vulnerabilities. Consider using
	 * {ReentrancyGuard} or the
	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
	 */
	function sendValue(address payable recipient, uint256 amount) internal {
		require(
			address(this).balance >= amount,
			'Address: insufficient balance'
		);

		// solhint-disable-next-line avoid-low-level-calls, avoid-call-value
		(bool success, ) = recipient.call{value: amount}('');
		require(
			success,
			'Address: unable to send value, recipient may have reverted'
		);
	}

	/**
	 * @dev Performs a Solidity function call using a low level `call`. A
	 * plain`call` is an unsafe replacement for a function call: use this
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
	function functionCall(address target, bytes memory data)
		internal
		returns (bytes memory)
	{
		return functionCall(target, data, 'Address: low-level call failed');
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
		return _functionCallWithValue(target, data, 0, errorMessage);
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
		return
			functionCallWithValue(
				target,
				data,
				value,
				'Address: low-level call with value failed'
			);
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
		require(
			address(this).balance >= value,
			'Address: insufficient balance for call'
		);
		return _functionCallWithValue(target, data, value, errorMessage);
	}

	function _functionCallWithValue(
		address target,
		bytes memory data,
		uint256 weiValue,
		string memory errorMessage
	) private returns (bytes memory) {
		require(isContract(target), 'Address: call to non-contract');

		// solhint-disable-next-line avoid-low-level-calls
		(bool success, bytes memory returndata) = target.call{value: weiValue}(
			data
		);
		if (success) {
			return returndata;
		} else {
			// Look for revert reason and bubble it up if present
			if (returndata.length > 0) {
				// The easiest way to bubble the revert reason is using memory via assembly

				// solhint-disable-next-line no-inline-assembly
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

/**
 *  SourceUnit: Protonauts-monorepo/contracts/node_modules/.pnpm/[email protected]_yvvssclfcbeff5cufonczletku/node_modules/hardhat-deploy/solc_0.7/proxy/OptimizedTransparentUpgradeableProxy.sol
 */

////// ////-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity ^0.7.0;

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
	function _delegate(address implementation) internal {
		// solhint-disable-next-line no-inline-assembly
		assembly {
			// Copy msg.data. We take full control of memory in this inline assembly
			// block because it will not return to Solidity code. We overwrite the
			// Solidity scratch pad at memory position 0.
			calldatacopy(0, 0, calldatasize())

			// Call the implementation.
			// out and outsize are 0 because we don't know the size yet.
			let result := delegatecall(
				gas(),
				implementation,
				0,
				calldatasize(),
				0,
				0
			)

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
	function _fallback() internal {
		_beforeFallback();
		_delegate(_implementation());
	}

	/**
	 * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
	 * function in the contract matches the call data.
	 */
	fallback() external payable {
		_fallback();
	}

	/**
	 * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
	 * is empty.
	 */
	receive() external payable {
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

/**
 *  SourceUnit: Protonauts-monorepo/contracts/node_modules/.pnpm/[email protected]_yvvssclfcbeff5cufonczletku/node_modules/hardhat-deploy/solc_0.7/proxy/OptimizedTransparentUpgradeableProxy.sol
 */

////// ////-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity ^0.7.0;

//////import "./Proxy.sol";
//////import "../utils/Address.sol";

/**
 * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
 * implementation address that can be changed. This address is stored in storage in the location specified by
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
 * implementation behind the proxy.
 *
 * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
 * {TransparentUpgradeableProxy}.
 */
contract UpgradeableProxy is Proxy {
	/**
	 * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
	 *
	 * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
	 * function call, and allows initializating the storage of the proxy like a Solidity constructor.
	 */
	constructor(address _logic, bytes memory _data) payable {
		assert(
			_IMPLEMENTATION_SLOT ==
				bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
		);
		_setImplementation(_logic);
		if (_data.length > 0) {
			// solhint-disable-next-line avoid-low-level-calls
			(bool success, ) = _logic.delegatecall(_data);
			require(success);
		}
	}

	/**
	 * @dev Emitted when the implementation is upgraded.
	 */
	event Upgraded(address indexed implementation);

	/**
	 * @dev Storage slot with the address of the current implementation.
	 * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
	 * validated in the constructor.
	 */
	bytes32 private constant _IMPLEMENTATION_SLOT =
		0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

	/**
	 * @dev Returns the current implementation address.
	 */
	function _implementation() internal view override returns (address impl) {
		bytes32 slot = _IMPLEMENTATION_SLOT;
		// solhint-disable-next-line no-inline-assembly
		assembly {
			impl := sload(slot)
		}
	}

	/**
	 * @dev Upgrades the proxy to a new implementation.
	 *
	 * Emits an {Upgraded} event.
	 */
	function _upgradeTo(address newImplementation) internal {
		_setImplementation(newImplementation);
		emit Upgraded(newImplementation);
	}

	/**
	 * @dev Stores a new address in the EIP1967 implementation slot.
	 */
	function _setImplementation(address newImplementation) private {
		require(
			Address.isContract(newImplementation),
			'UpgradeableProxy: new implementation is not a contract'
		);

		bytes32 slot = _IMPLEMENTATION_SLOT;

		// solhint-disable-next-line no-inline-assembly
		assembly {
			sstore(slot, newImplementation)
		}
	}
}

/**
 *  SourceUnit: Protonauts-monorepo/contracts/node_modules/.pnpm/[email protected]_yvvssclfcbeff5cufonczletku/node_modules/hardhat-deploy/solc_0.7/proxy/OptimizedTransparentUpgradeableProxy.sol
 */

////// ////-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.7.0;

//////import "../openzeppelin/proxy/UpgradeableProxy.sol";

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
 * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
 */
contract OptimizedTransparentUpgradeableProxy is UpgradeableProxy {
	address internal immutable _ADMIN;

	/**
	 * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
	 * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
	 */
	constructor(
		address initialLogic,
		address initialAdmin,
		bytes memory _data
	) payable UpgradeableProxy(initialLogic, _data) {
		assert(
			_ADMIN_SLOT ==
				bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1)
		);
		bytes32 slot = _ADMIN_SLOT;

		_ADMIN = initialAdmin;

		// still store it to work with EIP-1967
		// solhint-disable-next-line no-inline-assembly
		assembly {
			sstore(slot, initialAdmin)
		}
	}

	/**
	 * @dev Storage slot with the admin of the contract.
	 * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
	 * validated in the constructor.
	 */
	bytes32 private constant _ADMIN_SLOT =
		0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

	/**
	 * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
	 */
	modifier ifAdmin() {
		if (msg.sender == _admin()) {
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
	function admin() external ifAdmin returns (address) {
		return _admin();
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
	function implementation() external ifAdmin returns (address) {
		return _implementation();
	}

	/**
	 * @dev Upgrade the implementation of the proxy.
	 *
	 * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
	 */
	function upgradeTo(address newImplementation) external ifAdmin {
		_upgradeTo(newImplementation);
	}

	/**
	 * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
	 * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
	 * proxied contract.
	 *
	 * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
	 */
	function upgradeToAndCall(address newImplementation, bytes calldata data)
		external
		payable
		ifAdmin
	{
		_upgradeTo(newImplementation);
		// solhint-disable-next-line avoid-low-level-calls
		(bool success, ) = newImplementation.delegatecall(data);
		require(success);
	}

	/**
	 * @dev Returns the current admin.
	 */
	function _admin() internal view returns (address adm) {
		return _ADMIN;
	}

	/**
	 * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
	 */
	function _beforeFallback() internal virtual override {
		require(
			msg.sender != _admin(),
			'TransparentUpgradeableProxy: admin cannot fallback to proxy target'
		);
		super._beforeFallback();
	}
}

// : MIT

pragma solidity >=0.6.0;

/// @title Base64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides functions for encoding/decoding base64
library Base64 {
    string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
                                            hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
                                            hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
                                            hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return '';

        // load the table into memory
        string memory table = TABLE_ENCODE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {} lt(dataPtr, endPtr) {}
            {
                // read 3 bytes
                dataPtr := add(dataPtr, 3)
                let input := mload(dataPtr)

                // write 4 characters
                mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }

        return result;
    }

    function decode(string memory _data) internal pure returns (bytes memory) {
        bytes memory data = bytes(_data);

        if (data.length == 0) return new bytes(0);
        require(data.length % 4 == 0, "invalid base64 decoder input");

        // load the table into memory
        bytes memory table = TABLE_DECODE;

        // every 4 characters represent 3 bytes
        uint256 decodedLen = (data.length / 4) * 3;

        // add some extra buffer at the end required for the writing
        bytes memory result = new bytes(decodedLen + 32);

        assembly {
            // padding with '='
            let lastBytes := mload(add(data, mload(data)))
            if eq(and(lastBytes, 0xFF), 0x3d) {
                decodedLen := sub(decodedLen, 1)
                if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
                    decodedLen := sub(decodedLen, 1)
                }
            }

            // set the actual output length
            mstore(result, decodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 4 characters at a time
            for {} lt(dataPtr, endPtr) {}
            {
               // read 4 characters
               dataPtr := add(dataPtr, 4)
               let input := mload(dataPtr)

               // write 3 bytes
               let output := add(
                   add(
                       shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
                       shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
                   add(
                       shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
                               and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
                    )
                )
                mstore(resultPtr, shl(232, output))
                resultPtr := add(resultPtr, 3)
            }
        }

        return result;
    }
}


// : MIT
pragma solidity ^0.8.6;

//import'../../common/BaseNFT.sol';

/// @title ISVG721 - Interface
/// @author CulturalSurround64<CulturalSurround64@gmail.com>(https://github.com/SurroundingArt64/)
/// @notice Describes common functions.
/// @dev Used in Tunnels, SVG721 and L2_SVG721
interface ISVG721 {
	/// @notice updates feature values in batches
	/// @param tokenId array of ids of tokens to update
	/// @param featureName names of features
	/// @param newValue updated value in uint256
	function updateFeatureValueBatch(
		uint256[] memory tokenId,
		string[] memory featureName,
		uint256[] memory newValue
	) external;

	/// @notice get name, desc, etc
	/// @param tokenId id of token to query for
	function metadata(uint256 tokenId)
		external
		view
		returns (IBaseNFT.Metadata memory m);

	/// @notice get attributes for token. Sent in attributes array.
	/// @param tokenId query for token id
	function getAttributes(uint256 tokenId)
		external
		view
		returns (string[] memory featureNames, uint256[] memory values);

	/// @notice publicly available notice
	function exists(uint256 tokenId) external view returns (bool);

	/// @notice set base metadata
	/// @param m see IBaseNFT.Metadata
	/// @param tokenId id of token to set for
	/// @dev should not be available to all. only Admin or Owner.
	function setMetadata(IBaseNFT.Metadata memory m, uint256 tokenId) external;

	/// @notice mint in incremental order
	/// @param to address to send to.
	/// @dev only admin
	function mint(address to) external returns (uint256);
}


// : MIT
pragma solidity ^0.8.6;

/// @title ITokenDescriptor - Interface
/// @author CulturalSurround64<CulturalSurround64@gmail.com>(https://github.com/SurroundingArt64/)
/// @notice Describes common for L1, L2 and Equipment descriptors.
interface ITokenDescriptor {
	/// @notice tokenURI
	/// @param tokenId id of token
	/// @param indices => indices of svg storage for that token. [0(inclusive), 3(exclusive)]
	function tokenURI(uint256 tokenId, uint256[2] memory indices)
		external
		view
		returns (string memory);
}


// give the contract some SVG Code
// output an NFT URI with this SVG code
// Storing all the NFT metadata on-chain

// : MIT
pragma solidity ^0.8.6;
//import'@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';

/// @title AccessControlUpgradeable
/// @author CulturalSurround64<CulturalSurround64@gmail.com>(https://github.com/SurroundingArt64/)
/// @notice Describes common functions.
/// @dev Multiple uses
contract AccessControlUpgradeable is OwnableUpgradeable {
	/// @notice is admin mapping
	mapping(address => bool) private _admins;

	event AdminAccessSet(address indexed admin, bool enabled);

	/// @param _admin address
	/// @param enabled set as Admin
	function _setAdmin(address _admin, bool enabled) internal {
		_admins[_admin] = enabled;
		emit AdminAccessSet(_admin, enabled);
	}

	/// @param __admins addresses
	/// @param enabled set as Admin
	function setAdmin(address[] memory __admins, bool enabled)
		external
		onlyOwner
	{
		for (uint256 index = 0; index < __admins.length; index++) {
			_setAdmin(__admins[index], enabled);
		}
	}

	/// @param _admin address
	function isAdmin(address _admin) public view returns (bool) {
		return _admins[_admin];
	}

	modifier onlyAdmin() {
		require(
			isAdmin(_msgSender()) || _msgSender() == owner(),
			'Caller does not have admin access'
		);
		_;
	}
}


// : MIT
// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}


// : MIT
pragma solidity ^0.8.6;
//import'@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol';
//import'./AccessControlWithUpdater.sol';
//import'./interfaces/IBaseNFT.sol';

/// @title BaseNFT
/// @author CulturalSurround64<CulturalSurround64@gmail.com>(https://github.com/SurroundingArt64/)
/// @notice Describes common functions.
/// @dev Base ERC721 contract for l1 and l2 SVG721
abstract contract BaseNFT is AccessControlWithUpdater, IBaseNFT {
	using CountersUpgradeable for CountersUpgradeable.Counter;

	CountersUpgradeable.Counter public tokenIds;

	/// @notice total features(attributes in Opensea) of the NFT.
	uint256 public numFeatures;

	/// @dev when querying the token descriptor(for tokenURI) if indices are not set default ones are used. defaults to [0,3]
	uint256[2] public defaultIndices;

	/// @notice names of features(attributes in Opensea) for an index
	mapping(uint256 => string) public featureNames;
	/// @notice values of features(attributes in Opensea) for an index
	mapping(uint256 => mapping(string => uint256)) public values;

	/// @notice default value of all features. defaults to 1. check initialize.
	uint256 public defaultValue;

	/// @notice saved metadata for a tokenId. Returns default name and description if not set.
	mapping(uint256 => Metadata) internal _metadata;

	/// @notice query indices for image. Used to generate parts of SVG. defaults to defaultIndices
	mapping(uint256 => uint256[2]) internal _tokenIndices;

	/// @notice address of tokenDescriptor which generates and stores the SVG and tokenURI for Protonaut.
	address public tokenDescriptor;

	/// @notice default name in metadata
	string public defaultName;

	/// @notice default description in metadata
	string public defaultDescription;

	event SetNumFeatures(uint256 numFeatures);
	event UpdateFeatures(
		uint256 indexed tokenId,
		string featureName,
		uint256 oldValue,
		uint256 newValue
	);
	event SetTokenDescriptor(address tokenDescriptor);
	event SetFeatureName(uint256 index, bytes32 name);
	event SetTokenIndices(uint256 indexed tokenId, uint256 start, uint256 end);

	/// @param __tokenDescriptor address
	function setTokenDescriptor(address __tokenDescriptor)
		public
		override
		onlyAdmin
	{
		tokenDescriptor = __tokenDescriptor;
		emit SetTokenDescriptor(tokenDescriptor);
	}

	/// @param _defaultName string
	/// @param _defaultDescription string
	function setDefaults(
		string memory _defaultName,
		string memory _defaultDescription
	) public override onlyAdmin {
		defaultName = _defaultName;
		defaultDescription = _defaultDescription;
	}

	/// @param _numFeatures number
	function setNumFeatures(uint256 _numFeatures) external override onlyAdmin {
		numFeatures = _numFeatures;
		emit SetNumFeatures(numFeatures);
	}

	/// @param indices number[]
	/// @param _featureNames string[]
	/// @notice update name of attribute
	function setFeatureNameBatch(
		uint256[] memory indices,
		string[] memory _featureNames
	) external override onlyAdmin {
		require(indices.length == _featureNames.length, 'Length mismatch');
		for (uint256 index = 0; index < _featureNames.length; index++) {
			require(
				indices[index] < numFeatures,
				'Index should be less than numFeatures'
			);
			featureNames[indices[index]] = _featureNames[index];
			emit SetFeatureName(
				indices[index],
				keccak256(bytes(_featureNames[index]))
			);
		}
	}

	/// @param tokenId id of the token
	/// @param indices query indices for TokenDescriptor
	function setTokenIndices(uint256 tokenId, uint256[2] memory indices)
		public
		override
		onlyUpdateAdmin
	{
		require(exists(tokenId), 'Query for non-existent token');
		_tokenIndices[tokenId] = indices;
		emit SetTokenIndices(tokenId, indices[0], indices[1]);
	}

	/// @param tokenId number
	/// @notice returns base metadata, name, desc. Returns default if none exist.
	function metadata(uint256 tokenId)
		public
		view
		virtual
		override
		returns (Metadata memory m)
	{
		require(exists(tokenId), 'Query for non-existent token');
		m = _metadata[tokenId];
		if (bytes(m.name).length > 0) {
			return m;
		} else {
			return Metadata(defaultName, defaultDescription);
		}
	}

	// VIEW
	/// @notice total minted tokens.
	/// @dev warning doesn't take in account of burnt tokens as burn is disabled. Also, doesn't check locked in L1Tunnel.
	function totalSupply() public view returns (uint256) {
		return tokenIds.current();
	}

	/// @notice get attributes(features)
	/// @param tokenId id of the token
	function getAttributes(uint256 tokenId)
		public
		view
		virtual
		override
		returns (string[] memory featureNamesArr, uint256[] memory valuesArr)
	{
		require(exists(tokenId), 'Query for non-existent token');
		featureNamesArr = new string[](numFeatures);
		valuesArr = new uint256[](numFeatures);

		for (uint256 i = 0; i < numFeatures; i++) {
			featureNamesArr[i] = featureNames[i];
			valuesArr[i] = values[tokenId][featureNamesArr[i]];
			if (valuesArr[i] == 0) {
				valuesArr[i] = defaultValue;
			}
		}
	}

	/// @param m Metadata
	/// @param tokenId id of the token
	function setMetadata(Metadata memory m, uint256 tokenId)
		public
		virtual
		override
		onlyAdmin
	{
		require(exists(tokenId), 'Query for non-existent token');
		_metadata[tokenId] = m;
	}

	///	@param _tokenIds tokenIds to update for
	///	@param _featureNames name of feature to update for
	///	@param _newValues new value for update
	function updateFeatureValueBatch(
		uint256[] memory _tokenIds,
		string[] memory _featureNames,
		uint256[] memory _newValues
	) public virtual override onlyUpdateAdmin {
		for (uint256 index = 0; index < _tokenIds.length; index++) {
			require(exists(_tokenIds[index]), 'Query for non-existent token');
			uint256 oldValue = values[_tokenIds[index]][_featureNames[index]];

			values[_tokenIds[index]][_featureNames[index]] = _newValues[index];

			emit UpdateFeatures(
				_tokenIds[index],
				_featureNames[index],
				oldValue,
				_newValues[index]
			);
		}
	}

	/// @notice get feature value for a feature name like feature(1,"Health")
	/// @param tokenId id of the token
	/// @param featureName name of feature
	function feature(uint256 tokenId, string memory featureName)
		external
		view
		returns (uint256)
	{
		require(exists(tokenId), 'Query for non-existent token');
		if (values[tokenId][featureName] == 0) {
			return defaultValue;
		}
		return values[tokenId][featureName];
	}

	/// @param _indices number[]
	function setDefaultIndices(uint256[2] memory _indices) external onlyAdmin {
		defaultIndices[0] = _indices[0];
		defaultIndices[1] = _indices[1];
	}

	/// @param _value number. default to 1 in initializer.
	function setDefaultValuesForFeatures(uint256 _value) public onlyAdmin {
		defaultValue = _value;
	}

	/// @param tokenId id of token
	/// @notice need to override in 721. Requires `ERC721._exists`
	function exists(uint256 tokenId)
		public
		view
		virtual
		override
		returns (bool);

	/**
		@dev space reserved for inheritance
	 */
	uint256[49] private __gap;
}


// : MIT
// OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)

pragma solidity ^0.8.0;

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */
library CountersUpgradeable {
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


// : MIT
pragma solidity ^0.8.6;

//import'./AccessControlUpgradeable.sol';

/// @title AccessControlWithUpdater
/// @author CulturalSurround64<CulturalSurround64@gmail.com>(https://github.com/SurroundingArt64/)
/// @notice Describes common functions.
/// @dev Multiple uses. Used for second admin access. Granted only to contract(?)
contract AccessControlWithUpdater is AccessControlUpgradeable {
	mapping(address => bool) private _updateAdmins;

	event UpdateAccessSet(address indexed updateAdmin, bool enabled);

	/// @notice add/remove update admin
	/// @param _updateAdmin address
	/// @param enabled set as Admin?
	function setUpdateAccess(address _updateAdmin, bool enabled)
		external
		onlyOwner
	{
		_updateAdmins[_updateAdmin] = enabled;
		emit AdminAccessSet(_updateAdmin, enabled);
	}

	/// @notice check update admin status
	/// @param _admin address
	function isUpdateAdmin(address _admin) public view returns (bool) {
		return _updateAdmins[_admin];
	}

	modifier onlyUpdateAdmin() {
		require(
			isUpdateAdmin(_msgSender()) ||
				isAdmin(_msgSender()) ||
				_msgSender() == owner(),
			'Caller does not have admin access'
		);
		_;
	}
}


// : MIT
pragma solidity ^0.8.6;

/// @title IBaseNFT - Interface
/// @author CulturalSurround64<CulturalSurround64@gmail.com>(https://github.com/SurroundingArt64/)
/// @notice Describes common functions.
/// @dev Used in BaseNFT, SVG721 and L2_SVG721
abstract contract IBaseNFT {
	/** 
		@notice Stores Metadata for the NFT
		@dev Stored in mapping of tokenId => Metadata. Defaults to defaultMetadata.
	 */
	struct Metadata {
		string name;
		string description;
	}

	/** 
		@notice tokenURI is fetched from token descriptor contract
		@dev This is used to generate tokenURI on the fly
	 	@param __tokenDescriptor address of token descriptor contract
	*/
	function setTokenDescriptor(address __tokenDescriptor) public virtual;

	/** 
		@notice Sets default metadata name and description.
		@param _defaultName default name field
		@param _defaultDescription default description field
	*/
	function setDefaults(
		string memory _defaultName,
		string memory _defaultDescription
	) public virtual;

	/**
		@notice Set number of features
		@param _numFeatures total features available
	*/
	function setNumFeatures(uint256 _numFeatures) external virtual;

	/**
		@notice set feature names for idx
		@dev this should set after deployment and shouldn't be changes unless required or more are added.
		@param indices index
		@param _featureNames name of feature
	 */
	function setFeatureNameBatch(
		uint256[] memory indices,
		string[] memory _featureNames
	) external virtual;

	/**
		@notice values provided to tokenURI to get image data by SVG contract
		@dev token index to query. If Image is at index 0 to 3, indices will be [0,3]
		@dev Image data is too big to be stored in single transaction. So, multiple are required.

		@param tokenId token id for which to set
		@param indices Values to query.
	 */
	function setTokenIndices(uint256 tokenId, uint256[2] memory indices)
		public
		virtual;

	/**
		@notice query the metadata for a tokenId. Returns name and symbol

		@param tokenId token id to query for
		@return m Metadata {name and description}
	*/
	function metadata(uint256 tokenId)
		public
		view
		virtual
		returns (Metadata memory m);

	/**
		@notice query the metadata for a tokenId. Returns name and symbol

		@param tokenId token id to query for
		@return featureNamesArr list of features
		@return valuesArr list of values for a given feature
	*/
	function getAttributes(uint256 tokenId)
		public
		view
		virtual
		returns (string[] memory featureNamesArr, uint256[] memory valuesArr);

	function setMetadata(Metadata memory m, uint256 tokenId) public virtual;

	/**
		@notice update feature value

		@param _tokenIds tokenIds to update for
		@param _featureNames name of feature to update for
		@param _newValues new value for update 
	 */
	function updateFeatureValueBatch(
		uint256[] memory _tokenIds,
		string[] memory _featureNames,
		uint256[] memory _newValues
	) public virtual;

	/**
		@notice query the existence for a tokenId
		
		@param tokenId token id to query for
		@return bool true if exists
	*/
	function exists(uint256 tokenId) public view virtual returns (bool);

	/**
		@dev space reserved
	 */
	uint256[49] private __gap;
}


// : MIT
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

//import"../utils/ContextUpgradeable.sol";
//import"../proxy/utils/Initializable.sol";

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
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
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


// : MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;
//import"../proxy/utils/Initializable.sol";

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


// : MIT
// OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.0;

//import"../../utils/AddressUpgradeable.sol";

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
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
 * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
 * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() initializer {}
 * ```
 * ====
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
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
        // contract may have been reentered.
        require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");

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

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} modifier, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}


// : MIT
// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)

pragma solidity ^0.8.1;

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
        return verifyCallResult(success, returndata, errorMessage);
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
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
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


// : MIT
pragma solidity ^0.8.6;
//import'base64-sol/base64.sol';

//import'../l1/interfaces/ISVG721.sol';
//import'./interfaces/ITokenDescriptor.sol';
//import'../common/AccessControlUpgradeable.sol';

//import'@openzeppelin/contracts/utils/Strings.sol';

/// @title TokenDescriptor
/// @author CulturalSurround64<CulturalSurround64@gmail.com>(https://github.com/SurroundingArt64/)
/// @notice Describes common functions for TokenDescriptor
/// @dev Query the json token data from the SVG721 contract.
contract TokenDescriptor is ITokenDescriptor, AccessControlUpgradeable {
	using Strings for uint256;

	ISVG721 public SVG721;
	event SVG721Set(address indexed _SVG721);

	mapping(uint256 => string) public svgSprites;
	uint256 public numberOfSprites;

	function initialize() public initializer {
		__Ownable_init();
	}

	/// @param _SVG721 address of Svg721 contract
	function setSVG721(address _SVG721) external onlyOwner {
		SVG721 = ISVG721(_SVG721);
		emit SVG721Set(_SVG721);
	}

	/// @param _numberOfSprites number of sprites
	function setSVGSprites(uint256 _numberOfSprites) external onlyAdmin {
		numberOfSprites = _numberOfSprites;
	}

	/// @param _index index of sprite
	/// @param _sprite svg sprite part
	function setSVGSprite(uint256 _index, string memory _sprite)
		external
		onlyAdmin
	{
		svgSprites[_index] = _sprite;
	}

	// VIEW FUNCTIONS
	/// @param tokenId id of the token to query for
	/// @param indices indices to query for
	function tokenURI(uint256 tokenId, uint256[2] memory indices)
		external
		view
		override
		returns (string memory)
	{
		IBaseNFT.Metadata memory m = SVG721.metadata(tokenId);
		string memory baseURL = 'data:application/json;base64,';
		return
			string(
				abi.encodePacked(
					baseURL,
					Base64.encode(
						bytes(
							abi.encodePacked(
								'{"name": "',
								m.name,
								' #',
								tokenId.toString(),
								'",',
								'"description": "',
								m.description,
								'",',
								'"attributes": ',
								attributes(tokenId),
								',',
								'"image": "',
								imageURI(tokenId, indices),
								'"}'
							)
						)
					)
				)
			);
	}

	/// @param indices indices to query for
	/// @dev independent of tokenId but kept in as first arg for consistency
	function imageURI(uint256, uint256[2] memory indices)
		public
		view
		virtual
		returns (string memory image)
	{
		bytes memory b;
		for (uint256 i = indices[0]; i < indices[1]; i++) {
			// concatenate to return string with abi encode
			b = abi.encodePacked(b, svgSprites[i]);
		}
		if (b.length > 0) b = abi.encodePacked(b, '</svg>');
		return
			string(
				abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(b))
			);
	}

	/// @param tokenId id of the token to query for
	/// @dev returns a string of attributes in Opensea Standard format
	function attributes(uint256 tokenId)
		public
		view
		returns (string memory returnAttributes)
	{
		bytes memory b = abi.encodePacked('[');
		(string[] memory featureNames, uint256[] memory values) = SVG721
			.getAttributes(tokenId);
		for (uint256 index = 0; index < featureNames.length; index++) {
			b = abi.encodePacked(
				b,
				'{"trait_type": "',
				featureNames[index],
				'",',
				'"value": "',
				values[index].toString(),
				'","display_type": "number"}'
			);
			if (index != featureNames.length - 1) {
				b = abi.encodePacked(b, ',');
			}
		}
		b = abi.encodePacked(b, ']');
		returnAttributes = string(b);
	}
}



}
