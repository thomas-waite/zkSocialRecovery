/* global artifacts */
const Validator = artifacts.require('./Verifier');

module.exports = function (deployer) {
    deployer.deploy(Validator);
};
