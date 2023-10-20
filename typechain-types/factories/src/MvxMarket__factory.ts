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
import type { NonPayableOverrides } from "../../common";
import type { MvxMarket, MvxMarketInterface } from "../../src/MvxMarket";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint8",
        name: "_rule",
        type: "uint8",
      },
    ],
    name: "BuyItemError",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint8",
        name: "_rule",
        type: "uint8",
      },
    ],
    name: "ListItemError",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "itemId",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "collection",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "tokenId",
            type: "uint256",
          },
          {
            internalType: "address payable",
            name: "seller",
            type: "address",
          },
          {
            internalType: "address payable",
            name: "owner",
            type: "address",
          },
          {
            internalType: "address",
            name: "quoteAsset",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "price",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "listingTime",
            type: "uint256",
          },
        ],
        indexed: false,
        internalType: "struct MvxMarket.MarketItem",
        name: "_marketItem",
        type: "tuple",
      },
    ],
    name: "BuyItem",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint8",
        name: "version",
        type: "uint8",
      },
    ],
    name: "Initialized",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "itemId",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "collection",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "tokenId",
            type: "uint256",
          },
          {
            internalType: "address payable",
            name: "seller",
            type: "address",
          },
          {
            internalType: "address payable",
            name: "owner",
            type: "address",
          },
          {
            internalType: "address",
            name: "quoteAsset",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "price",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "listingTime",
            type: "uint256",
          },
        ],
        indexed: false,
        internalType: "struct MvxMarket.MarketItem",
        name: "_marketItem",
        type: "tuple",
      },
    ],
    name: "ListItem",
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
    inputs: [],
    name: "_itemIds",
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
    name: "_itemsSold",
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
    name: "_listingPrice",
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
        name: "_itemId",
        type: "uint256",
      },
    ],
    name: "buyItem",
    outputs: [],
    stateMutability: "payable",
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
    name: "idToMarketItem",
    outputs: [
      {
        internalType: "uint256",
        name: "itemId",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "collection",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        internalType: "address payable",
        name: "seller",
        type: "address",
      },
      {
        internalType: "address payable",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "quoteAsset",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "price",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "listingTime",
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
        name: "_initListingPrice",
        type: "uint256",
      },
    ],
    name: "initialize",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "itemId",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "collection",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "tokenId",
            type: "uint256",
          },
          {
            internalType: "address payable",
            name: "seller",
            type: "address",
          },
          {
            internalType: "address payable",
            name: "owner",
            type: "address",
          },
          {
            internalType: "address",
            name: "quoteAsset",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "price",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "listingTime",
            type: "uint256",
          },
        ],
        internalType: "struct MvxMarket.MarketItem",
        name: "marketItem",
        type: "tuple",
      },
    ],
    name: "listItem",
    outputs: [],
    stateMutability: "payable",
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
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
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
    inputs: [
      {
        internalType: "uint256",
        name: "minListingPrice_",
        type: "uint256",
      },
    ],
    name: "updateListingPrice",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405261012c609b5534801561001657600080fd5b506113d9806100266000396000f3fe6080604052600436106100c75760003560e01c8063ae677aa311610074578063e7fb74c71161004e578063e7fb74c7146102c4578063f2fde38b146102d7578063fe4b84df146102f757600080fd5b8063ae677aa3146101be578063b0545789146101de578063e61a70c0146101f157600080fd5b8063715018a6116100a5578063715018a61461015c57806387506a0d146101735780638da5cb5b1461018957600080fd5b8063150b7a02146100cc57806334a7f193146101225780636462a44a14610146575b600080fd5b3480156100d857600080fd5b506100ec6100e736600461102e565b610317565b6040517fffffffff0000000000000000000000000000000000000000000000000000000090911681526020015b60405180910390f35b34801561012e57600080fd5b5061013860975481565b604051908152602001610119565b34801561015257600080fd5b5061013860995481565b34801561016857600080fd5b506101716104d3565b005b34801561017f57600080fd5b5061013860985481565b34801561019557600080fd5b5060335460405173ffffffffffffffffffffffffffffffffffffffff9091168152602001610119565b3480156101ca57600080fd5b506101716101d93660046110cd565b6104e7565b6101716101ec3660046110e6565b6104f4565b3480156101fd57600080fd5b5061026c61020c3660046110cd565b609a6020526000908152604090208054600182015460028301546003840154600485015460058601546006870154600790970154959673ffffffffffffffffffffffffffffffffffffffff95861696949593841694928416939091169188565b6040805198895273ffffffffffffffffffffffffffffffffffffffff97881660208a01528801959095529285166060870152908416608086015290921660a084015260c083019190915260e082015261010001610119565b6101716102d23660046110cd565b610691565b3480156102e357600080fd5b506101716102f23660046110ff565b610b07565b34801561030357600080fd5b506101716103123660046110cd565b610bbb565b60978054600101905560008061032f83850185611123565b6097548082524260e083019081526000918252609a6020908152604092839020845181559084015160018201805473ffffffffffffffffffffffffffffffffffffffff9283167fffffffffffffffffffffffff0000000000000000000000000000000000000000918216179091558486015160028401556060860151600384018054918416918316919091179055608086015160048401805491841691831691909117905560a086015160058401805491909316911617905560c084015160068201559051600790910155519091507f494850cee43dfa7ff115c7c6e9fe9cd9d53f6663cad83b5f3147402a52627ab39061049f90839060006101008201905082518252602083015173ffffffffffffffffffffffffffffffffffffffff8082166020850152604085015160408501528060608601511660608501528060808601511660808501528060a08601511660a0850152505060c083015160c083015260e083015160e083015292915050565b60405180910390a1507f150b7a02000000000000000000000000000000000000000000000000000000009695505050505050565b6104db610d57565b6104e56000610dd8565b565b6104ef610d57565b609955565b6104fc610e4f565b346099541015610540576040517fcdff6792000000000000000000000000000000000000000000000000000000008152600160048201526024015b60405180910390fd5b600061055260408301602084016110ff565b905073ffffffffffffffffffffffffffffffffffffffff81166105a4576040517fcdff679200000000000000000000000000000000000000000000000000000000815260026004820152602401610537565b60008260c00135116105e5576040517fcdff679200000000000000000000000000000000000000000000000000000000815260036004820152602401610537565b81356000036106835773ffffffffffffffffffffffffffffffffffffffff811663b88d4fde333085604001358660405160200161062291906111f6565b6040516020818303038152906040526040518563ffffffff1660e01b815260040161065094939291906112a4565b600060405180830381600087803b15801561066a57600080fd5b505af115801561067e573d6000803e3d6000fd5b505050505b5061068e6001606555565b50565b610699610e4f565b6000818152609a6020908152604080832081516101008101835281548152600182015473ffffffffffffffffffffffffffffffffffffffff90811694820194909452600282015492810192909252600381015483166060830152600481015483166080830152600581015490921660a08201819052600683015460c0830181905260079093015460e0830152609b5491939092909161073791611341565b905073ffffffffffffffffffffffffffffffffffffffff82166108b85780341015610791576040517fce7b046000000000000000000000000000000000000000000000000000000000815260016004820152602401610537565b602083015173ffffffffffffffffffffffffffffffffffffffff166323b872dd303360408088015190517fffffffff0000000000000000000000000000000000000000000000000000000060e086901b16815273ffffffffffffffffffffffffffffffffffffffff93841660048201529290911660248301526044820152606401600060405180830381600087803b15801561082c57600080fd5b505af1158015610840573d6000803e3d6000fd5b5050506000858152609a602052604081208181556001810180547fffffffffffffffffffffffff00000000000000000000000000000000000000009081169091556002820183905560038201805482169055600482018054821690556005820180549091169055600681018290556007015550610afa565b73ffffffffffffffffffffffffffffffffffffffff82166323b872dd336040517fffffffff0000000000000000000000000000000000000000000000000000000060e084901b16815273ffffffffffffffffffffffffffffffffffffffff9091166004820152306024820152604481018490526064016020604051808303816000875af115801561094d573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906109719190611381565b6109d7576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152600a60248201527f6275794974656d3a3a31000000000000000000000000000000000000000000006044820152606401610537565b602083015173ffffffffffffffffffffffffffffffffffffffff166323b872dd303360408088015190517fffffffff0000000000000000000000000000000000000000000000000000000060e086901b16815273ffffffffffffffffffffffffffffffffffffffff93841660048201529290911660248301526044820152606401600060405180830381600087803b158015610a7257600080fd5b505af1158015610a86573d6000803e3d6000fd5b5050506000858152609a602052604081208181556001810180547fffffffffffffffffffffffff000000000000000000000000000000000000000090811690915560028201839055600382018054821690556004820180548216905560058201805490911690556006810182905560070155505b50505061068e6001606555565b610b0f610d57565b73ffffffffffffffffffffffffffffffffffffffff8116610bb2576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201527f64647265737300000000000000000000000000000000000000000000000000006064820152608401610537565b61068e81610dd8565b600054610100900460ff1615808015610bdb5750600054600160ff909116105b80610bf55750303b158015610bf5575060005460ff166001145b610c81576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602e60248201527f496e697469616c697a61626c653a20636f6e747261637420697320616c72656160448201527f647920696e697469616c697a65640000000000000000000000000000000000006064820152608401610537565b600080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001660011790558015610cdf57600080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff166101001790555b610ce7610ec2565b610cf0826104e7565b8015610d5357600080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff169055604051600181527f7f26b83ff96e1f2b6a682f133852f6798a09c465da95921460cefb38474024989060200160405180910390a15b5050565b60335473ffffffffffffffffffffffffffffffffffffffff1633146104e5576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820181905260248201527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e65726044820152606401610537565b6033805473ffffffffffffffffffffffffffffffffffffffff8381167fffffffffffffffffffffffff0000000000000000000000000000000000000000831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b600260655403610ebb576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601f60248201527f5265656e7472616e637947756172643a207265656e7472616e742063616c6c006044820152606401610537565b6002606555565b600054610100900460ff16610f59576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201527f6e697469616c697a696e670000000000000000000000000000000000000000006064820152608401610537565b6104e5600054610100900460ff16610ff3576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201527f6e697469616c697a696e670000000000000000000000000000000000000000006064820152608401610537565b6104e533610dd8565b73ffffffffffffffffffffffffffffffffffffffff8116811461068e57600080fd5b803561102981610ffc565b919050565b60008060008060006080868803121561104657600080fd5b853561105181610ffc565b9450602086013561106181610ffc565b935060408601359250606086013567ffffffffffffffff8082111561108557600080fd5b818801915088601f83011261109957600080fd5b8135818111156110a857600080fd5b8960208285010111156110ba57600080fd5b9699959850939650602001949392505050565b6000602082840312156110df57600080fd5b5035919050565b600061010082840312156110f957600080fd5b50919050565b60006020828403121561111157600080fd5b813561111c81610ffc565b9392505050565b600061010080838503121561113757600080fd5b6040519081019067ffffffffffffffff82118183101715611181577f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b81604052833581526111956020850161101e565b6020820152604084013560408201526111b06060850161101e565b60608201526111c16080850161101e565b60808201526111d260a0850161101e565b60a082015260c084013560c082015260e084013560e0820152809250505092915050565b813581526101008101602083013561120d81610ffc565b73ffffffffffffffffffffffffffffffffffffffff8082166020850152604085013560408501526060850135915061124482610ffc565b908116606084015260808401359061125b82610ffc565b16608083015261126d60a0840161101e565b73ffffffffffffffffffffffffffffffffffffffff811660a08401525060c083013560c083015260e083013560e083015292915050565b600073ffffffffffffffffffffffffffffffffffffffff8087168352602081871681850152856040850152608060608501528451915081608085015260005b828110156112ff5785810182015185820160a0015281016112e3565b5050600060a0828501015260a07fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0601f83011684010191505095945050505050565b8082018082111561137b577f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b92915050565b60006020828403121561139357600080fd5b8151801515811461111c57600080fdfea2646970667358221220642784d396f0cdb49272365415353d8736674a75eb9cafb1af3fd3a6ade82f5264736f6c63430008140033";

type MvxMarketConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: MvxMarketConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class MvxMarket__factory extends ContractFactory {
  constructor(...args: MvxMarketConstructorParams) {
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
      MvxMarket & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): MvxMarket__factory {
    return super.connect(runner) as MvxMarket__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): MvxMarketInterface {
    return new Interface(_abi) as MvxMarketInterface;
  }
  static connect(address: string, runner?: ContractRunner | null): MvxMarket {
    return new Contract(address, _abi, runner) as unknown as MvxMarket;
  }
}
