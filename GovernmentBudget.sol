// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Budget {  

    struct TaxPayer {
        uint256 taxAmount; //uint256 je najjeftiniji od svih ostalih --32 bytes       
        uint256 vote;   // index of the voted proposals
        TaxPayerType taxPayerType;
        bool voted;  // if true, that person already voted
        bool isValid; //0- active  --- 1- non-active
    }

    address immutable government;
    address immutable adminMultisig;

    enum TaxPayerType{ PHYSICAL_ENTITY, LEGAL_ENTITY }

    constructor(address governmentAddress, address multiSig) {
        government = governmentAddress;
        adminMultisig = multiSig;
    }

    modifier onlyAdmin(){
        require(msg.sender == government,"Error: Only Admin Can Call");
        _;
    }

    mapping(address => TaxPayer) public taxPayerMap;

    event TaxPayed(address TaxPayer, uint256 taxAmount);

    function fund() external payable {
        taxPayerMap[msg.sender].taxAmount += msg.value;
        emit TaxPayed(msg.sender, msg.value);
    }
    //struct - slozeni podatak
    //multisig(multi signature - vise EOA kontrolise kontrakt 'ako vise od 2 korisnika potpise moze da se koristi'


    // //withdraw() - only admin multsig
    // function withdraw(uint256 amount, address to) public onlyAdmin {
    //     (bool send, ) = government.call{value: amount}("");
    //     require(send, "Failed to send Ether");
    // }
    function sendPayment(uint256 amount, address payable receiver) public onlyAdmin {
        require(address(this).balance >= amount, "Insufficient balance in the contract");
        
        receiver.transfer(amount);
    }

}