/* global artifacts, contract, beforeEach, it */

const dotenv = require('dotenv');

dotenv.config();
const { expect } = require('chai');
const fs = require('fs');

const Validator = artifacts.require('./zk/verifier');

contract('Validator', async () => {
    let proofObject;
    let validator;

    beforeEach(async () => {
        validator = await Validator.new();
        const rawProof = fs.readFileSync('./contracts/zk/proof.json');
        proofObject = JSON.parse(rawProof);
    });

    it('should validate proof', async () => {
        const { proof, inputs } = proofObject;
        const { receipt } = await validator.verifyTx(proof.a, proof.b, proof.c, inputs);
        expect(receipt.status).to.equal(true);
    });
});
