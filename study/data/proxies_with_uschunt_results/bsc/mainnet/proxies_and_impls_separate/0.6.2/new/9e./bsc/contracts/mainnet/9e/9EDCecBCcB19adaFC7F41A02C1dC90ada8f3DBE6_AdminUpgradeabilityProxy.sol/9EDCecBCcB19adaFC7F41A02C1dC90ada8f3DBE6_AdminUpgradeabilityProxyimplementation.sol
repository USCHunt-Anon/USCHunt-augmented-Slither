// : MIT

pragma solidity >=0.4.0;

//import'./Ownable.sol';
//import'./Context.sol';
//import'./IBEP20.sol';
//import'./SafeMath.sol';
//import'./Address.sol';

/**
 * @dev Implementation of the {IBEP20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {BEP20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of BEP20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IBEP20-approve}.
 */
contract BEP20 is Context, IBEP20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external override view returns (address) {
        return owner();
    }

    /**
     * @dev Returns the token name.
     */
    function name() public override view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() public override view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() public override view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {BEP20-totalSupply}.
     */
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {BEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {BEP20-allowance}.
     */
    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {BEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {BEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
        );
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
        );
        return true;
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
     * the total supply.
     *
     * Requirements
     *
     * - `msg.sender` must be the token owner
     */
    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
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
    ) internal {
        require(sender != address(0), 'BEP20: transfer from the zero address');
        require(recipient != address(0), 'BEP20: transfer to the zero address');

        _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: mint to the zero address');

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: burn from the zero address');

        _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
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
    ) internal {
        require(owner != address(0), 'BEP20: approve from the zero address');
        require(spender != address(0), 'BEP20: approve to the zero address');

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
        );
    }
}


// : GPL-3.0-or-later

pragma solidity >=0.4.0;

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
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() internal {}

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


// : MIT

pragma solidity >=0.6.0 <0.8.0;
//import"./Initializable.sol";

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

    function __Context_init_unchained() internal initializer {
    }
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
pragma solidity ^0.6.12;

interface IAMVMinterV2 {
    function isMinter(address) view external returns(bool);
    function amountAMVToMint(uint bnbProfit) view external returns(uint);
    function amountAMVToMintForAMVBNB(uint amount, uint duration) view external returns(uint);
    function withdrawalFee(uint amount, uint depositedAt) view external returns(uint);
    function performanceFee(uint profit) view external returns(uint);
    function mintFor(address flip, uint _withdrawalFee, uint _performanceFee, address to, uint depositedAt) external payable;
    function mintForAMVBNB(uint amount, uint duration, address to) external;

    function amvPerProfitBNB() view external returns(uint);
    function WITHDRAWAL_FEE_FREE_PERIOD() view external returns(uint);
    function WITHDRAWAL_FEE() view external returns(uint);

    function setMinter(address minter, bool canMint) external;

    // V2 functions
    function mint(uint amount) external;
    function safeAMVTransfer(address to, uint256 amount) external;
    function mintGov(uint amount) external;
}

// : GPL-3.0-or-later

pragma solidity >=0.4.0;

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

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
    function allowance(address _owner, address spender) external view returns (uint256);

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
pragma solidity ^0.6.12;

interface IMasterChef {
    function cakePerBlock() view external returns(uint);
    function totalAllocPoint() view external returns(uint);

    function poolInfo(uint _pid) view external returns(address lpToken, uint allocPoint, uint lastRewardBlock, uint accCakePerShare);
    function userInfo(uint _pid, address _account) view external returns(uint amount, uint rewardDebt);

    function deposit(uint256 _pid, uint256 _amount) external;
    function withdraw(uint256 _pid, uint256 _amount) external;
    function emergencyWithdraw(uint256 _pid) external;

    function enterStaking(uint256 _amount) external;
    function leaveStaking(uint256 _amount) external;
}

// : MIT

// solhint-disable-next-line compiler-version
pragma solidity >=0.4.24 <0.8.0;


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
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

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
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }
}


// : MIT
pragma solidity >=0.6.2;

interface IPancakePair {
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

// : MIT
pragma solidity >=0.6.2;

interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


// : MIT

pragma solidity >=0.6.2;

//import'./IPancakeRouter01.sol';

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


// : MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

//import"./PoolConstant.sol";
//import"./IVaultController.sol";

interface IStrategy is IVaultController {
    function deposit(uint _amount) external;
    function depositAll() external;
    function withdraw(uint256 _amount) external;    // AMV STAKING POOL ONLY
    function withdrawAll() external;
    function getReward() external;                  // AMV STAKING POOL ONLY
    function harvest() external;

    function totalSupply() external view returns (uint);
    function balance() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function sharesOf(address account) external view returns (uint);
    function principalOf(address account) external view returns (uint);
    function earned(address account) external view returns (uint);
    function withdrawableBalanceOf(address account) external view returns (uint);   // AMV STAKING POOL ONLY
    function priceShare() external view returns(uint);

        /* ========== Strategy Information ========== */
    function pid() external view returns (uint);
    function poolType() external view returns (PoolConstant.PoolTypes);
    function depositedAt(address account) external view returns (uint);
    function rewardsToken() external view returns (address);

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount, uint256 withdrawalFee);
    event ProfitPaid(address indexed user, uint256 profit, uint256 performanceFee);
    event Harvested(uint256 profit);
}


// : MIT
pragma solidity ^0.6.12;

interface IVaultController {
    function minter() external view returns (address);
    function stakingToken() external view returns (address);
}

// : MIT

pragma solidity >=0.6.0 <0.8.0;

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
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}


// : GPL-3.0-or-later

pragma solidity >=0.4.0;

//import'./Context.sol';

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
    constructor() internal {
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
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// : MIT

pragma solidity >=0.6.0 <0.8.0;

//import"./ContextUpgradeable.sol";
//import"./Initializable.sol";
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
    function __Ownable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {
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
    uint256[49] private __gap;
}


/*
   ____            __   __        __   _
  / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
 _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
/___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
     /___/

* Docs: https://docs.synthetix.io/
*
*
* MIT License
* ===========
*
* Copyright (c) 2020 Synthetix
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/

// : MIT
pragma solidity ^0.6.2;

//import"./OwnableUpgradeable.sol";


abstract contract PausableUpgradeable is OwnableUpgradeable {
    uint public lastPauseTime;
    bool public paused;

    event PauseChanged(bool isPaused);

    modifier notPaused {
        require(!paused, "PausableUpgradeable: cannot be performed while the contract is paused");
        _;
    }

    function __PausableUpgradeable_init() internal initializer {
        __Ownable_init();
        require(owner() != address(0), "PausableUpgradeable: owner must be set");
    }

    function setPaused(bool _paused) external onlyOwner {
        if (_paused == paused) {
            return;
        }

        paused = _paused;
        if (paused) {
            lastPauseTime = now;
        }

        emit PauseChanged(paused);
    }
    uint256[50] private __gap;
}


// : MIT
pragma solidity ^0.6.12;

library PoolConstant {

    enum PoolTypes {
        AMVStake, AMVFlip, CakeStake, FlipToFlip, FlipToCake, FlipToBNB
    }

    struct PoolInfo {
        address pool;
        uint balance;
        uint principal;
        uint available;
        uint apy;
        uint tvl;
        uint pUSD;
        uint pBNB;
        uint pAMV;
        uint pCAKE;
        uint depositedAt;
        uint feeDuration;
        uint feePercentage;
    }

}


// : MIT

pragma solidity >=0.6.0 <0.8.0;
//import"./Initializable.sol";

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
abstract contract ReentrancyGuardUpgradeable is Initializable {
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


/*
   ____            __   __        __   _
  / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
 _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
/___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
     /___/

* Docs: https://docs.synthetix.io/
*
*
* MIT License
* ===========
*
* Copyright (c) 2020 Synthetix
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/

// : MIT
pragma solidity ^0.6.2;

//import"./OwnableUpgradeable.sol";

abstract contract RewardsDistributionRecipientUpgradeable is OwnableUpgradeable {
    address public rewardsDistribution;

    modifier onlyRewardsDistribution() {
        require(msg.sender == rewardsDistribution, "PausableUpgradeable: caller is not the rewardsDistribution");
        _;
    }

    function __RewardsDistributionRecipient_init() internal initializer {
        __Ownable_init();
    }

    function notifyRewardAmount(uint256 reward) virtual external;

    function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
        rewardsDistribution = _rewardsDistribution;
    }

    uint256[50] private __gap;
}


// : MIT

pragma solidity ^0.6.0;

//import'./IBEP20.sol';
//import'./SafeMath.sol';
//import'./Address.sol';

/**
 * @title SafeBEP20
 * @dev Wrappers around BEP20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IBEP20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IBEP20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IBEP20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            'SafeBEP20: approve from non-zero to non-zero allowance'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            'SafeBEP20: decreased allowance below zero'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
        }
    }
}


// : MIT

pragma solidity >=0.4.0;

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
        require(c >= a, 'SafeMath: addition overflow');

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
        return sub(a, b, 'SafeMath: subtraction overflow');
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
        require(c / a == b, 'SafeMath: multiplication overflow');

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
        return div(a, b, 'SafeMath: division by zero');
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
        return mod(a, b, 'SafeMath: modulo by zero');
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

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}


// : MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

//import"./SafeBEP20.sol";
//import"./BEP20.sol";

//import"./IPancakeRouter02.sol";
//import"./IPancakePair.sol";
//import"./IStrategy.sol";
//import"./IMasterChef.sol";
//import"./IAMVMinterV2.sol";
//import"./PausableUpgradeable.sol";
//import"./Whitelist.sol";

abstract contract VaultController is IVaultController, PausableUpgradeable, Whitelist {
    using SafeBEP20 for IBEP20;

    /* ========== CONSTANT VARIABLES ========== */
    BEP20 private constant AMV = BEP20(0x76383afd3C3501C2b0f5B4450E819eD430Ce4de0); // require mainnet
	BEP20 private constant CAKE = BEP20(0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82); // require mainnet

    /* ========== STATE VARIABLES ========== */

    address public keeper;
    IBEP20 internal _stakingToken;
    IAMVMinterV2 internal _minter;


    /* ========== Event ========== */

    event Recovered(address token, uint amount);


    /* ========== MODIFIERS ========== */

    modifier onlyKeeper {
        require(msg.sender == keeper || msg.sender == owner(), 'VaultController: caller is not the owner or keeper');
        _;
    }

    /* ========== INITIALIZER ========== */

    function __VaultController_init(IBEP20 token) internal initializer {
        __PausableUpgradeable_init();
        __Whitelist_init();

        keeper = 0x69acAf38Bcd090E2F888e0B2409c7031c005d760; // require mainnet
        _stakingToken = token;
    }

    /* ========== VIEWS FUNCTIONS ========== */

    function minter() external view override returns (address) {
        return canMint() ? address(_minter) : address(0);
    }

    function canMint() internal view returns (bool) {
        return address(_minter) != address(0) && _minter.isMinter(address(this));
    }

    function stakingToken() external view override returns (address) {
        return address(_stakingToken);
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function setKeeper(address _keeper) external onlyKeeper {
        require(_keeper != address(0), 'VaultController: invalid keeper address');
        keeper = _keeper;
    }

    function setMinter(address newMinter) virtual public onlyOwner {
        // can zero
        _minter = IAMVMinterV2(newMinter);
        if (address(newMinter) != address(0)) {
            require(address(newMinter) == AMV.getOwner(), 'VaultController: not amv minter');
            _stakingToken.safeApprove(address(newMinter), 0);
            _stakingToken.safeApprove(address(newMinter), uint(~0));
			
			IBEP20(CAKE).safeApprove(address(newMinter), 0);
            IBEP20(CAKE).safeApprove(address(newMinter), uint(~0));
        }
    }

    /* ========== SALVAGE PURPOSE ONLY ========== */

    function recoverToken(address _token, uint amount) virtual external onlyOwner {
        require(_token != address(_stakingToken), 'VaultController: cannot recover underlying token');
        IBEP20(_token).safeTransfer(owner(), amount);
    }

    /* ========== VARIABLE GAP ========== */

    uint256[50] private __gap;
}


// : MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

//import"./Math.sol";
//import"./SafeMath.sol";
//import"./SafeBEP20.sol";
//import"./ReentrancyGuardUpgradeable.sol";

//import"./RewardsDistributionRecipientUpgradeable.sol";
//import"./IStrategy.sol";
//import"./IMasterChef.sol";
//import"./IAMVMinterV2.sol";
//import"./VaultController.sol";
//import"./IPancakeRouter02.sol";
//import{PoolConstant} from "./PoolConstant.sol";


contract VaultFlipToBNB is VaultController, IStrategy, RewardsDistributionRecipientUpgradeable, ReentrancyGuardUpgradeable {
    using SafeMath for uint;
    using SafeBEP20 for IBEP20;

    /* ========== CONSTANTS ============= */

    address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    
    IMasterChef private constant CAKE_MASTER_CHEF = IMasterChef(0x73feaa1eE314F8c655E354234017bE2193C9E24E);
    IPancakeRouter02 private constant ROUTER = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    PoolConstant.PoolTypes public constant override poolType = PoolConstant.PoolTypes.FlipToBNB;

    /* ========== STATE VARIABLES ========== */

    IStrategy private _rewardsToken;

    uint public periodFinish;
    uint public rewardRate;
    uint public rewardsDuration;
    uint public lastUpdateTime;
    uint public rewardPerTokenStored;

    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public rewards;

    uint private _totalSupply;
    mapping(address => uint) private _balances;

    uint public override pid;
    mapping (address => uint) private _depositedAt;

    /* ========== MODIFIERS ========== */

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    /* ========== EVENTS ========== */

    event RewardAdded(uint reward);
    event RewardsDurationUpdated(uint newDuration);

    /* ========== INITIALIZER ========== */

    function initialize(uint _pid) external initializer {
        (address _token,,,) = CAKE_MASTER_CHEF.poolInfo(_pid);
        __VaultController_init(IBEP20(_token));
        __RewardsDistributionRecipient_init();
        __ReentrancyGuard_init();

        _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), uint(~0));

        pid = _pid;

        rewardsDuration = 4 hours;

        rewardsDistribution = msg.sender;
        setMinter(0xC7EBF06A6188040B45fe95112Ff5557c36Ded7c0);  
        setRewardsToken(0xe0C5E1c0e1B495D702C734d048D6cC09313E94DE); 
    }

    /* ========== VIEWS ========== */

    function totalSupply() external view override returns (uint) {
        return _totalSupply;
    }

    function balance() override external view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint) {
        return _balances[account];
    }

    function sharesOf(address account) external view override returns (uint) {
        return _balances[account];
    }

    function principalOf(address account) external view override returns (uint) {
        return _balances[account];
    }

    function depositedAt(address account) external view override returns (uint) {
        return _depositedAt[account];
    }

    function withdrawableBalanceOf(address account) public view override returns (uint) {
        return _balances[account];
    }

    function rewardsToken() external view override returns (address) {
        return address(_rewardsToken);
    }

    function priceShare() external view override returns (uint) {
        return 1e18;
    }

    function lastTimeRewardApplicable() public view returns (uint) {
        return Math.min(block.timestamp, periodFinish);
    }

    function rewardPerToken() public view returns (uint) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
        rewardPerTokenStored.add(
            lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
        );
    }

    function earned(address account) override public view returns (uint) {
        return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
    }

    function getRewardForDuration() external view returns (uint) {
        return rewardRate.mul(rewardsDuration);
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    function deposit(uint amount) override public {
        _deposit(amount, msg.sender);
    }

    function depositAll() override external {
        deposit(_stakingToken.balanceOf(msg.sender));
    }

    function withdraw(uint amount) override public nonReentrant updateReward(msg.sender) {
        require(amount > 0, "VaultFlipToBNB: amount must be greater than zero");
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        uint cakeHarvested = _withdrawStakingToken(amount);
        uint withdrawalFee;
        if (canMint()) {
            uint depositTimestamp = _depositedAt[msg.sender];
            withdrawalFee = _minter.withdrawalFee(amount, depositTimestamp);
            if (withdrawalFee > 0) {
                uint performanceFee = withdrawalFee.div(100);
                _minter.mintFor(address(_stakingToken), withdrawalFee.sub(performanceFee), performanceFee, msg.sender, depositTimestamp);
                amount = amount.sub(withdrawalFee);
            }
        }
        
        _stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount, withdrawalFee);

        _harvest(cakeHarvested);
    }

    function withdrawAll() external override {
		getReward();
        uint _withdraw = withdrawableBalanceOf(msg.sender);
        if (_withdraw > 0) {
            withdraw(_withdraw);
        }
// 		getReward();
    }

    function getReward() public override nonReentrant updateReward(msg.sender) {
        uint reward;
        if(rewards[msg.sender] > 0) {
            reward = rewards[msg.sender];
        } else {
            reward = earned(msg.sender);
        }
// 		reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            uint before = IBEP20(CAKE).balanceOf(address(this));
            
            _rewardsToken.withdraw(reward);
            
            uint cakeBalance = IBEP20(CAKE).balanceOf(address(this)).sub(before);
            uint performanceFee;

            if (canMint()) {
                performanceFee = _minter.performanceFee(cakeBalance);
                _minter.mintFor(CAKE, 0, performanceFee, msg.sender, _depositedAt[msg.sender]);
            }

            // IBEP20(CAKE).safeTransfer(msg.sender, cakeBalance.sub(performanceFee));
            if (cakeBalance.sub(performanceFee) > 0) {
                _swapTokenToToken(CAKE, cakeBalance.sub(performanceFee), WBNB);
            }
            emit ProfitPaid(msg.sender, cakeBalance, performanceFee);
        }
    }

    function harvest() public override {
        uint cakeHarvested = _withdrawStakingToken(0);
        _harvest(cakeHarvested);
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function setMinter(address newMinter) override public onlyOwner {
        VaultController.setMinter(newMinter);
        if (newMinter != address(0)) {
            IBEP20(CAKE).safeApprove(newMinter, 0);
            IBEP20(CAKE).safeApprove(newMinter, uint(- 1));
        }
    }

    function setRewardsToken(address newRewardsToken) public onlyOwner {
        require(address(_rewardsToken) == address(0), "VaultFlipToBNB: rewards token already set");

        _rewardsToken = IStrategy(newRewardsToken);
        IBEP20(CAKE).safeApprove(newRewardsToken, 0);
        IBEP20(CAKE).safeApprove(newRewardsToken, uint(- 1));
    }

    function notifyRewardAmount(uint reward) public override onlyRewardsDistribution {
        _notifyRewardAmount(reward);
    }

    function setRewardsDuration(uint _rewardsDuration) external onlyOwner {
        require(periodFinish == 0 || block.timestamp > periodFinish, "VaultFlipToBNB: reward duration can only be updated after the period ends");
        rewardsDuration = _rewardsDuration;
        emit RewardsDurationUpdated(rewardsDuration);
    }

    /* ========== PRIVATE FUNCTIONS ========== */
    
    function _approveTokenIfNeeded(address token) private {
        if (IBEP20(token).allowance(address(this), address(ROUTER)) == 0) {
            IBEP20(token).safeApprove(address(ROUTER), uint(~0));
        }
    }
    
    function _swapTokenToToken(address _from, uint amount, address _to) private returns (uint) {
        
        require(amount > 0, "VaultFlipToBNB: amount must be greater than zero");
        _approveTokenIfNeeded(_from);
        
        address[] memory path;
        
        if (_from == WBNB || _to == WBNB) {
            // [WBNB, AMV] or [AMV, WBNB]
            path = new address[](2);
            path[0] = _from;
            path[1] = _to;
        } else {
            // [USDT, AMV] or [AMV, USDT]
            path = new address[](3);
            path[0] = _from;
            path[1] = WBNB;
            path[2] = _to;
        }
       
        uint[] memory amounts = ROUTER.swapExactTokensForTokens(amount, 0, path, msg.sender, block.timestamp);
        return amounts[amounts.length - 1];
    }

    function _deposit(uint amount, address _to) private nonReentrant notPaused updateReward(_to) {
        require(amount > 0, "VaultFlipToBNB: amount must be greater than zero");
        _totalSupply = _totalSupply.add(amount);
        _balances[_to] = _balances[_to].add(amount);
        _depositedAt[_to] = block.timestamp;
        _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        uint cakeHarvested = _depositStakingToken(amount);
        emit Deposited(_to, amount);
		
        _harvest(cakeHarvested);
    }

    function _depositStakingToken(uint amount) private returns (uint cakeHarvested) {
        uint before = IBEP20(CAKE).balanceOf(address(this));
        CAKE_MASTER_CHEF.deposit(pid, amount);
        cakeHarvested = IBEP20(CAKE).balanceOf(address(this)).sub(before);
    }

    function _withdrawStakingToken(uint amount) private returns (uint cakeHarvested) {
        uint before = IBEP20(CAKE).balanceOf(address(this));
        CAKE_MASTER_CHEF.withdraw(pid, amount);
        cakeHarvested = IBEP20(CAKE).balanceOf(address(this)).sub(before);
    }

    function _harvest(uint cakeAmount) private {
        uint _before = _rewardsToken.sharesOf(address(this));
        _rewardsToken.deposit(cakeAmount);
        uint amount = _rewardsToken.sharesOf(address(this)).sub(_before);
        if (amount > 0) {
            _notifyRewardAmount(amount);
            emit Harvested(amount);
        }
    }

    function _notifyRewardAmount(uint reward) private updateReward(address(0)) {
        if (block.timestamp >= periodFinish) {
            rewardRate = reward.div(rewardsDuration);
        } else {
            uint remaining = periodFinish.sub(block.timestamp);
            uint leftover = remaining.mul(rewardRate);
            rewardRate = reward.add(leftover).div(rewardsDuration);
        }

        // Ensure the provided reward amount is not more than the balance in the contract.
        // This keeps the reward rate in the right range, preventing overflows due to
        // very high values of rewardRate in the earned and rewardsPerToken functions;
        // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
        uint _balance = _rewardsToken.sharesOf(address(this));
        require(rewardRate <= _balance.div(rewardsDuration), "VaultFlipToBNB: reward rate must be in the right range");

        lastUpdateTime = block.timestamp;
        periodFinish = block.timestamp.add(rewardsDuration);
        emit RewardAdded(reward);
    }

    /* ========== SALVAGE PURPOSE ONLY ========== */

    // @dev rewardToken(CAKE) must not remain balance in this contract. So dev should be able to salvage reward token transferred by mistake.
    // function recoverToken(address tokenAddress, uint tokenAmount) external override onlyOwner {
    //     require(tokenAddress != address(_stakingToken), "VaultFlipToBNB: cannot recover underlying token");

    //     IBEP20(tokenAddress).safeTransfer(owner(), tokenAmount);
    //     emit Recovered(tokenAddress, tokenAmount);
    // }

    /* ========== MIGRATE PANCAKE V1 to V2 ========== */

    // function migrate(address account, uint amount) public {
    //     if (amount == 0) return;
    //     _deposit(amount, account);
    // }

    // function migrateCake(uint amount) public onlyOwner {
    //     IBEP20(CAKE).safeTransferFrom(msg.sender, address(this), amount);

    //     uint _before = _rewardsToken.sharesOf(address(this));
    //     _rewardsToken.deposit(amount);

    //     uint reward = _rewardsToken.sharesOf(address(this)).sub(_before);
    //     if (reward > 0) {
    //         _notifyRewardAmount(reward);
    //     }
    // }

    // function setPidToken(uint _pid, address token) external onlyOwner {
    //     require(_totalSupply == 0);
    //     pid = _pid;
    //     _stakingToken = IBEP20(token);

    //     _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), 0);
    //     _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), uint(- 1));

    //     _stakingToken.safeApprove(address(_minter), 0);
    //     _stakingToken.safeApprove(address(_minter), uint(- 1));
    // }
}


// : MIT
pragma solidity ^0.6.12;

//import"./OwnableUpgradeable.sol";

contract Whitelist is OwnableUpgradeable {
    mapping (address => bool) private _whitelist;

    event Whitelisted(address indexed _address, bool whitelist);

    modifier onlyWhitelisted {
        require(_whitelist[msg.sender], "Whitelist: caller is not on the whitelist");
        _;
    }

    function __Whitelist_init() internal initializer {
        __Ownable_init();
    }

    function isWhitelist(address _address) public view returns(bool) {
        return _whitelist[_address];
    }

    function setWhitelist(address _address, bool _on) external onlyOwner {
        _whitelist[_address] = _on;

        emit Whitelisted(_address, _on);
    }

    uint256[50] private __gap;
}


// : MIT

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
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, 'Address: insufficient balance');

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}('');
        require(success, 'Address: unable to send value, recipient may have reverted');
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
        return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
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
        require(address(this).balance >= value, 'Address: insufficient balance for call');
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
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
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


