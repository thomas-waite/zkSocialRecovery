/* global artifacts */
const ZkWallet = artifacts.require('./ZkWallet');
const { randomHex } = require('web3-utils');

// config
const proofValidatorAddress = randomHex(20);
const transferable = true;

module.exports = function (deployer, network, accounts) {
    deployer.deploy(ZkWallet, accounts[0], transferable).then(async (wallet) => {
        await wallet.setProofValidator(proofValidatorAddress);
    });
};
