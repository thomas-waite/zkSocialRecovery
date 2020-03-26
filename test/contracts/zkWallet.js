/* global contract, describe, beforeEach, artifacts, expect, it */
const dotenv = require('dotenv');
const fs = require('fs');
const { randomHex } = require('web3-utils');

const { encodeProof } = require('../helpers/encodeProof');

dotenv.config();
const ZkWallet = artifacts.require('./ZkWallet');

contract('zkWallet', async (accounts) => {
    let zkWallet;

    const owner = accounts[0];
    const transferable = true;

    let proofObject;
    let firstHash;
    let secondHash;

    beforeEach(async () => {
        zkWallet = await ZkWallet.new(owner, transferable);

        const rawProof = fs.readFileSync('./contracts/zk/proof.json');
        proofObject = JSON.parse(rawProof);

        ({
            inputs: [firstHash, secondHash],
        } = proofObject);
    });

    describe('Initialisation', async () => {
        it('should set wallet owner', async () => {
            const recoveredOwner = await zkWallet.owner();
            expect(recoveredOwner).to.equal(owner);
        });

        it('should set proof validator', async () => {
            const recoveredValidatorAddress = await zkWallet.validatorContract();
            expect(recoveredValidatorAddress).to.not.equal('0x0');
        });
    });

    describe('ZkRecover functionality', async () => {
        it('should add a guardian', async () => {
            const { receipt } = await zkWallet.addGuardian(firstHash, secondHash);
            expect(receipt.status).to.equal(true);
        });

        it('should perform a zkRecover', async () => {
            await zkWallet.addGuardian(firstHash, secondHash);

            const proof = encodeProof(proofObject);
            console.log({ proof });

            const recoveryAddress = randomHex(20);
            const { receipt } = await zkWallet.zkRecover(recoveryAddress, proof);
            expect(receipt.status).to.equal(true);
        });
    });
});
