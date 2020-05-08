pragma solidity ^0.6.1;

import "./interfaces/IProofValidator.sol";
import "./lib/ownable.sol";
import "./zk/verifier.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/utils/Address.sol";

//// @title Smart contract wallet with ZK recovery capability.
contract ZkWallet is Ownable {

    using Address for address payable;
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    event Received(address indexed _from, uint _amount);
    event Transferred(address indexed _to, address indexed _token, uint _amount);
    event AddGuardian(bytes32 firstHash, bytes32 secondHash);
    event ProofValidator(address indexed validatorContract);

    address public validatorContract;
    bytes32 public firstHash;
    bytes32 public secondHash;

    /// @dev Constructor initializes the wallet top up limit and the vault contract.
    /// @param _owner is the owner account of the wallet contract.
    constructor(address payable _owner) Ownable(_owner) public {
        Verifier validator = new Verifier();
        validatorContract = address(validator);
        emit ProofValidator(validatorContract);
    }

    /// @dev Receive function.
    fallback() external payable {
        emit Received(msg.sender, msg.value);
    }

    function addGuardian(bytes32 _firstHalfOfHash, bytes32 _secondHalfOfHash) external onlyOwner {
        firstHash = _firstHalfOfHash;
        secondHash = _secondHalfOfHash;
        emit AddGuardian(firstHash, secondHash);
    }

     /// @dev This function is used to get the wallet balance for any ERC20 or ETH.
    /// @param _token is the address of an ERC20 token or 0x0 for ETH.
    function balance(address _token) external view returns (uint256) {
        if (_token != address(0)) {
            return IERC20(_token).balanceOf(address(this));
        } else {
            return address(this).balance;
        }
    }

    /// @dev Transfers the specified asset to the recipient's address.
    /// @param _to is the recipient's address.
    /// @param _token is the address of an ERC20 token or 0x0 for ETH.
    /// @param _amount is the amount of assets to be transferred in base units.
    function transfer(address payable _to, address _token, uint _amount) external onlyOwner {
        require(_to != address(0), "destination cannot be the 0 address");

        // address(0) is used to denote ETH
        if (_token == address(0)) {
            _to.sendValue(_amount);
        } else {
            IERC20(_token).safeTransfer(_to, _amount);
        }
        emit Transferred(_to, _token, _amount);
    }

    function zkRecover(address payable _recoveryAddress, bytes32[] calldata proof) external returns (bool) {
        (uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[3] memory inputs) = extractProof(proof);

        require(firstHash == bytes32(inputs[0]), 'guardian not approved');
        require(secondHash == bytes32(inputs[1]), 'guardian not approved');

        bool isValid = IProofValidator(validatorContract).verifyTx(a, b, c, inputs);
        require(isValid == true, 'proof failed');
    
        _transferOwnership(_recoveryAddress);
    }

    function extractProof(bytes32[] memory proof) internal pure returns (uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[3] memory inputs) {
        a[0] = uint256(proof[0]);
        a[1] = uint256(proof[1]);

        b[0][0] = uint256(proof[2]);
        b[0][1] = uint256(proof[3]);
        b[1][0] = uint256(proof[4]);
        b[1][1] = uint256(proof[5]);

        c[0] = uint256(proof[6]);
        c[1] = uint256(proof[7]);

        inputs[0] = uint256(proof[8]);
        inputs[1] = uint256(proof[9]);
        inputs[2] = uint256(proof[10]);
    }
}