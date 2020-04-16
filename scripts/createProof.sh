# Exit script as soon as a command fails.
set -o errexit

cd ./contracts/zk

# Run various zokrates scripts
zokrates compile -i guardian.zok 

# First 4 are private, last 2 are public
# First 4 are being hashed, last 2 are the result of that
zokrates compute-witness -a 0 0 2970261930 191920694071720833617132394921524560621 260011557418826107641577847731776857786 257527954319206040213098155536707508383 

zokrates setup

zokrates export-verifier

zokrates generate-proof

