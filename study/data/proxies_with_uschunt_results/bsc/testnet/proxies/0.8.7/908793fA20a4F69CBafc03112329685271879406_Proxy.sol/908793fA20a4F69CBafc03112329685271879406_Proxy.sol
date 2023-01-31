/**
 *Submitted for verification at BscScan.com on 2022-01-07
*/

// ////-License-Identifier: MIT
pragma solidity 0.8.7;

contract ProxyStorage {
    address public otherContractAddress;

    function setOtherAddressStorage(address _otherContract) internal {
        otherContractAddress = _otherContract;
    }
}

contract Proxy is ProxyStorage {

    mapping(address => bool) AccessWallet;
    address devwallet;
    constructor(address _devwallet) {
        devwallet = _devwallet;
        AccessWallet[_devwallet] = true;
    }

    function setOtherAddress(address _otherContract) public 
    {
        require(AccessWallet[msg.sender],"not devwallet");
        super.setOtherAddressStorage(_otherContract);
    }
    
    function withdrawEth(uint256 amount) external
    {
        require(msg.sender == devwallet,"not devwallet");
        (bool success,)  = devwallet.call{value:amount}("");
        require(success, "refund failed");
    }   
    
    function accessProvide(address _address) external
    { 
        require(msg.sender == devwallet,"not devwallet");
        AccessWallet[_address] = true;
    }

    function unaccessProvider(address _address) external
    {
        require(msg.sender == devwallet,"not devwallet");
        AccessWallet[_address] = false;
    }

    function upgradeDevwallet(address _address) external
    {
       require(msg.sender == devwallet,"not devwallet");
       devwallet = _address;
    }

     /**
  * @dev Fallback function allowing to perform a delegatecall to the given implementation.
  * This function will return whatever the implementation call returns
  */
  fallback() payable external {
    address _impl = otherContractAddress;

    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize())
      let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
      let size := returndatasize()
      returndatacopy(ptr, 0, size)

      switch result
      case 0 { revert(ptr, size) }
      default { return(ptr, size) }
    }
  }
}