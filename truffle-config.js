const dotenv = require('dotenv');

dotenv.config();

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
