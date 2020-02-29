/* global artifacts, contract, beforeEach, it */

const { expect } = require('chai');
const zokrates = require('zokrates-js');

const Validator = artifacts.require('./verifier');

contract('zk proof validator', async () => {
    let validator;
    beforeEach(async () => {
        validator = await Validator.new();
    });

    it('should deploy validator', async () => {
        const validatorAddress = validator.address;
        expect(validatorAddress).to.not.equal(undefined);
    });

    it('should validate a zk proof', async () => {

    });
});