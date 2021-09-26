pragma solidity <0.6.10;
// SPDX-License-Identifier: MIT

contract Interop {

    uint expectedPartiesNumber = 3; //we expect to have 3 parties
    uint realPartiesNumber = 0; 

    // in these two mappings we keep an index of bitcoiners and etherers.
    // Bitcoiner i will receive the money from Etherer i
    mapping (uint => address) public EtherersIndexed;
    mapping (uint => address) public BitcoinersIndexed;

    // here we take into account the amounts paid and the expected amounts
    mapping (address => uint) public EtherersAmounts;
    mapping (address => uint) private ExpectedEtherersAmounts;

    bytes32 public hashValue;
    address public  acctSender;
    uint256 public value;
    address payable newAcct;
    enum State { Created, HashInserted, Funded,  Active, Inactive }; // Enum

    State public state
    owner = msg.sender;

    modifier inState(State _state) {
        require(
            state == _state,
            "Invalid state."
        );
        _;
    }

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }

    // begin array functions

    function arrPush(address[] arr,uint i) public {
        // Append to array
        // This will increase the array length by 1.
        arr.push(i);
    }

    function arrPop(address[] arr) public {
        // Remove last element from array
        // This will decrease the array length by 1
        arr.pop();
    }

    function arrGetLength(address[] arr,uint i) public view returns (uint) {
        return arr.length;
    }

    function arrRemove(address[] arr,uint index) public {
        // Delete does not change the array length.
        // It resets the value at index to it's default value,
        // in this case 0
        delete arr[index];
    }

    // end array functions
    
    // You need to send a transaction to write to a state variable.
    function setHash(bytes32 _hashValue) public inState(State.Created) onlyOwner {
        hashValue=_hashValue;
        state = State.HashInserted;
    }

    function activationSwitch() public inState(State.Funded) onlyOwner {
        state = State.Active;
    }
        

    function isSha256Preimage(
        bytes memory _candidate
        // bytes32 _digest
    ) public returns (bool) {
        //bytes memory candidate_bytes = abi.encode(_candidate);
        return sha256(_candidate)==hashValue;
    }

    // You can read from a state variable without sending a transaction.
    // Actually we don't need this function. The compiler automatically
    // creates getter functions for all public variables.
    function getHash() public  returns (bytes32){
        return hashValue;
    }

    // see https://stackoverflow.com/questions/48898355/soldity-iterate-through-address-mapping

    function GetAmounts(address addr, uint amount) public payable inState(State.HashInserted) {
        require (ExpectedEtherersAmounts[addr] == amount, "this address has wrong  value or shouldn't participate in this contract");
        require (EtherersIndexed[realPartiesNumber] == addr, "it's not the turn of this address")
        EtherersAmounts[addr] = amount;
        realPartiesNumber++;
        if (realPartiesNumber == expectedPartiesNumber - 1) {
            state = State.Funded
        }
    }

    function PayOut(bytes memory _candidate) public inState(State.Active) returns (bool) {
        if (isSha256Preimage(_candidate)){
            for(uint i = 0 ; i<expectedPartiesNumber; i++) {
            BitcoinersIndexed[i].transfer(EtherersAmounts[EtherersIndexed[i]]);
        }
        return isSha256Preimage(_candidate);
    
    }
}
