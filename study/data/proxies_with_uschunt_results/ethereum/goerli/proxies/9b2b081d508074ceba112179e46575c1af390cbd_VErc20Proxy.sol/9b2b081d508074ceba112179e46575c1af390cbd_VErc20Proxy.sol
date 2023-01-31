/**
 *Submitted for verification at Etherscan.io on 2021-05-04
*/

// ////-License-Identifier:MIT
// produced by the Solididy File Flattener (c) David Appleton 2018 - 2020 and beyond
// contact : [email protected]
// source  : https://github.com/DaveAppleton/SolidityFlattery
// released under Apache 2.0 licence
// input  /Users/chris/Git/vestollc/vesto-contracts/src/proxy/VErc20Proxy.sol
// flattened :  Tuesday, 04-May-21 23:05:07 UTC
interface IOwnable {

    function setVAddress(
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) external;

    function setUserAddress(
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) external;

    function setRecoveryAddress(
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) external;
}
interface IErc20 {
    function totalSupply(
    ) external view returns (uint256);

    function balanceOf(
        address who
    ) external view returns (uint256);

    function decimals(
    ) external pure returns (uint8);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function transfer(
        address to,
        uint256 value
    ) external returns (bool);

    function approve(
        address spender,
        uint256 value
    ) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function symbol(
    ) external view returns (string memory);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

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

abstract contract AStorage {

    struct Signatures {
        string nonce;
        bytes32 hash;
        uint8[2] V;
        bytes32[2] R;
        bytes32[2] S;
    }

    struct Exchange {
        uint256 institutionApy;
        uint256 institutionRate;
        uint256 apy;
        uint256 rate;
        uint256 stamp;
    }

    struct Withdrawal {
        uint256 amount;
        uint256 stamp;
    }

    mapping(bytes32 => uint256) internal uint256Storage;
    mapping(bytes32 => string) internal stringStorage;
    mapping(bytes32 => address) internal addressStorage;
    mapping(bytes32 => bytes32) internal bytes32Storage;
    mapping(bytes32 => bool) internal boolStorage;
    mapping(bytes32 => int256) internal intStorage;
    mapping(bytes32 => Exchange) internal exchangeStorage;
    mapping(bytes32 => Withdrawal[]) internal withdrawalArrayStorage;
    mapping(bytes32 => mapping(address => uint256)) internal addressToUnitStorage;
    mapping(bytes32 => mapping(address => bool)) internal addressToBoolStorage;
    mapping(bytes32 => mapping(address => address)) internal addressToAddressStorage;
    mapping(bytes32 => mapping(bytes32 => bool)) internal bytes32ToBoolStorage;
    mapping(bytes32 => mapping(bytes32 => address)) internal bytes32ToAddressStorage;
    mapping(bytes32 => mapping(address => mapping(address => uint256))) internal addressToAddressToUnitStorage;
    mapping(bytes32 => mapping(address => mapping(address => bool))) internal addressToAddressToBoolStorage;
    mapping(bytes32 => mapping(bytes32 => mapping(address => bool))) internal bytes32ToAddressToBoolStorage;
    mapping(bytes32 => mapping(address => mapping(bytes32 => bool))) internal addressToBytes32ToBoolStorage;

    // Storage keys.
    bytes32 constant VSTORE_ADDRESS = keccak256(abi.encodePacked("VSTORE_ADDRESS"));
    bytes32 constant VSTORE_PROXY_ADDRESS = keccak256(abi.encodePacked("VSTORE_PROXY_ADDRESS"));
    bytes32 constant VFINANCE_ADDRESS = keccak256(abi.encodePacked("VFINANCE_ADDRESS"));
    bytes32 constant VFINANCE_PROXY_ADDRESS = keccak256(abi.encodePacked("VFINANCE_PROXY_ADDRESS"));
    bytes32 constant VERC20_ADDRESS = keccak256(abi.encodePacked("VERC20_ADDRESS"));
    bytes32 constant VERC20_PROXY_ADDRESSES = keccak256(abi.encodePacked("VERC20_PROXY_ADDRESSES"));
    bytes32 constant VDISTRIBUTION_ADDRESS = keccak256(abi.encodePacked("VDISTRIBUTION_ADDRESS"));
    bytes32 constant VDISTRIBUTION_PROXY_ADDRESSES = keccak256(abi.encodePacked("VDISTRIBUTION_PROXY_ADDRESSES"));
    bytes32 constant VWALLET_ADDRESS = keccak256(abi.encodePacked("VWALLET_ADDRESS"));
    bytes32 constant VWALLET_PROXY_ADDRESSES = keccak256(abi.encodePacked("VWALLET_PROXY_ADDRESSES"));
    bytes32 constant IMPLEMENTATION_ADDRESS_KEY = keccak256(abi.encodePacked("IMPLEMENTATION_ADDRESS_KEY"));
    bytes32 constant VADDRESS = keccak256(abi.encodePacked("VADDRESS"));
    bytes32 constant USER_ADDRESS = keccak256(abi.encodePacked("USER_ADDRESS"));
    bytes32 constant RECOVERY_ADDRESS = keccak256(abi.encodePacked("RECOVERY_ADDRESS"));
    bytes32 constant INSTITUTION_ID = keccak256(abi.encodePacked("INSTITUTION_ID"));
    bytes32 constant WITHDRAWALS = keccak256(abi.encodePacked("WITHDRAWALS"));
    bytes32 constant NAME = keccak256(abi.encodePacked("NAME"));
    bytes32 constant SYMBOL = keccak256(abi.encodePacked("SYMBOL"));
    bytes32 constant SUPPLY = keccak256(abi.encodePacked("SUPPLY"));
    bytes32 constant BALANCES = keccak256(abi.encodePacked("BALANCES"));
    bytes32 constant UNDERLYING = keccak256(abi.encodePacked("UNDERLYING"));
    bytes32 constant ALLOWANCES = keccak256(abi.encodePacked("ALLOWANCES"));
    bytes32 constant NONCES = keccak256(abi.encodePacked(abi.encodePacked("NONCES")));
    bytes32 constant UNDERLYING_ADDRESS_KEY = keccak256(abi.encodePacked("UNDERLYING_ADDRESS_KEY"));
    bytes32 constant REDEEM_ADDRESS_KEY = keccak256(abi.encodePacked("REDEEM_ADDRESS_KEY"));
    bytes32 constant RAYUSDC_ADDRESS = keccak256(abi.encodePacked("RAYUSDC_ADDRESS"));
    bytes32 constant RAYDAI_ADDRESS = keccak256(abi.encodePacked("RAYDAI_ADDRESS"));
    bytes32 constant RAYETH_ADDRESS = keccak256(abi.encodePacked("RAYETH_ADDRESS"));
    bytes32 constant USDC_ADDRESS = keccak256(abi.encodePacked("USDC_ADDRESS"));
    bytes32 constant DAI_ADDRESS = keccak256(abi.encodePacked("DAI_ADDRESS"));
    bytes32 constant CHAIN_ID = keccak256(abi.encodePacked("CHAIN_ID"));
    bytes32 constant DAILY_LIMIT = keccak256(abi.encodePacked("DAILY_LIMIT"));
    bytes32 constant ERC20_PREDICATE_PROXY_ADDRESS = keccak256(abi.encodePacked("ERC20_PREDICATE_PROXY_ADDRESS"));
    bytes32 constant ROOT_CHAIN_MANAGER_PROXY_ADDRESS = keccak256(abi.encodePacked("ROOT_CHAIN_MANAGER_PROXY_ADDRESS"));

    function key(
        string memory _key
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_key));
    }
}
interface IBase is IOwnable {

    function name(
    ) external view returns (string memory);

    function version(
    ) external pure returns (string memory);

    function institutionId(
    ) external view returns (string memory);
}
interface IProxy is IBase {

    function implementationAddress(
    ) external view returns (address);
}
interface IVErc20 is IBase, IErc20 {

    function underlying(
    ) external view returns (IErc20);

    function balanceOfUnderlying(
        address account
    ) external view returns (uint256);

    function totalBalanceOfUnderlying(
    ) external view returns (uint256);

    function mint(
    ) external;

    function redeem(
    ) external;

    function exchangeRate(
    ) external view returns (uint256);

    event Mint(
        uint256 tokens,
        uint256 underlyingTokens
    );

    event Redeem(
        uint256 tokens,
        uint256 underlyingTokens
    );
}
interface IVStore is IBase {

    function chainId(
    ) external view returns (uint256);

    function getAddress(
        bytes32 key
    ) external view returns (address);

    function setAddresses(
        bytes32[] memory keys,
        address[] memory addresses,
        string memory nonce,
        uint8[2] calldata V,
        bytes32[2] calldata R,
        bytes32[2] calldata S
    ) external;

    function setVErc20ProxyAddress(
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) external;

    function isVErc20(
        address _address
    ) external view returns(bool);

    function vDistributionProxyAddress(
        string memory institutionId
    ) external view returns (address);

    function setVDistributionProxyAddress(
        string memory institutionId,
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) external;

    function setVWalletProxyAddress(
        string memory institutionId,
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) external;

    function isVWallet(
        string memory institutionId,
        address _address
    ) external view returns(bool);

    function exchange(
        bytes32 symbolPair
    ) external view returns(uint256, uint256, uint256, uint256);

    function setExchanges(
        bytes32[] memory symbolPairs,
        uint256[] memory institutionApys,
        uint256[] memory apys,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) external;

    event SetExchanges(
        uint256[] institutionRates,
        uint256[] rates
    );
}
abstract contract ABase is IBase, AStorage {

    using SafeMath for uint256;

    uint256 constant ETHEREUM_MAINNET = 1;
    uint256 constant ETHEREUM_GOERLI = 5;
    uint256 constant ETHEREUM_KOVAN = 42;
    uint256 constant POLYGON_MAINNET = 137;
    uint256 constant POLYGON_MUMBAI = 8001;

    modifier onlyEthereum(
    ) {
        require(isEthereum(), "VBase::onlyEthereum - function only supported on Ethereum");
        _;
    }

    modifier onlyPolygon(
    ) {
        require(isPolygon(), "VBase::onlyPolygon - function only supported on Polygon");
        _;
    }

    modifier onlyUserAndVesto(
        Signatures memory signatures
    ) {
        address[2] memory signedBy = validateSignatures(signatures);
        require((signedBy[0] == userAddress() && signedBy[1] == vAddress()) || (signedBy[0] == vAddress() && signedBy[1] == userAddress()), "VBase::onlyUserAndVesto - must include user's and Vesto's signatures");
        _;
    }

    modifier onlyRecoveryAndVesto(
        Signatures memory signatures
    ) {
        address[2] memory signedBy = validateSignatures(signatures);
        require((signedBy[0] == recoveryAddress() && signedBy[1] == vAddress()) || (signedBy[0] == vAddress() && signedBy[1] == recoveryAddress()), "VBase::onlyRecoveryAndVesto - must include recovery's and Vesto's signatures");
        _;
    }

    modifier onlyUserAndRecovery(
        Signatures memory signatures
    ) {
        address[2] memory signedBy = validateSignatures(signatures);
        require((signedBy[0] == userAddress() && signedBy[1] == recoveryAddress()) || (signedBy[0] == recoveryAddress() && signedBy[1] == userAddress()), "VBase::onlyUserAndRecovery - must include user's and recovery's signatures");
        _;
    }

    modifier onlyVErc20(
        address _address
    ) {
        require(vStore().isVErc20(_address), "VBase::onlyVErc20 - only vErc20 addresses supported");
        _;
    }

    function isEthereum(
    ) internal view returns (bool) {
        return (vStore().chainId() == ETHEREUM_MAINNET || vStore().chainId() == ETHEREUM_KOVAN || vStore().chainId() == ETHEREUM_GOERLI);
    }

    function isPolygon(
    ) internal view returns (bool) {
        return (vStore().chainId() == POLYGON_MUMBAI ||  vStore().chainId() == POLYGON_MAINNET);
    }

    function version(
    ) override public pure returns (string memory) {
        return "1.0";
    }

    function institutionId(
    ) override public view returns (string memory) {
        return stringStorage[INSTITUTION_ID];
    }

    function vStore(
    ) internal view returns (IVStore){
        return IVStore(addressStorage[VSTORE_PROXY_ADDRESS]);
    }

    function vAddress(
    ) internal view returns (address) {
        return addressStorage[VADDRESS];
    }

    function userAddress(
    ) internal view returns (address) {
        return addressStorage[USER_ADDRESS];
    }

    function recoveryAddress(
    ) internal view returns (address) {
        return addressStorage[RECOVERY_ADDRESS];
    }

    function setVAddress(
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) onlyUserAndRecovery(
        Signatures(nonce, keccak256(abi.encodePacked(address(this), "setVAddress", _address, nonce)), V, R, S)
    ) override public {
        addressStorage[VADDRESS] = _address;
    }

    function setUserAddress(
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) onlyRecoveryAndVesto(
        Signatures(nonce, keccak256(abi.encodePacked(address(this), "setUserAddress", _address, nonce)), V, R, S)
    ) override public {
        addressStorage[USER_ADDRESS] = _address;
    }

    function setRecoveryAddress(
        address _address,
        string memory nonce,
        uint8[2] memory V,
        bytes32[2] memory R,
        bytes32[2] memory S
    ) onlyUserAndVesto(
        Signatures(nonce, keccak256(abi.encodePacked(address(this), "setRecoveryAddress", _address, nonce)), V, R, S)
    ) override public {
        addressStorage[RECOVERY_ADDRESS] = _address;
    }

    function isOwnerAddress(
        address _address
    ) internal view returns (bool) {
        return _address == vAddress() || _address == userAddress() || _address == recoveryAddress();
    }

    function validateSignatures(
        Signatures memory signatures
    ) internal returns (address[2] memory signedBy) {
        uint256 begin;
        uint256 end;
        (begin,end) = spliceTimestamps(signatures.nonce);
        require((end >= block.timestamp) && (begin < block.timestamp), "VBase::validateSignatures - invalid timestamps");
        require(!isThisNonceUsed(signatures.nonce), "VBase::validateSignatures - possible replay attack");

        address[2] memory addresses;
        for (uint i = 0; i < 2; i++) {
            uint8 csv = signatures.V[i];
            // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
            if (csv < 27) {
                csv += 27;
            }
            require(csv == 27 || csv == 28, "VBase::validateSignatures - invalid signature version");
            addresses[i] = ecrecover(signatures.hash, csv, signatures.R[i], signatures.S[i]);
            require(isOwnerAddress(addresses[i]), "VBase::validateSignatures - invalid signature");
        }
        require(addresses[0] != addresses[1], "VBase::validateSignatures - signatures must be from different accounts");
        flagThisNonce(signatures.nonce);
        return addresses;
    }

    function spliceTimestamps(
        string memory nonce
    ) private pure returns (uint256 begin, uint256 end) {
        bytes memory _bytes = bytes(nonce);
        require(_bytes.length == 56, "VBase::spliceTimestamps - invalid nonce length");

        uint256 result = 0;
        for (uint256 i = 36; i < _bytes.length; i++) {
            uint256 b = uint(uint8(_bytes[i]));
            if (b >= 48 && b <= 57) {
                result = result * 10 + (b - 48);
            }
        }
        begin = result / 1e10;
        end = result % 1e10;
    }

    function flagThisNonce(
        string memory nonce
    ) private {
        bytes32ToBoolStorage[NONCES][key(nonce)] = true;
    }

    function isThisNonceUsed(
        string memory nonce
    ) private view returns (bool) {
        return bytes32ToBoolStorage[NONCES][key(nonce)];
    }

    function encodePackedAddressArray(
        address[] memory array
    ) internal pure returns (bytes memory) {
        bytes memory data;
        for (uint i=0; i<array.length; i++) {
            data = abi.encodePacked(data, array[i]);
        }
        return data;
    }

    function encodePackedByte32Array(
        bytes32[] memory array
    ) internal pure returns (bytes memory) {
        bytes memory data;
        for (uint i=0; i<array.length; i++) {
            data = abi.encodePacked(data, array[i]);
        }
        return data;
    }

    function encodePackedUint32Array(
        uint256[] memory array
    ) internal pure returns (bytes memory) {
        bytes memory data;
        for (uint i=0; i<array.length; i++) {
            data = abi.encodePacked(data, array[i]);
        }
        return data;
    }

    function convert(
        IErc20 erc20,
        IErc20 pairedErc20,
        uint256 rate,
        uint256 tokens
    ) internal pure returns (uint256) {
        uint256 multiplier = 10 ** (18 + 18 - erc20.decimals()); // USDC 1e6 x 1e30 ➗ 1e18 -> 1e18
        uint256 convertedTokens = tokens
        .mul(multiplier)
        .mul(rate)
        .div(1e18)
        .div(1e18);

        if (pairedErc20.decimals() != 18) {
            multiplier = 10 ** (18 + 18 - pairedErc20.decimals()); // USDC 1e18 x 1e18 ➗ 1e30 -> 1e6
            convertedTokens = convertedTokens
            .mul(1e18)
            .div(multiplier);
        }
        return convertedTokens;
    }
}
abstract contract AProxy is IProxy, ABase {

    event Received(uint256 amount, address sender);

    constructor (
        address vAddress,
        address userAddress,
        address recoveryAddress,
        bytes32 _implementationAddressKey,
        address vStoreProxyAddress
    ) {
        addressStorage[VADDRESS] = vAddress;
        addressStorage[USER_ADDRESS] = userAddress;
        addressStorage[RECOVERY_ADDRESS] = recoveryAddress;
        bytes32Storage[IMPLEMENTATION_ADDRESS_KEY] = _implementationAddressKey;
        addressStorage[VSTORE_PROXY_ADDRESS] = vStoreProxyAddress;
    }

    function implementationAddressKey(
    ) internal view returns (bytes32) {
        return bytes32Storage[IMPLEMENTATION_ADDRESS_KEY];
    }

    function implementationAddress(
    ) override virtual public view returns (address) {
        return vStore().getAddress(implementationAddressKey());
    }

    /**
    * @dev Fallback function allowing to perform a delegatecall to the given implementation.
    * This function will return whatever the implementation call returns
    */
    receive(
    ) external payable {
        emit Received(msg.value, msg.sender);
    }

    fallback(
    ) payable external {
        address _implementationAddress = implementationAddress();
        require(_implementationAddress != address(0), "VProxy::fallback - invalid implementation address");
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _implementationAddress, ptr, calldatasize(), 0, 0)
            mstore(0x40, add(ptr, returndatasize()))
            returndatacopy(ptr, 0, returndatasize())
            switch result
            case 0 {revert(ptr, returndatasize())}
            default {return (ptr, returndatasize())}
        }
    }
}


contract VErc20Proxy is AProxy {
    constructor (
        address vAddress,
        address userAddress,
        address recoveryAddress,
        address vStoreProxyAddress,
        string memory name,
        string memory symbol,
        string memory underlyingAddressKey,
        string memory redeemAddressKey,
        string memory institutionId
    ) AProxy(vAddress, userAddress, recoveryAddress, VERC20_ADDRESS, vStoreProxyAddress) {
        stringStorage[NAME] = name;
        stringStorage[SYMBOL] = symbol;
        bytes32Storage[UNDERLYING_ADDRESS_KEY] = key(underlyingAddressKey);
        bytes32Storage[REDEEM_ADDRESS_KEY] = key(redeemAddressKey);
        stringStorage[INSTITUTION_ID] = institutionId;
    }

    function name(
    ) override public view returns (string memory) {
        return stringStorage[NAME];
    }
}