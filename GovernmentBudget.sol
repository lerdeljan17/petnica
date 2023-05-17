// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Budget {  
    //testnet - ima isto blockchain to je ethereum fondacija necentralizovan i sluzi za testiranje
    //dobar je za testiranje aplikacije
    //moze da bude dobar za testiranje klijenta
    //blockchain bez para
     enum TaxPayerType{ PHYSICAL_ENTITY, LEGAL_ENTITY }

    struct TaxPayer {
        uint256 taxAmount; //uint256 je najjeftiniji od svih ostalih --32 bytes
        TaxPayerType taxPayerType;
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted proposals
    }

    address immutable government;
    address immutable adminMultisig;
    constructor(address governmentAddress, address multiSig) {
        government = governmentAddress;
        adminMultisig = multiSig;
    }

    modifier  onlyAdmin(){
        require(msg.sender == government,"Error: Only Admin Can Call");
        _;
    }
    //petlja nevalja jer se uvek cita iz stack-a i to je mnogo kolicina gasa se trosi

    //hash funkcija bolje je da se koristi
    mapping(address => TaxPayer) public taxPayerMap;

    //cuvamo u logove a nije bitno za chain- ne cuva se na chain-u
    event TaxPayed(address donator, uint256 taxAmount);

    //fund - anyone can call
    function fund() external payable {
        //msg.sender
        //msg.value 
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