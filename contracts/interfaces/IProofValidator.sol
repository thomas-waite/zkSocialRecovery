pragma solidity ^0.6.1;


interface IProofValidator {
    function validateProof(bytes32, bytes calldata) external returns (bool);
}