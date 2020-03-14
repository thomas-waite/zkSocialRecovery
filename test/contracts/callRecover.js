/* global contract, expect, it, artifacts */
const fs = require('fs');

const ZkWallet = artifacts.require('./ZkWallet');
const { randomHex } = require('web3-utils');

const address = '0xA6B70542D800e492B5e54F9E1585e66C5bE19559';

contract('Call zkRecover()', async () => {
    it('call recover', async () => {
        const zkWallet = await ZkWallet.deployed(address);
        expect(zkWallet.address).to.not.equal(undefined);

        const rawProof = fs.readFileSync('./contracts/zk/guardian/proof.json');
        const proofObject = JSON.parse(rawProof);
        const { proof: { a, b, c }, inputs } = proofObject;

        const recoveryAddress = randomHex(20);
        console.log({ recoveryAddress });
        const { receipt } = await zkWallet.zkRecover(recoveryAddress, a, b, c, inputs);
        console.log({ receipt });
        expect(receipt.status).to.equal(true);
    });
});
