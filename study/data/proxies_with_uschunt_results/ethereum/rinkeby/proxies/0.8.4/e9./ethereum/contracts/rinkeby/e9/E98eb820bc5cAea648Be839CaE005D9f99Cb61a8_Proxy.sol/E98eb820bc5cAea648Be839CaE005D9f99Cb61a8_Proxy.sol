/**
 *Submitted for verification at Etherscan.io on 2021-08-17
*/

pragma solidity 0.8.4;

/*
 * Ownable
 *
 * Base contract with an owner.
 * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
 */
contract Ownable {
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender == owner)
      _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    if (newOwner != address(0)) owner = newOwner;
  }

}

contract Proxy is Ownable {
    
    uint256 public test1; // slot 1
    uint256 public test2; // slot 2
    uint256 public result; // slot 3
    
    address payable implementation = payable(0xBe8e44B61f90Ad2F71e571dc51eBc33788929342);
    uint256 version = 1;
    
    fallback() payable external {
        implementation.delegatecall(msg.data);
    }
    
    function changeImplementation(address payable _newImplementation, uint256 _newVersion) public onlyOwner {
        require(_newVersion > version, "New version must be greater then previous");
        implementation = _newImplementation;
    }
    
}