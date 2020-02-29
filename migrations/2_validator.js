/* global artifacts */
const Validator = artifacts.require('./verifier');

module.exports = function (deployer) {
    deployer.deploy(Validator);
};
