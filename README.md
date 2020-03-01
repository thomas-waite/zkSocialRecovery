# zKSocialRecovery
This repo aims to build a proof of concept, showing that is is possible to make the `guardian`s of smart contract wallets private. We have implemented a basic smart contract wallet with built in zero-knowledge tech. 

Specifically, we store the `guardian` address as a hash on-chain. When a candidate `guardian` wishes to restore wallet access for a user, they must submit a zk proof - created from a `groth16` zkSNARK via the `Zokrates` tooling. This is then validated on chain. 

To get started:
1) Clone the repo: `git clone https://github.com/thomas-waite/zkSocialRecovery.git`
2) cd into the directory, `cd zkSocialRecovery`
3) Start ganache in the background, `ganache-cli`
4) Run `yarn install`
5) Make sure you `Zokrates` and it's various dependencies installed: https://zokrates.github.io/gettingstarted.html 
6) Run `yarn createProof` to setup the snark and create a proof
7) Run `yarn start` to launch the UI on `localhost:3001`

