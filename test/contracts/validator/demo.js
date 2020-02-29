/* global artifacts, contract, beforeEach, it */

const { expect } = require('chai');
const fs = require('fs');

const Validator = artifacts.require('./zk/demo/verifier');

contract('zk proof validator', async () => {
    let demoProofObject;
    let validator;

    beforeEach(async () => {
        validator = await Validator.new();
        const rawProof = fs.readFileSync('./contracts/zk/demo/proof.json');
        demoProofObject = JSON.parse(rawProof);
    });

    it('should deploy validator', async () => {
        const validatorAddress = validator.address;
        expect(validatorAddress).to.not.equal(undefined);
    });

    it('should validate a valid zk proof', async () => {
        const { proof, inputs } = demoProofObject;
        const { receipt } = await validator.verifyTx(proof.a, proof.b, proof.c, inputs);
        console.log({ receipt });
        expect(receipt.status).to.equal(true);
    });
});
