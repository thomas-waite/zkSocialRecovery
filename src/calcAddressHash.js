const dotenv = require('dotenv');

dotenv.config();
const { sha3, toBN } = require('web3-utils');

function calcAddressHash() {
    const guardianAddress = process.env.GUARDIAN;
    const hashedAddress = (sha3(guardianAddress)).slice(2);

    const firstHalfDigest = toBN(hashedAddress.slice(0, 32)).toString();
    const secondHalfDigest = toBN(hashedAddress.slice(32, 64)).toString();

    console.log({ firstHalfDigest, secondHalfDigest });
}

calcAddressHash();
