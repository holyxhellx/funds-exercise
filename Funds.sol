pragma solidity >=0.4.22 <0.6.0;

contract Funds { // Name of the contract
    
    // Define a signature through a name and an address
    struct Signature {
        string name;
        address add;
    }
    
    // Vector containing singatures
    Signature[] public signatures;
    
    // Says if an address has already been used to sign the contract
    mapping(address => bool) address_previously_used;
    
    // Allows to define permissions to call functions
    modifier isOwner(bool expectedStatus, string memory error) {
        require(address_previously_used[msg.sender] == expectedStatus, error);
        _;
    }

    // Allows to sign the contract
    function writeSignature(string memory _name) public isOwner(false, "An address can be used only once to sign the contract.") {
        signatures.push(Signature(_name, msg.sender));
        address_previously_used[msg.sender] = true;
    }
    
    // Shows signatures (and names) written into the contract
    function showSignatures() public view returns (string memory) {
        string memory signatures_concatenated = "";
        for (uint i = 0; i < signatures.length; i++) {
            if (i == 0) {
                signatures_concatenated = signatures[0].name;
            } else {
                signatures_concatenated = string(abi.encodePacked(signatures_concatenated, ", ", signatures[i].name));
            }
        }
        return signatures_concatenated;
    }
    
    // Allows to withdraw funds from smart contract
    function withdrawFunds() external isOwner(true, "An address must have been used to sign the contract to withdraw funds.") {
        // At least 2 signatures have to be available
        require(signatures.length >= 2);
        msg.sender.transfer(address(this).balance);
    }
    
    // Returns smart contract balance in Wei (1/10^18 Ether) 
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
    
    // Allows to deposit funds into the contract
    function () external payable {}  
}
