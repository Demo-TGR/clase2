pragma solidity ^0.4.24;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";
import "./HouseSell.sol";

contract House is ERC721Mintable {

    function sell(HouseSell _sellProcess) public {
        approve(_sellProcess,_sellProcess.getTokenId());
    }
	
}