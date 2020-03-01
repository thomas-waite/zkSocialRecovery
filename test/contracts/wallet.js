/* global contract, describe, beforeEach, artifacts, expect, it */
const dotenv = require('dotenv');
const fs = require('fs');
const { randomHex } = require('web3-utils');

dotenv.config();
const ZkWallet = artifacts.require('./ZkWallet');
const Validator = artifacts.require('./zk/guardian/verifier');

contract('zkWallet', async (accounts) => {
    let zkWallet;
    let validator;
    let proofObject;

    const owner = accounts[0];
    const transferable = true;
    const threshold = 1;

    let firstHash;
    let secondHash;

    beforeEach(async () => {
        zkWallet = await ZkWallet.new(owner, transferable, threshold);
        validator = await Validator.new();

        await zkWallet.setProofValidator(validator.address);

        const rawProof = fs.readFileSync('./contracts/zk/guardian/proof.json');
        proofObject = JSON.parse(rawProof);

        const { inputs } = proofObject;
        [firstHash, secondHash] = inputs;
    });

    describe('Initialisation', async () => {
        it('should set wallet owner', async () => {
            const recoveredOwner = await zkWallet.owner();
            expect(recoveredOwner).to.equal(owner);
        });

        it('should set proof validator', async () => {
            const recoveredValidatorAddress = await zkWallet.validatorContract();
            expect(recoveredValidatorAddress).to.equal(validator.address);
        });
    });

    describe('ZkRecover functionality', async () => {
        it('should add a guardian', async () => {
            const { receipt } = await zkWallet.addGuardian(firstHash, secondHash);
            expect(receipt.status).to.equal(true);
        });

        it.only('should perform a zkRecover', async () => {
            await zkWallet.addGuardian(firstHash, secondHash);

            const {
                proof: { a, b, c },
                inputs,
            } = proofObject;

            const recoveryAddress = randomHex(20);
            const { receipt } = await zkWallet.zkRecover(recoveryAddress, a, b, c, inputs);
            expect(receipt.status).to.equal(true);
        });
    });
});
