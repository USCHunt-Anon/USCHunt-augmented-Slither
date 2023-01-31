/**
 *Submitted for verification at Etherscan.io on 2021-03-30
*/

pragma solidity ^0.5.16;


/**
  * @title Pesa's PController Interface
  */
contract PControllerInterface {
    /// @notice Indicator that this is a PController contract (for inspection)
    bool public constant isPController = true;

    /*** Assets You Are In ***/

    function enterMarkets(address[] calldata pTokens) external returns (uint[] memory);
    function exitMarket(address pToken) external returns (uint);

    /*** Policy Hooks ***/

    function mintAllowed(address pToken, address minter, uint mintAmount) external returns (uint);
    function mintVerify(address pToken, address minter, uint mintAmount, uint mintTokens) external;

    function redeemAllowed(address pToken, address redeemer, uint redeemTokens) external returns (uint);
    function redeemVerify(address pToken, address redeemer, uint redeemAmount, uint redeemTokens) external;

    function borrowAllowed(address pToken, address borrower, uint borrowAmount) external returns (uint);
    function borrowVerify(address pToken, address borrower, uint borrowAmount) external;

    function repayBorrowAllowed(address pToken, address payer, address borrower, uint repayAmount) external returns (uint);
    function repayBorrowVerify(address pToken, address payer, address borrower, uint repayAmount, uint borrowerIndex) external;

    function liquidateBorrowAllowed(address pTokenBorrowed, address pTokenCollateral, address liquidator, address borrower, uint repayAmount) external returns (uint);
    function liquidateBorrowVerify(address pTokenBorrowed, address pTokenCollateral, address liquidator, address borrower, uint repayAmount, uint seizeTokens) external;

    function seizeAllowed(address pTokenCollateral, address pTokenBorrowed, address liquidator, address borrower, uint seizeTokens) external returns (uint);
    function seizeVerify(address pTokenCollateral, address pTokenBorrowed, address liquidator, address borrower, uint seizeTokens) external;

    function transferAllowed(address pToken, address src, address dst, uint transferTokens) external returns (uint);
    function transferVerify(address pToken, address src, address dst, uint transferTokens) external;

    /*** Liquidity/Liquidation Calculations ***/

    function liquidateCalculateSeizeTokens(address pTokenBorrowed, address pTokenCollateral, uint repayAmount) external view returns (uint, uint);
}

/**
  * @title Pesa's InterestRateModel Interface
  */
contract InterestRateModel {
    /// @notice Indicator that this is an InterestRateModel contract (for inspection)
    bool public constant isInterestRateModel = true;

    /**
      * @notice Calculates the current borrow interest rate per block
      * @param cash The total amount of cash the market has
      * @param borrows The total amount of borrows the market has outstanding
      * @param reserves The total amount of reserves the market has
      * @return The borrow rate per block (as a percentage, and scaled by 1e18)
      */
    function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);

    /**
      * @notice Calculates the current supply interest rate per block
      * @param cash The total amount of cash the market has
      * @param borrows The total amount of borrows the market has outstanding
      * @param reserves The total amount of reserves the market has
      * @param reserveFactorMantissa The current reserve factor the market has
      * @return The supply rate per block (as a percentage, and scaled by 1e18)
      */
    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);

}

/**
 * @title EPNTokenInterface
 */
interface EPNTokenInterface {
    
     /**
     * @notice Create new EPN (Ethereum Phone Number) for a owner
     * @param id The id of the EPN
     * @param owner The Owner wallet address
     * @param phoneNumber The phoneNumber of the owner 
     * @return The tokenId owned by `owner`
     */ 
    function createEPN(uint256 id, address owner, uint256 phoneNumber) external returns (uint256);
    
    /**
     * @notice Create new EPN (Ethereum Phone Number) for a owner
     * @param id The id of the EPN
     * @param owner The Owner wallet address
     * @param phoneNumber The phoneNumber of the owner 
     * @param ensName The ENS name that user's own
     * @return The tokenId owned by `owner`
     */ 
    function createEPNwithENS(uint256 id, address owner, uint256 phoneNumber, string calldata ensName) external returns (uint256);
    
    /**
     * @notice Get the tokenId of the `phoneNumber`
     * @param phoneNumber The phoneNumber of the owner to query
     * @return The tokenId owned by `owner`
     */
    function getTokenId(uint256 phoneNumber) external view returns (uint256);
    
    /**
     * @notice Get the tokenId of the `ensName`
     * @param ensName The ENS name that owner's own
     * @return The tokenId owned by `owner`
     */
    function getTokenId(string calldata ensName) external view returns (uint256);
    
    /**
     * @notice Get the owner of the `phoneNumber`
     * @param phoneNumber The Phonenumber of the owner to query
     * @return The wallet address owned by `owner`
     */
    function getOnwerOfPhoneNumber(uint256 phoneNumber) external view returns (address);
    
    /**
     * @notice Get the owner of the `phoneNumber`
     * @param ensName The ENS name that owner's own
     * @return The wallet address owned by `owner`
     */
    function getOnwerOfENS(string calldata ensName) external view returns (address);
    
    /**
     * @notice Check if phoneNumber is available to register or not
     * @param phoneNumber The Phonenumber to check whether it is registered or not
     * @return Returns true if the specified phoneNumber is not mapped with any tokenId
     */
    function available(uint256 phoneNumber) external view returns(bool);
    
    /**
     * @notice Check if ensName is already linked with user or not
     * @param ensName The ENS name that owner's own
     * @return Returns true if the specified ensName is not mapped with any tokenId
     */
    function available(string calldata ensName) external view returns(bool);
    
    /**
     * @notice The caller must own `tokenId` or be an approved operator.
     * @param tokenId The tokenId owned by the owner or an approved operator
     */
    function burnEPN(uint256 tokenId) external;
}

/**
  * @title Pesa's PToken Storage
  */
contract PTokenStorage {
    /**
     * @dev Guard variable for re-entrancy checks
     */
    bool internal _notEntered;

    /**
     * @notice EIP-20 token name for this token
     */
    string public name;

    /**
     * @notice EIP-20 token symbol for this token
     */
    string public symbol;

    /**
     * @notice EIP-20 token decimals for this token
     */
    uint8 public decimals;

    /**
     * @notice Maximum borrow rate that can ever be applied (.0005% / block)
     */

    uint internal constant borrowRateMaxMantissa = 0.0005e16;

    /**
     * @notice Maximum fraction of interest that can be set aside for reserves
     */
    uint internal constant reserveFactorMaxMantissa = 1e18;

    /**
     * @notice Administrator for this contract
     */
    address payable public admin;

    /**
     * @notice Pending administrator for this contract
     */
    address payable public pendingAdmin;

    /**
     * @notice Contract which oversees inter-pToken operations
     */
    PControllerInterface public pController;

    /**
     * @notice EPN Token to provide epn number to sPesa market
     */
    EPNTokenInterface public epnToken;

    /**
     * @notice Indicator that this is a EPN claim enabled for the market
     */
    bool public isEPNClaimEnabled = false;

    /**
     * @notice Minimum EPN claim value
     */

    uint public minimumClaimValue = 100e8;

    /**
     * @notice Model which tells what the current interest rate should be
     */
    InterestRateModel public interestRateModel;

    /**
     * @notice Initial exchange rate used when minting the first PTokens (used when totalSupply = 0)
     */
    uint internal initialExchangeRateMantissa;

    /**
     * @notice Fraction of interest currently set aside for reserves
     */
    uint public reserveFactorMantissa;

    /**
     * @notice Block number that interest was last accrued at
     */
    uint public accrualBlockNumber;

    /**
     * @notice Accumulator of the total earned interest rate since the opening of the market
     */
    uint public borrowIndex;

    /**
     * @notice Total amount of outstanding borrows of the underlying in this market
     */
    uint public totalBorrows;

    /**
     * @notice Total amount of reserves of the underlying held in this market
     */
    uint public totalReserves;

    /**
     * @notice Total number of tokens in circulation
     */
    uint public totalSupply;

    /**
     * @notice Official record of token balances for each account
     */
    mapping (address => uint) internal accountTokens;

    /**
     * @notice Approved token transfer amounts on behalf of others
     */
    mapping (address => mapping (address => uint)) internal transferAllowances;

    /**
     * @notice Container for borrow balance information
     * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
     * @member interestIndex Global borrowIndex as of the most recent balance-changing action
     */
    struct BorrowSnapshot {
        uint principal;
        uint interestIndex;
    }

    /**
     * @notice Mapping of account addresses to outstanding borrow balances
     */
    mapping(address => BorrowSnapshot) internal accountBorrows;
}

/**
  * @title Pesa's PToken Interface
  */
contract PTokenInterface is PTokenStorage {
    /**
     * @notice Indicator that this is a PToken contract (for inspection)
     */
    bool public constant isPToken = true;


    /*** Market Events ***/

    /**
     * @notice Event emitted when interest is accrued
     */
    event AccrueInterestToken(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);

    /**
     * @notice Event emitted when tokens are minted
     */
    event MintToken(address minter, uint mintAmount, uint mintTokens);

    /**
     * @notice Event emitted when tokens are redeemed
     */
    event RedeemToken(address redeemer, uint redeemAmount, uint redeemTokens);

    /**
     * @notice Event emitted when underlying is borrowed
     */
    event BorrowToken(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);

    /**
     * @notice Event emitted when a borrow is repaid
     */
    event RepayBorrowToken(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);

    /**
     * @notice Event emitted when a borrow is liquidated
     */
    event LiquidateBorrowToken(address liquidator, address borrower, uint repayAmount, address pTokenCollateral, uint seizeTokens);


    /*** Admin Events ***/

    /**
     * @notice Event emitted when pendingAdmin is changed
     */
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

    /**
     * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
     */
    event NewAdmin(address oldAdmin, address newAdmin);

    /**
     * @notice Event emitted when pController is changed
     */
    event NewPController(PControllerInterface oldPController, PControllerInterface newPController);

    /**
     * @notice Event emitted when epnToken is changed
     */
    event NewEPNToken(EPNTokenInterface oldEPNToken, EPNTokenInterface newEPNToken);

    /**
     * @notice Event emitted when epnToken is changed
     */
    event NewMinimumClaimValue(uint oldMinimumClaimValue, uint newMinimumClaimValue);

    /**
     * @notice Event emitted when isEPNClaimEnabled status changed
     */
    event NewIsEPNClaimStatus(bool oldStatus, bool newStatus);

    /**
     * @notice Event emitted when interestRateModel is changed
     */
    event NewMarketTokenInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);

    /**
     * @notice Event emitted when the reserve factor is changed
     */
    event NewTokenReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);

    /**
     * @notice Event emitted when the reserves are added
     */
    event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);

    /**
     * @notice Event emitted when the reserves are reduced
     */
    event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);

    /**
     * @notice EIP20 Transfer event
     */
    event Transfer(address indexed from, address indexed to, uint amount);

    /**
     * @notice EIP20 Approval event
     */
    event Approval(address indexed owner, address indexed spender, uint amount);

    /**
     * @notice Failure event
     */
    event Failure(uint error, uint info, uint detail);


    /*** User Interface ***/

    function transfer(address dst, uint amount) external returns (bool);
    function transferFrom(address src, address dst, uint amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function balanceOfUnderlying(address owner) external returns (uint);
    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
    function borrowRatePerBlock() external view returns (uint);
    function supplyRatePerBlock() external view returns (uint);
    function totalBorrowsCurrent() external returns (uint);
    function borrowBalanceCurrent(address account) external returns (uint);
    function borrowBalanceStored(address account) public view returns (uint);
    function exchangeRateCurrent() public returns (uint);
    function exchangeRateStored() public view returns (uint);
    function getCash() external view returns (uint);
    function accrueInterest() public returns (uint);
    function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);

    function claimEPN(uint256 id, address owner, uint256 phoneNumber) external returns(uint);
    function claimEPNwithENS(uint256 id, address owner, uint256 phoneNumber, string calldata ensName) external returns(uint);


    /*** Admin Functions ***/

    function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);
    function _acceptAdmin() external returns (uint);
    function _setPController(PControllerInterface newPController) public returns (uint);
    function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
    function _reduceReserves(uint reduceAmount) external returns (uint);
    function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);
    function _setEPN(EPNTokenInterface newEPNToken) external returns (uint);
    function _setMinimumClaimValue(uint newMinimumClaimValue) external returns (uint);
    function _changeEPNClaimStatus() external returns (uint);
    
}

/**
  * @title Pesa's PErc20 Storage
  */
contract PErc20Storage {
    /**
     * @notice Underlying asset for this PToken
     */
    address public underlying;
}

/**
  * @title Pesa's PErc20 Interface
  */
contract PErc20Interface is PErc20Storage {

    /*** User Interface ***/

    function mint(uint mintAmount) external returns (uint);
    function redeem(uint redeemTokens) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
    function liquidateBorrow(address borrower, uint repayAmount, PTokenInterface pTokenCollateral) external returns (uint);


    /*** Admin Functions ***/

    function _addReserves(uint addAmount) external returns (uint);
}

/**
  * @title Pesa's PDelegation Storage
  */
contract PDelegationStorage {
    /**
     * @notice Implementation address for this contract
     */
    address public implementation;
}

/**
  * @title Pesa's PDelegator Interface
  */
contract PDelegatorInterface is PDelegationStorage {
    /**
     * @notice Emitted when implementation is changed
     */
    event NewImplementation(address oldImplementation, address newImplementation);

    /**
     * @notice Called by the admin to update the implementation of the delegator
     * @param implementation_ The address of the new implementation for delegation
     * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
     * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
     */
    function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
}

/**
  * @title Pesa's PDelegate Interface
  */
contract PDelegateInterface is PDelegationStorage {
    /**
     * @notice Called by the delegator on a delegate to initialize it for duty
     * @dev Should revert if any issues arise which make it unfit for delegation
     * @param data The encoded bytes data for any initialization
     */
    function _becomeImplementation(bytes memory data) public;

    /**
     * @notice Called by the delegator on a delegate to forfeit its responsibility
     */
    function _resignImplementation() public;
}

/**
 * @title Pesa's PErc20WBTCDelegator Contract
 * @notice PTokens which wrap an EIP-20 underlying and delegate to an implementation
 */
contract PErc20WBTCDelegator is PTokenInterface, PErc20Interface, PDelegatorInterface {
    /**
     * @notice Construct a new money market
     * @param underlying_ The address of the underlying asset
     * @param pController_ The address of the PController
     * @param interestRateModel_ The address of the interest rate model
     * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
     * @param name_ ERC-20 name of this token
     * @param symbol_ ERC-20 symbol of this token
     * @param decimals_ ERC-20 decimal precision of this token
     * @param admin_ Address of the administrator of this token
     * @param implementation_ The address of the implementation the contract delegates to
     * @param becomeImplementationData The encoded args for becomeImplementation
     */
    constructor(address underlying_,
                PControllerInterface pController_,
                InterestRateModel interestRateModel_,
                uint initialExchangeRateMantissa_,
                string memory name_,
                string memory symbol_,
                uint8 decimals_,
                address payable admin_,
                address implementation_,
                bytes memory becomeImplementationData) public {
        // Creator of the contract is admin during initialization
        admin = msg.sender;

        // First delegate gets to initialize the delegator (i.e. storage contract)
        delegateTo(implementation_, abi.encodeWithSignature("initialize(address,address,address,uint256,string,string,uint8)",
                                                            underlying_,
                                                            pController_,
                                                            interestRateModel_,
                                                            initialExchangeRateMantissa_,
                                                            name_,
                                                            symbol_,
                                                            decimals_));

        // New implementations always get set via the settor (post-initialize)
        _setImplementation(implementation_, false, becomeImplementationData);

        // Set the proper admin now that initialization is done
        admin = admin_;
    }

    /**
     * @notice Called by the admin to update the implementation of the delegator
     * @param implementation_ The address of the new implementation for delegation
     * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
     * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
     */
    function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
        require(msg.sender == admin, "PErc20WBTCDelegator::_setImplementation: Caller must be admin");

        if (allowResign) {
            delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
        }

        address oldImplementation = implementation;
        implementation = implementation_;

        delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));

        emit NewImplementation(oldImplementation, implementation);
    }

    /**
     * @notice Sender supplies assets into the market and receives pTokens in exchange
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param mintAmount The amount of the underlying asset to supply
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function mint(uint mintAmount) external returns (uint) {
        mintAmount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Sender redeems pTokens in exchange for the underlying asset
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param redeemTokens The number of pTokens to redeem into underlying
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function redeem(uint redeemTokens) external returns (uint) {
        redeemTokens; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Sender redeems pTokens in exchange for a specified amount of underlying asset
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param redeemAmount The amount of underlying to redeem
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function redeemUnderlying(uint redeemAmount) external returns (uint) {
        redeemAmount; // Shh
        delegateAndReturn();
    }

    /**
      * @notice Sender borrows assets from the protocol to their own address
      * @param borrowAmount The amount of the underlying asset to borrow
      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
      */
    function borrow(uint borrowAmount) external returns (uint) {
        borrowAmount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Sender repays their own borrow
     * @param repayAmount The amount to repay
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function repayBorrow(uint repayAmount) external returns (uint) {
        repayAmount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Sender repays a borrow belonging to borrower
     * @param borrower the account with the debt being payed off
     * @param repayAmount The amount to repay
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
        borrower; repayAmount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice The sender liquidates the borrowers collateral.
     *  The collateral seized is transferred to the liquidator.
     * @param borrower The borrower of this pToken to be liquidated
     * @param pTokenCollateral The market in which to seize collateral from the borrower
     * @param repayAmount The amount of the underlying borrowed asset to repay
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function liquidateBorrow(address borrower, uint repayAmount, PTokenInterface pTokenCollateral) external returns (uint) {
        borrower; repayAmount; pTokenCollateral; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Transfer `amount` tokens from `msg.sender` to `dst`
     * @param dst The address of the destination account
     * @param amount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transfer(address dst, uint amount) external returns (bool) {
        dst; amount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Transfer `amount` tokens from `src` to `dst`
     * @param src The address of the source account
     * @param dst The address of the destination account
     * @param amount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transferFrom(address src, address dst, uint256 amount) external returns (bool) {
        src; dst; amount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Approve `spender` to transfer up to `amount` from `src`
     * @dev This will overwrite the approval amount for `spender`
     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
     * @param spender The address of the account which may transfer tokens
     * @param amount The number of tokens that are approved (-1 means infinite)
     * @return Whether or not the approval succeeded
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        spender; amount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Get the current allowance from `owner` for `spender`
     * @param owner The address of the account which owns the tokens to be spent
     * @param spender The address of the account which may transfer tokens
     * @return The number of tokens allowed to be spent (-1 means infinite)
     */
    function allowance(address owner, address spender) external view returns (uint) {
        owner; spender; // Shh
        delegateToViewAndReturn();
    }

    /**
     * @notice Get the token balance of the `owner`
     * @param owner The address of the account to query
     * @return The number of tokens owned by `owner`
     */
    function balanceOf(address owner) external view returns (uint) {
        owner; // Shh
        delegateToViewAndReturn();
    }

    /**
     * @notice Get the underlying balance of the `owner`
     * @dev This also accrues interest in a transaction
     * @param owner The address of the account to query
     * @return The amount of underlying owned by `owner`
     */
    function balanceOfUnderlying(address owner) external returns (uint) {
        owner; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Get a snapshot of the account's balances, and the cached exchange rate
     * @dev This is used by pController to more efficiently perform liquidity checks.
     * @param account Address of the account to snapshot
     * @return (possible error, token balance, borrow balance, exchange rate mantissa)
     */
    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
        account; // Shh
        delegateToViewAndReturn();
    }

    /**
     * @notice Returns the current per-block borrow interest rate for this pToken
     * @return The borrow interest rate per block, scaled by 1e18
     */
    function borrowRatePerBlock() external view returns (uint) {
        delegateToViewAndReturn();
    }

    /**
     * @notice Returns the current per-block supply interest rate for this pToken
     * @return The supply interest rate per block, scaled by 1e18
     */
    function supplyRatePerBlock() external view returns (uint) {
        delegateToViewAndReturn();
    }

    /**
     * @notice Returns the current total borrows plus accrued interest
     * @return The total borrows with interest
     */
    function totalBorrowsCurrent() external returns (uint) {
        delegateAndReturn();
    }

    /**
     * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
     * @param account The address whose balance should be calculated after updating borrowIndex
     * @return The calculated balance
     */
    function borrowBalanceCurrent(address account) external returns (uint) {
        account; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Return the borrow balance of account based on stored data
     * @param account The address whose balance should be calculated
     * @return The calculated balance
     */
    function borrowBalanceStored(address account) public view returns (uint) {
        account; // Shh
        delegateToViewAndReturn();
    }

   /**
     * @notice Accrue interest then return the up-to-date exchange rate
     * @return Calculated exchange rate scaled by 1e18
     */
    function exchangeRateCurrent() public returns (uint) {
        delegateAndReturn();
    }

    /**
     * @notice Calculates the exchange rate from the underlying to the PToken
     * @dev This function does not accrue interest before calculating the exchange rate
     * @return Calculated exchange rate scaled by 1e18
     */
    function exchangeRateStored() public view returns (uint) {
        delegateToViewAndReturn();
    }

    /**
     * @notice Get cash balance of this pToken in the underlying asset
     * @return The quantity of underlying asset owned by this contract
     */
    function getCash() external view returns (uint) {
        delegateToViewAndReturn();
    }

    /**
      * @notice Applies accrued interest to total borrows and reserves.
      * @dev This calculates interest accrued from the last checkpointed block
      *      up to the current block and writes new checkpoint to storage.
      */
    function accrueInterest() public returns (uint) {
        delegateAndReturn();
    }

    /**
     * @notice Transfers collateral tokens (this market) to the liquidator.
     * @dev Will fail unless called by another pToken during the process of liquidation.
     *  Its absolutely critical to use msg.sender as the borrowed pToken and not a parameter.
     * @param liquidator The account receiving seized collateral
     * @param borrower The account having collateral seized
     * @param seizeTokens The number of pTokens to seize
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint) {
        liquidator; borrower; seizeTokens; // Shh
        delegateAndReturn();
    }

    function claimEPN(uint256 id, address owner, uint256 phoneNumber) external returns(uint) {
        id; owner; phoneNumber; // Shh
        delegateAndReturn();
    }

    function claimEPNwithENS(uint256 id, address owner, uint256 phoneNumber, string calldata ensName) external returns(uint) {
        id; owner; phoneNumber; ensName;
        delegateAndReturn();
    }

    /*** Admin Functions ***/

    /**
      * @notice Sets a new epnToken for the market
      * @dev Admin function to set a new epnToken
      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
      */
    function _setEPN(EPNTokenInterface newEPNToken) external returns (uint)  {
        newEPNToken; // Shh
        delegateAndReturn();
    }

    /**
      * @notice Sets a new minimumClaimValue for the market
      * @dev Admin function to set a new minimumClaimValue
      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
      */
    function _setMinimumClaimValue(uint newMinimumClaimValue) external returns (uint) {
        newMinimumClaimValue; // Shh
        delegateAndReturn();
    }

    /**
      * @notice Change the current status of EPNClaim for the market
      * @dev Admin function to change EPNClaimStatus
      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
      */
    function _changeEPNClaimStatus() external returns (uint) {
        delegateAndReturn();
    }

    /**
      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
      * @param newPendingAdmin New pending admin.
      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
      */
    function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
        newPendingAdmin; // Shh
        delegateAndReturn();
    }

    /**
      * @notice Sets a new pController for the market
      * @dev Admin function to set a new pController
      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
      */
    function _setPController(PControllerInterface newPController) public returns (uint) {
        newPController; // Shh
        delegateAndReturn();
    }

    /**
      * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
      * @dev Admin function to accrue interest and set a new reserve factor
      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
      */
    function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint) {
        newReserveFactorMantissa; // Shh
        delegateAndReturn();
    }

    /**
      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
      * @dev Admin function for pending admin to accept role and update admin
      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
      */
    function _acceptAdmin() external returns (uint) {
        delegateAndReturn();
    }

    /**
     * @notice Accrues interest and adds reserves by transferring from admin
     * @param addAmount Amount of reserves to add
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function _addReserves(uint addAmount) external returns (uint) {
        addAmount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Accrues interest and reduces reserves by transferring to admin
     * @param reduceAmount Amount of reduction to reserves
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function _reduceReserves(uint reduceAmount) external returns (uint) {
        reduceAmount; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Accrues interest and updates the interest rate model using _setInterestRateModelFresh
     * @dev Admin function to accrue interest and update the interest rate model
     * @param newInterestRateModel the new interest rate model to use
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
        newInterestRateModel; // Shh
        delegateAndReturn();
    }

    /**
     * @notice Internal method to delegate execution to another contract
     * @dev It returns to the external caller whatever the implementation returns or forwards reverts
     * @param callee The contract to delegatecall
     * @param data The raw data to delegatecall
     * @return The returned bytes from the delegatecall
     */
    function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returnData) = callee.delegatecall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
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
    function delegateToImplementation(bytes memory data) public returns (bytes memory) {
        return delegateTo(implementation, data);
    }

    /**
     * @notice Delegates execution to an implementation contract
     * @dev It returns to the external caller whatever the implementation returns or forwards reverts
     *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
     * @param data The raw data to delegatecall
     * @return The returned bytes from the delegatecall
     */
    function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
        (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return abi.decode(returnData, (bytes));
    }

    function delegateToViewAndReturn() private view returns (bytes memory) {
        (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));

        assembly {
            let free_mem_ptr := mload(0x40)
            returndatacopy(free_mem_ptr, 0, returndatasize)

            switch success
            case 0 { revert(free_mem_ptr, returndatasize) }
            default { return(add(free_mem_ptr, 0x40), returndatasize) }
        }
    }

    function delegateAndReturn() private returns (bytes memory) {
        (bool success, ) = implementation.delegatecall(msg.data);

        assembly {
            let free_mem_ptr := mload(0x40)
            returndatacopy(free_mem_ptr, 0, returndatasize)

            switch success
            case 0 { revert(free_mem_ptr, returndatasize) }
            default { return(free_mem_ptr, returndatasize) }
        }
    }

    /**
     * @notice Delegates execution to an implementation contract
     * @dev It returns to the external caller whatever the implementation returns or forwards reverts
     */
    function () external payable {
        require(msg.value == 0,"PErc20WBTCDelegator:fallback: cannot send value to fallback");

        // delegate all other functions to current implementation
        delegateAndReturn();
    }
}