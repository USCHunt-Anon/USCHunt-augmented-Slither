/**
 *Submitted for verification at Etherscan.io on 2021-03-15
*/

/// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
/// @author Stefan George - <[email protected]> /// adapted by pepihasenfuss.eth
pragma solidity >=0.4.22 <0.6.0;

contract Proxy {
    address internal masterCopy;

    string public constant standard = 'ERC-20';
    uint256 private _guardCounter = 1;

    address public ownerAddr;
    bytes32 public dHash;
    
    mapping (address => bool)    public frozenAccount;
    mapping (address => uint256) public balances;
    mapping (address => mapping  (address => uint256)) public allowed;

    uint256 public sellP =  95;
    uint256 public buyP  = 100;

    string  public nm;
    string  public constant symb = "shares";
    uint8   public constant dec  = 2;
    uint256 public constant sply = 1000000;
    

    constructor(address _masterCopy) public payable
    {
      require(_masterCopy != address(0x0), "MasterCopy address MUST BE != 0x0");
      masterCopy = _masterCopy;
    }
    
    function () external payable
    {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
            if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
                mstore(0, masterCopy)
                return(0, 0x20)
            }

            //calldatacopy(0, 0, calldatasize())
            //let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
            //returndatacopy(0, 0, returndatasize())
            //if eq(success, 0) { revert(0, returndatasize()) }
            //return(0, returndatasize())
            
            calldatacopy(0, 0, calldatasize())
            if eq(call(gas, masterCopy, 0, 0, calldatasize(), 0, 0), 0) { revert(0, 0) }

        }
    }
}