pragma solidity ^0.6.1;


import "./lib/ownable.sol";
import "./lib/SafeMath.sol";
import "./interfaces/IProofValidator.sol";

//// @title Smart contract wallet with ZK recovery capability.
contract ZkWallet is Ownable {

    using SafeMath for uint256;

    event Received(address indexed _from, uint _amount);
    event Transferred(address indexed _to, uint _amount);
    event AddGuardian(uint firstHash, uint secondHash);
    event ProofValidator(address indexed validatorContract);

    address public validatorContract;
    uint public firstHash;
    uint public secondHash;

    /// @dev Constructor initializes the wallet top up limit and the vault contract.
    /// @param _owner is the owner account of the wallet contract.
    /// @param _transferable indicates whether the contract ownership can be transferred.
    /// @param _threshold indicates how many proofs need to be provided in order to recover the wallet.
    constructor(address payable _owner, bool _transferable) Ownable(_owner, _transferable) public {
    }

    /// @dev Receive function.
    fallback() external payable {
        emit Received(msg.sender, msg.value);
    }

    function setProofValidator(address _validator) public onlyOwner {
        require(_validator != address(0x0), 'Wallet/can not set _validator to zero');
        validatorContract = _validator;
        emit ProofValidator(validatorContract);
    }

    function addGuardian(uint _input1, uint _input2) external onlyOwner {
        firstHash = _input1;
        secondHash = _input2;
        emit AddGuardian(firstHash, secondHash);
    }

    function zkRecover(address payable _recoveryAddress, uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[3] memory inputs) public returns (bool) {
        require(firstHash == inputs[0], 'guardian not approved');
        require(secondHash == inputs[1], 'guardian not approved');

        bool isValid = IProofValidator(validatorContract).verifyTx(a, b, c, inputs);
        require(isValid == true, 'proof failed');
    
        _transferOwnership(_recoveryAddress, true);
    }

    /// @dev Transfers the specified asset to the recipient's address.
    /// @param _to is the recipient's address.
    /// @param _amount is the amount of assets to be transferred in base units.
    function transfer(address payable _to,  uint _amount) public onlyOwner {
        require(_to != address(0), "destination cannot be zero");
        _to.transfer(_amount);
        emit Transferred(_to, _amount);
    }
}