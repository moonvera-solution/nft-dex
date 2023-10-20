/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  Contract,
  ContractFactory,
  ContractTransactionResponse,
  Interface,
} from "ethers";
import type { Signer, ContractDeployTransaction, ContractRunner } from "ethers";
import type { NonPayableOverrides } from "../../../../common";
import type {
  SwapperByMoonveratest3,
  SwapperByMoonveratest3Interface,
} from "../../../../src/dex/OrderMatcher.sol/SwapperByMoonveratest3";

const _abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "offerId",
        type: "uint256",
      },
    ],
    name: "OfferApproved",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "offerId",
        type: "uint256",
      },
    ],
    name: "OfferCancelled",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "offerId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "offerer",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "token",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "ethAmount",
        type: "uint256",
      },
    ],
    name: "OfferCreated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Paused",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
    ],
    name: "TradeCancelled",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "trader",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "token",
        type: "uint256",
      },
    ],
    name: "TradeCreated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "offerId",
        type: "uint256",
      },
    ],
    name: "TradeExecuted",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Unpaused",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "activeTrades",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "offerId",
        type: "uint256",
      },
    ],
    name: "approveOffer",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "offerId",
        type: "uint256",
      },
    ],
    name: "cancelOffer",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
    ],
    name: "cancelTrade",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "offeredToken",
        type: "uint256",
      },
      {
        internalType: "contract ERC721",
        name: "offeredTokenContract",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "ethAmount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "offerDuration",
        type: "uint256",
      },
    ],
    name: "createOffer",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "token",
        type: "uint256",
      },
      {
        internalType: "contract ERC721",
        name: "contractAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "duration",
        type: "uint256",
      },
    ],
    name: "createTrade",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tradeId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "additionalDuration",
        type: "uint256",
      },
    ],
    name: "extendTradeDuration",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "onERC721Received",
    outputs: [
      {
        internalType: "bytes4",
        name: "",
        type: "bytes4",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "pause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "paused",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "platformFeeBasisPoints",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "platformFeeFixed",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "platformFeeRecipient",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_platformFeeBasisPoints",
        type: "uint256",
      },
    ],
    name: "setPlatformFeeBasisPoints",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_platformFeeFixed",
        type: "uint256",
      },
    ],
    name: "setPlatformFeeFixed",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "totalTradesEverMade",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "tradeCounter",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "trades",
    outputs: [
      {
        internalType: "address payable",
        name: "trader",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "token",
        type: "uint256",
      },
      {
        internalType: "contract ERC721",
        name: "contractAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "tradeEndsAt",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "isCancelled",
        type: "bool",
      },
      {
        internalType: "uint256",
        name: "offersCounter",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "acceptedOfferId",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "unpause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x6080604052600060035560006004556064600555600060065534801561002457600080fd5b50600160005561003333610057565b6001805460ff60a01b19169055600280546001600160a01b031916331790556100a9565b600180546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b61297d806100b86000396000f3fe6080604052600436106101755760003560e01c8063665d31d7116100cb578063c58bfb661161007f578063eb13554f11610059578063eb13554f146104f5578063f16f373014610522578063f2fde38b1461054257600080fd5b8063c58bfb66146104a9578063d3f830f7146104bf578063d45557cc146104d557600080fd5b80638456cb59116100b05780638456cb59146104285780638da5cb5b1461043d578063c247e6861461048957600080fd5b8063665d31d7146103f3578063715018a61461041357600080fd5b8063150b7a021161012d5780634be52276116101075780634be522761461036d5780635c975abb146103ad578063660d15b5146103dd57600080fd5b8063150b7a02146102185780631e6c598e1461028e5780633f4ba83a1461035857600080fd5b806309ec6cc71161015e57806309ec6cc7146101c55780630a35a303146101e55780630f5df3391461020557600080fd5b806308b7db701461017a578063094569f2146101a3575b600080fd5b34801561018657600080fd5b5061019060045481565b6040519081526020015b60405180910390f35b3480156101af57600080fd5b506101c36101be36600461269e565b610562565b005b3480156101d157600080fd5b506101c36101e03660046126d6565b610a32565b3480156101f157600080fd5b506101c36102003660046126d6565b610cb5565b6101c36102133660046126ef565b610cc2565b34801561022457600080fd5b5061025d610233366004612738565b7f150b7a020000000000000000000000000000000000000000000000000000000095945050505050565b6040517fffffffff00000000000000000000000000000000000000000000000000000000909116815260200161019a565b34801561029a57600080fd5b506103036102a93660046126d6565b600760205260009081526040902080546001820154600283015460038401546004850154600586015460069096015473ffffffffffffffffffffffffffffffffffffffff95861696949590931693919260ff909116919087565b6040805173ffffffffffffffffffffffffffffffffffffffff98891681526020810197909752949096169385019390935260608401919091521515608083015260a082015260c081019190915260e00161019a565b34801561036457600080fd5b506101c361134b565b34801561037957600080fd5b5061039d6103883660046126d6565b60086020526000908152604090205460ff1681565b604051901515815260200161019a565b3480156103b957600080fd5b5060015474010000000000000000000000000000000000000000900460ff1661039d565b3480156103e957600080fd5b5061019060035481565b3480156103ff57600080fd5b506101c361040e3660046127d7565b61135d565b34801561041f57600080fd5b506101c36114d5565b34801561043457600080fd5b506101c36114e7565b34801561044957600080fd5b5060015473ffffffffffffffffffffffffffffffffffffffff165b60405173ffffffffffffffffffffffffffffffffffffffff909116815260200161019a565b34801561049557600080fd5b506101c36104a43660046126d6565b6114f7565b3480156104b557600080fd5b5061019060055481565b3480156104cb57600080fd5b5061019060065481565b3480156104e157600080fd5b506101c36104f03660046127d7565b611504565b34801561050157600080fd5b506002546104649073ffffffffffffffffffffffffffffffffffffffff1681565b34801561052e57600080fd5b506101c361053d3660046127d7565b611741565b34801561054e57600080fd5b506101c361055d3660046127f9565b61197b565b61056a611a2f565b610572611ab4565b6040517f6352211e00000000000000000000000000000000000000000000000000000000815260048101849052339073ffffffffffffffffffffffffffffffffffffffff841690636352211e90602401602060405180830381865afa1580156105df573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610603919061281d565b73ffffffffffffffffffffffffffffffffffffffff1614610685576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4d75737420626520746865206f776e6572206f662074686520746f6b656e000060448201526064015b60405180910390fd5b6040517fa22cb4650000000000000000000000000000000000000000000000000000000081523360048201526001602482015273ffffffffffffffffffffffffffffffffffffffff83169063a22cb46590604401600060405180830381600087803b1580156106f357600080fd5b505af1158015610707573d6000803e3d6000fd5b505060035460009081526008602052604090205460ff161591506108599050576003546000908152600760205260409020600481015460ff168061074e5750600681015415155b6107b4576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f50726576696f7573207472616465206973207374696c6c206163746976650000604482015260640161067c565b5060038054600090815260076020908152604080832080547fffffffffffffffffffffffff000000000000000000000000000000000000000090811682556001820185905560028201805490911690558085018490556004810180547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff009081169091556005820185905560069091018490559354835260089091529020805490911690555b6003805490600061086983612869565b90915550506004805490600061087e83612869565b909155505060035460009081526007602052604090208054337fffffffffffffffffffffffff00000000000000000000000000000000000000009182161782556001820185905560028201805490911673ffffffffffffffffffffffffffffffffffffffff85161790556108f282426128a1565b600382810191909155600480830180547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00908116909155600060058501819055600685018190559254835260086020526040928390208054909116600117905590517f42842e0e00000000000000000000000000000000000000000000000000000000815233918101919091523060248201526044810185905273ffffffffffffffffffffffffffffffffffffffff8416906342842e0e90606401600060405180830381600087803b1580156109c757600080fd5b505af11580156109db573d6000803e3d6000fd5b50506003546040805191825233602083015281018790527f41ac822878e5f14cc044c3129e4a9966c96e7c151cab503be2f1d6b3c3b4eac29250606001905060405180910390a150610a2d6001600055565b505050565b610a3a611a2f565b610a42611ab4565b60008181526008602052604090205460ff16610ae0576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602a60248201527f547261646520646f65736e2774206578697374206f7220686173206265656e2060448201527f636c65616e656420757000000000000000000000000000000000000000000000606482015260840161067c565b6000818152600760205260409020805473ffffffffffffffffffffffffffffffffffffffff163314610b93576040517f08c379a0000000000000000000000000000000000000000000000000000000008152602060048201526024808201527f4f6e6c7920746865207472616465722063616e2063616e63656c20746865207460448201527f7261646500000000000000000000000000000000000000000000000000000000606482015260840161067c565b6002810154815460018301546040517f42842e0e00000000000000000000000000000000000000000000000000000000815230600482015273ffffffffffffffffffffffffffffffffffffffff928316602482015260448101919091529116906342842e0e90606401600060405180830381600087803b158015610c1657600080fd5b505af1158015610c2a573d6000803e3d6000fd5b5050505060048101805460017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00918216179091556000838152600860209081526040918290208054909316909255518381527f4e02dcf02d8510f6c8a6878a3c54ae6e2bfbf552df29221d7a1eed173a6b1ae7910160405180910390a150610cb26001600055565b50565b610cbd611b27565b600655565b610cca611a2f565b610cd2611ab4565b60008581526008602052604090205460ff16610d70576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602a60248201527f547261646520646f65736e2774206578697374206f7220686173206265656e2060448201527f636c65616e656420757000000000000000000000000000000000000000000000606482015260840161067c565b6000858152600760205260409020805473ffffffffffffffffffffffffffffffffffffffff163303610e24576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602e60248201527f5472616465722063616e6e6f74206d616b6520616e206f66666572206f6e207460448201527f68656972206f776e207472616465000000000000000000000000000000000000606482015260840161067c565b600481015460ff1615610e93576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601860248201527f547261646520686173206265656e2063616e63656c6c65640000000000000000604482015260640161067c565b6040517f6352211e00000000000000000000000000000000000000000000000000000000815260048101869052339073ffffffffffffffffffffffffffffffffffffffff861690636352211e90602401602060405180830381865afa158015610f00573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610f24919061281d565b73ffffffffffffffffffffffffffffffffffffffff1614610fc7576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602660248201527f4d75737420626520746865206f776e6572206f662074686520746f6b656e206f60448201527f6666657265640000000000000000000000000000000000000000000000000000606482015260840161067c565b8060030154421115611035576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601a60248201527f5472616465206475726174696f6e206861732065787069726564000000000000604482015260640161067c565b42816003015461104591906128b4565b8211156110d4576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152603560248201527f4f66666572206475726174696f6e2063616e6e6f74206578636565642072656d60448201527f61696e696e67207472616465206475726174696f6e0000000000000000000000606482015260840161067c565b6005810180549060006110e683612869565b91905055508234111561117b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602860248201527f53656e7420457468657220646f6573206e6f74206d617463682074686520746f60448201527f74616c20636f7374000000000000000000000000000000000000000000000000606482015260840161067c565b60006040518060e001604052803373ffffffffffffffffffffffffffffffffffffffff1681526020018781526020018673ffffffffffffffffffffffffffffffffffffffff16815260200185815260200160001515815260200160001515815260200184426111ea91906128a1565b9052600583810180546000908152600786016020908152604091829020855181547fffffffffffffffffffffffff000000000000000000000000000000000000000090811673ffffffffffffffffffffffffffffffffffffffff928316178355878401516001840155878501516002840180549092169216919091179055606080870151600383015560808088015160048401805460a0808c01517fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00009092169315157fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff16939093176101009115159190910217905560c08901519390970192909255935483518e81529283015233928201929092529182018a905281018790529192507f8bdb6541b99259f92b7d7c61d0f892fdd62042bd96c57fca917a3553af72b270910160405180910390a150506113446001600055565b5050505050565b611353611b27565b61135b611ba8565b565b611365611a2f565b60008281526008602052604090205460ff16611403576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602a60248201527f547261646520646f65736e2774206578697374206f7220686173206265656e2060448201527f636c65616e656420757000000000000000000000000000000000000000000000606482015260840161067c565b6000828152600760205260409020805473ffffffffffffffffffffffffffffffffffffffff1633146114b7576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602d60248201527f4f6e6c7920746865207472616465722063616e20657874656e6420746865207460448201527f72616465206475726174696f6e00000000000000000000000000000000000000606482015260840161067c565b818160030160008282546114cb91906128a1565b9091555050505050565b6114dd611b27565b61135b6000611c25565b6114ef611b27565b61135b611c9c565b6114ff611b27565b600555565b61150c611a2f565b611514611ab4565b60008281526008602052604090205460ff166115b2576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602a60248201527f547261646520646f65736e2774206578697374206f7220686173206265656e2060448201527f636c65616e656420757000000000000000000000000000000000000000000000606482015260840161067c565b6000828152600760208181526040808420858552928301909152909120805473ffffffffffffffffffffffffffffffffffffffff163314611674576040517f08c379a0000000000000000000000000000000000000000000000000000000008152602060048201526024808201527f4f6e6c7920746865206f6666657265722063616e2063616e63656c20616e206f60448201527f6666657200000000000000000000000000000000000000000000000000000000606482015260840161067c565b6003810154156116ca578054600382015460405173ffffffffffffffffffffffffffffffffffffffff9092169181156108fc0291906000818181858888f193505050501580156116c8573d6000803e3d6000fd5b505b6004810180547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff1661010017905560408051858152602081018590527f33559c26e53c3e89ff8feeaf6cfba76e46453390b4a80b64e8672dad0a0a45fb910160405180910390a1505061173d6001600055565b5050565b611749611a2f565b611751611ab4565b60008281526008602052604090205460ff166117ef576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602a60248201527f547261646520646f65736e2774206578697374206f7220686173206265656e2060448201527f636c65616e656420757000000000000000000000000000000000000000000000606482015260840161067c565b6000828152600760208181526040808420858552928301909152909120815473ffffffffffffffffffffffffffffffffffffffff1633146118b1576040517f08c379a0000000000000000000000000000000000000000000000000000000008152602060048201526024808201527f4f6e6c7920746865207472616465722063616e20617070726f766520616e206f60448201527f6666657200000000000000000000000000000000000000000000000000000000606482015260840161067c565b6004810154610100900460ff1615611925576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601860248201527f4f6666657220686173206265656e2063616e63656c6c65640000000000000000604482015260640161067c565b6006820183905560408051858152602081018590527f96d9707f8fe04b429a2a4acee1add3fc5f45fa2cab9544430629f26f77f2933d910160405180910390a161196f8484611d0b565b505061173d6001600055565b611983611b27565b73ffffffffffffffffffffffffffffffffffffffff8116611a26576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201527f6464726573730000000000000000000000000000000000000000000000000000606482015260840161067c565b610cb281611c25565b60015474010000000000000000000000000000000000000000900460ff161561135b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601060248201527f5061757361626c653a2070617573656400000000000000000000000000000000604482015260640161067c565b600260005403611b20576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601f60248201527f5265656e7472616e637947756172643a207265656e7472616e742063616c6c00604482015260640161067c565b6002600055565b60015473ffffffffffffffffffffffffffffffffffffffff16331461135b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820181905260248201527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572604482015260640161067c565b611bb06124a0565b600180547fffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff1690557f5db9ee0a495bf2e6ff9c91a7834c1ba4fdd244a5e8aa4e537bd38aeae4b073aa335b60405173ffffffffffffffffffffffffffffffffffffffff909116815260200160405180910390a1565b6001805473ffffffffffffffffffffffffffffffffffffffff8381167fffffffffffffffffffffffff0000000000000000000000000000000000000000831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b611ca4611a2f565b600180547fffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff16740100000000000000000000000000000000000000001790557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a258611bfb3390565b611d13611ab4565b6000828152600760208181526040808420858552928301909152909120815473ffffffffffffffffffffffffffffffffffffffff163314611dd6576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602560248201527f4f6e6c7920746865207472616465722063616e2065786563757465207468652060448201527f7472616465000000000000000000000000000000000000000000000000000000606482015260840161067c565b8160030154421115611e44576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601660248201527f5472616465206475726174696f6e206578706972656400000000000000000000604482015260640161067c565b8060050154421115611eb2576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601660248201527f4f66666572206475726174696f6e206578706972656400000000000000000000604482015260640161067c565b6000826006015411611f20576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4e6f206f6666657220686173206265656e206163636570746564207965740000604482015260640161067c565b6004810154610100900460ff1615611f94576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601860248201527f4f6666657220686173206265656e2063616e63656c6c65640000000000000000604482015260640161067c565b8054600282015460018301546040517f6352211e000000000000000000000000000000000000000000000000000000008152600481019190915273ffffffffffffffffffffffffffffffffffffffff9283169290911690636352211e90602401602060405180830381865afa158015612011573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190612035919061281d565b73ffffffffffffffffffffffffffffffffffffffff16146120b2576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f4f666665726572206d757374207374696c6c206f776e20746865204e46540000604482015260640161067c565b600381015460028201548254845460018501546040517f42842e0e00000000000000000000000000000000000000000000000000000000815273ffffffffffffffffffffffffffffffffffffffff93841660048201529183166024830152604482015260009291909116906342842e0e90606401600060405180830381600087803b15801561214057600080fd5b505af1158015612154573d6000803e3d6000fd5b50505050600082111561233b576006546127106005548461217591906128c7565b61217f91906128de565b61218991906128a1565b60028501549091506000906121d49073ffffffffffffffffffffffffffffffffffffffff167f2a55205a00000000000000000000000000000000000000000000000000000000612524565b156122d957600285015460018601546040517f2a55205a000000000000000000000000000000000000000000000000000000008152600092839273ffffffffffffffffffffffffffffffffffffffff90911691632a55205a91612244918990600401918252602082015260400190565b6040805180830381865afa158015612260573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906122849190612919565b9350915082905080156122d65760405173ffffffffffffffffffffffffffffffffffffffff83169084156108fc029085906000818181858888f193505050501580156122d4573d6000803e3d6000fd5b505b50505b6000816122e684866128b4565b6122f091906128b4565b865460405191925073ffffffffffffffffffffffffffffffffffffffff169082156108fc029083906000818181858888f19350505050158015612337573d6000803e3d6000fd5b5050505b6002840154835460018601546040517f42842e0e00000000000000000000000000000000000000000000000000000000815230600482015273ffffffffffffffffffffffffffffffffffffffff928316602482015260448101919091529116906342842e0e90606401600060405180830381600087803b1580156123be57600080fd5b505af11580156123d2573d6000803e3d6000fd5b505050600087815260086020526040902080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001690555080156124595760025460405173ffffffffffffffffffffffffffffffffffffffff9091169082156108fc029083906000818181858888f19350505050158015612457573d6000803e3d6000fd5b505b60408051878152602081018790527f589de19ac049f650e30154ebb6ba9be12c5394027648b0ff506705d197ec7086910160405180910390a15050505061173d6001600055565b60015474010000000000000000000000000000000000000000900460ff1661135b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601460248201527f5061757361626c653a206e6f7420706175736564000000000000000000000000604482015260640161067c565b600061252f83612549565b8015612540575061254083836125ad565b90505b92915050565b6000612575827f01ffc9a7000000000000000000000000000000000000000000000000000000006125ad565b801561254357506125a6827fffffffff000000000000000000000000000000000000000000000000000000006125ad565b1592915050565b604080517fffffffff000000000000000000000000000000000000000000000000000000008316602480830191909152825180830390910181526044909101909152602080820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff167f01ffc9a700000000000000000000000000000000000000000000000000000000178152825160009392849283928392918391908a617530fa92503d91506000519050828015612665575060208210155b80156126715750600081115b979650505050505050565b73ffffffffffffffffffffffffffffffffffffffff81168114610cb257600080fd5b6000806000606084860312156126b357600080fd5b8335925060208401356126c58161267c565b929592945050506040919091013590565b6000602082840312156126e857600080fd5b5035919050565b600080600080600060a0868803121561270757600080fd5b853594506020860135935060408601356127208161267c565b94979396509394606081013594506080013592915050565b60008060008060006080868803121561275057600080fd5b853561275b8161267c565b9450602086013561276b8161267c565b935060408601359250606086013567ffffffffffffffff8082111561278f57600080fd5b818801915088601f8301126127a357600080fd5b8135818111156127b257600080fd5b8960208285010111156127c457600080fd5b9699959850939650602001949392505050565b600080604083850312156127ea57600080fd5b50508035926020909101359150565b60006020828403121561280b57600080fd5b81356128168161267c565b9392505050565b60006020828403121561282f57600080fd5b81516128168161267c565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff820361289a5761289a61283a565b5060010190565b808201808211156125435761254361283a565b818103818111156125435761254361283a565b80820281158282048414176125435761254361283a565b600082612914577f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b500490565b6000806040838503121561292c57600080fd5b82516129378161267c565b602093909301519294929350505056fea26469706673582212202e2fe1405504b8d2268dcdf30270bb02b76ec3d4ccd6991e52c2db41ae48590964736f6c63430008140033";

type SwapperByMoonveratest3ConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: SwapperByMoonveratest3ConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class SwapperByMoonveratest3__factory extends ContractFactory {
  constructor(...args: SwapperByMoonveratest3ConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(overrides || {});
  }
  override deploy(overrides?: NonPayableOverrides & { from?: string }) {
    return super.deploy(overrides || {}) as Promise<
      SwapperByMoonveratest3 & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(
    runner: ContractRunner | null
  ): SwapperByMoonveratest3__factory {
    return super.connect(runner) as SwapperByMoonveratest3__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): SwapperByMoonveratest3Interface {
    return new Interface(_abi) as SwapperByMoonveratest3Interface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): SwapperByMoonveratest3 {
    return new Contract(
      address,
      _abi,
      runner
    ) as unknown as SwapperByMoonveratest3;
  }
}
