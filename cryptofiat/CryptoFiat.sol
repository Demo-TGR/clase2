pragma solidity ^0.4.15;

import "./Owned.sol";
import "./SafeMath.sol";

contract CryptoFiat is Owned {

    string description;
    address minter;
    
    uint256 totalSupply;

    bool contractEnabled;
    
    struct Account{
        uint256 balance;
        bool enabled;
    }
    mapping(address => Account) Accounts;

    modifier onlyIfStarted {
        if (contractEnabled == false) revert();
        _;
    }
    
    event accountCreated(address newAccount);
    event accountFreezed(address account);
    event accountUnfreezed(address account);
    event tokenMinted(uint quantity);
    event tokenRedeemed(uint quantity);
    event contractStopped();
    event contractStarted();
    event tokensTransfered(address sender, address destination, uint quantity);

    function CryptoFiat(string fiatDescription) {
        description  = fiatDescription;
        minter = owner;
        totalSupply = 0;
        contractEnabled=true;
    }
    
    function EmergencyStop() 
        public onlyOwner
        returns (bool result)
    {
       contractEnabled= false;
       contractStopped();
       return true;
    }
    
    function EmergencyStart() 
       public onlyOwner
       returns (bool result)    
    {
        contractEnabled = true;
        contractStarted();
        return true;
    }

    //This function enables an address to operate with the CryptoFiat
    function CreateAccount(address accountNumber) 
    public onlyOwner onlyIfStarted
    returns (bool result)
    {
        Accounts[accountNumber] = Account(0,true);
        accountCreated(accountNumber);
        return true;
    }
    
    //This function prevent an account from sending/receiving token
    //good for security or regulatory issues
    function FreezeAccount(address accountNumber) 
    public onlyOwner onlyIfStarted
    returns (bool result)    
    {
        Accounts[accountNumber].enabled=false;
        accountFreezed(accountNumber);
        return true;
    }

    function UnfreezeAccount(address accountNumber)
    public onlyOwner onlyIfStarted
    returns (bool result) 
    {
        Accounts[accountNumber].enabled=true;
        accountUnfreezed(accountNumber);
        return true;        
    }

    function Mint(address destination,uint quantity) 
    public onlyOwner onlyIfStarted
    returns (bool result)
    {
        //If account is enabled to operate, we add the fresh minted tokens
        totalSupply = SafeMath.add(totalSupply,quantity);
        if(Accounts[destination].enabled==false) {
            totalSupply = SafeMath.sub(totalSupply,quantity);
            return false;
        } else {
            Accounts[destination].balance = SafeMath.add(quantity,Accounts[destination].balance);
            tokenMinted(quantity);
            return true;
        }
    }

    function Redeem(address requester,uint quantity) 
    public onlyOwner onlyIfStarted
    returns (bool result) 
    {
        if(Accounts[requester].enabled == false || Accounts[requester].balance<quantity) {
            return false;
        } else {
            totalSupply = SafeMath.sub(totalSupply,quantity);
            Accounts[requester].balance = SafeMath.sub(Accounts[requester].balance,quantity);
            tokenRedeemed(quantity);
            return true;
        }
    }
    
    function Transfer(address destination,uint quantity) 
    public onlyIfStarted
    returns (bool result)
    {
        //check if destination, target and balance are ok
        if (Accounts[msg.sender].enabled == false) revert();
        if (Accounts[destination].enabled == false) revert();
        if (Accounts[msg.sender].balance <= quantity) revert();
        Accounts[msg.sender].balance = SafeMath.sub(Accounts[msg.sender].balance,quantity);
        Accounts[destination].balance = SafeMath.add(Accounts[destination].balance,quantity);
        tokensTransfered(msg.sender,destination,quantity);
        return true;
    }

    function GetStatus(address target)
    constant public returns (bool enabled,uint balance) {
        return (Accounts[target].enabled,Accounts[target].balance);
    }

    function GetContractEnabled() 
    constant public
    returns (bool result)
    {
        return contractEnabled;
    }
    
    function GetTotalSupply() 
        public constant returns (uint supply)
    {
        return totalSupply;
    }
    
}