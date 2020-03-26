const dotenv = require('dotenv');
const HDWalletProvider = require('@truffle/hdwallet-provider');

dotenv.config();
const infuraKey = process.env.INFURA_API_KEY;
const privateKey = process.env.PRIVATE_KEY;


module.exports = {
    networks: {
        development: {
            host: '127.0.0.1', // Localhost (default: none)
            port: 8545, // Standard Ethereum port (default: none)
            network_id: '*', // Any network (default: none)
        },
    },

    mocha: {
        timeout: 100000,
    },

    compilers: {
        solc: {
            version: '0.6.1',
            settings: {
                optimizer: {
                    enabled: false,
                    runs: 200,
                },
                evmVersion: 'istanbul',
            },
        },
    },
};
