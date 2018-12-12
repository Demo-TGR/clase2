pragma solidity ^0.4.24;

import "./Pausable.sol";

contract Crowdfunding is Pausable {
    
    address public _beneficiario;
    uint public _meta;
    uint public _montoActual;

    mapping (address=>uint) public aportes;
    
    modifier onlyBeneficiario {
        if(msg.sender!=_beneficiario) revert();
        _;
    }
    
    event metaAlcanzada(uint monto);
    
    constructor(address beneficiario,uint meta) 
    public {
        require(msg.sender != beneficiario);
        require(meta > 0);
        _beneficiario = beneficiario;
        _meta= meta * 1000000000000000000;
        _montoActual = 0;
    }

    function aportar() whenNotPaused
    public payable {
        _montoActual += msg.value;
        
        if (_montoActual >= _meta) {
            emit metaAlcanzada(_montoActual);
            _beneficiario.transfer(_montoActual);
            _montoActual=0;
            selfdestruct(_beneficiario);
        } 
    }
    
}