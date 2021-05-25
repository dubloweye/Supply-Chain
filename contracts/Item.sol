pragma solidity ^0.6.0;

import "./ItemManager.sol";

// Individual Contract for items to improve UI
contract Item {
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }
    
    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        // Have to listen to return value. Gives 2 return values: boolean for success and any return values in triggerPayment. Only bool.
        require(success, "Transaction unsuccessful, cancelling");
    }
    
    fallback() external {
        
    }
}