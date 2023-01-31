// File: contracts/interface/DelegatorInterface.sol

pragma solidity 0.6.12;

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

// File: contracts/interface/IMarketRegulator.sol

pragma solidity 0.6.12;

interface IMarketRegulator {
    function IsInWhiteList(address wantToken)
        external
        view
        returns (bool inTheList);

    function IsInBlackList(uint256 _shardPoolId)
        external
        view
        returns (bool inTheList);
}

// File: contracts/interface/IBuyoutProposals.sol

pragma solidity 0.6.12;

contract IBuyoutProposalsStorge {
    address public governance;
    address public regulator;
    address public market;

    uint256 public proposolIdCount;

    uint256 public voteLenth = 259200;

    mapping(uint256 => uint256) public proposalIds;

    mapping(uint256 => uint256[]) internal proposalsHistory;

    mapping(uint256 => Proposal) public proposals;

    mapping(uint256 => mapping(address => bool)) public voted;

    uint256 public passNeeded = 75;

    // n times higher than the market price to buyout
    uint256 public buyoutTimes = 100;

    uint256 internal constant max = 100;

    uint256 public buyoutProportion = 15;

    mapping(uint256 => uint256) allVotes;

    struct Proposal {
        uint256 votesReceived;
        uint256 voteTotal;
        bool passed;
        address submitter;
        uint256 voteDeadline;
        uint256 shardAmount;
        uint256 wantTokenAmount;
        uint256 buyoutTimes;
        uint256 price;
        bool isSubmitterWithDraw;
        uint256 shardPoolId;
        bool isFailedConfirmed;
        uint256 blockHeight;
        uint256 createTime;
    }
}

abstract contract IBuyoutProposals is IBuyoutProposalsStorge {
    function createProposal(
        uint256 _shardPoolId,
        uint256 shardBalance,
        uint256 wantTokenAmount,
        uint256 currentPrice,
        uint256 totalShardSupply,
        address submitter
    ) external virtual returns (uint256 proposalId, uint256 buyoutTimes);

    function vote(
        uint256 _shardPoolId,
        bool isAgree,
        address shard,
        address voter
    ) external virtual returns (uint256 proposalId, uint256 balance);

    function voteResultConfirm(uint256 _shardPoolId)
        external
        virtual
        returns (
            uint256 proposalId,
            bool result,
            address submitter,
            uint256 shardAmount,
            uint256 wantTokenAmount
        );

    function exchangeForWantToken(uint256 _shardPoolId, uint256 shardAmount)
        external
        view
        virtual
        returns (uint256 wantTokenAmount);

    function redeemForBuyoutFailed(uint256 _proposalId, address submitter)
        external
        virtual
        returns (
            uint256 _shardPoolId,
            uint256 shardTokenAmount,
            uint256 wantTokenAmount
        );

    function setBuyoutTimes(uint256 _buyoutTimes) external virtual;

    function setVoteLenth(uint256 _voteLenth) external virtual;

    function setPassNeeded(uint256 _passNeeded) external virtual;

    function setBuyoutProportion(uint256 _buyoutProportion) external virtual;

    function setGovernance(address _governance) external virtual;

    function setMarket(address _market) external virtual;

    function getProposalsForExactPool(uint256 _shardPoolId)
        external
        view
        virtual
        returns (uint256[] memory _proposalsHistory);
}

// File: contracts/interface/IShardToken.sol

pragma solidity 0.6.12;

interface IShardToken {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function burn(address from, uint256 value) external;

    function mint(address to, uint256 value) external;

    function initialize(
        string memory _name,
        string memory _symbol,
        address market
    ) external;

    function getPriorVotes(address account, uint256 blockNumber)
        external
        view
        returns (uint256);
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// : MIT

pragma solidity >=0.6.0 <0.8.0;

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

// File: contracts/BuyoutProposals.sol

pragma solidity 0.6.12;





contract BuyoutProposals is IBuyoutProposals {
    using SafeMath for uint256;

    constructor() public {}

    function initialize(address _governance, address _regulator) external {
        require(governance == msg.sender, "UNAUTHORIZED");
        require(regulator == address(0), "ALREADY INITIALIZED");
        governance = _governance;
        regulator = _regulator;
    }

    function createProposal(
        uint256 _shardPoolId,
        uint256 shardBalance,
        uint256 wantTokenAmount,
        uint256 currentPrice,
        uint256 totalShardSupply,
        address submitter
    ) external override returns (uint256, uint256) {
        require(msg.sender == market, "UNAUTHORIZED");
        require(
            shardBalance >= totalShardSupply.mul(buyoutProportion).div(max),
            "INSUFFIENT BALANCE"
        );
        uint256 otherShards = totalShardSupply.sub(shardBalance);
        uint256 needAmount =
            otherShards.mul(currentPrice).mul(buyoutTimes).div(max).div(1e18);
        require(wantTokenAmount >= needAmount, "INSUFFICIENT WANTTOKENAMOUNT");
        require(
            !IMarketRegulator(regulator).IsInBlackList(_shardPoolId),
            "ON THE BLACKLIST"
        );
        uint256 proposalId = proposolIdCount.add(1);
        proposalIds[_shardPoolId] = proposalId;
        uint256 timestamp = block.timestamp.add(voteLenth);
        proposals[proposalId] = Proposal({
            votesReceived: 0,
            voteTotal: 0,
            passed: false,
            submitter: submitter,
            voteDeadline: timestamp,
            shardAmount: shardBalance,
            wantTokenAmount: wantTokenAmount,
            buyoutTimes: buyoutTimes,
            price: currentPrice,
            isSubmitterWithDraw: false,
            shardPoolId: _shardPoolId,
            isFailedConfirmed: false,
            blockHeight: block.number,
            createTime: block.timestamp
        });
        allVotes[proposalId] = otherShards;
        proposalsHistory[_shardPoolId].push(proposalId);
        voted[proposalId][submitter] = true;
        proposolIdCount = proposalId;
        return (proposalId, buyoutTimes);
    }

    function vote(
        uint256 _shardPoolId,
        bool isAgree,
        address shard,
        address voter
    ) external override returns (uint256 proposalId, uint256 balance) {
        require(msg.sender == market, "UNAUTHORIZED");
        proposalId = proposalIds[_shardPoolId];
       require(
           block.timestamp <= proposals[proposalId].voteDeadline,
           "EXPIRED"
       );
        uint256 blockHeight = proposals[proposalId].blockHeight;
        balance = IShardToken(shard).getPriorVotes(voter, blockHeight);
       require(balance > 0, "INSUFFICIENT VOTERIGHT");
       require(!voted[proposalId][voter], "AlREADY VOTED");
        voted[proposalId][voter] = true;
        if (isAgree) {
            proposals[proposalId].votesReceived = proposals[proposalId]
                .votesReceived
                .add(balance);
            proposals[proposalId].voteTotal = proposals[proposalId]
                .voteTotal
                .add(balance);
        } else {
            proposals[proposalId].voteTotal = proposals[proposalId]
                .voteTotal
                .add(balance);
        }
    }

    function voteResultConfirm(uint256 _shardPoolId)
        external
        override
        returns (
            uint256 proposalId,
            bool result,
            address submitter,
            uint256 shardAmount,
            uint256 wantTokenAmount
        )
    {
        require(msg.sender == market, "UNAUTHORIZED");
        proposalId = proposalIds[_shardPoolId];
        require(
            block.timestamp > proposals[proposalId].voteDeadline,
            "NOT READY"
        );
        uint256 votesRejected =
            proposals[proposalId].voteTotal.sub(
                proposals[proposalId].votesReceived
            );
        uint256 rejectNeed = max.sub(passNeeded);
        if (
            votesRejected <= allVotes[proposalId].mul(rejectNeed).div(max) &&
            !IMarketRegulator(regulator).IsInBlackList(_shardPoolId)
        ) {
            proposals[proposalId].passed = true;
            result = true;
            submitter = proposals[proposalId].submitter;
            shardAmount = proposals[proposalId].shardAmount;
            wantTokenAmount = proposals[proposalId].wantTokenAmount;
        } else {
            proposals[proposalId].passed = false;
            proposals[proposalId].isFailedConfirmed = true;
            result = false;
        }
    }

    function exchangeForWantToken(uint256 _shardPoolId, uint256 shardAmount)
        external
        view
        override
        returns (uint256 wantTokenAmount)
    {
        uint256 proposalId = proposalIds[_shardPoolId];
        Proposal memory p = proposals[proposalId];
        uint256 otherShards = allVotes[proposalId];
        wantTokenAmount = shardAmount.mul(p.wantTokenAmount).div(otherShards);
    }

    function redeemForBuyoutFailed(uint256 _proposalId, address submitter)
        external
        override
        returns (
            uint256 shardPoolId,
            uint256 shardTokenAmount,
            uint256 wantTokenAmount
        )
    {
        require(msg.sender == market, "UNAUTHORIZED");
        Proposal memory p = proposals[_proposalId];
        require(submitter == p.submitter, "UNAUTHORIZED");
        require(
            p.isFailedConfirmed && !p.isSubmitterWithDraw && !p.passed,
            "WRONG STATE"
        );
        shardPoolId = p.shardPoolId;
        shardTokenAmount = p.shardAmount;
        wantTokenAmount = p.wantTokenAmount;
        proposals[_proposalId].isSubmitterWithDraw = true;
    }

    function setVoteLenth(uint256 _voteLenth) external override {
        require(msg.sender == governance, "UNAUTHORIZED");
        voteLenth = _voteLenth;
    }

    function setPassNeeded(uint256 _passNeeded) external override {
        require(msg.sender == governance, "UNAUTHORIZED");
        require(_passNeeded < max, "INVALID");
        passNeeded = _passNeeded;
    }

    function setBuyoutProportion(uint256 _buyoutProportion) external override {
        require(msg.sender == governance, "UNAUTHORIZED");
        require(_buyoutProportion < max, "INVALID");
        buyoutProportion = _buyoutProportion;
    }

    function setBuyoutTimes(uint256 _buyoutTimes) external override {
        require(msg.sender == governance, "UNAUTHORIZED");
        buyoutTimes = _buyoutTimes;
    }

    function setGovernance(address _governance) external override {
        require(msg.sender == governance, "UNAUTHORIZED");
        governance = _governance;
    }

    function setMarket(address _market) external override {
        require(msg.sender == governance, "UNAUTHORIZED");
        market = _market;
    }

    function getProposalsForExactPool(uint256 _shardPoolId)
        external
        view
        override
        returns (uint256[] memory _proposalsHistory)
    {
        _proposalsHistory = proposalsHistory[_shardPoolId];
    }

     function getMarket()
        external
        view 
        returns (address)
    {
        return market;
    }
}

// File: contracts/BuyoutProposalsDelegate.sol

pragma solidity 0.6.12;



contract BuyoutProposalsDelegate is BuyoutProposals, DelegateInterface {
    /**
     * @notice Construct an empty delegate
     */
    constructor() public {}

    /**
     * @notice Called by the delegator on a delegate to initialize it for duty
     * @param data The encoded bytes data for any initialization
     */
    function _becomeImplementation(bytes memory data) public override {
        // Shh -- currently unused
        data;

        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

        require(
            msg.sender == governance,
            "only the admin may call _becomeImplementation"
        );
    }

    /**
     * @notice Called by the delegator on a delegate to forfeit its responsibility
     */
    function _resignImplementation() public override {
        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

        require(
            msg.sender == governance,
            "only the admin may call _resignImplementation"
        );
    }
}