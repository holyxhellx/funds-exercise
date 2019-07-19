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

    // Allows to sign the contract
    function writeSignature(string memory _name) public {
        // The address must not have been already used to sing the contract
        require(address_previously_used[msg.sender] == false);
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
    function withdrawFunds() external {
        // The address must have been used to sing the contract
        require(address_previously_used[msg.sender] == true);
        // At least 3 signatures have to be available
        require(signatures.length >= 3);
        msg.sender.transfer(address(this).balance);
    }
    
    // Allows to deposit funds into the contract
    function () external payable {}  
}
