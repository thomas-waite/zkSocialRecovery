pragma solidity ^0.6.1;


import "./lib/ownable.sol";
import "./lib/SafeMath.sol";
import "./interfaces/IProofValidator.sol";

//// @title Smart contract wallet with ZK recovery capability.
contract ZkWallet is Ownable {

    using SafeMath for uint256;

    event Received(address indexed _from, uint _amount);
    event Transferred(address indexed _to, uint _amount);
    event CommittedZK(uint _commit);
    event UncommittedZK(uint _commit);
    event ProofValidator(address indexed validatorContract);

    address public validatorContract;
    mapping(uint => bool) public zkCommits;

    struct Proof {
        uint[2] a;
        uint[2][2] b;
        uint[2] c;
        uint[3] input;
    }

    Proof _proof;
    // mapping (uint => Proof) _proofs;

    uint public commitCnt;
    uint public recoveryThreshold;

    uint private _proofsValidated;

    /// @dev Constructor initializes the wallet top up limit and the vault contract.
    /// @param _owner is the owner account of the wallet contract.
    /// @param _transferable indicates whether the contract ownership can be transferred.
    /// @param _threshold indicates how many proofs need to be provided in order to recover the wallet.
    constructor(address payable _owner, bool _transferable, uint8 _threshold) Ownable(_owner, _transferable) public {
        recoveryThreshold = _threshold;
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

    // solUI compatible
    function addZkCommit(uint _commit) external onlyOwner {

        // Dedup commits before adding them to the mapping
        if (!zkCommits[_commit]) {
            // adds to the whitelist mapping
            zkCommits[_commit] = true;
            commitCnt++;
        }
        emit CommittedZK(_commit);
    }

    function addZkCommits(uint[] calldata _commits) external onlyOwner {

        for (uint i = 0; i < _commits.length; i++) {
            uint commit = _commits[i];
            // Dedup commits before adding them to the mapping
            if (!zkCommits[commit]) {
                // adds to the whitelist mapping
                zkCommits[commit] = true;
                commitCnt++;
            }
            emit CommittedZK(commit);
        }
    }

    function removeZkCommits(uint[] calldata _commits) external onlyOwner {

        for (uint i = 0; i < _commits.length; i++) {
            uint commit = _commits[i];
            // Dedup commits before adding them to the mapping
            if (zkCommits[commit]) {
                // adds to the whitelist mapping
                zkCommits[commit] = false;
                commitCnt = commitCnt.sub(1);
            }
            emit UncommittedZK(commit);
        }
    }

    function storeProof(uint _a0, uint _a1, uint _b00, uint _b01, uint _b10, uint _b11, uint _c0, uint _c1, uint _input1, uint _input2) external {
        // Proof storage proof = _proofs[_input];
        _proof.a[0] = _a0;
        _proof.a[1] = _a1;
        _proof.b[0][0] = _b00;
        _proof.b[0][1] = _b01;
        _proof.b[1][0] = _b10;
        _proof.b[1][1] = _b11;
        _proof.c[0] = _c0;
        _proof.c[1] = _c1;
        _proof.input[0] = _input1;
        _proof.input[1] = _input2;
        _proof.input[2] = uint(1);
     }

    function zkRecover(address payable _recoveryAddress, uint _proofId) public returns (bool){

        require(zkCommits[_proofId], "Commit is not set");

        // Proof memory proof = _proofs[_proofId];
        bool isValid = IProofValidator(validatorContract).verifyTx(_proof.a, _proof.b, _proof.c, _proof.input);

        if (isValid){
            _proofsValidated++;
        }
        else{
            //slash malicious actor
        }
        if(_proofsValidated == recoveryThreshold){
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