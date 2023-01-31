// : MIT
pragma solidity ^0.8.0;

//import"@openzeppelin/contracts/token/ERC20/IERC20.sol";
//import"@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
//import"@openzeppelin/contracts/access/Ownable.sol";
//import"@openzeppelin/contracts/token/ERC721/IERC721.sol";
//import"./IStakingPool.sol";


contract Upgradable721 is Ownable {
    address public trustPayAddress;
    uint256 public taxFee;
    uint256 public totalPoolCreated; // Total pool created by admin
    uint256 public totalUserStaked; // Total user staked to pools
    // uint256 constant ONE_DAY_IN_SECONDS = 86400;
    uint256 constant ONE_DAY_IN_SECONDS = 86400;
    uint256 constant ONE_YEAR_IN_SECONDS = 31536000;
    mapping(string => PoolInfo) public poolInfo; // Pools info
    mapping(address => uint256) public totalAmountStaked; //  tokenAddress => totalAmountStaked: balance of token staked to the pools
    mapping(address => uint256) public totalRewardClaimed; // tokenAddress => totalRewardClaimed: total reward user has claimed
    mapping(address => uint256) public totalRewardFund; // tokenAddress => rewardFund: total pools reward fund
    mapping(address => uint256) public totalStakedBalancePerUser; // total value users staked to the pool
    mapping(address => mapping(address => uint256)) public totalRewardClaimedPerUser; // tokenAddress => userAddress => amount: total reward users claimed
    mapping(string => mapping(address => uint256)) public stakedBalancePerUser; // poolId => userAddress => balance: total value each user staked to the pool
    mapping(string => mapping(address => uint256)) public rewardClaimedPerUser; // poolId => userAddress => balance: reward each user has claimed
    address public controller;
    // uint256 totalSuperAdmin; // total Super Admin
    uint256 public totalUserStakeNFT721;
    mapping(address => uint256) public totalStakedNFT721BalancePerUser;
    mapping(address => mapping(address => uint256)) public totalStakedNFT721BalanceByNFT;
    mapping(string => mapping(uint256 => address)) public stakeNFT721ByUser; // poolId => tokenId => userAddress
    mapping(address => uint256) public totalAmountNFT721Staked; //  tokenAddress => totalAmountStaked: balance of token staked to the pools
    mapping(string => mapping(address => mapping(uint256=>mapping(string=>StakingData721)))) public stakingDatas721; //pool -> user -> tokenId -> internalTxid -> StakingData
    uint256 public totalNFT721Staked; // total amount stake of all token
    uint256 public totalNFT721Staking; //total token stake in contract at the momment
    
    /*================================ MODIFIERS ================================*/
    
    modifier onlyAdmins() {
        require(IStakingPool(trustPayAddress).isAdmin(msg.sender) || IStakingPool(trustPayAddress).isSuperAdmin(msg.sender) || msg.sender == controller, "Only admins or super admins or controller");
        _;
    }
    
    modifier poolExist(string memory poolId) {
        require(poolInfo[poolId].initialFund != 0, "Pool is not exist");
        require(poolInfo[poolId].active == 1, "Pool has been disabled");
        _;
    }
    
    modifier notBlocked() {
        require(!IStakingPool(trustPayAddress).isBlackList(msg.sender), "Caller has been blocked");
        _;
    }

    modifier onlyController() {
        require(msg.sender == controller, "Only controller");
        _;
    }

    modifier onlySuperAdmin() {
        require(IStakingPool(trustPayAddress).isSuperAdmin(msg.sender) || msg.sender == controller, "Only super admins or controller");
        _;
    }
    
    /*================================ EVENTS ================================*/
    
    event StakingEvent( 
        uint256 amount,
        address indexed account,
        string poolId,
        string internalTxID
    );
    
    event PoolUpdated(
        uint256 rewardFund,
        address indexed creator,
        string poolId,
        string internalTxID
    );

    event AdminSet(
        address indexed admin,
        bool isSet,
        string typeAdmin
    );

    event FeeRecipientSet(
        address indexed setter,
        address indexed recipient
    );

    event TaxFeeSet(
        address indexed setter,
        uint256 fee
    );

    event BlacklistSet(
        address indexed user,
        bool isSet
    );

    event PoolActivationSet(
        address indexed admin,
        string poolId,
        uint256 isActive
    );

     event StakeNFT721(
        address indexed tokenAddress,
        address indexed from,
        address indexed to,
        uint256[] tokenIds,
        string[] strs
    );
    
    /*================================ STRUCTS ================================*/

    struct StakingData721 {
        uint256 amount;
        uint256 stakedTime; 
        uint256 unstakedTime;
        uint256 lastUpdateTime;
        uint256 claimedReward;
        uint256 claimableReward;
        uint256 rewardPerTokenPaid;
    }
    
    struct PoolInfo {
        address stakingToken; // staking token of the pool
        address rewardToken; // reward token of the pool
        uint256 stakedBalance; // total balance staked the pool
        uint256 totalRewardClaimed; // total reward user has claimed
        uint256 rewardFund; // reward token available
        uint256 initialFund; // initial reward fund
        uint256 apr; // annual percentage rate
        uint256 totalUserStaked; // total user staked
        uint256 rewardRatio; // ratio of reward amount user can claim, 0 < fixedTimeRate < 100
        uint256 stakingLimit; // maximum amount of token users can stake to the pool
        uint256 active; // pool activation status, 0: disable, 1: active
        uint256 poolType; // flexible: 0, fixedTime: 1, monthly: 2, 3: monthly with unstake period
        uint256[] flexData; // lastUpdateTime(0), rewardPerTokenPaid(1)
        uint256[] configs; // startDate(0), endDate(1), duration(2), endStakeDate(3), exchangeRateRewardToStaking(4), poolNFT(5)
        // uint256 poolNFT; // 1: pool Token, 2: pool 721, 3: pool 1155
    }
}


// : MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

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


// : MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.0;

//import"../IERC20.sol";
//import"../../../utils/Address.sol";

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


// : MIT
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

//import"../utils/Context.sol";

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
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
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
}


// : MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

//import"../../utils/introspection/IERC165.sol";

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}


// : MIT

pragma solidity ^0.8.0;

interface IStakingPool {
    function isAdmin(address _address) external view returns(bool);

    function controller() external view returns(address);

    function isSuperAdmin(address _address) external view returns(bool);

    function taxFee() external view returns(uint256);

    function feeRecipientAddress() external view returns(address);

    function isBlackList(address _address) external view returns(bool);
}

// : MIT
// OpenZeppelin Contracts v4.4.1 (utils/Address.sol)

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
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

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
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// : MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// : MIT
pragma solidity ^0.8.0;

//import"./Upgradable.sol"; 

contract StakingNFT721 is Upgradable721 {
    using SafeERC20 for IERC20;
    constructor() {
        controller = msg.sender;
    }
    /**
     * @dev Stake NFT721 to a pool  
     * @param strs: poolId(0), internalTxID(1)
     * @param tokenIds: id of token
    */
    function stakeNFT721(string[] memory strs, uint256[] memory tokenIds) external poolExist(strs[0]) notBlocked payable{
        string memory poolId = strs[0];
        PoolInfo storage pool = poolInfo[poolId];
        require(pool.configs[5] == 2);
        require(1e18*tokenIds.length <= pool.stakingLimit, "Pool staking limit is exceeded");

        require(msg.value == IStakingPool(trustPayAddress).taxFee(), "Tax fee amount is invalid");
        //check if valid stake date
        require(block.timestamp <= pool.configs[1] && block.timestamp >= pool.configs[0], "Stake721: stake time not valid");

        if (totalStakedNFT721BalancePerUser[msg.sender] == 0) {
            totalUserStakeNFT721 += 1;
        }
        if (stakedBalancePerUser[poolId][msg.sender] == 0) {
            pool.totalUserStaked += 1;
        }
        for(uint256 i = 0; i < tokenIds.length; i++) {
            uint256 amount = 1e18;
            //check amount > 0
            require(amount > 0, "Staking amount must be greater than 0");
            //check staking limit
            require(amount <= pool.stakingLimit, "Pool staking limit is exceeded");

            // Flexible pool update 
            if (pool.poolType == 0) {
                pool.flexData[1] = rewardPerToken(poolId);
                pool.flexData[0] = block.timestamp;
            }

            //create staking data 
            StakingData721 memory data = StakingData721(
                1e18,
                block.timestamp, //stake time
                0, //unstake time
                block.timestamp, //last update time
                0,
                0,
                pool.poolType == 0 ? pool.flexData[1] : 0
            );

            stakeNFT721ByUser[poolId][tokenIds[i]] = msg.sender;

            totalStakedNFT721BalancePerUser[msg.sender] += amount;

            // Update user staked balance by token address
            totalStakedNFT721BalanceByNFT[pool.stakingToken][msg.sender] += amount; 

            // Update user staked balance by pool
            stakedBalancePerUser[poolId][msg.sender] += amount;
            
            // Update pool staked balance
            pool.stakedBalance += amount;

            // Update staking limit
            pool.stakingLimit -= amount;
            
            // Update total staked balance by token address and tokenId
            totalAmountNFT721Staked[pool.stakingToken] += amount;
            totalNFT721Staked += amount;
            totalNFT721Staking += amount;

            stakingDatas721[poolId][msg.sender][tokenIds[i]][strs[i+1]] = data;
            IERC721(pool.stakingToken).safeTransferFrom(msg.sender, address(this), tokenIds[i]);
        }
        
        // Transfer tax fee
        _transferTaxFee();
        emit StakeNFT721(pool.stakingToken, msg.sender, address(this), tokenIds, strs);
    }

     /**
     * @dev Unstake NFT721 of a pool  
     * @param strs: poolId(0), internalTxID(1)
     * @param tokenId: token ID
    */
    function unstakeNFT(string[] memory strs, uint256 tokenId) external poolExist(strs[0]) notBlocked payable {
        string memory poolId = strs[0];
        PoolInfo storage pool = poolInfo[poolId];
        uint256[] memory t = new uint256[](1);
        t[0] = tokenId;
        StakingData721 storage data = stakingDatas721[poolId][msg.sender][tokenId][strs[1]];
        require(pool.configs[5] == 2,"This pool cant unstake NFT721");
        require(msg.value == IStakingPool(trustPayAddress).taxFee(), "Tax fee amount is invalid");

        require(data.amount == 1e18, "721 Unstake: Unstake amount exceed staked balance");

        // If monthly with unstake period pool
        if (pool.poolType == 3) {
            require(data.stakedTime + pool.configs[2] * ONE_DAY_IN_SECONDS <= block.timestamp, "Need to wait until staking period ended");
        }

        // Flexible pool update
        if (pool.poolType == 0) {
            pool.flexData[1] = rewardPerToken(poolId);
            pool.flexData[0] = block.timestamp;
        }

        // Update reward
        data.claimableReward = earned(msg.sender,tokenId, strs);
        if(pool.poolType == 0) data.rewardPerTokenPaid = pool.flexData[1];
        // Update user stake balance
        totalStakedNFT721BalancePerUser[msg.sender] -= 1e18;
        
        // Update user stake balance by token address 
        totalStakedNFT721BalanceByNFT[pool.stakingToken][msg.sender] -= 1e18;
        if (totalStakedNFT721BalancePerUser[msg.sender] == 0) {
            totalUserStakeNFT721 -= 1;
        }
        
        // Update user stake balance by pool
        stakedBalancePerUser[poolId][msg.sender] -= 1e18;
        if (stakedBalancePerUser[poolId][msg.sender] == 0) {
            pool.totalUserStaked -= 1;
        }
        // Update staked balance
        data.amount -= 1e18;
        
        // Update pool staked balance
        pool.stakedBalance -= 1e18; 

        // Update Staking Limit
        pool.stakingLimit += 1e18;
        
        // Update total staked balance by token address 
        totalAmountNFT721Staked[pool.stakingToken] -= 1e18;
        totalNFT721Staking -= 1e18;

        uint256 reward = 0;
         // If user unstake all token and has reward
         if ((canGetReward(strs,tokenId) && data.claimableReward > 0 && data.amount == 0) 
            || (data.claimableReward > 0 && pool.rewardRatio > 0 && data.amount == 0)) {
            reward = data.claimableReward; 
            require(IERC20(pool.rewardToken).balanceOf(address(this))  > reward, "Not enough balance");
            
            // If fixed time pool can only get partial amount ratio which was set by admin
            if (pool.poolType == 1 && data.stakedTime + pool.configs[2] * ONE_DAY_IN_SECONDS > block.timestamp) { 
                reward = reward * pool.rewardRatio / 100;
            }
            
            // Update pool total reward claimed and reward fund
            pool.totalRewardClaimed += reward;
            pool.rewardFund -= reward;
            
            // Update total reward user has claimed by token address
            totalRewardClaimed[pool.rewardToken] += reward;
            
            // Update pool reward claimed by user
            rewardClaimedPerUser[poolId][msg.sender] += reward;
            
            // Update pool reward claimed by user and token address
            totalRewardClaimedPerUser[pool.rewardToken][msg.sender] += reward;
            
            // Reset reward
            data.claimableReward = 0;
            
            // Transfer reward
            IERC20(pool.rewardToken).safeTransfer(msg.sender, reward);
        }  
        
        // Transfer staking token back to user
        IERC721(pool.stakingToken).safeTransferFrom(address(this), msg.sender, tokenId, "");
        // Transfer tax fee
        _transferTaxFee();
        emit StakeNFT721(pool.stakingToken,address(this), msg.sender, t, strs);
    }


    /**
     * @dev Claim reward when user has staked to the pool for a period of time 
     * @param strs: poolId(0), internalTxID(1)
    */
    function claimRewardNFT721(string[] memory strs, uint256 tokenId) external poolExist(strs[0]) notBlocked payable { 
        string memory poolId = strs[0];
        PoolInfo storage pool = poolInfo[poolId];
        StakingData721 storage data = stakingDatas721[poolId][msg.sender][tokenId][strs[1]];
        
        require(msg.value == IStakingPool(trustPayAddress).taxFee(), "Tax fee amount is invalid");
        
        // Flexible pool update
        if (pool.poolType == 0) {
            pool.flexData[1] = rewardPerToken(poolId);
            pool.flexData[0] = block.timestamp;
        }
        
        // Update reward        
        data.claimableReward = earned(msg.sender,tokenId, strs);
        if(pool.poolType == 0) data.rewardPerTokenPaid = pool.flexData[1];
        // Flexible pool update
        if (pool.poolType != 0) {
            data.lastUpdateTime = block.timestamp < pool.configs[1] ? block.timestamp : pool.configs[1];
        }
        
        uint256 availableAmount = data.claimableReward;
        
        // Fixed time get partial reward
        if (pool.poolType == 1 && data.stakedTime + pool.configs[2] * ONE_DAY_IN_SECONDS > block.timestamp) { 
            availableAmount = availableAmount * pool.rewardRatio / 100;
        }
        
        require(availableAmount > 0, "Reward is 0");
        require(IERC20(pool.rewardToken).balanceOf(address(this)) >= availableAmount, "Pool balance is not enough");
        require(canGetReward(strs, tokenId), "Not enough staking time"); 

        // Reset reward
        data.claimableReward = 0;
        data.claimedReward += availableAmount;
        
        // Update pool claimed amount
        pool.totalRewardClaimed += availableAmount;
        
        // Update pool reward fund
        pool.rewardFund -= availableAmount; 
        
        // Update reward claimed by token address
        totalRewardClaimed[pool.rewardToken] += availableAmount;
        
        // Update pool reward claimed by user
        rewardClaimedPerUser[poolId][msg.sender] += availableAmount;
        
        // Update pool reward claimed by user and token address
        totalRewardClaimedPerUser[pool.rewardToken][msg.sender] += availableAmount;
        
        // Transfer reward
        IERC20(pool.rewardToken).safeTransfer(msg.sender, availableAmount);

        // Transfer tax fee
        _transferTaxFee();
    
        emit StakingEvent(availableAmount, msg.sender, poolId, strs[1]); 
    } 

    function earned(address account,uint256 tokenId, string[] memory strs) 
        public
        view 
        returns(uint256)
    {
        string memory poolId = strs[0];
        string memory internalTxId = strs[1];
        StakingData721 memory data = stakingDatas721[poolId][account][tokenId][internalTxId];
        if (data.amount == 0) return 0;
        
        PoolInfo memory pool = poolInfo[poolId];
        uint256 amount = 0;
        // Flexible pool
        if (pool.poolType == 0) {
            amount = data.amount * (rewardPerToken(poolId) - data.rewardPerTokenPaid) / 1e20 + data.claimableReward;
        } else { 
            uint256 currentTimestamp = block.timestamp < pool.configs[1] ? block.timestamp : pool.configs[1];
            // Get current timestamp, if currentTimestamp > poolEndDate then poolEndDate will be currentTimestamp
            amount = (currentTimestamp - data.lastUpdateTime) * data.amount * pool.configs[4] / 1e18;
        }
        return pool.rewardFund > amount ? amount : pool.rewardFund;
    } 
    
    
    /**
     * @dev Check if enough time to claim reward
     * @param strs: poolId(0), internalTxId(1)
     * @param tokenId: token ID
    */
    function canGetReward(string[] memory strs, uint256 tokenId) public view returns (bool) {
        PoolInfo memory pool = poolInfo[strs[0]];
        StakingData721 memory data = stakingDatas721[strs[0]][msg.sender][tokenId][strs[1]];
        
        // Flexible & fixed time pool
        if (pool.poolType == 0) return true;
        
        // Pool with staking period
        return data.stakedTime + pool.configs[2] * ONE_DAY_IN_SECONDS <= block.timestamp;
    }

    function checkERC(address contractAddress) external view returns(bool) {
        return IERC721(contractAddress).supportsInterface(0x80ac58cd);
    }

    /**
     * @dev Return MaxTVL
     * @param poolDuration: endDate - startDate
     * @param totalReward: pool.initialFund
    */
    function getMaxTVL(uint256 poolDuration, uint256 totalReward) internal pure returns(uint256){
        return (totalReward* 1e20)/poolDuration;
    }

    /*================================ ADMINISTRATOR FUNCTIONS ================================*/
    
    /**
     * @dev Create pool
     * @param strs: poolId(0), internalTxID(1)
     * @param addr: stakingToken(0), rewardToken(1)
     * @param data: rewardFund(0), apr(1), rewardRatio(2), stakingLimit(3), poolType(4), poolNFT(5)
     * @param configs: startDate(0), endDate(1), duration(2), endStakedTime(3)
    */
    function createPool(string[] memory strs, address[] memory addr, uint256[] memory data, uint256[] memory configs) external onlyAdmins {
        require(poolInfo[strs[0]].initialFund == 0, "Pool already exists");
        require(data[0] > 0, "Reward fund must be greater than 0");
        require(configs[0] < configs[1], "End date must be greater than start date");
        require(configs[0] < configs[3], "End staking date must be greater than start date");
        
        uint256[] memory flexData = new uint256[](2);
        PoolInfo memory pool;
        if(data[4]!=0){
            pool = PoolInfo(addr[0], addr[1], 0, 0, data[0], data[0], data[1], 0, data[2], data[3] * 1e18, 1, data[4], flexData, configs);
        } else {
            uint256 poolDuration = configs[1] - configs[0];
            uint256 MaxTVL = getMaxTVL(poolDuration,data[0]);
            pool = PoolInfo(addr[0], addr[1], 0, 0, data[0], data[0], data[1], 0, data[2], MaxTVL, 1, data[4], flexData, configs);
        }
        
        if (isAdmin(msg.sender)) {
            IERC20(pool.rewardToken).safeTransferFrom(msg.sender, address(this), data[0]);
        }
        poolInfo[strs[0]] = pool;
        totalPoolCreated += 1;
        totalRewardFund[pool.rewardToken] += data[0];
        
        poolInfo[strs[0]].configs.push(data[5]);
        
        emit PoolUpdated(data[0], msg.sender, strs[0], strs[1]); 
    }
   

    /**
     * @dev Return configs of a pool
     * @param poolId: Pool id
    */
    function showConfigs(string memory poolId) external view returns(uint256[] memory) {
        PoolInfo memory pool = poolInfo[poolId];
        return pool.configs;
    }

    
    /**
     * @dev Return annual percentage rate of a pool
     * @param poolId: Pool id
    */
    function apr(string memory poolId) public view returns (uint256) {
        PoolInfo memory pool = poolInfo[poolId];
        
        // If not flexible pool
        if (pool.poolType != 0) return pool.apr; 
        
        // Flexible pool
        uint256 poolDuration = pool.configs[1] - pool.configs[0];
        if (pool.stakedBalance == 0 || poolDuration == 0) return 0;
        
        return (ONE_YEAR_IN_SECONDS * pool.rewardFund / poolDuration) * 100 / pool.stakedBalance; 
    }
    
    /**
     * @dev Return amount of reward token distibuted per second
     * @param poolId: Pool id
    */
    function rewardPerToken(string memory poolId) public view returns (uint256) {
        PoolInfo memory pool = poolInfo[poolId];
        
        require(pool.poolType == 0, "Only flexible pool");
        
        // poolDuration = poolEndDate - poolStartDate
        uint256 poolDuration = pool.configs[1] - pool.configs[0]; 
        
        // Get current timestamp, if currentTimestamp > poolEndDate then poolEndDate will be currentTimestamp
        uint256 currentTimestamp = block.timestamp < pool.configs[1] ? block.timestamp : pool.configs[1];
        // If stakeBalance = 0 or poolDuration = 0
        if (pool.stakedBalance == 0 || poolDuration == 0) return 0;
        
        
        // If the pool has ended then stop calculate reward per token
        if (currentTimestamp <= pool.flexData[0]) return pool.flexData[1];
        
        // result = result * 1e8 for zero prevention
        uint256 rewardPool = pool.initialFund * (currentTimestamp - pool.flexData[0]) * 1e20;
        
        // newRewardPerToken = rewardPerToken(newPeriod) + lastRewardPertoken          
        return rewardPool / (poolDuration * pool.stakedBalance) + pool.flexData[1];
    }
    
    /**
     * @dev Withdraw fund admin has sent to the pool
     * @param _tokenAddress: the token contract owner want to withdraw fund
     * @param _account: the account which is used to receive fund
     * @param _amount: the amount contract owner want to withdraw
    */
    function withdrawFund(address _tokenAddress, address _account, uint256 _amount) external onlyController {
        require(IERC20(_tokenAddress).balanceOf(address(this)) >= _amount, "Pool not has enough balance");
        
        // Transfer fund back to account
        IERC20(_tokenAddress).safeTransfer(_account, _amount);
    }

    /**
     * @dev Withdraw fund admin has sent to the pool
     * @param contractAddress: the NFT contract owner want to withdraw fund
     * @param _account: the account which is used to receive fund
     * @param tokenId: token ID
    */
    function withdrawNFT721(address contractAddress, address _account, uint256 tokenId) external onlyController {
        require(IERC721(contractAddress).ownerOf(tokenId) == address(this), "Pool not has this token");
        // Transfer fund back to account
        IERC721(contractAddress).safeTransferFrom(address(this), _account, tokenId);
    }
    
    /**
     * @dev Transfer tax fee 
    */
    function _transferTaxFee() internal {
        // If recipientAddress and taxFee are set
        if (IStakingPool(trustPayAddress).feeRecipientAddress() != address(0) && IStakingPool(trustPayAddress).taxFee() > 0) {
            payable(IStakingPool(trustPayAddress).feeRecipientAddress()).transfer(IStakingPool(trustPayAddress).taxFee());
        }
    }

    function setTotalNFT721Staking(uint256 amount) public onlyController {
        totalNFT721Staking = amount;
    }

    function viewTotalNFT721Staked() external view returns(uint256) {
        return totalNFT721Staked;
    }

    function viewTotalNFT721Staking() external view returns(uint256) {
        return totalNFT721Staking;
    }

    /**
     * @dev Check if a wallet address is admin or not
     * @param _address: wallet address of the user
    */
    function isAdmin(address _address) public view returns (bool) {
        return IStakingPool(trustPayAddress).isAdmin(_address);
    }

    /**
     * @dev Check if a wallet address is super admin or not
     * @param _address: wallet address of the user
    */
    function isSuperAdmin(address _address) external view returns (bool) {
        return IStakingPool(trustPayAddress).isSuperAdmin(_address);
    }
    
    /**
     * @dev Check if a user has been blocked
     * @param _address: user wallet 
    */
    function isBlackList(address _address) external view returns (bool) {
        return IStakingPool(trustPayAddress).isBlackList(_address);
    }
    
    /**
     * @dev Set pool active/deactive
     * @param _poolId: the pool id
     * @param _value: true/false
    */
    function setPoolActive(string memory _poolId, uint256 _value) external onlyAdmins {
        poolInfo[_poolId].active = _value;
        
        emit PoolActivationSet(msg.sender, _poolId, _value);
    }

    function initialize(address contractTrustPay) external onlyController{
        require(contractTrustPay != address(0), "Address is the zero address");
        trustPayAddress = contractTrustPay;
        taxFee = IStakingPool(trustPayAddress).taxFee();
        controller = IStakingPool(trustPayAddress).controller();
    }
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
    function blockTime() external view returns(uint256) {
        return block.timestamp;
    }
}

