const Validator = artifacts.require('./zk/verifier');

contract('zk proof validator', async () => {
    let validator;
    beforeEach(async () => {
        validator = await Validator.new();
        console.log({ validator})
    });

    it('should deploy validator', async () => {
        const validatorAddress = validator.address;
        console.log({ validatorAddress });
        expect(validatorAddress).to.not.equal(undefined);
    });

    it('should validate a zk proof', async () => {

    });
});