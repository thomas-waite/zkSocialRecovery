/* global artifacts, contract, beforeEach, it */

const dotenv = require('dotenv');

dotenv.config();
const { expect } = require('chai');
const fs = require('fs');
const truffleAssert = require('truffle-assertions');
const { randomHex } = require('web3-utils');

const Validator = artifacts.require('./zk/Verifier');

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

    it('should reject fake inputs in proof', async () => {
        const { proof } = proofObject;
        const fakeInputs = [randomHex(32), randomHex(32), randomHex(32)];
        await truffleAssert.reverts(validator.verifyTx(proof.a, proof.b, proof.c, fakeInputs));
    });
});
