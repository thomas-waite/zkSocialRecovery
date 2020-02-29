const dotenv = require('dotenv');

dotenv.config();
const { toBN } = require('web3-utils');

const guardianAddress = process.env.GUARDIAN;
console.log({ guardianAddress });

function calcProofInput() {
    const noZeroHexAddress = (guardianAddress.slice(2));
    const firstHalfInput = (toBN(noZeroHexAddress.slice(0, 8))).toString();
    const secondHalfInput = (toBN(noZeroHexAddress.slice(8, 40))).toString();
    console.log({ firstHalfInput, secondHalfInput });
}


calcProofInput();
