const Validator = artifacts.require("Validator");

module.exports = function(deployer) {
  deployer.deploy(Validator);
};