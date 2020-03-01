/* global artifacts, contract, beforeEach, it */

const dotenv = require('dotenv');

dotenv.config();
const { expect } = require('chai');
const fs = require('fs');

const Validator = artifacts.require('./zk/guardian/verifier');

contract.only('zk proof validator', async () => {
    let proofObject;
    let validator;

    const guardianAddress = process.env.GUARDIAN;

    beforeEach(async () => {
        validator = await Validator.new();
        const rawProof = fs.readFileSync('./contracts/zk/guardian/proof.json');
        proofObject = JSON.parse(rawProof);
    });

    it('should validate proof', async () => {
        const { proof, inputs } = proofObject;
        inputs[0] = 2;
        proof.a[0] = '0x2ad632030a7c4ef17e2ff58d33927670f271b8c1bd0c2d32d446d06194fafd79';

        const { receipt } = await validator.verifyTx(proof.a, proof.b, proof.c, inputs);
        expect(receipt.status).to.equal(true);
    });
});
