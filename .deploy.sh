## MAINNET
forge create src/MvxFactory.sol:MvxFactory  --rpc-url https://mainnet.infura.io/v3/0f16b26af1dc41ceb5ebf74a86e1d5b3 --private-key  --constructor-args $(cast abi-encode "constructor(uint256)" 300000000000000000)
forge verify-contract 0x6A213cDDb2f5eD08ef3D27c66E7f6493970e9426 MvxFactory --watch --chain-id 1 --constructor-args $(cast abi-encode "constructor(uint256)" 0)

forge create src/MvxFactory.sol:MvxFactory --rpc-url  https://goerli.infura.io/v3/41da61585a3c420cb9067f9e5edb5d0c --private-key  7a3b2dc7d031efa7d9e7c5a069c5941f0488e2c7b44c188763be7300e0a907ec --gas-limit 30000000

forge create src/MvxCollection.sol:MvxCollection  --rpc-url  https://goerli.infura.io/v3/41da61585a3c420cb9067f9e5edb5d0c --private-key  7a3b2dc7d031efa7d9e7c5a069c5941f0488e2c7b44c188763be7300e0a907ec --gas-limit 30000000
forge verify-contract 0x2451BC046B353c941847208b387F32237D51eBfc MvxCollection --watch --chain-id 5

 ## GOERLI
forge create src/MvxFactory.sol:MvxFactory  --rpc-url https://goerli.infura.io/v3/0f16b26af1dc41ceb5ebf74a86e1d5b3 --private-key 7a3b2dc7d031efa7d9e7c5a069c5941f0488e2c7b44c188763be7300e0a907ec
forge verify-contract 0x2c48d408f25B8100adEfeb9E8323C309F62e50Fd MvxFactory --watch --chain-id 5 --constructor-args $(cast abi-encode "constructor(uint256)" 0)

forge create src/MvxCollection.sol:MvxCollection  --rpc-url https://rpc.ankr.com/eth_goerli --private-key 7a3b2dc7d031efa7d9e7c5a069c5941f0488e2c7b44c188763be7300e0a907ec
forge verify-contract 0x5ff2B4d7fE3Bac7e7aC20E3a05a85D291c04970E MvxCollection --watch --chain-id 5
# remixd -s . --remix-ide https://remix.ethereum.org  
 
 ## MAINNET create collection

 # static with call
 # tx with send
 cast call 0x34C08426FFF16BbD9E8E8811daF42De66C482955 \
 --rpc-url https://mainnet.infura.io/v3/0f16b26af1dc41ceb5ebf74a86e1d5b3 \
 --private-key 1c13abfc7d3931295cf76076c859f12d910f50798d719c4cd713ee85e4c19615 \
 "members(address)" "0x6321b689c44960f6fde45993da55d87ea9fd1a8f"


 ## GOERLI create collection
 cast send 0x335870163d9Bc397ADA314885478E13F1213BeC3 \ 
 --rpc-url "https://rpc.ankr.com/eth_goerli" \
 --private-key "7a3b2dc7d031efa7d9e7c5a069c5941f0488e2c7b44c188763be7300e0a907ec" \
 "updateMember(address,uint256)" "(0x37aa961D37F3513ae760ea7B704dAe3415f67B2F,1698015624)"


 
 ➜ bytes memory data = abi.encodeWithSelector(bytes4(keccak256("updateMember(address,uint256)")),0x6321b689c44960f6fde45993da55d87ea9fd1a8f,1698015624);



 forge verify-contract 0x2c48d408f25B8100adEfeb9E8323C309F62e50Fd \
  src/MvxFactory.sol:MvxFactory \
  --chain-id 5 \
  --verifier sourcify