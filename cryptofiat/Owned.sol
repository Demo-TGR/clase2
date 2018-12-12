pragma solidity ^0.4.15;

contract Owned {
    
    address owner;
    
    modifier onlyOwner {
        if (msg.sender != owner) revert();
        _;
    }

    function Owned() 
    {
        owner = msg.sender;
    }
    
    function changeOwnership(address newOwner) 
    public onlyOwner
    returns (bool result)
    {
        owner = newOwner;
        return true;
    }
    
    function getOwner()
    public constant
    returns (address ownerAddress)
    {
        return owner;
    }
    
}