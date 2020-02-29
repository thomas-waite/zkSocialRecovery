pragma solidity ^0.6.1;


contract DummyWallet {
    uint8 public _recoveryThreshold;
    bool public recovered;

    constructor(address payable _owner, bool _transferable, uint8 _threshold) public {
        _recoveryThreshold = _threshold;
    }

    mapping (bytes32 => bool) public zkMerlins;

    function setGuardian(bytes32 encryptedGuardianAddress) public {
        zkMerlins[encryptedGuardianAddress] = true;
    }

    function zkRecover(address payable _recoveryAddress, bytes32 _proofHash, bytes memory _proofData) public returns (bool) {
        recovered = true;
        return recovered;
    }
    
    function transfer(address payable _to,  uint _amount) public {
    }
}