pragma solidity ^0.4.24;

import "./KongrioToken.sol";
import "./House.sol";

contract HouseSell {
    
    uint price;
    uint tokenId;
    uint deadline;
    bool ready; 
    address houseSeller;
    address houseBuyer;
    address erc20Address;
    address erc721Address;
    
    constructor(uint _price, uint _tokenId, address _houseSeller, 
                address _houseBuyer, address _erc20Address,
                address _erc721Address) public {
        ready = false;
        price = _price;
        houseSeller = _houseSeller;
        houseBuyer =  _houseBuyer;
        tokenId = _tokenId;
        erc20Address = _erc20Address;
        erc721Address = _erc721Address;
    }
    
    function done() public {
      KongrioToken token = KongrioToken(erc20Address);
      House house = House(erc721Address);
      token.transferFrom(houseBuyer,houseSeller,price);
      house.transferFrom(houseSeller,houseBuyer,tokenId);
    } 
    
    function getPrice() view public returns (uint _price) {
        return price;   
    }

    function getTokenId() view public returns (uint _tokenId) {
        return tokenId;   
    }

    
}