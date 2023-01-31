/**
 *Submitted for verification at Etherscan.io on 2021-03-12
*/

// File: interfaces/DelegatorInterface.sol

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

contract DelegationStorage {
    /**
     * @notice Implementation address for this contract
     */
    address public implementation;
}

abstract contract DelegatorInterface is DelegationStorage {
    /**
     * @notice Emitted when implementation is changed
     */
    event NewImplementation(
        address oldImplementation,
        address newImplementation
    );

    /**
     * @notice Called by the admin to update the implementation of the delegator
     * @param implementation_ The address of the new implementation for delegation
     * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
     * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
     */
    function _setImplementation(
        address implementation_,
        bool allowResign,
        bytes memory becomeImplementationData
    ) public virtual;
}

abstract contract DelegateInterface is DelegationStorage {
    /**
     * @notice Called by the delegator on a delegate to initialize it for duty
     * @dev Should revert if any issues arise which make it unfit for delegation
     * @param data The encoded bytes data for any initialization
     */
    function _becomeImplementation(bytes memory data) public virtual;

    /**
     * @notice Called by the delegator on a delegate to forfeit its responsibility
     */
    function _resignImplementation() public virtual;
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


pragma solidity ^0.6.0;

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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

// File: @openzeppelin/contracts/math/SafeMath.sol


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
library SafeMath {
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
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/utils/Address.sol


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
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
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

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
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
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
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
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
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

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol


pragma solidity ^0.6.0;




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
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
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
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: interfaces/IInvitation.sol

pragma solidity 0.6.12;

interface IInvitation{

    function acceptInvitation(address _invitor) external;

    function getInvitation(address _sender) external view returns(address _invitor, address[] memory _invitees, bool _isWithdrawn);
    
}

// File: @openzeppelin/contracts/GSN/Context.sol


pragma solidity ^0.6.0;

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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// ////-License-Identifier: MIT

pragma solidity ^0.6.0;

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
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: contracts/ActivityBase.sol

pragma solidity 0.6.12;

contract ActivityBase{
    // invitee's supply 5% deposit weight to its invitor
    uint256 public constant INVITEE_WEIGHT = 20; 
    // invitee's supply 10% deposit weight to its invitor
    uint256 public constant INVITOR_WEIGHT = 10;

    // The block number when SHARD mining starts.
    uint256 public startBlock;

    // dev fund
    uint256 public userDividendWeight;
    uint256 public devDividendWeight;
    address public devAddress;
}

// File: contracts/MasterchefActivityOne.sol

pragma solidity 0.6.12;








contract MasterchefActivityOne is Ownable, ActivityBase{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Info of each user.
    struct UserInfo {
        uint256 amount;     // How much LP token the user has provided.
        uint256 originWeight; //initial weight
        uint256 modifiedWeight; //take the invitation relationship into consideration.
        uint256 revenue;
        uint256 rewardDebt; // Reward debt. See explanation below.
        bool withdrawnState;
        bool isContractSender;
        bool isUsed;
    }

    // Info of each pool.
    struct PoolInfo {
        uint256 tokenAmount;  // lock amount
        IERC20 erc20Token;   // uniswapPair contract
        uint256 allocPoint;
        uint256 accumulativeDividend;
        uint256 lastDividendHeight;  // last dividend block height
        uint256 accShardPerWeight;
        uint256 totalWeight;
    }

    uint256 public constant BONUS_MULTIPLIER = 10;
    // The SHARD TOKEN!
    IERC20 public SHARD;
    // Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    // Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => uint256)) public userInviteeTotalAmount; // total invitee weight
    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Total allocation poitns. Must be the sum of all allocation poishard in all pools.
    uint256 public totalAllocPoint = 0;
    // SHARD tokens created per block.
    uint256 public shardPerBlock = 1 * (1e18);

    //get invitation relationship
    IInvitation public invitation;

    uint256 public bonusEndBlock;
    uint256 public totalAvailableDividend;

    // deposit limit
    uint256 public tokenAmountLimit;
    uint256 public amountFeeRateNumerator = 1;
    uint256 public amountfeeRateDenominator = 2;

    // contract sender fee rate
    uint256 public contractFeeRateNumerator = 1;
    uint256 public contractFeeRateDenominator = 2;
    
    bool public isInitialized;

    event AddPool(uint256 indexed pid, address tokenAddress);
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount, uint256 weight);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

    function initialize(
        IERC20 _SHARD,
        IInvitation _invitation,
        uint256 _bonusEndBlock,
        uint256 _startBlock, 
        uint256 _shardPerBlock,
        uint256 _shardRewardLimit,
        address _devAddress
    ) public virtual onlyOwner{
        require(!isInitialized, "contract has been initialized");
        invitation = _invitation;
        bonusEndBlock = _bonusEndBlock;
        startBlock = _startBlock;
        SHARD = _SHARD;
        devAddress = _devAddress;
        if(_shardPerBlock > 0){
            shardPerBlock = _shardPerBlock;
        }
        tokenAmountLimit = _shardRewardLimit;
        userDividendWeight = 1;
        devDividendWeight = 0;
        isInitialized = true;
    }

    function setDeveloperFund(address _devAddress, uint256 _userDividendWeight, uint256 _devDividendWeight) public virtual onlyOwner {
        require(
            _userDividendWeight != 0 && _devDividendWeight != 0,
            "invalid input"
        );
        userDividendWeight = _userDividendWeight;
        devDividendWeight = _devDividendWeight;
        devAddress = _devAddress;
    }

    function setTokenAmountLimitFeeRate(uint256 _amountLimit, uint256 _feeRateNumerator, uint256 _feeRateDenominator) public virtual onlyOwner {
        require(
            _feeRateDenominator >= _feeRateNumerator, "invalid input"
        );
        tokenAmountLimit = _amountLimit;
        amountFeeRateNumerator = _feeRateNumerator;
        amountfeeRateDenominator = _feeRateDenominator;
    }

    function setContracSenderFeeRate(uint256 _feeRateNumerator, uint256 _feeRateDenominator) public virtual onlyOwner {
        require(
            _feeRateDenominator >= _feeRateNumerator, "invalid input"
        );
        contractFeeRateNumerator = _feeRateNumerator;
        contractFeeRateDenominator = _feeRateDenominator;
    }

    // Add a new lp to the pool. Can only be called by the owner.
    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
    function add(uint256 _allocPoint, IERC20 _erc20Token, bool _withUpdate) public virtual onlyOwner{ 
        if(_withUpdate){
            massUpdatePools();
        }
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        PoolInfo memory newpool = PoolInfo({
            erc20Token: _erc20Token, 
            tokenAmount: 0,
            allocPoint: _allocPoint,
            lastDividendHeight: lastRewardBlock,
            accumulativeDividend: 0,
            accShardPerWeight: 0,
            totalWeight: 0
        });
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(newpool);
        emit AddPool(poolInfo.length.sub(1), address(_erc20Token));
    }

    // Update the given pool's allocation point. Can only be called by the owner.
    function setAllocationPoint(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public virtual onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
    }

    function setDistributeShardVelocity(uint256 _shardPerBlock, bool _withUpdate) public virtual onlyOwner{
        if (_withUpdate) {
            massUpdatePools();
        }
        shardPerBlock = _shardPerBlock;
    }

    // update reward vairables for pools. Be careful of gas spending!
    function massUpdatePools() public virtual {
        uint256 poolCount = poolInfo.length;
        for(uint256 i = 0; i < poolCount; i ++){
            updatePoolDividend(i);
        }
    }

    function addAvailableDividend(uint256 _amount, bool _withUpdate) public virtual {
        if(_withUpdate){
            massUpdatePools();
        }
        SHARD.safeTransferFrom(address(msg.sender), address(this), _amount);
        totalAvailableDividend = totalAvailableDividend.add(_amount);
    }

    // update reward vairables for a pool
    function updatePoolDividend(uint256 _pid) public virtual {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastDividendHeight) {
            return;
        }
        if (pool.tokenAmount == 0) {
            pool.lastDividendHeight = block.number;
            return;
        }
        uint256 availableDividend = totalAvailableDividend;
        uint256 multiplier = getMultiplier(pool.lastDividendHeight, block.number);
        uint256 producedToken = multiplier.mul(shardPerBlock);
        producedToken = availableDividend > producedToken? producedToken: availableDividend;
        if(totalAllocPoint > 0){
            uint256 poolDevidend = producedToken.mul(pool.allocPoint).div(totalAllocPoint);
            if(poolDevidend > 0){
                totalAvailableDividend = totalAvailableDividend.sub(poolDevidend);
                pool.accumulativeDividend = pool.accumulativeDividend.add(poolDevidend);
                pool.accShardPerWeight = pool.accShardPerWeight.add(poolDevidend.mul(1e12).div(pool.totalWeight));
            } 
        }
        pool.lastDividendHeight = block.number;
    }

    // Deposit LP tokens to MasterChef for SHARD allocation.
    function deposit(uint256 _pid, uint256 _amount) public virtual {
        require(_amount > 0, "invalid amount");
        (address invitor, , bool isWithdrawn) = invitation.getInvitation(msg.sender);
        require(invitor != address(0), "should be accept invitation firstly");
        updatePoolDividend(_pid);
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        UserInfo storage userInvitor = userInfo[_pid][invitor];
        uint256 existedAmount = user.amount;
        bool withdrawnState = user.withdrawnState;
        if(!user.isUsed){
            user.isUsed = true;
            user.isContractSender = msg.sender != tx.origin;
            withdrawnState = isWithdrawn;
        }
        if(!withdrawnState && userInvitor.amount > 0){
            updateUserRevenue(userInvitor, pool);
        }
        if(!withdrawnState){
            updateInvitorWeight(msg.sender, invitor, _pid, true, _amount, isWithdrawn, withdrawnState);
        }

        if(existedAmount > 0){ 
            updateUserRevenue(user, pool);
        }

        updateUserWeight(msg.sender, _pid, true, _amount, isWithdrawn);
        if(!withdrawnState && userInvitor.amount > 0){
            userInvitor.rewardDebt = userInvitor.modifiedWeight.mul(pool.accShardPerWeight).div(1e12);
        }  
        if(!withdrawnState){
            user.withdrawnState = isWithdrawn;
        }
        user.amount = existedAmount.add(_amount);
        user.rewardDebt = user.modifiedWeight.mul(pool.accShardPerWeight).div(1e12);
        IERC20(pool.erc20Token).safeTransferFrom(address(msg.sender), address(this), _amount);
        pool.tokenAmount = pool.tokenAmount.add(_amount);
        emit Deposit(msg.sender, _pid, _amount, user.modifiedWeight);
    }

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _pid, uint256 _amount) public virtual {
        (address invitor, , bool isWithdrawn) = invitation.getInvitation(msg.sender);
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        bool withdrawnState = user.withdrawnState;
        uint256 existedAmount = user.amount;
        require(existedAmount >= _amount, "withdraw: not good");
        updatePoolDividend(_pid);
        uint256 pending = updateUserRevenue(user, pool);
        UserInfo storage userInvitor = userInfo[_pid][invitor];
        if(!withdrawnState && userInvitor.amount > 0){
            updateUserRevenue(userInvitor, pool);
        }
        if(!withdrawnState){
            updateInvitorWeight(msg.sender, invitor, _pid, false, _amount, isWithdrawn, withdrawnState);
        }
        updateUserWeight(msg.sender, _pid, false, _amount, isWithdrawn);
        user.revenue = 0;
        user.amount = existedAmount.sub(_amount);
        user.rewardDebt = user.modifiedWeight.mul(pool.accShardPerWeight).div(1e12);
        user.withdrawnState = isWithdrawn;
        if(!withdrawnState && userInvitor.amount > 0){
            userInvitor.rewardDebt = userInvitor.modifiedWeight.mul(pool.accShardPerWeight).div(1e12);
        }
        uint256 devDividend = 0;
        uint256 fee = 0;
        if(user.isContractSender){
            fee = pending.mul(contractFeeRateNumerator).div(contractFeeRateDenominator);
            devDividend = devDividend.add(fee);
            pending = pending.sub(fee);
        }
        if(tokenAmountLimit > 0 && existedAmount >= tokenAmountLimit){
            fee = pending.mul(amountFeeRateNumerator).div(amountfeeRateDenominator);
            devDividend =devDividend.add(fee);
            pending = pending.sub(fee);
        }
        if(devDividendWeight > 0){
            fee = pending.mul(devDividendWeight).div(devDividendWeight.add(userDividendWeight));
            devDividend = devDividend.add(fee);
            pending = pending.sub(fee);
        }
        pool.tokenAmount = pool.tokenAmount.sub(_amount);
        if(_amount > 0){
            IERC20(pool.erc20Token).safeTransfer(address(msg.sender), _amount);
        }
        if(devDividend > 0){
            pending = pending.sub(devDividend);
            safeSHARDTransfer(devAddress, devDividend);
        }
        if(pending > 0){
            safeSHARDTransfer(msg.sender, pending);
        }
        emit Withdraw(msg.sender, _pid, _amount);
    }

    // Safe SHARD transfer function, just in case if rounding error causes pool to not have enough SHARDs.
    function safeSHARDTransfer(address _to, uint256 _amount) internal {
        uint256 SHARDBal = SHARD.balanceOf(address(this));
        if (_amount > SHARDBal) {
            SHARD.transfer(_to, SHARDBal);
        } else {
            SHARD.transfer(_to, _amount);
        }
    }

    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view virtual returns (uint256) {
        if (_to <= bonusEndBlock) {
            return _to.sub(_from).mul(BONUS_MULTIPLIER);
        } else if (_from >= bonusEndBlock) {
            return _to.sub(_from);
        } else {
            return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
                _to.sub(bonusEndBlock)
            );
        }
    }

    // View function to see pending SHARDs on frontend.
    function pendingSHARD(uint256 _pid, address _user) external view virtual returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accShardPerWeight = pool.accShardPerWeight;
        uint256 lpSupply = pool.tokenAmount;
        if (block.number > pool.lastDividendHeight && lpSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastDividendHeight, block.number);
            uint256 shardReward = multiplier.mul(shardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accShardPerWeight = accShardPerWeight.add(shardReward.mul(1e12).div(pool.totalWeight));
        }
        return user.modifiedWeight.mul(accShardPerWeight).div(1e12).sub(user.rewardDebt).add(user.revenue);
    }

    function getDepositWeight(uint256 _amount) public pure returns(uint256 weight){
        return _amount;
    }

    function getPoolLength() public view virtual returns(uint256){
        return poolInfo.length;
    }

    function getPoolInfo(uint256 _pid) public view virtual returns(uint256 _allocPoint, uint256 _accumulativeDividend, uint256 _usersTotalWeight, uint256 _tokenAmount, address _tokenAddress, uint256 _accs){
        PoolInfo storage pool = poolInfo[_pid];
        _allocPoint = pool.allocPoint;
        _accumulativeDividend = pool.accumulativeDividend;
        _usersTotalWeight = pool.totalWeight;
        _tokenAmount = pool.tokenAmount;
        _tokenAddress = address(pool.erc20Token);
        _accs = pool.accShardPerWeight;
    }

    function getPagePoolInfo(uint256 _fromIndex, uint256 _toIndex) public view virtual
    returns(uint256[] memory _allocPoint, uint256[] memory _accumulativeDividend, uint256[] memory _usersTotalWeight, uint256[] memory _tokenAmount, 
    address[] memory _tokenAddress, uint256[] memory _accs){
        uint256 poolCount = _toIndex.sub(_fromIndex).add(1);
        _allocPoint = new uint256[](poolCount);
        _accumulativeDividend = new uint256[](poolCount);
        _usersTotalWeight = new uint256[](poolCount);
        _tokenAmount = new uint256[](poolCount);
        _tokenAddress = new address[](poolCount);
        _accs = new uint256[](poolCount);
        uint256 startIndex = 0;
        for(uint i = _fromIndex; i <= _toIndex; i ++){
            PoolInfo storage pool = poolInfo[i];
            _allocPoint[startIndex] = pool.allocPoint;
            _accumulativeDividend[startIndex] = pool.accumulativeDividend;
            _usersTotalWeight[startIndex] = pool.totalWeight;
            _tokenAmount[startIndex] = pool.tokenAmount;
            _tokenAddress[startIndex] = address(pool.erc20Token);
            _accs[startIndex] = pool.accShardPerWeight;
            startIndex ++;
        }
    }

    function getUserInfo(uint256 _pid, address _user) external view virtual returns
    (uint256 _amount, uint256 _originWeight, uint256 _modifiedWeight, 
    uint256 _revenue, uint256 _rewardDebt, bool _withdrawnState, bool _isContractSender){
        UserInfo storage user = userInfo[_pid][_user];
        _amount = user.amount;
        _originWeight = user.originWeight;
        _modifiedWeight = user.modifiedWeight;
        _revenue = user.revenue;
        _rewardDebt = user.rewardDebt;
        _withdrawnState = user.withdrawnState;
        _isContractSender = user.isContractSender;
    }

    function getAvailableDividendSHARD() public view virtual returns(uint256){
        return totalAvailableDividend;
    }

    function updateUserRevenue(UserInfo storage _user, PoolInfo storage _pool) private returns (uint256){
        uint256 pending = _user.modifiedWeight.mul(_pool.accShardPerWeight).div(1e12).sub(_user.rewardDebt);
        _user.revenue = _user.revenue.add(pending);
        _pool.accumulativeDividend = _pool.accumulativeDividend.sub(pending);
        return _user.revenue;
    }

    function updateInvitorWeight(address _sender, address _invitor, uint256 _pid, bool _isAddAmount, uint256 _amount, bool _isWithdrawn, bool _withdrawnState) private {
        UserInfo storage user = userInfo[_pid][_sender];
        uint256 subInviteeAmount = 0;
        uint256 addInviteeAmount = 0;
        if(user.amount > 0  && !_withdrawnState){
            subInviteeAmount = user.originWeight;
        }
        if(!_isWithdrawn){
            if(_isAddAmount){
                addInviteeAmount = getDepositWeight(user.amount.add(_amount));
            }
            else{ 
                addInviteeAmount = getDepositWeight(user.amount.sub(_amount));
            }
        }

        UserInfo storage invitor = userInfo[_pid][_invitor];
        PoolInfo storage pool = poolInfo[_pid];
        uint256 inviteeAmountOfUserInvitor = userInviteeTotalAmount[_pid][_invitor];
        uint256 newInviteeAmountOfUserInvitor = inviteeAmountOfUserInvitor.add(addInviteeAmount).sub(subInviteeAmount);
        userInviteeTotalAmount[_pid][_invitor] = newInviteeAmountOfUserInvitor;
        if(invitor.amount > 0){
            invitor.modifiedWeight = invitor.modifiedWeight.add(newInviteeAmountOfUserInvitor.div(INVITEE_WEIGHT))
                                                                   .sub(inviteeAmountOfUserInvitor.div(INVITEE_WEIGHT));
            pool.totalWeight = pool.totalWeight.add(newInviteeAmountOfUserInvitor.div(INVITEE_WEIGHT))
                                               .sub(inviteeAmountOfUserInvitor.div(INVITEE_WEIGHT));                              
        }
    }

    function updateUserWeight(address _user, uint256 _pid, bool _isAddAmount, uint256 _amount, bool _isWithdrawn) private {
        UserInfo storage user = userInfo[_pid][_user];
        uint256 userOriginModifiedWeight = user.modifiedWeight;
        uint256 userNewModifiedWeight;
        if(_isAddAmount){
            userNewModifiedWeight = getDepositWeight(_amount.add(user.amount));
        }
        else{
            userNewModifiedWeight = getDepositWeight(user.amount.sub(_amount));
        }
        user.originWeight = userNewModifiedWeight;
        if(!_isWithdrawn){
            userNewModifiedWeight = userNewModifiedWeight.add(userNewModifiedWeight.div(INVITOR_WEIGHT));
        }
        uint256 inviteeAmountOfUser = userInviteeTotalAmount[_pid][msg.sender];
        userNewModifiedWeight = userNewModifiedWeight.add(inviteeAmountOfUser.div(INVITEE_WEIGHT));
        user.modifiedWeight = userNewModifiedWeight;
        PoolInfo storage pool = poolInfo[_pid];
        pool.totalWeight = pool.totalWeight.add(userNewModifiedWeight).sub(userOriginModifiedWeight);
    }
}

// File: contracts/MasterchefActivityOneDelegator.sol

pragma solidity 0.6.12;




contract MasterchefActivityOneDelegator is MasterchefActivityOne, DelegatorInterface {
    constructor(
        address _SHARD,
        address _invitation,
        uint256 _bonusEndBlock,
        uint256 _startBlock,
        uint256 _shardPerBlock,
        uint256 _tokenAmountLimit,
        address _devAddress,
        address implementation_,
        bytes memory becomeImplementationData
    ) public {
        delegateTo(
            implementation_,
            abi.encodeWithSignature(
                "initialize(address,address,uint256,uint256,uint256,uint256,address)",
                _SHARD,
                _invitation,
                _bonusEndBlock,
                _startBlock,
                _shardPerBlock,
                _tokenAmountLimit,
                _devAddress
            )
        );
        _setImplementation(implementation_, false, becomeImplementationData);
    }

    function _setImplementation(
        address implementation_,
        bool allowResign,
        bytes memory becomeImplementationData
    ) public override onlyOwner {
        if (allowResign) {
            delegateToImplementation(
                abi.encodeWithSignature("_resignImplementation()")
            );
        }

        address oldImplementation = implementation;
        implementation = implementation_;

        delegateToImplementation(
            abi.encodeWithSignature(
                "_becomeImplementation(bytes)",
                becomeImplementationData
            )
        );

        emit NewImplementation(oldImplementation, implementation);
    }

    function delegateTo(address callee, bytes memory data)
        internal
        returns (bytes memory)
    {
        (bool success, bytes memory returnData) = callee.delegatecall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize())
            }
        }
        return returnData;
    }

    /**
     * @notice Delegates execution to the implementation contract
     * @dev It returns to the external caller whatever the implementation returns or forwards reverts
     * @param data The raw data to delegatecall
     * @return The returned bytes from the delegatecall
     */
    function delegateToImplementation(bytes memory data)
        public
        returns (bytes memory)
    {
        return delegateTo(implementation, data);
    }

    /**
     * @notice Delegates execution to an implementation contract
     * @dev It returns to the external caller whatever the implementation returns or forwards reverts
     *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
     * @param data The raw data to delegatecall
     * @return The returned bytes from the delegatecall
     */
    function delegateToViewImplementation(bytes memory data)
        public
        view
        returns (bytes memory)
    {
        (bool success, bytes memory returnData) =
            address(this).staticcall(
                abi.encodeWithSignature("delegateToImplementation(bytes)", data)
            );
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize())
            }
        }
        return abi.decode(returnData, (bytes));
    }

    /**
     * @notice Delegates execution to an implementation contract
     * @dev It returns to the external caller whatever the implementation returns or forwards reverts
    //  */
    fallback() external payable {
        if (msg.value > 0) return;
        // delegate all other functions to current implementation
        (bool success, ) = implementation.delegatecall(msg.data);
        assembly {
            let free_mem_ptr := mload(0x40)
            returndatacopy(free_mem_ptr, 0, returndatasize())
            switch success
                case 0 {
                    revert(free_mem_ptr, returndatasize())
                }
                default {
                    return(free_mem_ptr, returndatasize())
                }
        }
    }

    
    function add(
        uint256 _allocPoint,
        IERC20 _erc20Token,
        bool _isUpdate
    ) public override {
        delegateToImplementation(
            abi.encodeWithSignature(
                "add(uint256,address,bool)",
                _allocPoint,
                _erc20Token,
                _isUpdate
            )
        );
    }

    function setAllocationPoint(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public override {
        delegateToImplementation(
            abi.encodeWithSignature(
                "setAllocationPoint(uint256,uint256,bool)",
                _pid,
                _allocPoint,
                _withUpdate
            )
        );
    }

    function setDistributeShardVelocity(uint256 _shardPerBlock, bool _withUpdate) public override {
        delegateToImplementation(
            abi.encodeWithSignature(
                "setAllocationPoint(uint256,bool)",
                _shardPerBlock,
                _withUpdate
            )
        );
    }

    function massUpdatePools() public override {
        delegateToImplementation(abi.encodeWithSignature("massUpdatePools()"));
    }

    function addAvailableDividend(uint256 _amount, bool _isUpdate) public override {
        delegateToImplementation(
            abi.encodeWithSignature("addAvailableDividend(uint256,bool)", _amount, _isUpdate)
        );
    }

    function updatePoolDividend(uint256 _pid) public override {
        delegateToImplementation(
            abi.encodeWithSignature("updatePoolDividend(uint256)", _pid)
        );
    }

    function deposit(
        uint256 _pid,
        uint256 _amount
    ) public override {
        delegateToImplementation(
            abi.encodeWithSignature(
                "deposit(uint256,uint256)",
                _pid,
                _amount
            )
        );
    }

    function withdraw(uint256 _pid, uint256 _amount) public override {
        delegateToImplementation(
            abi.encodeWithSignature("withdraw(uint256,uint256)", _pid, _amount)
        );
    }

    function setDeveloperFund(
        address _devAddress,
        uint256 _userDividendWeight,
        uint256 _devDividendWeight
    ) public override {
        delegateToImplementation(
            abi.encodeWithSignature(
                "setDeveloperFund(address,uint256,uint256)",
                _devAddress,
                _userDividendWeight,
                _devDividendWeight
            )
        );
    }

    function setTokenAmountLimitFeeRate(
        uint256 _amountLimit,
        uint256 _feeRateNumerator,
        uint256 _feeRateDenominator
    ) public override {
        delegateToImplementation(
            abi.encodeWithSignature(
                "setTokenAmountLimitFeeRate(uint256,uint256,uint256)",
                _amountLimit,
                _feeRateNumerator,
                _feeRateDenominator
            )
        );
    }

    function setContracSenderFeeRate(
        uint256 _feeRateNumerator,
        uint256 _feeRateDenominator
    ) public override {
        delegateToImplementation(
            abi.encodeWithSignature(
                "setContracSenderFeeRate(uint256,uint256)",
                _feeRateNumerator,
                _feeRateDenominator
            )
        );
    }

    function pendingSHARD(uint256 _pid, address _user)
        external
        view
        override
        returns (uint256)
    {
        bytes memory data =
            delegateToViewImplementation(
                abi.encodeWithSignature(
                    "pendingSHARD(uint256,address)",
                    _pid,
                    _user
                )
            );
        return abi.decode(data, (uint256));
    }

    function getPoolLength() public view override returns (uint256) {
        bytes memory data =
            delegateToViewImplementation(
                abi.encodeWithSignature("getPoolLength()")
            );
        return abi.decode(data, (uint256));
    }

    function getAvailableDividendSHARD() public view override returns (uint256) {
        bytes memory data =
            delegateToViewImplementation(
                abi.encodeWithSignature("getAvailableDividendSHARD()")
            );
        return abi.decode(data, (uint256));
    }

    function getMultiplier(uint256 _from, uint256 _to) public view override returns (uint256) {
        bytes memory data =
            delegateToViewImplementation(
                abi.encodeWithSignature("getMultiplier(uint256,uint256)", _from, _to)
            );
        return abi.decode(data, (uint256));
    }

    function getPoolInfo(uint256 _pid) 
        public 
        view 
        override
        returns(
            uint256 _allocPoint,
            uint256 _accumulativeDividend, 
            uint256 _usersTotalWeight, 
            uint256 _lpTokenAmount, 
            address _swapAddress, 
            uint256 _accs)
    {
        bytes memory data =
            delegateToViewImplementation(
                abi.encodeWithSignature(
                    "getPoolInfo(uint256)",
                    _pid
                )
            );
            return
            abi.decode(
                data,
                (
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    address,
                    uint256
                )
            );
    }

    function getPagePoolInfo(uint256 _fromIndex, uint256 _toIndex)
        public
        view
        override
        returns (
            uint256[] memory _allocPoint,
            uint256[] memory _accumulativeDividend, 
            uint256[] memory _usersTotalWeight, 
            uint256[] memory _lpTokenAmount, 
            address[] memory _swapAddress, 
            uint256[] memory _accs
        )
    {
        bytes memory data =
            delegateToViewImplementation(
                abi.encodeWithSignature(
                    "getPagePoolInfo(uint256,uint256)",
                    _fromIndex,
                    _toIndex
                )
            );
        return
            abi.decode(
                data,
                (
                    uint256[],
                    uint256[],
                    uint256[],
                    uint256[],
                    address[],
                    uint256[]
                )
            );
    }

    function getUserInfo(uint256 _pid, address _user)
        public
        view
        override
        returns (
            uint256 _amount, 
            uint256 _originWeight, 
            uint256 _modifiedWeight, 
            uint256 _revenue, 
            uint256 _rewardDebt, 
            bool _withdrawnState,
            bool _isContractSender
        )
    {
        bytes memory data =
            delegateToViewImplementation(
                abi.encodeWithSignature(
                    "getUserInfo(uint256,address)",
                    _pid,
                    _user
                )
            );
        return abi.decode(data, (uint256, uint256, uint256, uint256, uint256, bool, bool));
    }
}