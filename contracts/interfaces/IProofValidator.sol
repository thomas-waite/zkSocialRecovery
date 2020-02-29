pragma solidity ^0.5.15;


interface IProofValidator {
    function validateProof(bytes32, bytes calldata) external returns (bool);
}