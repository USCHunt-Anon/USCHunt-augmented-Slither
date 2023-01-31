// : Apache License, Version 2.0

pragma solidity 0.7.6;



// Part: Address

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
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
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
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
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
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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

// Part: IChainLinkFeed

interface IChainLinkFeed {
    function latestAnswer() external view returns (int256);
}

// Part: IERC165

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

// Part: IERC20

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

// Part: ReentrancyGuard

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

    constructor () internal {
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

// Part: SafeMath

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
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
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
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
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
        require(b > 0, errorMessage);
        return a % b;
    }
}

// Part: IERC1155

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
}

// Part: IStarNFT

/**
 * @title IStarNFT
 * @author Galaxy Protocol
 *
 * Interface for operating with StarNFTs.
 */
interface IStarNFT is IERC1155 {
    /* ============ Events =============== */
    event PowahUpdated(uint256 indexed id, uint256 indexed oldPoints, uint256 indexed newPoints);

    /* ============ Functions ============ */

    function isOwnerOf(address, uint256) external view returns (bool);
    function starInfo(uint256) external view returns (uint128 powah, uint128 mintBlock, address originator);
    function quasarInfo(uint256) external view returns (uint128 mintBlock, IERC20 stakeToken, uint256 amount, uint256 campaignID);
    function superInfo(uint256) external view returns (uint128 mintBlock, IERC20[] memory stakeToken, uint256[] memory amount, uint256 campaignID);

    // mint
    function mint(address account, uint256 powah) external returns (uint256);
    function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external returns (uint256[] memory);
    function burn(address account, uint256 id) external;
    function burnBatch(address account, uint256[] calldata ids) external;

    // asset-backing mint
    function mintQuasar(address account, uint256 powah, uint256 cid, IERC20 stakeToken, uint256 amount) external returns (uint256);
    function burnQuasar(address account, uint256 id) external;

    // asset-backing forge
    function mintSuper(address account, uint256 powah, uint256 campaignID, IERC20[] calldata stakeTokens, uint256[] calldata amounts) external returns (uint256);
    function burnSuper(address account, uint256 id) external;
    // update
    function updatePowah(address owner, uint256 id, uint256 powah) external;
}

// File: SpaceStation.sol

/**
 * @title SpaceStation
 * @author Galaxy Protocol
 *
 * Campaign contract that allows privileged DAOs to initiate campaigns for members to claim StarNFTs.
 */
contract SpaceStation is ReentrancyGuard {
    using Address for address;
    using SafeMath for uint256;

    /* ============ Events ============ */
    event EventActivateCampaign(uint256 _cid);
    event EventActivateStakeCampaign(uint256 _cid);
    event EventExpireCampaign(uint256 _cid);
    event EventClaim(uint256 _cid, address _sender);
    event EventStakeIn(uint256 _cid, address _sender, uint256 _stakeAmount, address _erc20);
    event EventStakeOut(address _starNFT, uint256 _nftID);
    event EventForgeNoStake(uint256 _cid, address _sender, address _starNFT, uint256[] _nftIDs);
    event EventForgeWithStake(uint256 _cid, address _sender, address _starNFT, uint256[] _nftIDs, uint256 _stakeAmount, address _erc20);

    /* ============ Modifiers ============ */
    /**
     * Throws if the address is not a validated starNFT contract
     */
    modifier onlyStarNFT(IStarNFT _starNFTAddress)  {
        require(_starNFTs[_starNFTAddress], "Invalid Star NFT contract address");
        _;
    }
    /**
     * Throws if the sender is not the manager
     */
    modifier onlyManager() {
        _validateOnlyManager();
        _;
    }
    /**
     * Throws if the sender is not the Treasury's manager
     */
    modifier onlyTreasuryManager() {
        _validateOnlyTreasuryManager();
        _;
    }
    /**
     * Throws if the contract paused
     */
    modifier onlyNoPaused() {
        _validateOnlyNotPaused();
        _;
    }

    /* ============ Enums ================ */

    // Operation a user could interact with Galaxy per campaign of DAO
    enum Operation {
        Default,
        Claim,
        StakeIn,
        StakeOut,
        Forge
    }

    /* ============ Structs ============ */

    struct CampaignStakeConfig {
        address erc20;                  // Address of token being staked
        uint256 minStakeAmount;         // Minimum amount of token to stake required, included
        uint256 maxStakeAmount;         // Maximum amount of token to stake required, included
        uint256 lockBlockNum;           // To indicate when token lock-up period is met
        bool burnRequired;              // Require NFT burnt if staked out
        bool isEarlyStakeOutAllowed;    // Whether early stake out is allowed or not
        uint256 earlyStakeOutFine;      // If early stake out is allowed, the applied penalty
    }

    struct CampaignFeeConfig {
        address erc20;                 // Address of token asset if required
        uint256 erc20Fee;              // Amount of token if required
        uint256 operationFee;          // Amount of fee for using the service if applicable
        bool isActive;                 // Indicate whether this campaign exists and is active
    }

    /* ============ State Variables ============ */

    // The manager which has privilege to add, remove starNFT address, control treasury.
    address public manager;
    address public treasury_manager;

    // Mapping that stores all stake requirement for a given activated campaign.
    mapping(uint256 => CampaignStakeConfig) public campaignStakeConfigs;

    // Mapping that stores all fee requirements per Operation for a given activated campaign.
    // If no fee is required at all, Operation(DEFAULT) should set to all zero values.
    // Operation(DEFAULT) should always exist.
    mapping(uint256 => mapping(Operation => CampaignFeeConfig)) public campaignFeeConfigs;

    // Set that contains all validated starNFT contract addresses
    mapping(IStarNFT => bool) private _starNFTs;

    // Mapping that records fees totals owned by galaxy-treasury,
    // Separate from escrow backed-asset from users.
    uint256 public galaxyTreasuryNetwork;
    mapping(address => uint256) public galaxyTreasuryERC20;
    // contract is initialized
    bool public initialized;
    // contract is paused
    bool public paused;

    /* ============ Constant Variables ============ */
    // calcGasUsedAvg() using historical data from etherscan.
    mapping(Operation => uint) public mintGasAvg;
    // TODO: make it constant or immutable.
    // ethereum: IChainLinkFeed(0x169E633A2D1E6c10dD91238Ba11c4A708dfEF37C);
    // Rinkeby: IChainLinkFeed(0xc3fFAC889CEB6c556CA36c04F69E68253bdB5218);
    IChainLinkFeed public FASTGAS;

    /* ============ Constructor ============ */

    constructor() {}

    function initialize(address _manager, address _treasury_manager, address _iChainLinkFeed) external {
        require(!initialized, "Contract already initialized");
        if (_manager != address(0)) {
            manager = _manager;
        } else {
            // `manager` defaults to msg.sender on construction if no valid manager address passed in.
            manager = msg.sender;
        }
        if (_treasury_manager != address(0)) {
            treasury_manager = _treasury_manager;
        } else {
            // `treasury_manager` defaults to msg.sender on construction if no valid treasury_manager address passed in.
            treasury_manager = msg.sender;
        }
        // Init global network gas config.
        // calcGasUsedAvg() using historical data from etherscan for starNFT operations. TODO: Try using avg(gasUsed) oracle if there is such service.
        mintGasAvg[Operation.Default] = 114169;
        // Init ChainLinkFeed contract interface. Ethereum: 0x169E633A2D1E6c10dD91238Ba11c4A708dfEF37C.
        FASTGAS = IChainLinkFeed(_iChainLinkFeed);
        initialized = true;
    }

    /* ============ External Functions ============ */

    function activateCampaign(
        uint256 _cid,
        Operation[] calldata _op,
        uint256[] calldata _platformFee,
        uint256[] calldata _erc20Fee,
        address[] calldata _erc20
    ) external onlyManager {
        _setFees(_cid, _op, _platformFee, _erc20Fee, _erc20);
        emit EventActivateCampaign(_cid);
    }

    /**
     * Expire a non-stake campaign. Those with asset-backed quasar_nft campaigns won't get touched.
     * NOTE: should only reset non-stake campaigns.
     */
    function expireCampaign(uint256 _cid, Operation[] calldata _op) external onlyManager {
        require(_op.length > 0, "Array(_op) should not be empty.");
        for (uint256 i = 0; i < _op.length; i++) {
            delete campaignFeeConfigs[_cid][_op[i]];
        }
        emit EventExpireCampaign(_cid);
    }


    /**
     * Activate a stake campaign.
     * @param _params bytes1: Bitwise params for stake requirements
     * {
     *   burnRequired,         // First bit, Require NFT burnt if staked out
     *   earlyStakeOutFine     // Second bit, Whether early stake out is allowed or not
     * }
     * 0b00000000 0x00  => false, false
     * 0b01000000 0x40  => false, true
     * 0b10000000 0x80  => true, false
     * 0b11000000 0xc0  => true, true
     */
    function activateStakeCampaign(
        uint256 _cid,
        address _stakeErc20,
        uint256 _minStakeAmount,
        uint256 _maxStakeAmount,
        uint256 _lockBlockNum,
        bytes1 _params,
        uint256 _earlyStakeOutFine,
        Operation[] calldata _op,
        uint256[] calldata _platformFee,
        uint256[] calldata _erc20Fee,
        address[] calldata _erc20
    ) external onlyManager {
        require(_stakeErc20 != address(0), "Stake Token must not be null address");
        require(_minStakeAmount > 0, "Min stake amount should be greater than 0 for stake campaign");
        require(_minStakeAmount <= _maxStakeAmount, "StakeAmount min should less than or equal to max");

        _setFees(_cid, _op, _platformFee, _erc20Fee, _erc20);

        _setStake(_cid, _stakeErc20, _minStakeAmount, _maxStakeAmount, _lockBlockNum, _params, _earlyStakeOutFine);

        emit EventActivateStakeCampaign(_cid);
    }

    // TODO: add merkle proof and direct `Operation` support.

    function claim(uint256 _cid) external payable onlyNoPaused {
        _payFees(_cid, Operation.Claim);
        emit EventClaim(_cid, msg.sender);
    }

    function stakeIn(uint256 _cid, uint256 stakeAmount) external payable nonReentrant onlyNoPaused {
        _payFees(_cid, Operation.StakeIn);
        _stakeIn(_cid, stakeAmount);
        emit EventStakeIn(_cid, msg.sender, stakeAmount, campaignStakeConfigs[_cid].erc20);
    }

    // CALL STAR_NFT*
    function stakeOutQuasar(IStarNFT _starNFT, uint256 _nftID) external payable onlyStarNFT(_starNFT) nonReentrant {
        require(_starNFT.isOwnerOf(msg.sender, _nftID), "Must be owner of this Quasar NFT");
        // 1.1 get info, make sure nft has backing-asset
        (uint256 _mintBlock, IERC20 _stakeToken, uint256 _amount, uint256 _cid) = _starNFT.quasarInfo(_nftID);
        require(address(_stakeToken) != address(0), "Backing-asset token must not be null address");
        require(_amount > 0, "Backing-asset amount must be greater than 0");
        // 2. check early stake out fine if applies
        _payFine(_cid, _mintBlock);
        // 3. pay fee
        _payFees(_cid, Operation.StakeOut);
        // 4. transfer back (backed asset)
        require(_stakeToken.transfer(msg.sender, _amount), "Stake out transfer assert back failed");
        // 5. postStakeOut (quasar->star nft; burn quasar)
        if (campaignStakeConfigs[_cid].burnRequired) {
            _starNFT.burn(msg.sender, _nftID);
        } else {
            _starNFT.burnQuasar(msg.sender, _nftID);
        }
        emit EventStakeOut(address(_starNFT), _nftID);
    }

    function stakeOutSuper(IStarNFT _starNFT, uint256 _nftID) external payable onlyStarNFT(_starNFT) nonReentrant {
        require(_starNFT.isOwnerOf(msg.sender, _nftID), "Must be owner of this Super NFT");
        // 1.1 get info, make sure nft has backing-asset
        (uint256 _mintBlock, IERC20[] memory _stakeToken, uint256[] memory _amount, uint256 _cid) = IStarNFT(_starNFT).superInfo(_nftID);
        require(_stakeToken.length > 0, "Array(_stakeToken) should not be empty.");
        require(_stakeToken.length == _amount.length, "Array(_amount) length mismatch");
        // 2. check early stake out fine if applies
        _payFine(_cid, _mintBlock);
        // 3. pay fee
        _payFees(_cid, Operation.StakeOut);
        // 4. transfer back (backed asset)
        for (uint256 i = 0; i < _stakeToken.length; i++) {
            require(address(_stakeToken[i]) != address(0), "Backing-asset token must not be null address");
            require(_amount[i] > 0, "Backing-asset amount must be greater than 0");
            require(_stakeToken[i].transfer(msg.sender, _amount[i]), "Stake out transfer assert back failed");
        }
        // 5. postStakeOut (super->star nft; burn super)
        if (campaignStakeConfigs[_cid].burnRequired) {
            _starNFT.burn(msg.sender, _nftID);
        } else {
            _starNFT.burnSuper(msg.sender, _nftID);
        }
        emit EventStakeOut(address(_starNFT), _nftID);
    }

    function forgeNoStake(uint256 _cid, IStarNFT _starNFT, uint256[] calldata _nftIDs) external payable onlyStarNFT(_starNFT) nonReentrant onlyNoPaused {
        for (uint i = 0; i < _nftIDs.length; i++) {
            require(_starNFT.isOwnerOf(msg.sender, _nftIDs[i]), "Not the owner");
        }
        _payFees(_cid, Operation.Forge);
        _starNFT.burnBatch(msg.sender, _nftIDs);
        emit EventForgeNoStake(_cid, msg.sender, address(_starNFT), _nftIDs);
    }

    function forgeStake(uint256 _cid, IStarNFT _starNFT, uint256[] calldata _nftIDs, uint256 stakeAmount) external payable onlyStarNFT(_starNFT) nonReentrant onlyNoPaused {
        for (uint i = 0; i < _nftIDs.length; i++) {
            require(_starNFT.isOwnerOf(msg.sender, _nftIDs[i]), "Not the owner");
        }
        _payFees(_cid, Operation.Forge);
        _stakeIn(_cid, stakeAmount);
        _starNFT.burnBatch(msg.sender, _nftIDs);
        emit EventForgeWithStake(_cid, msg.sender, address(_starNFT), _nftIDs, stakeAmount, campaignStakeConfigs[_cid].erc20);
    }

    receive() external payable {}

    fallback() external payable {}

    function setPause(bool _paused) external onlyManager {
        paused = _paused;
    }

    /**
     * PRIVILEGED MODULE FUNCTION. Function that update global chainLink oracle contract address.
     */
    function updateIChainLinkFeedContractAddress(address feedAddress) external onlyManager {
        require(feedAddress != address(0), "IChainLinkFeed contract must not be null address");
        FASTGAS = IChainLinkFeed(feedAddress);
    }

    /**
     * PRIVILEGED MODULE FUNCTION. Function that update global network gas avg per Operation.
     */
    function updateGasAvgPerOp(Operation[] calldata _op, uint256[] calldata _gasAvg) external onlyManager {
        require(_op.length > 0, "Array(_op) should not be empty.");
        // Don't use validate arrays because empty arrays are valid
        require(_op.length == _gasAvg.length, "Array(_gasAvg) length mismatch");

        for (uint i = 0; i < _op.length; i++) {
            mintGasAvg[_op[i]] = _gasAvg[i];
        }
    }
    /**
     * PRIVILEGED MODULE FUNCTION. Function that adds a validated starNFT address.
     */
    function addValidatedStarNFTAddress(IStarNFT _starNFT) external onlyManager {
        require(address(_starNFT) != address(0), "Validate StarNFT contract must not be null address");
        _starNFTs[_starNFT] = true;
    }
    /**
     * PRIVILEGED MODULE FUNCTION. Function that removes a validated starNFT address.
     */
    function removeValidatedStarNFTAddress(IStarNFT _starNFT) external onlyManager {
        require(address(_starNFT) != address(0), "Invalidate StarNFT contract must not be null address");
        _starNFTs[_starNFT] = false;
    }

    /**
     * PRIVILEGED MODULE FUNCTION. Function that withdraw fees[network] total owned by galaxy-treasury to manager.
     */
    function networkWithdraw() external onlyTreasuryManager {
        // get the amount of Ether/BNB fees stored in this contract owned by galaxy-treasury
        uint256 amount = galaxyTreasuryNetwork;
        require(amount > 0, "Treasury of network should be greater than 0");

        // modify state first
        galaxyTreasuryNetwork = 0;
        // send Ether/BNB fees to manager
        // Manager can receive Ether/BNB since the address of manager is payable
        (bool success,) = manager.call{value : amount}("");
        require(success, "Failed to send Ether/BNB fees to treasury manager");
    }

    /**
     * PRIVILEGED MODULE FUNCTION. Function that withdraw fees[erc20] total owned by galaxy-treasury to manager.
     */
    function erc20Withdraw(address erc20) external onlyTreasuryManager nonReentrant {
        // get the amount of erc20 fees stored in this contract owned by galaxy-treasury
        uint256 amount = galaxyTreasuryERC20[erc20];
        require(amount > 0, "Treasury of ERC20 should be greater than 0");

        // modify state first
        galaxyTreasuryERC20[erc20] = 0;
        // send erc20 fees to manager
        require(IERC20(erc20).transfer(manager, amount), "Failed to send Erc20 fees to treasury manager");
    }

    /**
      * @dev stake out quasar in emergency mode
      */
    function emergencyWithdrawQuasar(IStarNFT _starNFT, uint256 _nftID) external onlyStarNFT(_starNFT) nonReentrant {
        require(paused, "Not paused");
        require(_starNFT.isOwnerOf(msg.sender, _nftID), "Must be owner of this Quasar NFT");
        // 1.1 get info, make sure nft has backing-asset
        (uint256 _mintBlock, IERC20 _stakeToken, uint256 _amount, uint256 _cid) = _starNFT.quasarInfo(_nftID);
        require(address(_stakeToken) != address(0), "Backing-asset token must not be null address");
        require(_amount > 0, "Backing-asset amount must be greater than 0");
        // 4. transfer back (backed asset)
        require(_stakeToken.transfer(msg.sender, _amount), "Stake out transfer assert back failed");
        // 5. postStakeOut (quasar->star nft; burn quasar)
        if (campaignStakeConfigs[_cid].burnRequired) {
            _starNFT.burn(msg.sender, _nftID);
        } else {
            _starNFT.burnQuasar(msg.sender, _nftID);
        }
        emit EventStakeOut(address(_starNFT), _nftID);
    }

    /**
      * @dev stake out super in emergency mode
      */
    function emergencyWithdrawSuper(IStarNFT _starNFT, uint256 _nftID) external onlyStarNFT(_starNFT) nonReentrant {
        require(paused, "Not paused");
        require(_starNFT.isOwnerOf(msg.sender, _nftID), "Must be owner of this Super NFT");
        // 1.1 get info, make sure nft has backing-asset
        (uint256 _mintBlock, IERC20[] memory _stakeToken, uint256[] memory _amount, uint256 _cid) = IStarNFT(_starNFT).superInfo(_nftID);
        require(_stakeToken.length > 0, "Array(_stakeToken) should not be empty.");
        require(_stakeToken.length == _amount.length, "Array(_amount) length mismatch");
        // 4. transfer back (backed asset)
        for (uint256 i = 0; i < _stakeToken.length; i++) {
            require(address(_stakeToken[i]) != address(0), "Backing-asset token must not be null address");
            require(_amount[i] > 0, "Backing-asset amount must be greater than 0");
            require(_stakeToken[i].transfer(msg.sender, _amount[i]), "Stake out transfer assert back failed");
        }
        // 5. postStakeOut (super->star nft; burn super)
        if (campaignStakeConfigs[_cid].burnRequired) {
            _starNFT.burn(msg.sender, _nftID);
        } else {
            _starNFT.burnSuper(msg.sender, _nftID);
        }
        emit EventStakeOut(address(_starNFT), _nftID);
    }

    /* ============ External Getter Functions ============ */

    function getFastGasPrice() external view returns (uint) {
        return uint(FASTGAS.latestAnswer());
    }

    function stakeOutInfo(IStarNFT _starNFTAddress, uint256 _nft_id) external onlyStarNFT(_starNFTAddress) view returns (
        bool _allowStakeOut,
        uint256 _allowBlock,
        bool _requireBurn,
        uint256 _earlyStakeOutFine,
        uint256 _noFineBlock
    ) {
        (uint256 _createBlock, IERC20 _stakeToken, uint256 _amount, uint256 _cid) = _starNFTAddress.quasarInfo(_nft_id);
        if (address(_stakeToken) == address(0)) {
            // no asset
            return (false, 0, false, 0, 0);
        }
        _requireBurn = campaignStakeConfigs[_cid].burnRequired;
        //        uint256 lockBlockNum = campaignStakeConfigs[_cid].lockBlockNum;
        if (block.number >= campaignStakeConfigs[_cid].lockBlockNum.add(_createBlock)) {
            return (true, 0, _requireBurn, 0, 0);
        }
        _allowBlock = campaignStakeConfigs[_cid].lockBlockNum + _createBlock;
        if (!campaignStakeConfigs[_cid].isEarlyStakeOutAllowed) {
            // not allow early stakeout
            return (false, _allowBlock, _requireBurn, 0, 0);
        }
        _allowStakeOut = true;
        _allowBlock = _createBlock;
        _noFineBlock = _createBlock + campaignStakeConfigs[_cid].lockBlockNum;
        _earlyStakeOutFine = _noFineBlock
        .sub(block.number)
        .mul(10000)
        .mul(campaignStakeConfigs[_cid].earlyStakeOutFine)
        .div(campaignStakeConfigs[_cid].lockBlockNum)
        .div(10000);
    }

    function superStakeOutInfo(IStarNFT _starNFTAddress, uint256 _nft_id) external onlyStarNFT(_starNFTAddress) view returns (
        bool _allowStakeOut,
        uint256 _allowBlock,
        bool _requireBurn,
        uint256 _earlyStakeOutFine,
        uint256 _noFineBlock
    ) {
        (uint256 _createBlock, IERC20[] memory _stakeToken, , uint256 _cid) = _starNFTAddress.superInfo(_nft_id);
        if (_stakeToken.length == 0) {
            // no asset
            return (false, 0, false, 0, 0);
        }
        _requireBurn = campaignStakeConfigs[_cid].burnRequired;
        //        uint256 lockBlockNum = campaignStakeConfigs[_cid].lockBlockNum;
        if (block.number >= campaignStakeConfigs[_cid].lockBlockNum.add(_createBlock)) {
            return (true, 0, _requireBurn, 0, 0);
        }
        _allowBlock = campaignStakeConfigs[_cid].lockBlockNum + _createBlock;
        if (!campaignStakeConfigs[_cid].isEarlyStakeOutAllowed) {
            // not allow early stakeout
            return (false, _allowBlock, _requireBurn, 0, 0);
        }
        _allowStakeOut = true;
        _allowBlock = _createBlock;
        _noFineBlock = _createBlock + campaignStakeConfigs[_cid].lockBlockNum;
        _earlyStakeOutFine = _noFineBlock
        .sub(block.number)
        .mul(10000)
        .mul(campaignStakeConfigs[_cid].earlyStakeOutFine)
        .div(campaignStakeConfigs[_cid].lockBlockNum)
        .div(10000);
    }

    function isValidatedStarNFTAddress(IStarNFT _starNFT) external returns (bool) {
        return _starNFTs[_starNFT];
    }

    /* ============ Internal Functions ============ */

    function _getGasAvgPerOp(Operation _op) private returns (uint) {
        uint gasAvg = mintGasAvg[_op];
        if (gasAvg > 0) {
            return gasAvg;
        } else {
            return mintGasAvg[Operation.Default];
        }
    }

    function _setFees(
        uint256 _cid,
        Operation[] calldata _op,
        uint256[] calldata _platformFee,
        uint256[] calldata _erc20Fee,
        address[] calldata _erc20
    ) private {
        require(_op.length > 0, "Array(_op) should not be empty.");
        // Don't use validate arrays because empty arrays are valid
        require(_op.length == _platformFee.length, "Array(_platformFee) length mismatch");
        require(_op.length == _erc20Fee.length, "Array(_erc20Fee) length mismatch");
        require(_op.length == _erc20.length, "Array(_erc20) length mismatch");

        for (uint256 i = 0; i < _op.length; i++) {
            require((_erc20[i] == address(0) && _erc20Fee[i] == 0) || (_erc20[i] != address(0) && _erc20Fee[i] != 0), "Invalid erc20 fee requirement arguments");
            campaignFeeConfigs[_cid][_op[i]] = CampaignFeeConfig(_erc20[i], _erc20Fee[i], _platformFee[i], true);
        }
    }

    function _setStake(
        uint256 _cid,
        address _erc20,
        uint256 _minStakeAmount,
        uint256 _maxStakeAmount,
        uint256 _lockBlockNum,
        bytes1 _params,
        uint256 _earlyStakeOutFine
    ) private {
        campaignStakeConfigs[_cid] = CampaignStakeConfig(
            _erc20,
            _minStakeAmount,
            _maxStakeAmount,
            _lockBlockNum,
            _params & bytes1(0x80) != 0,
            _params & bytes1(0x40) != 0,
            _earlyStakeOutFine
        );
    }

    function _payFees(uint256 _cid, Operation _op) private {
        require(campaignFeeConfigs[_cid][Operation.Default].isActive, "Operation(DEFAULT) should be activated");

        // 0. which fee record to use
        Operation op_key = campaignFeeConfigs[_cid][_op].isActive ? _op : Operation.Default;
        CampaignFeeConfig memory feeConf = campaignFeeConfigs[_cid][op_key];
        // 1. pay network gas if needed
        uint256 total = _getGasAvgPerOp(_op) * uint(FASTGAS.latestAnswer()) + feeConf.operationFee;
        // 2. pay operationFee if needed
        require(msg.value >= total, "Invalid msg.value sent for networkGas plus operationFee");
        galaxyTreasuryNetwork = galaxyTreasuryNetwork.add(msg.value);
        // 3. pay erc20_fee if needed
        if (feeConf.erc20Fee > 0) {
            // user wallet transfer <erc20> of <feeConf.erc20Fee> to <this contract>.
            require(IERC20(feeConf.erc20).transferFrom(msg.sender, address(this), feeConf.erc20Fee), "Transfer erc20_fee failed");
            galaxyTreasuryERC20[feeConf.erc20] = galaxyTreasuryERC20[feeConf.erc20].add(feeConf.erc20Fee);
        }
    }

    function _payFine(uint256 _cid, uint256 _mintBlock) private {
        uint256 lockBlockNum = campaignStakeConfigs[_cid].lockBlockNum;
        // 1.2 only need to check early-stake-out config if lock up time has not been met yet
        if (block.number < _mintBlock + lockBlockNum) {
            require(campaignStakeConfigs[_cid].isEarlyStakeOutAllowed, "Early stake out not allowed");
            // calc fine if allow early stake out
            uint256 _fine = (_mintBlock + lockBlockNum)
            .sub(block.number)
            .mul(10000)
            .mul(campaignStakeConfigs[_cid].earlyStakeOutFine)
            .div(lockBlockNum)
            .div(10000);
            // Fine will be adding to treasury with platformFee in _payFees() if applies.
            // require(msg.value >= campaignFeeConfigs[_cid][Operation.StakeOut].platformFee.add(_fine), "Insufficient fine");
            uint256 total = _getGasAvgPerOp(Operation.StakeOut) * uint(FASTGAS.latestAnswer()) + campaignFeeConfigs[_cid][Operation.StakeOut].operationFee;
            require(msg.value >= total.add(_fine), "Insufficient fine");
        }
    }

    function _stakeIn(uint256 _cid, uint256 stakeAmount) private {
        // Stake in if needed
        require(campaignStakeConfigs[_cid].erc20 != address(0), "Stake campaign should be activated");
        require(stakeAmount >= campaignStakeConfigs[_cid].minStakeAmount, "StakeAmount should >= minStakeAmount");
        require(stakeAmount <= campaignStakeConfigs[_cid].maxStakeAmount, "StakeAmount should <= maxStakeAmount");
        // transfer <erc20> of <stakeAmount> to <this contract> from user wallet.
        require(IERC20(campaignStakeConfigs[_cid].erc20).transferFrom(msg.sender, address(this), stakeAmount), "Stake in erc20 failed");

    }

    /**
     * Due to reason error bloat, internal functions are used to reduce bytecode size
     */
    function _validateOnlyManager() internal view {
        require(msg.sender == manager, "Only manager can call");
    }

    function _validateOnlyTreasuryManager() internal view {
        require(msg.sender == treasury_manager, "Only treasury manager can call");
    }

    function _validateOnlyNotPaused() internal view {
        require(!paused, "Contract paused");
    }
}
