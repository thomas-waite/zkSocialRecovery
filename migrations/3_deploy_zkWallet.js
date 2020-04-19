/* global artifacts */
const ZkWallet = artifacts.require('./ZkWallet');

module.exports = function (deployer, network, accounts) {
    deployer.deploy(ZkWallet, accounts[0]);
};
