pragma solidity ^0.4.24;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "./HouseSell.sol";

contract KongrioToken is ERC20Mintable, ERC20Burnable {
	
	string name;
	
	
	constructor() public {
	    name = "KongrioToken"; 
	}
	
	function buy(HouseSell sellProcess) public {
	    approve(sellProcess,sellProcess.getPrice());
	}
	
}