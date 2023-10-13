/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Interface, type ContractRunner } from "ethers";
import type {
  IDutchAuction,
  IDutchAuctionInterface,
} from "../../../src/interfaces/IDutchAuction";

const _abi = [
  {
    inputs: [],
    name: "InvalidAmountInWei",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint64",
        name: "startTime",
        type: "uint64",
      },
      {
        internalType: "uint64",
        name: "endTime",
        type: "uint64",
      },
    ],
    name: "InvalidStartEndTime",
    type: "error",
  },
  {
    inputs: [],
    name: "NotEnded",
    type: "error",
  },
  {
    inputs: [],
    name: "NotRefundable",
    type: "error",
  },
  {
    inputs: [],
    name: "NotStarted",
    type: "error",
  },
  {
    inputs: [],
    name: "TransferFailed",
    type: "error",
  },
  {
    inputs: [],
    name: "UserAlreadyClaimed",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint32",
        name: "qty",
        type: "uint32",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "price",
        type: "uint256",
      },
    ],
    name: "Bid",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "refundInWei",
        type: "uint256",
      },
    ],
    name: "ClaimRefund",
    type: "event",
  },
] as const;

export class IDutchAuction__factory {
  static readonly abi = _abi;
  static createInterface(): IDutchAuctionInterface {
    return new Interface(_abi) as IDutchAuctionInterface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): IDutchAuction {
    return new Contract(address, _abi, runner) as unknown as IDutchAuction;
  }
}