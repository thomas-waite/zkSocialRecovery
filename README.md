<p align="center"><img src="https://github.com/thomas-waite/zkSocialRecovery/blob/master/zkSocialRecovery.png?raw=true" width="280px"/></p>

__Warning: This is a hackathon project, do not use for anything serious and only for fun. It should definitely not be deployed to mainnet and is likely very possible to lose funds. Use at own risk.__

# zKSocialRecovery
This project is a proof of concept of `zkSocialRecovery` - the act of a `guardian` restoring a  user's access to their smart contract wallet, without the Ethereum address of the `guardian` being revealed. We use zero-knowledge technology in the form of zk-SNARKs. 

## To get started
### Prerequisites
Make sure you have installed:
1. `solUI` globally: https://solui.dev/docs/getting-started
2. `Zokrates` and it's various dependencies installed: https://zokrates.github.io/gettingstarted.html 

## Then..
1) Start ganache in the background, `ganache-cli`
2) Clone the repo: `git clone https://github.com/thomas-waite/zkSocialRecovery.git`
3) cd into the directory, `cd zkSocialRecovery`
4) Run `yarn install`
5) Run `yarn createProof` to setup the snark and create a proof (this will take ~20secs before returning a result)
6) Run `yarn start` to launch the UI on `localhost:3001`

## Background
### What is social recovery
Social recovery is a smart contract wallet technique whereby a user is able to grant trusted persons the ability to restore the user access to their account. This is useful in case the user accidentally gets locked out of their account - access can simply be restored and the user is able to again access their account. 

To do this, a smart contract wallet user will first nominate another Ethereum address to be their guardian. This is done by calling a method on the user's smart contract wallet, `Wallet.addGuardian()`, and passing the Ethereum address of the guardian. This address is then placed into storage on-chain.

If the user later loses access to their account, they will ask the guardian to restore their access. The guardian will produce a signature indicating their approval, and `Wallet.recover()` will be called. Under the hood, this transfers ownership of the smart contract wallet to a new address held by the user. 

### This project
The previous approach places the Ethereum address of the `guardian` in plain text on-chain. We seek to instead keep the `guardian` address private, whilst still allowing social recovery functionality. 

To do this, when a user is adding a `guardian`, using `ZkWallet.addGuardian()`, they instead pass the hash of the `guardian` address and it is that is stored on-chain. 

Then when the guardian later comes to restoring user access to their locked wallet, the guardian will generate a zk proof locally to prove that they know the preimage (the input address) to the `guardian` hash that is stored on chain. This proof is then passed to `ZkWallet.zkRecover()`, instead of passing a signature as in standard social recovery. 

The proof is validated on chain by a proof validator contract, and if successful the usual recovery process occurs - giving the user access to their account again. 

We have implemented a basic proof of concept smart contract wallet to demonstrate this functionality and make use of a `groth16` zkSNARK via the `Zokrates` tooling. 

## Limitations
This is a proof of concept, there are limitations to the project:
- Works for one Guardian address
- Proof data has to be manually inputted by user into the relevant part of the UI
- Other privacy related limitations - currently `zkRecover` is called by the candidate guardian rather than a relayer


## EthLondon
This project was one of the winning hacks at EthLondon 2020, check out the Devpost!: https://devpost.com/software/zksocialrecovery



