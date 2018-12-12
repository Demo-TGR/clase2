pragma solidity ^0.4.24;

import "./Crowdfunding.sol";

contract CrowdfundingFactory is Ownable {
 
    constructor() public {
        
    }
    
    function createCrowdfunding(address _beneficiario, uint _meta) public onlyOwner
    returns (address newCrowdfundfing)
    {
        Crowdfunding _t = new Crowdfunding(_beneficiario,_meta);
        return _t;
    }
}