/**
 *Submitted for verification at Etherscan.io on 2020-10-09
 */

// ////-License-Identifier: MIT

pragma solidity ^0.6.2;

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
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}

/**
 * @title Proxy
 * @dev Implements delegation of calls to other contracts, with proper
 * forwarding of return values and bubbling of failures.
 * It defines a fallback function that delegates all calls to the address
 * returned by the abstract _implementation() internal function.
 */
abstract contract Proxy {
    /**
     * @dev Fallback function.
     * Implemented entirely in `_fallback`.
     */
    fallback() external payable {
        _fallback();
    }

    /**
     * @dev Receive function.
     * Implemented entirely in `_fallback`.
     */
    receive() external payable {
        _fallback();
    }

    /**
     * @return The Address of the implementation.
     */
    function _implementation() internal view virtual returns (address);

    /**
     * @dev Delegates execution to an implementation contract.
     * This is a low level function that doesn't return to its internal call site.
     * It will return to the external caller whatever the implementation returns.
     * @param implementation Address to delegate.
     */
    function _delegate(address implementation) internal {
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
     * @dev Function that is run as the first thing in the fallback function.
     * Can be redefined in derived contracts to add functionality.
     * Redefinitions must call super._willFallback().
     */
    function _willFallback() internal virtual {}

    /**
     * @dev fallback implementation.
     * Extracted to enable manual triggering.
     */
    function _fallback() internal {
        _willFallback();
        _delegate(_implementation());
    }
}

/**
 * @title UpgradeabilityProxy
 * @dev This contract implements a proxy that allows to change the
 * implementation address to which it will delegate.
 * Such a change is called an implementation upgrade.
 */
contract UpgradeabilityProxy is Proxy {
    /**
     * @dev Contract constructor.
     * @param _logic Address of the initial implementation.
     * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
     * It should include the signature and the parameters of the function to be called, as described in
     * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
     * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
     */
    constructor(address _logic, bytes memory _data) public payable {
        assert(
            IMPLEMENTATION_SLOT ==
                bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
        );
        _setImplementation(_logic);
        if (_data.length > 0) {
            (bool success, ) = _logic.delegatecall(_data);
            require(success);
        }
    }

    /**
     * @dev Emitted when the implementation is upgraded.
     * @param implementation Address of the new implementation.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Returns the current implementation.
     * @return impl Address of the current implementation
     */
    function _implementation() internal view override returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }

    /**
     * @dev Upgrades the proxy to a new implementation.
     * @param newImplementation Address of the new implementation.
     */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
     * @dev Sets the implementation address of the proxy.
     * @param newImplementation Address of the new implementation.
     */
    function _setImplementation(address newImplementation) internal {
        require(
            Address.isContract(newImplementation),
            "Cannot set a proxy implementation to a non-contract address"
        );

        bytes32 slot = IMPLEMENTATION_SLOT;

        assembly {
            sstore(slot, newImplementation)
        }
    }
}

/**
 * @title AdminUpgradeabilityProxy
 * @dev This contract combines an upgradeability proxy with an authorization
 * mechanism for administrative tasks.
 * All external functions in this contract must be guarded by the
 * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
 * feature proposal that would enable this to be done automatically.
 */
contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
    /**
     * Contract constructor.
     * @param _logic address of the initial implementation.
     * @param _admin Address of the proxy administrator.
     * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
     * It should include the signature and the parameters of the function to be called, as described in
     * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
     * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
     */
    constructor(
        address _logic,
        address _admin,
        bytes memory _data
    ) public payable UpgradeabilityProxy(_logic, _data) {
        assert(
            ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
        );
        _setAdmin(_admin);
    }

    /**
     * @dev Emitted when the administration has been transferred.
     * @param previousAdmin Address of the previous admin.
     * @param newAdmin Address of the new admin.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
     * validated in the constructor.
     */

    bytes32 internal constant ADMIN_SLOT =
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Modifier to check whether the `msg.sender` is the admin.
     * If it is, it will run the function. Otherwise, it will delegate the call
     * to the implementation.
     */
    modifier ifAdmin() {
        if (msg.sender == _admin()) {
            _;
        } else {
            _fallback();
        }
    }

    /**
     * @return The address of the proxy admin.
     */
    function admin() external ifAdmin returns (address) {
        return _admin();
    }

    /**
     * @return The address of the implementation.
     */
    function implementation() external ifAdmin returns (address) {
        return _implementation();
    }

    /**
     * @dev Changes the admin of the proxy.
     * Only the current admin can call this function.
     * @param newAdmin Address to transfer proxy administration to.
     */
    function changeAdmin(address newAdmin) external ifAdmin {
        require(
            newAdmin != address(0),
            "Cannot change the admin of a proxy to the zero address"
        );
        emit AdminChanged(_admin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev Upgrade the backing implementation of the proxy.
     * Only the admin can call this function.
     * @param newImplementation Address of the new implementation.
     */
    function upgradeTo(address newImplementation) external ifAdmin {
        _upgradeTo(newImplementation);
    }

    /**
     * @dev Upgrade the backing implementation of the proxy and call a function
     * on the new implementation.
     * This is useful to initialize the proxied contract.
     * @param newImplementation Address of the new implementation.
     * @param data Data to send as msg.data in the low level call.
     * It should include the signature and the parameters of the function to be called, as described in
     * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
     */
    function upgradeToAndCall(address newImplementation, bytes calldata data)
        external
        payable
        ifAdmin
    {
        _upgradeTo(newImplementation);
        (bool success, ) = newImplementation.delegatecall(data);
        require(success);
    }

    /**
     * @return adm The admin slot.
     */
    function _admin() internal view returns (address adm) {
        bytes32 slot = ADMIN_SLOT;
        assembly {
            adm := sload(slot)
        }
    }

    /**
     * @dev Sets the address of the proxy admin.
     * @param newAdmin Address of the new proxy admin.
     */
    function _setAdmin(address newAdmin) internal {
        bytes32 slot = ADMIN_SLOT;

        assembly {
            sstore(slot, newAdmin)
        }
    }

    /**
     * @dev Only fall back when the sender is not the admin.
     */
    function _willFallback() internal virtual override {
        require(
            msg.sender != _admin(),
            "Cannot call fallback function from the proxy admin"
        );
        super._willFallback();
    }
}

// : MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}


// : MIT

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMathUpgradeable {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


// : MIT

pragma solidity ^0.6.2;

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
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
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
                "Address: low-level call with value failed"
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
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) =
            target.call{value: weiValue}(data);
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


// : MIT

pragma solidity ^0.6.0;

//import"IERC20Upgradeable.sol";
//import"SafeMathUpgradeable.sol";
//import"AddressUpgradeable.sol";

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20Upgradeable {
    using SafeMathUpgradeable for uint256;
    using AddressUpgradeable for address;

    function safeTransfer(
        IERC20Upgradeable token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20Upgradeable token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20Upgradeable token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20Upgradeable token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance =
            token.allowance(address(this), spender).add(value);
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20Upgradeable token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance =
            token.allowance(address(this), spender).sub(
                value,
                "SafeERC20: decreased allowance below zero"
            );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20Upgradeable token, bytes memory data)
        private
    {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata =
            address(token).functionCall(
                data,
                "SafeERC20: low-level call failed"
            );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}


// : MIT

pragma solidity ^0.6.0;
//import"Initializable.sol";

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
contract ReentrancyGuardUpgradeable is Initializable {
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

    function __ReentrancyGuard_init() internal initializer {
        __ReentrancyGuard_init_unchained();
    }

    function __ReentrancyGuard_init_unchained() internal initializer {
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
    uint256[49] private __gap;
}


// : MIT

pragma solidity >=0.4.24 <0.7.0;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
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
        require(
            _initializing || _isConstructor() || !_initialized,
            "Initializable: contract is already initialized"
        );

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

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            cs := extcodesize(self)
        }
        return cs == 0;
    }
}


// : MIT

pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;

interface ISettV4 {
    function deposit(uint256 _amount) external;

    function depositFor(address _recipient, uint256 _amount) external;

    function withdraw(uint256 _amount) external;

    function balance() external view returns (uint256);

    function getPricePerFullShare() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    
}


// : MIT
pragma solidity >=0.5.0 <0.8.0;

interface IController {
    function withdraw(address, uint256) external;

    function strategies(address) external view returns (address);

    function balanceOf(address) external view returns (uint256);

    function earn(address, uint256) external;

    function want(address) external view returns (address);

    function rewards() external view returns (address);

    function vaults(address) external view returns (address);
}


// : MIT
pragma solidity 0.6.12;

interface ICvxLocker {
    function maximumBoostPayment() external view returns (uint256);

    function lock(
        address _account,
        uint256 _amount,
        uint256 _spendRatio
    ) external;

    function getReward(address _account, bool _stake) external;

    //BOOSTED balance of an account which only includes properly locked tokens as of the most recent eligible epoch
    function balanceOf(address _user) external view returns (uint256 amount);

    // total token balance of an account, including unlocked but not withdrawn tokens
    function lockedBalanceOf(address _user)
        external
        view
        returns (uint256 amount);

    // Withdraw/relock all currently locked tokens where the unlock time has passed
    function processExpiredLocks(
        bool _relock,
        uint256 _spendRatio,
        address _withdrawTo
    ) external;

    // Withdraw/relock all currently locked tokens where the unlock time has passed
    function processExpiredLocks(bool _relock) external;
}


// : MIT
pragma solidity 0.6.12;

interface ICVXBribes {
    function getReward(address _account, address _token) external;
    function getRewards(address _account, address[] calldata _tokens) external;
}

// : MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

interface IVotiumBribes {
    struct claimParam {
        address token;
        uint256 index;
        uint256 amount;
        bytes32[] merkleProof;
    }

    function claimMulti(address account, claimParam[] calldata claims) external;
    function claim(address token, uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
}

// : MIT
pragma solidity 0.6.12;

interface IBribesProcessor {
  function notifyNewRound() external;
}

// : MIT
pragma solidity 0.6.12;

///@dev Snapshot Delegate registry so we can delegate voting to XYZ
interface IDelegateRegistry {
    function setDelegate(bytes32 id, address delegate) external;

    function delegation(address, bytes32) external returns (address);
}


// : MIT
pragma solidity 0.6.12;

interface ICurvePool {
  function exchange(
    int128 i,
    int128 j,
    uint256 _dx,
    uint256 _min_dy
  ) external returns (uint256);
}

// : MIT

pragma solidity ^0.6.11;

//import"IERC20Upgradeable.sol";
//import"SafeMathUpgradeable.sol";
//import"MathUpgradeable.sol";
//import"AddressUpgradeable.sol";
//import"PausableUpgradeable.sol";
//import"SafeERC20Upgradeable.sol";
//import"Initializable.sol";
//import"IUniswapRouterV2.sol";
//import"IController.sol";
//import"IStrategy.sol";

//import"SettAccessControl.sol";

/*
    ===== Badger Base Strategy =====
    Common base class for all Sett strategies

    Changelog
    V1.1
    - Verify amount unrolled from strategy positions on withdraw() is within a threshold relative to the requested amount as a sanity check
    - Add version number which is displayed with baseStrategyVersion(). If a strategy does not implement this function, it can be assumed to be 1.0

    V1.2
    - Remove idle want handling from base withdraw() function. This should be handled as the strategy sees fit in _withdrawSome()
*/
abstract contract BaseStrategy is PausableUpgradeable, SettAccessControl {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using SafeMathUpgradeable for uint256;

    event Withdraw(uint256 amount);
    event WithdrawAll(uint256 balance);
    event WithdrawOther(address token, uint256 amount);
    event SetStrategist(address strategist);
    event SetGovernance(address governance);
    event SetController(address controller);
    event SetWithdrawalFee(uint256 withdrawalFee);
    event SetPerformanceFeeStrategist(uint256 performanceFeeStrategist);
    event SetPerformanceFeeGovernance(uint256 performanceFeeGovernance);
    event Harvest(uint256 harvested, uint256 indexed blockNumber);
    event Tend(uint256 tended);

    address public want; // Want: Curve.fi renBTC/wBTC (crvRenWBTC) LP token

    uint256 public performanceFeeGovernance;
    uint256 public performanceFeeStrategist;
    uint256 public withdrawalFee;

    uint256 public constant MAX_FEE = 10000;
    address public constant uniswap =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap Dex

    address public controller;
    address public guardian;

    uint256 public withdrawalMaxDeviationThreshold;

    function __BaseStrategy_init(
        address _governance,
        address _strategist,
        address _controller,
        address _keeper,
        address _guardian
    ) public initializer whenNotPaused {
        __Pausable_init();
        governance = _governance;
        strategist = _strategist;
        keeper = _keeper;
        controller = _controller;
        guardian = _guardian;
        withdrawalMaxDeviationThreshold = 50;
    }

    // ===== Modifiers =====

    function _onlyController() internal view {
        require(msg.sender == controller, "onlyController");
    }

    function _onlyAuthorizedActorsOrController() internal view {
        require(
            msg.sender == keeper ||
                msg.sender == governance ||
                msg.sender == controller,
            "onlyAuthorizedActorsOrController"
        );
    }

    function _onlyAuthorizedPausers() internal view {
        require(
            msg.sender == guardian || msg.sender == governance,
            "onlyPausers"
        );
    }

    /// ===== View Functions =====
    function baseStrategyVersion() public view returns (string memory) {
        return "1.2";
    }

    /// @notice Get the balance of want held idle in the Strategy
    function balanceOfWant() public view returns (uint256) {
        return IERC20Upgradeable(want).balanceOf(address(this));
    }

    /// @notice Get the total balance of want realized in the strategy, whether idle or active in Strategy positions.
    function balanceOf() public view virtual returns (uint256) {
        return balanceOfWant().add(balanceOfPool());
    }

    function isTendable() public view virtual returns (bool) {
        return false;
    }

    /// ===== Permissioned Actions: Governance =====

    function setGuardian(address _guardian) external {
        _onlyGovernance();
        guardian = _guardian;
    }

    function setWithdrawalFee(uint256 _withdrawalFee) external {
        _onlyGovernance();
        require(
            _withdrawalFee <= MAX_FEE,
            "base-strategy/excessive-withdrawal-fee"
        );
        withdrawalFee = _withdrawalFee;
    }

    function setPerformanceFeeStrategist(uint256 _performanceFeeStrategist)
        external
    {
        _onlyGovernance();
        require(
            _performanceFeeStrategist <= MAX_FEE,
            "base-strategy/excessive-strategist-performance-fee"
        );
        performanceFeeStrategist = _performanceFeeStrategist;
    }

    function setPerformanceFeeGovernance(uint256 _performanceFeeGovernance)
        external
    {
        _onlyGovernance();
        require(
            _performanceFeeGovernance <= MAX_FEE,
            "base-strategy/excessive-governance-performance-fee"
        );
        performanceFeeGovernance = _performanceFeeGovernance;
    }

    function setController(address _controller) external {
        _onlyGovernance();
        controller = _controller;
    }

    function setWithdrawalMaxDeviationThreshold(uint256 _threshold) external {
        _onlyGovernance();
        require(
            _threshold <= MAX_FEE,
            "base-strategy/excessive-max-deviation-threshold"
        );
        withdrawalMaxDeviationThreshold = _threshold;
    }

    function deposit() public virtual whenNotPaused {
        _onlyAuthorizedActorsOrController();
        uint256 _want = IERC20Upgradeable(want).balanceOf(address(this));
        if (_want > 0) {
            _deposit(_want);
        }
        _postDeposit();
    }

    // ===== Permissioned Actions: Controller =====

    /// @notice Controller-only function to Withdraw partial funds, normally used with a vault withdrawal
    function withdrawAll()
        external
        virtual
        whenNotPaused
        returns (uint256 balance)
    {
        _onlyController();

        _withdrawAll();

        _transferToVault(IERC20Upgradeable(want).balanceOf(address(this)));
    }

    /// @notice Withdraw partial funds from the strategy, unrolling from strategy positions as necessary
    /// @notice Processes withdrawal fee if present
    /// @dev If it fails to recover sufficient funds (defined by withdrawalMaxDeviationThreshold), the withdrawal should fail so that this unexpected behavior can be investigated
    function withdraw(uint256 _amount) external virtual whenNotPaused {
        _onlyController();

        // Withdraw from strategy positions, typically taking from any idle want first.
        _withdrawSome(_amount);
        uint256 _postWithdraw =
            IERC20Upgradeable(want).balanceOf(address(this));

        // Sanity check: Ensure we were able to retrieve sufficent want from strategy positions
        // If we end up with less than the amount requested, make sure it does not deviate beyond a maximum threshold
        if (_postWithdraw < _amount) {
            uint256 diff = _diff(_amount, _postWithdraw);

            // Require that difference between expected and actual values is less than the deviation threshold percentage
            require(
                diff <=
                    _amount.mul(withdrawalMaxDeviationThreshold).div(MAX_FEE),
                "base-strategy/withdraw-exceed-max-deviation-threshold"
            );
        }

        // Return the amount actually withdrawn if less than amount requested
        uint256 _toWithdraw = MathUpgradeable.min(_postWithdraw, _amount);

        // Process withdrawal fee
        uint256 _fee = _processWithdrawalFee(_toWithdraw);

        // Transfer remaining to Vault to handle withdrawal
        _transferToVault(_toWithdraw.sub(_fee));
    }

    // NOTE: must exclude any tokens used in the yield
    // Controller role - withdraw should return to Controller
    function withdrawOther(address _asset)
        external
        virtual
        whenNotPaused
        returns (uint256 balance)
    {
        _onlyController();
        _onlyNotProtectedTokens(_asset);

        balance = IERC20Upgradeable(_asset).balanceOf(address(this));
        IERC20Upgradeable(_asset).safeTransfer(controller, balance);
    }

    /// ===== Permissioned Actions: Authoized Contract Pausers =====

    function pause() external {
        _onlyAuthorizedPausers();
        _pause();
    }

    function unpause() external {
        _onlyGovernance();
        _unpause();
    }

    /// ===== Internal Helper Functions =====

    /// @notice If withdrawal fee is active, take the appropriate amount from the given value and transfer to rewards recipient
    /// @return The withdrawal fee that was taken
    function _processWithdrawalFee(uint256 _amount) internal returns (uint256) {
        if (withdrawalFee == 0) {
            return 0;
        }

        uint256 fee = _amount.mul(withdrawalFee).div(MAX_FEE);
        IERC20Upgradeable(want).safeTransfer(
            IController(controller).rewards(),
            fee
        );
        return fee;
    }

    /// @dev Helper function to process an arbitrary fee
    /// @dev If the fee is active, transfers a given portion in basis points of the specified value to the recipient
    /// @return The fee that was taken
    function _processFee(
        address token,
        uint256 amount,
        uint256 feeBps,
        address recipient
    ) internal returns (uint256) {
        if (feeBps == 0) {
            return 0;
        }
        uint256 fee = amount.mul(feeBps).div(MAX_FEE);
        IERC20Upgradeable(token).safeTransfer(recipient, fee);
        return fee;
    }

    /// @dev Reset approval and approve exact amount
    function _safeApproveHelper(
        address token,
        address recipient,
        uint256 amount
    ) internal {
        IERC20Upgradeable(token).safeApprove(recipient, 0);
        IERC20Upgradeable(token).safeApprove(recipient, amount);
    }

    function _transferToVault(uint256 _amount) internal {
        address _vault = IController(controller).vaults(address(want));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20Upgradeable(want).safeTransfer(_vault, _amount);
    }

    /// @notice Swap specified balance of given token on Uniswap with given path
    function _swap(
        address startToken,
        uint256 balance,
        address[] memory path
    ) internal {
        _safeApproveHelper(startToken, uniswap, balance);
        IUniswapRouterV2(uniswap).swapExactTokensForTokens(
            balance,
            0,
            path,
            address(this),
            now
        );
    }

    function _swapEthIn(uint256 balance, address[] memory path) internal {
        IUniswapRouterV2(uniswap).swapExactETHForTokens{value: balance}(
            0,
            path,
            address(this),
            now
        );
    }

    function _swapEthOut(
        address startToken,
        uint256 balance,
        address[] memory path
    ) internal {
        _safeApproveHelper(startToken, uniswap, balance);
        IUniswapRouterV2(uniswap).swapExactTokensForETH(
            balance,
            0,
            path,
            address(this),
            now
        );
    }

    /// @notice Add liquidity to uniswap for specified token pair, utilizing the maximum balance possible
    function _add_max_liquidity_uniswap(address token0, address token1)
        internal
        virtual
    {
        uint256 _token0Balance =
            IERC20Upgradeable(token0).balanceOf(address(this));
        uint256 _token1Balance =
            IERC20Upgradeable(token1).balanceOf(address(this));

        _safeApproveHelper(token0, uniswap, _token0Balance);
        _safeApproveHelper(token1, uniswap, _token1Balance);

        IUniswapRouterV2(uniswap).addLiquidity(
            token0,
            token1,
            _token0Balance,
            _token1Balance,
            0,
            0,
            address(this),
            block.timestamp
        );
    }

    /// @notice Utility function to diff two numbers, expects higher value in first position
    function _diff(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a >= b, "diff/expected-higher-number-in-first-position");
        return a.sub(b);
    }

    // ===== Abstract Functions: To be implemented by specific Strategies =====

    /// @dev Internal deposit logic to be implemented by Stratgies
    function _deposit(uint256 _amount) internal virtual;

    function _postDeposit() internal virtual {
        //no-op by default
    }

    /// @notice Specify tokens used in yield process, should not be available to withdraw via withdrawOther()
    function _onlyNotProtectedTokens(address _asset) internal virtual;

    function getProtectedTokens()
        external
        view
        virtual
        returns (address[] memory);

    /// @dev Internal logic for strategy migration. Should exit positions as efficiently as possible
    function _withdrawAll() internal virtual;

    /// @dev Internal logic for partial withdrawals. Should exit positions as efficiently as possible.
    /// @dev The withdraw() function shell automatically uses idle want in the strategy before attempting to withdraw more using this
    function _withdrawSome(uint256 _amount) internal virtual returns (uint256);

    /// @dev Realize returns from positions
    /// @dev Returns can be reinvested into positions, or distributed in another fashion
    /// @dev Performance fees should also be implemented in this function
    /// @dev Override function stub is removed as each strategy can have it's own return signature for STATICCALL
    // function harvest() external virtual;

    /// @dev User-friendly name for this strategy for purposes of convenient reading
    function getName() external pure virtual returns (string memory);

    /// @dev Balance of want currently held in strategy positions
    function balanceOfPool() public view virtual returns (uint256);

    uint256[49] private __gap;
}


// : MIT

pragma solidity ^0.6.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library MathUpgradeable {
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
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
    }
}


// : MIT

pragma solidity ^0.6.0;

//import"ContextUpgradeable.sol";
//import"Initializable.sol";

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract PausableUpgradeable is Initializable, ContextUpgradeable {
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
    function __Pausable_init() internal initializer {
        __Context_init_unchained();
        __Pausable_init_unchained();
    }

    function __Pausable_init_unchained() internal initializer {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
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
        require(!_paused, "Pausable: paused");
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
        require(_paused, "Pausable: not paused");
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

    uint256[49] private __gap;
}


// : MIT

pragma solidity ^0.6.0;
//import"Initializable.sol";

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {}

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    uint256[50] private __gap;
}


// : MIT
pragma solidity >=0.5.0 <0.8.0;

interface IUniswapRouterV2 {
    function factory() external view returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}


// : MIT

// : MIT
pragma solidity >=0.5.0 <0.8.0;

interface IStrategy {
    function want() external view returns (address);

    function deposit() external;

    // NOTE: must exclude any tokens used in the yield
    // Controller role - withdraw should return to Controller
    function withdrawOther(address) external returns (uint256 balance);

    // Controller | Vault role - withdraw should always return to Vault
    function withdraw(uint256) external;

    // Controller | Vault role - withdraw should always return to Vault
    function withdrawAll() external returns (uint256);

    function balanceOf() external view returns (uint256);

    function getName() external pure returns (string memory);

    function setStrategist(address _strategist) external;

    function setWithdrawalFee(uint256 _withdrawalFee) external;

    function setPerformanceFeeStrategist(uint256 _performanceFeeStrategist)
        external;

    function setPerformanceFeeGovernance(uint256 _performanceFeeGovernance)
        external;

    function setGovernance(address _governance) external;

    function setController(address _controller) external;

    function tend() external;

    function harvest() external;
}


// : MIT
pragma solidity ^0.6.11;

//import"Initializable.sol";

/*
    Common base for permissioned roles throughout Sett ecosystem
*/
contract SettAccessControl is Initializable {
    address public governance;
    address public strategist;
    address public keeper;

    // ===== MODIFIERS =====
    function _onlyGovernance() internal view {
        require(msg.sender == governance, "onlyGovernance");
    }

    function _onlyGovernanceOrStrategist() internal view {
        require(
            msg.sender == strategist || msg.sender == governance,
            "onlyGovernanceOrStrategist"
        );
    }

    function _onlyAuthorizedActors() internal view {
        require(
            msg.sender == keeper || msg.sender == governance,
            "onlyAuthorizedActors"
        );
    }

    // ===== PERMISSIONED ACTIONS =====

    /// @notice Change strategist address
    /// @notice Can only be changed by governance itself
    function setStrategist(address _strategist) external {
        _onlyGovernance();
        strategist = _strategist;
    }

    /// @notice Change keeper address
    /// @notice Can only be changed by governance itself
    function setKeeper(address _keeper) external {
        _onlyGovernance();
        keeper = _keeper;
    }

    /// @notice Change governance address
    /// @notice Can only be changed by governance itself
    function setGovernance(address _governance) public {
        _onlyGovernance();
        governance = _governance;
    }

    uint256[50] private __gap;
}


// : MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

//import"IERC20Upgradeable.sol";
//import"SafeMathUpgradeable.sol";
//import"AddressUpgradeable.sol";
//import"SafeERC20Upgradeable.sol";
//import"ReentrancyGuardUpgradeable.sol";

//import"ISettV4.sol";
//import"IController.sol";
//import"ICvxLocker.sol";
//import"ICVXBribes.sol";
//import"IVotiumBribes.sol";
//import"IBribesProcessor.sol";
//import"IDelegateRegistry.sol";
//import"ICurvePool.sol";

//import{BaseStrategy} from "BaseStrategy.sol";


/**
 * CHANGELOG
 * V1.0 Initial Release, can lock
 * V1.1 Update to handle rewards which are sent to a multisig
 * V1.2 Update to emit badger, all other rewards are sent to multisig
 * V1.3 Updated Address to claim CVX Rewards
 * V1.4 Updated Claiming mechanism to allow claiming any token (using difference in balances)
 * V1.5 Unlocks are permissioneless, added Chainlink Keepeers integration
 * V1.6 New Locker, work towards fully permissioneless claiming // Protected Launch
 * V1.7 Integration with onChain BribesProcessor
 * V1.7.1 Updated BribesProcessor
 */
contract MyStrategy is BaseStrategy, ReentrancyGuardUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using SafeMathUpgradeable for uint256;

    uint256 public constant MAX_BPS = 10_000;

    // address public want // Inherited from BaseStrategy, the token the strategy wants, swaps into and tries to grow
    address public lpComponent; // Token we provide liquidity with
    address public reward; // Token we farm and swap to want / lpComponent

    address public constant BADGER_TREE = 0x660802Fc641b154aBA66a62137e71f331B6d787A;

    IDelegateRegistry public constant SNAPSHOT =
        IDelegateRegistry(0x469788fE6E9E9681C6ebF3bF78e7Fd26Fc015446);

    // The initial DELEGATE for the strategy // NOTE we can change it by using manualSetDelegate below
    address public constant DELEGATE =
        0x14F83fF95D4Ec5E8812DDf42DA1232b0ba1015e6;

    bytes32 public constant DELEGATED_SPACE =
        0x6376782e65746800000000000000000000000000000000000000000000000000;
    
    ISettV4 public constant CVXCRV_VAULT =
        ISettV4(0x2B5455aac8d64C14786c3a29858E43b5945819C0);

    // NOTE: Locker V2
    ICvxLocker public constant LOCKER = ICvxLocker(0x72a19342e8F1838460eBFCCEf09F6585e32db86E);

    ICVXBribes public constant CVX_EXTRA_REWARDS = ICVXBribes(0xDecc7d761496d30F30b92Bdf764fb8803c79360D);
    IVotiumBribes public constant VOTIUM_BRIBE_CLAIMER = IVotiumBribes(0x378Ba9B73309bE80BF4C2c027aAD799766a7ED5A);
    
    // We hardcode, an upgrade is required to change this as it's a meaningful change
    address public constant BRIBES_PROCESSOR = 0xb2Bf1d48F2C2132913278672e6924efda3385de2;
    
    // We emit badger through the tree to the vault holders
    address public constant BADGER = 0x3472A5A71965499acd81997a54BBA8D852C6E53d;

    bool public withdrawalSafetyCheck = false;
    bool public harvestOnRebalance = false;
    // If nothing is unlocked, processExpiredLocks will revert
    bool public processLocksOnReinvest = false;
    bool public processLocksOnRebalance = false;

    // Used to signal to the Badger Tree that rewards where sent to it
    event TreeDistribution(
        address indexed token,
        uint256 amount,
        uint256 indexed blockNumber,
        uint256 timestamp
    );
    event RewardsCollected(
        address token,
        uint256 amount
    );
    event PerformanceFeeGovernance(
        address indexed destination,
        address indexed token,
        uint256 amount,
        uint256 indexed blockNumber,
        uint256 timestamp
    );
    event PerformanceFeeStrategist(
        address indexed destination,
        address indexed token,
        uint256 amount,
        uint256 indexed blockNumber,
        uint256 timestamp
    );

    function initialize(
        address _governance,
        address _strategist,
        address _controller,
        address _keeper,
        address _guardian,
        address[3] memory _wantConfig,
        uint256[3] memory _feeConfig
    ) public initializer {
        __BaseStrategy_init(
            _governance,
            _strategist,
            _controller,
            _keeper,
            _guardian
        );

        __ReentrancyGuard_init();

        /// @dev Add config here
        want = _wantConfig[0];
        lpComponent = _wantConfig[1];
        reward = _wantConfig[2];

        performanceFeeGovernance = _feeConfig[0];
        performanceFeeStrategist = _feeConfig[1];
        withdrawalFee = _feeConfig[2];

        
        IERC20Upgradeable(reward).safeApprove(address(CVXCRV_VAULT), type(uint256).max);

        /// @dev do one off approvals here
        // Permissions for Locker
        IERC20Upgradeable(want).safeApprove(address(LOCKER), type(uint256).max);

        // Delegate voting to DELEGATE
        SNAPSHOT.setDelegate(DELEGATED_SPACE, DELEGATE);
    }

    /// ===== Extra Functions =====
    /// @dev Change Delegation to another address
    function manualSetDelegate(address delegate) external {
        _onlyGovernance();
        // Set delegate is enough as it will clear previous delegate automatically
        SNAPSHOT.setDelegate(DELEGATED_SPACE, delegate);
    }

    ///@dev Should we check if the amount requested is more than what we can return on withdrawal?
    function setWithdrawalSafetyCheck(bool newWithdrawalSafetyCheck) external {
        _onlyGovernance();
        withdrawalSafetyCheck = newWithdrawalSafetyCheck;
    }

    ///@dev Should we harvest before doing manual rebalancing
    ///@notice you most likely want to skip harvest if everything is unlocked, or there's something wrong and you just want out
    function setHarvestOnRebalance(bool newHarvestOnRebalance) external {
        _onlyGovernance();
        harvestOnRebalance = newHarvestOnRebalance;
    }

    ///@dev Should we processExpiredLocks during reinvest?
    function setProcessLocksOnReinvest(bool newProcessLocksOnReinvest) external {
        _onlyGovernance();
        processLocksOnReinvest = newProcessLocksOnReinvest;
    }

    ///@dev Should we processExpiredLocks during manualRebalance?
    function setProcessLocksOnRebalance(bool newProcessLocksOnRebalance)
        external
    {
        _onlyGovernance();
        processLocksOnRebalance = newProcessLocksOnRebalance;
    }

    // Claiming functions, wrote on 10th of March with goal of removing access controls on 10th June

    /// @dev Function to move rewards that are not protected
    /// @notice Only not protected, moves the whole amount using _handleRewardTransfer
    /// @notice because token paths are harcoded, this function is safe to be called by anyone
    /// @notice Will not notify the BRIBES_PROCESSOR as this could be triggered outside bribes
    function sweepRewardToken(address token) public nonReentrant {
        _onlyGovernanceOrStrategist();
        _onlyNotProtectedTokens(token);

        uint256 toSend = IERC20Upgradeable(token).balanceOf(address(this));
        _handleRewardTransfer(token, toSend);
    }

    /// @dev Bulk function for sweepRewardToken
    function sweepRewards(address[] calldata tokens) external {
        uint256 length = tokens.length;
        for(uint i = 0; i < length; i++){
            sweepRewardToken(tokens[i]);
        }
    }

    /// @dev Skim away want to bring back ppfs to 1e18
    /// @notice permissioneless function as all paths are hardcoded // In the future
    function skim() external nonReentrant {
        _onlyGovernanceOrStrategist();
        // Just withdraw and deposit into more of the vault, and send it to tree
        uint256 beforeBalance = _getBalance();
        uint256 totalSupply = _getTotalSupply();

        // Take the excess amount that is throwing off peg
        // Works because both are in 1e18
        uint256 excessAmount = beforeBalance.sub(totalSupply);

        if(excessAmount == 0) { return; }

        _sendTokenToBribesProcessor(want, excessAmount);

        // getPricePerFullShare == balance().mul(1e18).div(totalSupply())
        require(_getBalance() == _getTotalSupply()); // Proof we skimmed only back to 1 ppfs
    }

    /// @dev given a token address, and convexAddress claim that as reward from CVX Extra Rewards
    /// @notice funds are transfered to the hardcoded address BRIBES_PROCESSOR
    function claimBribeFromConvex(ICVXBribes convexAddress, address token) external nonReentrant {
        _onlyGovernanceOrStrategist();
        uint256 beforeVaultBalance = _getBalance();
        uint256 beforePricePerFullShare = _getPricePerFullShare();


        uint256 beforeBalance = IERC20Upgradeable(token).balanceOf(address(this));
        // Claim reward for token
        convexAddress.getReward(address(this), token);
        uint256 afterBalance = IERC20Upgradeable(token).balanceOf(address(this));

        uint256 difference = afterBalance.sub(beforeBalance);
        _handleRewardTransfer(token, difference);

        if(difference > 0) {
            _notifyBribesProcessor();
        }

        require(beforeVaultBalance == _getBalance(), "Balance can't change");
        require(beforePricePerFullShare == _getPricePerFullShare(), "Ppfs can't change");
    }

    /// @dev Given the ExtraRewards address and a list of tokens, claims and processes them
    /// @notice permissioneless function as all paths are hardcoded // In the future
    /// @notice allows claiming any token as it uses the difference in balance
    function claimBribesFromConvex(ICVXBribes convexAddress, address[] memory tokens) external nonReentrant {
        _onlyGovernanceOrStrategist();
        uint256 beforeVaultBalance = _getBalance();
        uint256 beforePricePerFullShare = _getPricePerFullShare();

        // Also checks balance diff
        uint256 length = tokens.length;
        uint256[] memory beforeBalance = new uint256[](length);
        for(uint i = 0; i < length; i++){
            beforeBalance[i] = IERC20Upgradeable(tokens[i]).balanceOf(address(this));
        }

        // Claim reward for tokens
        convexAddress.getRewards(address(this), tokens);


        bool nonZeroDiff; // Cached value but also to check if we need to notifyProcessor
        // Ultimately it's proof of non-zero which is good enough

        // Send reward to Multisig
        for(uint x = 0; x < length; x++){
            address token = tokens[x];
            uint256 difference = IERC20Upgradeable(token).balanceOf(address(this)).sub(beforeBalance[x]);

            if(difference > 0){
                nonZeroDiff = true;
                _handleRewardTransfer(token, difference);
            }
        }

        if(nonZeroDiff) {
            _notifyBribesProcessor();
        }

        require(beforeVaultBalance == _getBalance(), "Balance can't change");
        require(beforePricePerFullShare == _getPricePerFullShare(), "Ppfs can't change");
    }

    /// @dev given the votium data and their tree address (available at: https://github.com/oo-00/Votium/tree/main/merkle)
    /// @dev allows claiming of rewards, badger is sent to tree
    function claimBribeFromVotium(
        IVotiumBribes votiumTree,
        address token, 
        uint256 index, 
        address account, 
        uint256 amount, 
        bytes32[] calldata merkleProof
    ) external nonReentrant {
        _onlyGovernanceOrStrategist();
        uint256 beforeVaultBalance = _getBalance();
        uint256 beforePricePerFullShare = _getPricePerFullShare();

        uint256 beforeBalance = IERC20Upgradeable(token).balanceOf(address(this));
        votiumTree.claim(token, index, account, amount, merkleProof);
        uint256 afterBalance = IERC20Upgradeable(token).balanceOf(address(this));

        uint256 difference = afterBalance.sub(beforeBalance);

        _handleRewardTransfer(token, difference);

        if(difference > 0) {
            _notifyBribesProcessor();
        }

        require(beforeVaultBalance == _getBalance(), "Balance can't change");
        require(beforePricePerFullShare == _getPricePerFullShare(), "Ppfs can't change");
    }

    /// @dev given the votium data (available at: https://github.com/oo-00/Votium/tree/main/merkle)
    /// @dev allows claiming of multiple rewards rewards, badger is sent to tree
    /// @notice permissioneless function as all paths are hardcoded // In the future
    /// @notice allows claiming any token as it uses the difference in balance
    function claimBribesFromVotium(
        IVotiumBribes votiumTree,
        address account, 
        address[] calldata tokens, 
        uint256[] calldata indexes,
        uint256[] calldata amounts, 
        bytes32[][] calldata merkleProofs
    ) external nonReentrant {
        _onlyGovernanceOrStrategist();
        uint256 beforeVaultBalance = _getBalance();
        uint256 beforePricePerFullShare = _getPricePerFullShare();

        require(tokens.length == indexes.length && tokens.length == amounts.length && tokens.length == merkleProofs.length, "Length Mismatch");
        // tokens.length = length, can't declare var as stack too deep
        uint256[] memory beforeBalance = new uint256[](tokens.length);
        for(uint i = 0; i < tokens.length; i++){
            beforeBalance[i] = IERC20Upgradeable(tokens[i]).balanceOf(address(this));
        }

        IVotiumBribes.claimParam[] memory request = new IVotiumBribes.claimParam[](tokens.length);
        for(uint x = 0; x < tokens.length; x++){
            request[x] = IVotiumBribes.claimParam({
                token: tokens[x],
                index: indexes[x],
                amount: amounts[x],
                merkleProof: merkleProofs[x]
            });
        }

        votiumTree.claimMulti(account, request);

        bool nonZeroDiff; // Cached value but also to check if we need to notifyProcessor
        // Ultimately it's proof of non-zero which is good enough

        for(uint i = 0; i < tokens.length; i++){
            address token = tokens[i]; // Caching it allows it to compile else we hit stack too deep
            uint256 difference = IERC20Upgradeable(token).balanceOf(address(this)).sub(beforeBalance[i]);
            if(difference > 0){
                nonZeroDiff = true;
                _handleRewardTransfer(token, difference);
            }
        }

        // If at least one diff is non-zero
        if(nonZeroDiff) {
            _notifyBribesProcessor();
        }

        require(beforeVaultBalance == _getBalance(), "Balance can't change");
        require(beforePricePerFullShare == _getPricePerFullShare(), "Ppfs can't change");
    }

    // END TRUSTLESS

    /// *** Handling of rewards ***
    function _handleRewardTransfer(address token, uint256 amount) internal {
        // NOTE: BADGER is emitted through the tree
        if (token == BADGER){
            _sendBadgerToTree(amount);
        } else {
        // NOTE: All other tokens are sent to bribes processor
            _sendTokenToBribesProcessor(token, amount);
        }
    }

    /// @dev Notify the BribesProcessor that a new round of bribes has happened
    function _notifyBribesProcessor() internal {
        IBribesProcessor(BRIBES_PROCESSOR).notifyNewRound();
    }

    /// @dev Send funds to the bribes receiver
    function _sendTokenToBribesProcessor(address token, uint256 amount) internal {
        IERC20Upgradeable(token).safeTransfer(BRIBES_PROCESSOR, amount);
        emit RewardsCollected(token, amount);
    }

    /// @dev Send the BADGER token to the badgerTree
    function _sendBadgerToTree(uint256 amount) internal {
        IERC20Upgradeable(BADGER).safeTransfer(BADGER_TREE, amount);
        emit TreeDistribution(BADGER, amount, block.number, block.timestamp);
    }

    /// @dev Get the current Vault.balance
    /// @notice this is reflexive, a change in the strat will change the balance in the vault
    function _getBalance() internal returns (uint256) {
        ISettV4 vault = ISettV4(IController(controller).vaults(want));
        return vault.balance();
    }
    /// @dev Get the current Vault.totalSupply
    function _getTotalSupply() internal returns (uint256) {
        ISettV4 vault = ISettV4(IController(controller).vaults(want));
        return vault.totalSupply();
    }

    function _getPricePerFullShare() internal returns (uint256) {
        ISettV4 vault = ISettV4(IController(controller).vaults(want));
        return vault.getPricePerFullShare();
    }

    /// ===== View Functions =====

    function getBoostPayment() public view returns(uint256){
        // uint256 maximumBoostPayment = LOCKER.maximumBoostPayment();
        // require(maximumBoostPayment <= 1500, "over max payment"); //max 15%
        return 0; // Unused at this stage, so for security reasons we just zero it
    }

    /// @dev Specify the name of the strategy
    function getName() external pure override returns (string memory) {
        return "veCVX Voting Strategy";
    }

    /// @dev Specify the version of the Strategy, for upgrades
    function version() external pure returns (string memory) {
        return "1.7";
    }

    /// @dev Balance of want currently held in strategy positions
    function balanceOfPool() public view override returns (uint256) {
        // Return the balance in locker
        return LOCKER.lockedBalanceOf(address(this));
    }

    /// @dev Returns true if this strategy requires tending
    function isTendable() public view override returns (bool) {
        return false;
    }

    // @dev These are the tokens that cannot be moved except by the vault
    function getProtectedTokens()
        public
        view
        override
        returns (address[] memory)
    {
        address[] memory protectedTokens = new address[](3);
        protectedTokens[0] = want;
        protectedTokens[1] = lpComponent; // vlCVX
        protectedTokens[2] = reward; // cvxCRV // 
        return protectedTokens;
    }

    /// ===== Internal Core Implementations =====
    /// @dev security check to avoid moving tokens that would cause a rugpull, edit based on strat
    function _onlyNotProtectedTokens(address _asset) internal override {
        address[] memory protectedTokens = getProtectedTokens();

        for (uint256 x = 0; x < protectedTokens.length; x++) {
            require(
                address(protectedTokens[x]) != _asset,
                "Asset is protected"
            );
        }
    }

    /// @dev invest the amount of want
    /// @notice When this function is called, the controller has already sent want to this
    /// @notice Just get the current balance and then invest accordingly
    function _deposit(uint256 _amount) internal override {
        // Lock tokens for 16 weeks, send credit to strat, always use max boost cause why not?
        LOCKER.lock(address(this), _amount, getBoostPayment());
    }

    /// @dev utility function to withdraw all CVX that we can from the lock
    function prepareWithdrawAll() external {
        manualProcessExpiredLocks();
    }

    /// @dev utility function to withdraw everything for migration
    /// @dev NOTE: You cannot call this unless you have rebalanced to have only CVX left in the vault
    function _withdrawAll() internal override {
        //NOTE: This probably will always fail unless we have all tokens expired
        require(
            LOCKER.lockedBalanceOf(address(this)) == 0 &&
                LOCKER.balanceOf(address(this)) == 0,
            "You have to wait for unlock or have to manually rebalance out of it"
        );

        // Make sure to call prepareWithdrawAll before _withdrawAll
    }

    /// @dev withdraw the specified amount of want, liquidate from lpComponent to want, paying off any necessary debt for the conversion
    function _withdrawSome(uint256 _amount)
        internal
        override
        returns (uint256)
    {
        uint256 max = balanceOfWant();

        if(_amount > max){
            // Try to unlock, as much as possible
            // @notice Reverts if no locks expired
            LOCKER.processExpiredLocks(false);
            max = balanceOfWant();
        }


        if (withdrawalSafetyCheck) {
            require(
                max >= _amount.mul(9_980).div(MAX_BPS),
                "Withdrawal Safety Check"
            ); // 20 BP of slippage
        }

        if (_amount > max) {
            return max;
        }

        return _amount;
    }

    /// @dev Harvest from strategy mechanics, realizing increase in underlying position
    function harvest() public whenNotPaused returns (uint256) {
        _onlyAuthorizedActors();

        uint256 _beforeReward = IERC20Upgradeable(reward).balanceOf(address(this));

        // Get cvxCRV
        LOCKER.getReward(address(this), false);

        // Rewards Math
        uint256 earnedReward =
            IERC20Upgradeable(reward).balanceOf(address(this)).sub(_beforeReward);

        uint256 cvxCrvToGovernance = earnedReward.mul(performanceFeeGovernance).div(MAX_FEE);
        if(cvxCrvToGovernance > 0){
            CVXCRV_VAULT.depositFor(IController(controller).rewards(), cvxCrvToGovernance);
            emit PerformanceFeeGovernance(IController(controller).rewards(), address(CVXCRV_VAULT), cvxCrvToGovernance, block.number, block.timestamp);
        }
        uint256 cvxCrvToStrategist = earnedReward.mul(performanceFeeStrategist).div(MAX_FEE);
        if(cvxCrvToStrategist > 0){
            CVXCRV_VAULT.depositFor(strategist, cvxCrvToStrategist);
            emit PerformanceFeeStrategist(strategist, address(CVXCRV_VAULT), cvxCrvToStrategist, block.number, block.timestamp);   
        }

        // Send rest of earned to tree //We send all rest to avoid dust and avoid protecting the token
        // We take difference of vault token to emit the event in shares rather than underlying
        uint256 cvxCRVInitialBalance = CVXCRV_VAULT.balanceOf(BADGER_TREE);
        uint256 cvxCrvToTree = IERC20Upgradeable(reward).balanceOf(address(this));
        CVXCRV_VAULT.depositFor(BADGER_TREE, cvxCrvToTree);
        uint256 cvxCRVAfterBalance = CVXCRV_VAULT.balanceOf(BADGER_TREE);
        emit TreeDistribution(address(CVXCRV_VAULT), cvxCRVAfterBalance.sub(cvxCRVInitialBalance), block.number, block.timestamp);

        /// @dev Harvest event that every strategy MUST have, see BaseStrategy
        emit Harvest(0, block.number);

        /// @dev Harvest must return the amount of want increased
        return 0;
    }

    /// @dev Rebalance, Compound or Pay off debt here
    function tend() external whenNotPaused {
        revert("no op"); // NOTE: For now tend is replaced by manualRebalance
    }

    /// MANUAL FUNCTIONS ///

    /// @dev manual function to reinvest all CVX that was locked
    function reinvest() external whenNotPaused returns (uint256) {
        _onlyGovernance();

        if (processLocksOnReinvest) {
            // Withdraw all we can
            LOCKER.processExpiredLocks(false);
        }

        // Redeposit all into veCVX
        uint256 toDeposit = IERC20Upgradeable(want).balanceOf(address(this));

        // Redeposit into veCVX
        _deposit(toDeposit);

        return toDeposit;
    }

    /// @dev process all locks, to redeem
    /// @notice No Access Control Checks, anyone can unlock an expired lock
    function manualProcessExpiredLocks() public whenNotPaused {
        // Unlock veCVX that is expired and redeem CVX back to this strat
        LOCKER.processExpiredLocks(false);
    }

    function checkUpkeep(bytes calldata checkData) external view returns (bool upkeepNeeded, bytes memory performData) {
        // We need to unlock funds if the lockedBalance (locked + unlocked) is greater than the balance (actively locked for this epoch)
        upkeepNeeded = LOCKER.lockedBalanceOf(address(this)) > LOCKER.balanceOf(address(this));
    }

    /// @dev Function for ChainLink Keepers to automatically process expired locks
    function performUpkeep(bytes calldata performData) external {
        // Works like this because it reverts if lock is not expired
        LOCKER.processExpiredLocks(false);
    }

    /// @dev Send all available CVX to the Vault
    /// @notice you can do this so you can earn again (re-lock), or just to add to the redemption pool
    function manualSendCVXToVault() external whenNotPaused {
        _onlyGovernance();
        uint256 cvxAmount = IERC20Upgradeable(want).balanceOf(address(this));
        _transferToVault(cvxAmount);
    }

    /// @dev use the currently available CVX to lock
    /// @notice toLock = 0, lock nothing, deposit in CVX as much as you can
    /// @notice toLock = 10_000, lock everything (CVX) you have
    function manualRebalance(uint256 toLock) external whenNotPaused {
        _onlyGovernance();
        require(toLock <= MAX_BPS, "Max is 100%");

        if (processLocksOnRebalance) {
            // manualRebalance will revert if you have no expired locks
            LOCKER.processExpiredLocks(false);
        }

        if (harvestOnRebalance) {
            harvest();
        }

        // Token that is highly liquid
        uint256 balanceOfWant =
            IERC20Upgradeable(want).balanceOf(address(this));
        // Locked CVX in the locker
        uint256 balanceInLock = LOCKER.balanceOf(address(this));
        uint256 totalCVXBalance =
            balanceOfWant.add(balanceInLock);

        // Amount we want to have in lock
        uint256 newLockAmount = totalCVXBalance.mul(toLock).div(MAX_BPS);

        // We can't unlock enough, no-op
        if (newLockAmount <= balanceInLock) {
            return;
        }

        // If we're continuing, then we are going to lock something
        uint256 cvxToLock = newLockAmount.sub(balanceInLock);

        // We only lock up to the available CVX
        uint256 maxCVX = IERC20Upgradeable(want).balanceOf(address(this));
        if (cvxToLock > maxCVX) {
            // Just lock what we can
            LOCKER.lock(address(this), maxCVX, getBoostPayment());
        } else {
            // Lock proper
            LOCKER.lock(address(this), cvxToLock, getBoostPayment());
        }

        // If anything left, send to vault
        uint256 cvxLeft = IERC20Upgradeable(want).balanceOf(address(this));
        if(cvxLeft > 0){
            _transferToVault(cvxLeft);
        }
    }
}



}
