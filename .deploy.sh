## MAINNET
forge create src/MvxFactory.sol:MvxFactory  --rpc-url https://mainnet.infura.io/v3/0f16b26af1dc41ceb5ebf74a86e1d5b3 --private-key 1c13abfc7d3931295cf76076c859f12d910f50798d719c4cd713ee85e4c19615 --constructor-args $(cast abi-encode "constructor(uint256)" 0)
forge verify-contract 0x34C08426FFF16BbD9E8E8811daF42De66C482955 MvxFactory --watch --chain-id 1 --constructor-args $(cast abi-encode "constructor(uint256)" 0)

forge create src/MvxCollection.sol:MvxCollection  --rpc-url https://rpc.ankr.com/eth --private-key 1c13abfc7d3931295cf76076c859f12d910f50798d719c4cd713ee85e4c19615 --gas-limit 30000000
forge verify-contract 0x2451BC046B353c941847208b387F32237D51eBfc MvxCollection --watch --chain-id 5

 ## GOERLI
forge create src/MvxFactory.sol:MvxFactory  --rpc-url https://goerli.infura.io/v3/0f16b26af1dc41ceb5ebf74a86e1d5b3 --private-key 7a3b2dc7d031efa7d9e7c5a069c5941f0488e2c7b44c188763be7300e0a907ec --constructor-args $(cast abi-encode "constructor(uint256)" 0)
forge verify-contract 0x335870163d9Bc397ADA314885478E13F1213BeC3 MvxFactory --watch --chain-id 5 --constructor-args $(cast abi-encode "constructor(uint256)" 0)

forge create src/MvxCollection.sol:MvxCollection  --rpc-url https://rpc.ankr.com/eth_goerli --private-key 7a3b2dc7d031efa7d9e7c5a069c5941f0488e2c7b44c188763be7300e0a907ec
forge verify-contract 0x2451BC046B353c941847208b387F32237D51eBfc MvxCollection --watch --chain-id 5
# remixd -s . --remix-ide https://remix.ethereum.org  
 