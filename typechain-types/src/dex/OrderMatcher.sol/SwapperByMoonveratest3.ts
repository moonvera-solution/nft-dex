/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumberish,
  BytesLike,
  FunctionFragment,
  Result,
  Interface,
  EventFragment,
  AddressLike,
  ContractRunner,
  ContractMethod,
  Listener,
} from "ethers";
import type {
  TypedContractEvent,
  TypedDeferredTopicFilter,
  TypedEventLog,
  TypedLogDescription,
  TypedListener,
  TypedContractMethod,
} from "../../../common";

export interface SwapperByMoonveratest3Interface extends Interface {
  getFunction(
    nameOrSignature:
      | "activeTrades"
      | "approveOffer"
      | "cancelOffer"
      | "cancelTrade"
      | "createOffer"
      | "createTrade"
      | "extendTradeDuration"
      | "onERC721Received"
      | "owner"
      | "pause"
      | "paused"
      | "platformFeeBasisPoints"
      | "platformFeeFixed"
      | "platformFeeRecipient"
      | "renounceOwnership"
      | "setPlatformFeeBasisPoints"
      | "setPlatformFeeFixed"
      | "totalTradesEverMade"
      | "tradeCounter"
      | "trades"
      | "transferOwnership"
      | "unpause"
  ): FunctionFragment;

  getEvent(
    nameOrSignatureOrTopic:
      | "OfferApproved"
      | "OfferCancelled"
      | "OfferCreated"
      | "OwnershipTransferred"
      | "Paused"
      | "TradeCancelled"
      | "TradeCreated"
      | "TradeExecuted"
      | "Unpaused"
  ): EventFragment;

  encodeFunctionData(
    functionFragment: "activeTrades",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "approveOffer",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "cancelOffer",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "cancelTrade",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "createOffer",
    values: [
      BigNumberish,
      BigNumberish,
      AddressLike,
      BigNumberish,
      BigNumberish
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "createTrade",
    values: [BigNumberish, AddressLike, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "extendTradeDuration",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "onERC721Received",
    values: [AddressLike, AddressLike, BigNumberish, BytesLike]
  ): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(functionFragment: "pause", values?: undefined): string;
  encodeFunctionData(functionFragment: "paused", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "platformFeeBasisPoints",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "platformFeeFixed",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "platformFeeRecipient",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "renounceOwnership",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setPlatformFeeBasisPoints",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setPlatformFeeFixed",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "totalTradesEverMade",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "tradeCounter",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "trades",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [AddressLike]
  ): string;
  encodeFunctionData(functionFragment: "unpause", values?: undefined): string;

  decodeFunctionResult(
    functionFragment: "activeTrades",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "approveOffer",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "cancelOffer",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "cancelTrade",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "createOffer",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "createTrade",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "extendTradeDuration",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "onERC721Received",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "pause", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "paused", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "platformFeeBasisPoints",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "platformFeeFixed",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "platformFeeRecipient",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "renounceOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setPlatformFeeBasisPoints",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setPlatformFeeFixed",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "totalTradesEverMade",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "tradeCounter",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "trades", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "unpause", data: BytesLike): Result;
}

export namespace OfferApprovedEvent {
  export type InputTuple = [tradeId: BigNumberish, offerId: BigNumberish];
  export type OutputTuple = [tradeId: bigint, offerId: bigint];
  export interface OutputObject {
    tradeId: bigint;
    offerId: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace OfferCancelledEvent {
  export type InputTuple = [tradeId: BigNumberish, offerId: BigNumberish];
  export type OutputTuple = [tradeId: bigint, offerId: bigint];
  export interface OutputObject {
    tradeId: bigint;
    offerId: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace OfferCreatedEvent {
  export type InputTuple = [
    tradeId: BigNumberish,
    offerId: BigNumberish,
    offerer: AddressLike,
    token: BigNumberish,
    ethAmount: BigNumberish
  ];
  export type OutputTuple = [
    tradeId: bigint,
    offerId: bigint,
    offerer: string,
    token: bigint,
    ethAmount: bigint
  ];
  export interface OutputObject {
    tradeId: bigint;
    offerId: bigint;
    offerer: string;
    token: bigint;
    ethAmount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace OwnershipTransferredEvent {
  export type InputTuple = [previousOwner: AddressLike, newOwner: AddressLike];
  export type OutputTuple = [previousOwner: string, newOwner: string];
  export interface OutputObject {
    previousOwner: string;
    newOwner: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace PausedEvent {
  export type InputTuple = [account: AddressLike];
  export type OutputTuple = [account: string];
  export interface OutputObject {
    account: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace TradeCancelledEvent {
  export type InputTuple = [tradeId: BigNumberish];
  export type OutputTuple = [tradeId: bigint];
  export interface OutputObject {
    tradeId: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace TradeCreatedEvent {
  export type InputTuple = [
    tradeId: BigNumberish,
    trader: AddressLike,
    token: BigNumberish
  ];
  export type OutputTuple = [tradeId: bigint, trader: string, token: bigint];
  export interface OutputObject {
    tradeId: bigint;
    trader: string;
    token: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace TradeExecutedEvent {
  export type InputTuple = [tradeId: BigNumberish, offerId: BigNumberish];
  export type OutputTuple = [tradeId: bigint, offerId: bigint];
  export interface OutputObject {
    tradeId: bigint;
    offerId: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace UnpausedEvent {
  export type InputTuple = [account: AddressLike];
  export type OutputTuple = [account: string];
  export interface OutputObject {
    account: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export interface SwapperByMoonveratest3 extends BaseContract {
  connect(runner?: ContractRunner | null): SwapperByMoonveratest3;
  waitForDeployment(): Promise<this>;

  interface: SwapperByMoonveratest3Interface;

  queryFilter<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;
  queryFilter<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;

  on<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  on<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  once<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  once<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  listeners<TCEvent extends TypedContractEvent>(
    event: TCEvent
  ): Promise<Array<TypedListener<TCEvent>>>;
  listeners(eventName?: string): Promise<Array<Listener>>;
  removeAllListeners<TCEvent extends TypedContractEvent>(
    event?: TCEvent
  ): Promise<this>;

  activeTrades: TypedContractMethod<[arg0: BigNumberish], [boolean], "view">;

  approveOffer: TypedContractMethod<
    [tradeId: BigNumberish, offerId: BigNumberish],
    [void],
    "nonpayable"
  >;

  cancelOffer: TypedContractMethod<
    [tradeId: BigNumberish, offerId: BigNumberish],
    [void],
    "nonpayable"
  >;

  cancelTrade: TypedContractMethod<
    [tradeId: BigNumberish],
    [void],
    "nonpayable"
  >;

  createOffer: TypedContractMethod<
    [
      tradeId: BigNumberish,
      offeredToken: BigNumberish,
      offeredTokenContract: AddressLike,
      ethAmount: BigNumberish,
      offerDuration: BigNumberish
    ],
    [void],
    "payable"
  >;

  createTrade: TypedContractMethod<
    [token: BigNumberish, contractAddress: AddressLike, duration: BigNumberish],
    [void],
    "nonpayable"
  >;

  extendTradeDuration: TypedContractMethod<
    [tradeId: BigNumberish, additionalDuration: BigNumberish],
    [void],
    "nonpayable"
  >;

  onERC721Received: TypedContractMethod<
    [
      operator: AddressLike,
      from: AddressLike,
      tokenId: BigNumberish,
      data: BytesLike
    ],
    [string],
    "nonpayable"
  >;

  owner: TypedContractMethod<[], [string], "view">;

  pause: TypedContractMethod<[], [void], "nonpayable">;

  paused: TypedContractMethod<[], [boolean], "view">;

  platformFeeBasisPoints: TypedContractMethod<[], [bigint], "view">;

  platformFeeFixed: TypedContractMethod<[], [bigint], "view">;

  platformFeeRecipient: TypedContractMethod<[], [string], "view">;

  renounceOwnership: TypedContractMethod<[], [void], "nonpayable">;

  setPlatformFeeBasisPoints: TypedContractMethod<
    [_platformFeeBasisPoints: BigNumberish],
    [void],
    "nonpayable"
  >;

  setPlatformFeeFixed: TypedContractMethod<
    [_platformFeeFixed: BigNumberish],
    [void],
    "nonpayable"
  >;

  totalTradesEverMade: TypedContractMethod<[], [bigint], "view">;

  tradeCounter: TypedContractMethod<[], [bigint], "view">;

  trades: TypedContractMethod<
    [arg0: BigNumberish],
    [
      [string, bigint, string, bigint, boolean, bigint, bigint] & {
        trader: string;
        token: bigint;
        contractAddress: string;
        tradeEndsAt: bigint;
        isCancelled: boolean;
        offersCounter: bigint;
        acceptedOfferId: bigint;
      }
    ],
    "view"
  >;

  transferOwnership: TypedContractMethod<
    [newOwner: AddressLike],
    [void],
    "nonpayable"
  >;

  unpause: TypedContractMethod<[], [void], "nonpayable">;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "activeTrades"
  ): TypedContractMethod<[arg0: BigNumberish], [boolean], "view">;
  getFunction(
    nameOrSignature: "approveOffer"
  ): TypedContractMethod<
    [tradeId: BigNumberish, offerId: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "cancelOffer"
  ): TypedContractMethod<
    [tradeId: BigNumberish, offerId: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "cancelTrade"
  ): TypedContractMethod<[tradeId: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "createOffer"
  ): TypedContractMethod<
    [
      tradeId: BigNumberish,
      offeredToken: BigNumberish,
      offeredTokenContract: AddressLike,
      ethAmount: BigNumberish,
      offerDuration: BigNumberish
    ],
    [void],
    "payable"
  >;
  getFunction(
    nameOrSignature: "createTrade"
  ): TypedContractMethod<
    [token: BigNumberish, contractAddress: AddressLike, duration: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "extendTradeDuration"
  ): TypedContractMethod<
    [tradeId: BigNumberish, additionalDuration: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "onERC721Received"
  ): TypedContractMethod<
    [
      operator: AddressLike,
      from: AddressLike,
      tokenId: BigNumberish,
      data: BytesLike
    ],
    [string],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "owner"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "pause"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "paused"
  ): TypedContractMethod<[], [boolean], "view">;
  getFunction(
    nameOrSignature: "platformFeeBasisPoints"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "platformFeeFixed"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "platformFeeRecipient"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "renounceOwnership"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setPlatformFeeBasisPoints"
  ): TypedContractMethod<
    [_platformFeeBasisPoints: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setPlatformFeeFixed"
  ): TypedContractMethod<
    [_platformFeeFixed: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "totalTradesEverMade"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "tradeCounter"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "trades"
  ): TypedContractMethod<
    [arg0: BigNumberish],
    [
      [string, bigint, string, bigint, boolean, bigint, bigint] & {
        trader: string;
        token: bigint;
        contractAddress: string;
        tradeEndsAt: bigint;
        isCancelled: boolean;
        offersCounter: bigint;
        acceptedOfferId: bigint;
      }
    ],
    "view"
  >;
  getFunction(
    nameOrSignature: "transferOwnership"
  ): TypedContractMethod<[newOwner: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "unpause"
  ): TypedContractMethod<[], [void], "nonpayable">;

  getEvent(
    key: "OfferApproved"
  ): TypedContractEvent<
    OfferApprovedEvent.InputTuple,
    OfferApprovedEvent.OutputTuple,
    OfferApprovedEvent.OutputObject
  >;
  getEvent(
    key: "OfferCancelled"
  ): TypedContractEvent<
    OfferCancelledEvent.InputTuple,
    OfferCancelledEvent.OutputTuple,
    OfferCancelledEvent.OutputObject
  >;
  getEvent(
    key: "OfferCreated"
  ): TypedContractEvent<
    OfferCreatedEvent.InputTuple,
    OfferCreatedEvent.OutputTuple,
    OfferCreatedEvent.OutputObject
  >;
  getEvent(
    key: "OwnershipTransferred"
  ): TypedContractEvent<
    OwnershipTransferredEvent.InputTuple,
    OwnershipTransferredEvent.OutputTuple,
    OwnershipTransferredEvent.OutputObject
  >;
  getEvent(
    key: "Paused"
  ): TypedContractEvent<
    PausedEvent.InputTuple,
    PausedEvent.OutputTuple,
    PausedEvent.OutputObject
  >;
  getEvent(
    key: "TradeCancelled"
  ): TypedContractEvent<
    TradeCancelledEvent.InputTuple,
    TradeCancelledEvent.OutputTuple,
    TradeCancelledEvent.OutputObject
  >;
  getEvent(
    key: "TradeCreated"
  ): TypedContractEvent<
    TradeCreatedEvent.InputTuple,
    TradeCreatedEvent.OutputTuple,
    TradeCreatedEvent.OutputObject
  >;
  getEvent(
    key: "TradeExecuted"
  ): TypedContractEvent<
    TradeExecutedEvent.InputTuple,
    TradeExecutedEvent.OutputTuple,
    TradeExecutedEvent.OutputObject
  >;
  getEvent(
    key: "Unpaused"
  ): TypedContractEvent<
    UnpausedEvent.InputTuple,
    UnpausedEvent.OutputTuple,
    UnpausedEvent.OutputObject
  >;

  filters: {
    "OfferApproved(uint256,uint256)": TypedContractEvent<
      OfferApprovedEvent.InputTuple,
      OfferApprovedEvent.OutputTuple,
      OfferApprovedEvent.OutputObject
    >;
    OfferApproved: TypedContractEvent<
      OfferApprovedEvent.InputTuple,
      OfferApprovedEvent.OutputTuple,
      OfferApprovedEvent.OutputObject
    >;

    "OfferCancelled(uint256,uint256)": TypedContractEvent<
      OfferCancelledEvent.InputTuple,
      OfferCancelledEvent.OutputTuple,
      OfferCancelledEvent.OutputObject
    >;
    OfferCancelled: TypedContractEvent<
      OfferCancelledEvent.InputTuple,
      OfferCancelledEvent.OutputTuple,
      OfferCancelledEvent.OutputObject
    >;

    "OfferCreated(uint256,uint256,address,uint256,uint256)": TypedContractEvent<
      OfferCreatedEvent.InputTuple,
      OfferCreatedEvent.OutputTuple,
      OfferCreatedEvent.OutputObject
    >;
    OfferCreated: TypedContractEvent<
      OfferCreatedEvent.InputTuple,
      OfferCreatedEvent.OutputTuple,
      OfferCreatedEvent.OutputObject
    >;

    "OwnershipTransferred(address,address)": TypedContractEvent<
      OwnershipTransferredEvent.InputTuple,
      OwnershipTransferredEvent.OutputTuple,
      OwnershipTransferredEvent.OutputObject
    >;
    OwnershipTransferred: TypedContractEvent<
      OwnershipTransferredEvent.InputTuple,
      OwnershipTransferredEvent.OutputTuple,
      OwnershipTransferredEvent.OutputObject
    >;

    "Paused(address)": TypedContractEvent<
      PausedEvent.InputTuple,
      PausedEvent.OutputTuple,
      PausedEvent.OutputObject
    >;
    Paused: TypedContractEvent<
      PausedEvent.InputTuple,
      PausedEvent.OutputTuple,
      PausedEvent.OutputObject
    >;

    "TradeCancelled(uint256)": TypedContractEvent<
      TradeCancelledEvent.InputTuple,
      TradeCancelledEvent.OutputTuple,
      TradeCancelledEvent.OutputObject
    >;
    TradeCancelled: TypedContractEvent<
      TradeCancelledEvent.InputTuple,
      TradeCancelledEvent.OutputTuple,
      TradeCancelledEvent.OutputObject
    >;

    "TradeCreated(uint256,address,uint256)": TypedContractEvent<
      TradeCreatedEvent.InputTuple,
      TradeCreatedEvent.OutputTuple,
      TradeCreatedEvent.OutputObject
    >;
    TradeCreated: TypedContractEvent<
      TradeCreatedEvent.InputTuple,
      TradeCreatedEvent.OutputTuple,
      TradeCreatedEvent.OutputObject
    >;

    "TradeExecuted(uint256,uint256)": TypedContractEvent<
      TradeExecutedEvent.InputTuple,
      TradeExecutedEvent.OutputTuple,
      TradeExecutedEvent.OutputObject
    >;
    TradeExecuted: TypedContractEvent<
      TradeExecutedEvent.InputTuple,
      TradeExecutedEvent.OutputTuple,
      TradeExecutedEvent.OutputObject
    >;

    "Unpaused(address)": TypedContractEvent<
      UnpausedEvent.InputTuple,
      UnpausedEvent.OutputTuple,
      UnpausedEvent.OutputObject
    >;
    Unpaused: TypedContractEvent<
      UnpausedEvent.InputTuple,
      UnpausedEvent.OutputTuple,
      UnpausedEvent.OutputObject
    >;
  };
}
