/* global artifacts, contract, beforeEach, it */

const { expect } = require('chai');
const fs = require('fs');

const Validator = artifacts.require('./zk/guardian/verifier');

contract('zk proof validator', async () => {
    let proofObject;
    let validator;

    const guardianAddress = process.env.GUARDIAN;
    console.log({ guardianAddress });

    beforeEach(async () => {
        validator = await Validator.new();
        const rawProof = fs.readFileSync('./contracts/zk/demo/proof.json');
        proofObject = JSON.parse(rawProof);
    });

    it('should validate proof that address maps to stored address', async () => {
        const { proof, inputs } = proofObject;
        console.log({ proof, inputs });
        const { receipt } = await validator.verifyTx(proof.a, proof.b, proof.c, inputs);
        console.log({ receipt });
        expect(receipt.status).to.equal(true);
    });
});
