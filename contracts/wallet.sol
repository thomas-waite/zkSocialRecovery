pragma solidity ^0.6.1;


import "./lib/ownable.sol";
import "./interfaces/IProofValidator.sol";

//// @title Smart contract wallet with ZK recovery capability.
contract Wallet is Ownable {

    event Received(address _from, uint _amount);
    event Transferred(address _to, uint _amount);

    address public validatorContract;
    mapping(bytes32 => bool) public zkMerlins;

    uint8 private _recoveryThreshold;
    uint8 private _proofsValidated;

    /// @dev Constructor initializes the wallet top up limit and the vault contract.
    /// @param _owner is the owner account of the wallet contract.
    /// @param _transferable indicates whether the contract ownership can be transferred.
    /// @param _threshold indicates how many proofs need to be provided in order to recover the wallet.
    constructor(address payable _owner, bool _transferable, uint8 _threshold) Ownable(_owner, _transferable) public {
        _recoveryThreshold = _threshold;
    }

    /// @dev Fallback function.
    fallback() external payable {
        emit Received(msg.sender, msg.value);
    }

    function zkRecover(address payable _recoveryAddress, bytes32 _proofHash, bytes calldata _proofData) external returns (bool){

        bool isValid = IProofValidator(validatorContract).validateProof(_proofHash, _proofData);
        if (isValid){
            _proofsValidated++;
        }
        else{
            //slash malicious actor
        }
        if(_proofsValidated == _recoveryThreshold){
            _proofsValidated = 0;
            _transferOwnership(_recoveryAddress, true);
        }
    }

    /// @dev Transfers the specified asset to the recipient's address.
    /// @param _to is the recipient's address.
    /// @param _amount is the amount of assets to be transferred in base units.
    function transfer(address payable _to,  uint _amount) public onlyOwner {
        // Prevents from sending to the zero-address
        require(_to != address(0), "destination cannot be zero");

        // Transfer token or ether based on the provided address.
        _to.transfer(_amount);
        // Emit the transfer event.
        emit Transferred(_to, _amount);
    }


}