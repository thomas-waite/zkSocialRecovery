pragma solidity ^0.6.1;


contract DummyWallet {

    mapping (bytes32 => bool) public zkMerlins;

    function setGuardian(bytes32 encryptedGuardianAddress) public {
        zkMerlins[encryptedGuardianAddress] = true;
    }

    function zkRecover(address payable _recoveryAddress, bytes32 _proofHash, bytes memory _proofData) public returns (bool) {
    }
    
    function transfer(address payable _to,  uint _amount) public {
    }
}