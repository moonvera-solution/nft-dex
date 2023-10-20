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
} from "../common";

export type CollectionStruct = {
  name: string;
  symbol: string;
  baseURI: string;
  baseExt: string;
  maxSupply: BigNumberish;
  royaltyFee: BigNumberish;
  royaltyReceiver: AddressLike;
};

export type CollectionStructOutput = [
  name: string,
  symbol: string,
  baseURI: string,
  baseExt: string,
  maxSupply: bigint,
  royaltyFee: bigint,
  royaltyReceiver: string
] & {
  name: string;
  symbol: string;
  baseURI: string;
  baseExt: string;
  maxSupply: bigint;
  royaltyFee: bigint;
  royaltyReceiver: string;
};

export type StagesStruct = {
  ogMintPrice: BigNumberish;
  whitelistMintPrice: BigNumberish;
  mintPrice: BigNumberish;
  mintMaxPerUser: BigNumberish;
  ogMintMaxPerUser: BigNumberish;
  whitelistMintMaxPerUser: BigNumberish;
  mintStart: BigNumberish;
  mintEnd: BigNumberish;
  ogMintStart: BigNumberish;
  ogMintEnd: BigNumberish;
  whitelistMintStart: BigNumberish;
  whitelistMintEnd: BigNumberish;
};

export type StagesStructOutput = [
  ogMintPrice: bigint,
  whitelistMintPrice: bigint,
  mintPrice: bigint,
  mintMaxPerUser: bigint,
  ogMintMaxPerUser: bigint,
  whitelistMintMaxPerUser: bigint,
  mintStart: bigint,
  mintEnd: bigint,
  ogMintStart: bigint,
  ogMintEnd: bigint,
  whitelistMintStart: bigint,
  whitelistMintEnd: bigint
] & {
  ogMintPrice: bigint;
  whitelistMintPrice: bigint;
  mintPrice: bigint;
  mintMaxPerUser: bigint;
  ogMintMaxPerUser: bigint;
  whitelistMintMaxPerUser: bigint;
  mintStart: bigint;
  mintEnd: bigint;
  ogMintStart: bigint;
  ogMintEnd: bigint;
  whitelistMintStart: bigint;
  whitelistMintEnd: bigint;
};

export interface MvxFactoryInterface extends Interface {
  getFunction(
    nameOrSignature:
      | "artists"
      | "collectionCount"
      | "collectionImpl"
      | "collections"
      | "createCollection"
      | "deployFee"
      | "getPartnerBalance"
      | "getReferralBalance"
      | "getTime()"
      | "getTime(uint256)"
      | "grantReferral"
      | "members"
      | "owner"
      | "partners"
      | "platformFee"
      | "renounceOwnership"
      | "setCollectionImpl"
      | "setPartnership"
      | "totalCollections"
      | "transferOwnership"
      | "updateArtist"
      | "updateDeployFee"
      | "updateMember"
      | "updatePlatformFee"
      | "withdraw"
      | "withdrawPartner"
      | "withdrawReferral"
  ): FunctionFragment;

  getEvent(
    nameOrSignatureOrTopic:
      | "CollectionDiscount"
      | "CreateCloneEvent"
      | "CreateCollectionEvent"
      | "DiscountGranted"
      | "InitCollectionEvent"
      | "InitOwnerEvent"
      | "Log"
      | "OwnershipTransferred"
      | "WithdrawPartner"
      | "WithdrawReferral"
  ): EventFragment;

  encodeFunctionData(
    functionFragment: "artists",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "collectionCount",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "collectionImpl",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "collections",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "createCollection",
    values: [CollectionStruct, StagesStruct, AddressLike[], AddressLike[]]
  ): string;
  encodeFunctionData(functionFragment: "deployFee", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "getPartnerBalance",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "getReferralBalance",
    values: [AddressLike]
  ): string;
  encodeFunctionData(functionFragment: "getTime()", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "getTime(uint256)",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "grantReferral",
    values: [AddressLike, AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "members",
    values: [AddressLike]
  ): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "partners",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "platformFee",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "renounceOwnership",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setCollectionImpl",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setPartnership",
    values: [AddressLike, AddressLike, BigNumberish, BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "totalCollections",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "updateArtist",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "updateDeployFee",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "updateMember",
    values: [AddressLike, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "updatePlatformFee",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "withdraw", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "withdrawPartner",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "withdrawReferral",
    values: [AddressLike]
  ): string;

  decodeFunctionResult(functionFragment: "artists", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "collectionCount",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "collectionImpl",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "collections",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "createCollection",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "deployFee", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "getPartnerBalance",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getReferralBalance",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "getTime()", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "getTime(uint256)",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "grantReferral",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "members", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "partners", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "platformFee",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "renounceOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setCollectionImpl",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setPartnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "totalCollections",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "updateArtist",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "updateDeployFee",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "updateMember",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "updatePlatformFee",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "withdraw", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "withdrawPartner",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "withdrawReferral",
    data: BytesLike
  ): Result;
}

export namespace CollectionDiscountEvent {
  export type InputTuple = [_collection: AddressLike, _discount: BigNumberish];
  export type OutputTuple = [_collection: string, _discount: bigint];
  export interface OutputObject {
    _collection: string;
    _discount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace CreateCloneEventEvent {
  export type InputTuple = [
    sender: AddressLike,
    impl: AddressLike,
    cloneAddress: AddressLike
  ];
  export type OutputTuple = [
    sender: string,
    impl: string,
    cloneAddress: string
  ];
  export interface OutputObject {
    sender: string;
    impl: string;
    cloneAddress: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace CreateCollectionEventEvent {
  export type InputTuple = [
    sender: AddressLike,
    template: AddressLike,
    clone: AddressLike
  ];
  export type OutputTuple = [sender: string, template: string, clone: string];
  export interface OutputObject {
    sender: string;
    template: string;
    clone: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace DiscountGrantedEvent {
  export type InputTuple = [
    _artist: AddressLike,
    _sender: AddressLike,
    _collection: AddressLike,
    _discount: BigNumberish
  ];
  export type OutputTuple = [
    _artist: string,
    _sender: string,
    _collection: string,
    _discount: bigint
  ];
  export interface OutputObject {
    _artist: string;
    _sender: string;
    _collection: string;
    _discount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace InitCollectionEventEvent {
  export type InputTuple = [sender: AddressLike, collection: AddressLike];
  export type OutputTuple = [sender: string, collection: string];
  export interface OutputObject {
    sender: string;
    collection: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace InitOwnerEventEvent {
  export type InputTuple = [sender: AddressLike];
  export type OutputTuple = [sender: string];
  export interface OutputObject {
    sender: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace LogEvent {
  export type InputTuple = [arg0: string, arg1: BigNumberish];
  export type OutputTuple = [arg0: string, arg1: bigint];
  export interface OutputObject {
    arg0: string;
    arg1: bigint;
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

export namespace WithdrawPartnerEvent {
  export type InputTuple = [
    _sender: AddressLike,
    _collection: AddressLike,
    _adminBalance: BigNumberish
  ];
  export type OutputTuple = [
    _sender: string,
    _collection: string,
    _adminBalance: bigint
  ];
  export interface OutputObject {
    _sender: string;
    _collection: string;
    _adminBalance: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace WithdrawReferralEvent {
  export type InputTuple = [
    _sender: AddressLike,
    _artist: AddressLike,
    _referralBalance: BigNumberish
  ];
  export type OutputTuple = [
    _sender: string,
    _artist: string,
    _referralBalance: bigint
  ];
  export interface OutputObject {
    _sender: string;
    _artist: string;
    _referralBalance: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export interface MvxFactory extends BaseContract {
  connect(runner?: ContractRunner | null): MvxFactory;
  waitForDeployment(): Promise<this>;

  interface: MvxFactoryInterface;

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

  artists: TypedContractMethod<
    [arg0: AddressLike],
    [
      [string, bigint, string, bigint] & {
        referral: string;
        referralBalance: bigint;
        collection: string;
        expiration: bigint;
      }
    ],
    "view"
  >;

  collectionCount: TypedContractMethod<[], [bigint], "view">;

  collectionImpl: TypedContractMethod<[], [string], "view">;

  collections: TypedContractMethod<[arg0: AddressLike], [string], "view">;

  createCollection: TypedContractMethod<
    [
      _nftsData: CollectionStruct,
      _mintingStages: StagesStruct,
      _ogs: AddressLike[],
      _wls: AddressLike[]
    ],
    [string],
    "payable"
  >;

  deployFee: TypedContractMethod<[], [bigint], "view">;

  getPartnerBalance: TypedContractMethod<
    [_collection: AddressLike],
    [bigint],
    "view"
  >;

  getReferralBalance: TypedContractMethod<
    [_artist: AddressLike],
    [bigint],
    "view"
  >;

  "getTime()": TypedContractMethod<[], [bigint], "view">;

  "getTime(uint256)": TypedContractMethod<
    [_daysFromNow: BigNumberish],
    [bigint],
    "view"
  >;

  grantReferral: TypedContractMethod<
    [_extCollection: AddressLike, _artist: AddressLike],
    [void],
    "nonpayable"
  >;

  members: TypedContractMethod<[arg0: AddressLike], [bigint], "view">;

  owner: TypedContractMethod<[], [string], "view">;

  partners: TypedContractMethod<
    [arg0: AddressLike],
    [
      [string, bigint, bigint, bigint, bigint] & {
        admin: string;
        adminOwnPercent: bigint;
        referralOwnPercent: bigint;
        adminBalance: bigint;
        discount: bigint;
      }
    ],
    "view"
  >;

  platformFee: TypedContractMethod<[], [bigint], "view">;

  renounceOwnership: TypedContractMethod<[], [void], "nonpayable">;

  setCollectionImpl: TypedContractMethod<
    [_impl: AddressLike],
    [void],
    "payable"
  >;

  setPartnership: TypedContractMethod<
    [
      _collection: AddressLike,
      _admin: AddressLike,
      _adminOwnPercent: BigNumberish,
      _referralOwnPercent: BigNumberish,
      _discountPercent: BigNumberish
    ],
    [void],
    "nonpayable"
  >;

  totalCollections: TypedContractMethod<[], [bigint], "view">;

  transferOwnership: TypedContractMethod<
    [newOwner: AddressLike],
    [void],
    "nonpayable"
  >;

  updateArtist: TypedContractMethod<
    [artist: AddressLike],
    [void],
    "nonpayable"
  >;

  updateDeployFee: TypedContractMethod<
    [_newFee: BigNumberish],
    [void],
    "payable"
  >;

  updateMember: TypedContractMethod<
    [_newMember: AddressLike, _expirationDays: BigNumberish],
    [void],
    "payable"
  >;

  updatePlatformFee: TypedContractMethod<
    [_fee: BigNumberish],
    [void],
    "payable"
  >;

  withdraw: TypedContractMethod<[], [void], "payable">;

  withdrawPartner: TypedContractMethod<
    [_collection: AddressLike],
    [void],
    "nonpayable"
  >;

  withdrawReferral: TypedContractMethod<
    [_artist: AddressLike],
    [void],
    "nonpayable"
  >;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "artists"
  ): TypedContractMethod<
    [arg0: AddressLike],
    [
      [string, bigint, string, bigint] & {
        referral: string;
        referralBalance: bigint;
        collection: string;
        expiration: bigint;
      }
    ],
    "view"
  >;
  getFunction(
    nameOrSignature: "collectionCount"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "collectionImpl"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "collections"
  ): TypedContractMethod<[arg0: AddressLike], [string], "view">;
  getFunction(
    nameOrSignature: "createCollection"
  ): TypedContractMethod<
    [
      _nftsData: CollectionStruct,
      _mintingStages: StagesStruct,
      _ogs: AddressLike[],
      _wls: AddressLike[]
    ],
    [string],
    "payable"
  >;
  getFunction(
    nameOrSignature: "deployFee"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "getPartnerBalance"
  ): TypedContractMethod<[_collection: AddressLike], [bigint], "view">;
  getFunction(
    nameOrSignature: "getReferralBalance"
  ): TypedContractMethod<[_artist: AddressLike], [bigint], "view">;
  getFunction(
    nameOrSignature: "getTime()"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "getTime(uint256)"
  ): TypedContractMethod<[_daysFromNow: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "grantReferral"
  ): TypedContractMethod<
    [_extCollection: AddressLike, _artist: AddressLike],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "members"
  ): TypedContractMethod<[arg0: AddressLike], [bigint], "view">;
  getFunction(
    nameOrSignature: "owner"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "partners"
  ): TypedContractMethod<
    [arg0: AddressLike],
    [
      [string, bigint, bigint, bigint, bigint] & {
        admin: string;
        adminOwnPercent: bigint;
        referralOwnPercent: bigint;
        adminBalance: bigint;
        discount: bigint;
      }
    ],
    "view"
  >;
  getFunction(
    nameOrSignature: "platformFee"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "renounceOwnership"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setCollectionImpl"
  ): TypedContractMethod<[_impl: AddressLike], [void], "payable">;
  getFunction(
    nameOrSignature: "setPartnership"
  ): TypedContractMethod<
    [
      _collection: AddressLike,
      _admin: AddressLike,
      _adminOwnPercent: BigNumberish,
      _referralOwnPercent: BigNumberish,
      _discountPercent: BigNumberish
    ],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "totalCollections"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "transferOwnership"
  ): TypedContractMethod<[newOwner: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "updateArtist"
  ): TypedContractMethod<[artist: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "updateDeployFee"
  ): TypedContractMethod<[_newFee: BigNumberish], [void], "payable">;
  getFunction(
    nameOrSignature: "updateMember"
  ): TypedContractMethod<
    [_newMember: AddressLike, _expirationDays: BigNumberish],
    [void],
    "payable"
  >;
  getFunction(
    nameOrSignature: "updatePlatformFee"
  ): TypedContractMethod<[_fee: BigNumberish], [void], "payable">;
  getFunction(
    nameOrSignature: "withdraw"
  ): TypedContractMethod<[], [void], "payable">;
  getFunction(
    nameOrSignature: "withdrawPartner"
  ): TypedContractMethod<[_collection: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "withdrawReferral"
  ): TypedContractMethod<[_artist: AddressLike], [void], "nonpayable">;

  getEvent(
    key: "CollectionDiscount"
  ): TypedContractEvent<
    CollectionDiscountEvent.InputTuple,
    CollectionDiscountEvent.OutputTuple,
    CollectionDiscountEvent.OutputObject
  >;
  getEvent(
    key: "CreateCloneEvent"
  ): TypedContractEvent<
    CreateCloneEventEvent.InputTuple,
    CreateCloneEventEvent.OutputTuple,
    CreateCloneEventEvent.OutputObject
  >;
  getEvent(
    key: "CreateCollectionEvent"
  ): TypedContractEvent<
    CreateCollectionEventEvent.InputTuple,
    CreateCollectionEventEvent.OutputTuple,
    CreateCollectionEventEvent.OutputObject
  >;
  getEvent(
    key: "DiscountGranted"
  ): TypedContractEvent<
    DiscountGrantedEvent.InputTuple,
    DiscountGrantedEvent.OutputTuple,
    DiscountGrantedEvent.OutputObject
  >;
  getEvent(
    key: "InitCollectionEvent"
  ): TypedContractEvent<
    InitCollectionEventEvent.InputTuple,
    InitCollectionEventEvent.OutputTuple,
    InitCollectionEventEvent.OutputObject
  >;
  getEvent(
    key: "InitOwnerEvent"
  ): TypedContractEvent<
    InitOwnerEventEvent.InputTuple,
    InitOwnerEventEvent.OutputTuple,
    InitOwnerEventEvent.OutputObject
  >;
  getEvent(
    key: "Log"
  ): TypedContractEvent<
    LogEvent.InputTuple,
    LogEvent.OutputTuple,
    LogEvent.OutputObject
  >;
  getEvent(
    key: "OwnershipTransferred"
  ): TypedContractEvent<
    OwnershipTransferredEvent.InputTuple,
    OwnershipTransferredEvent.OutputTuple,
    OwnershipTransferredEvent.OutputObject
  >;
  getEvent(
    key: "WithdrawPartner"
  ): TypedContractEvent<
    WithdrawPartnerEvent.InputTuple,
    WithdrawPartnerEvent.OutputTuple,
    WithdrawPartnerEvent.OutputObject
  >;
  getEvent(
    key: "WithdrawReferral"
  ): TypedContractEvent<
    WithdrawReferralEvent.InputTuple,
    WithdrawReferralEvent.OutputTuple,
    WithdrawReferralEvent.OutputObject
  >;

  filters: {
    "CollectionDiscount(address,uint96)": TypedContractEvent<
      CollectionDiscountEvent.InputTuple,
      CollectionDiscountEvent.OutputTuple,
      CollectionDiscountEvent.OutputObject
    >;
    CollectionDiscount: TypedContractEvent<
      CollectionDiscountEvent.InputTuple,
      CollectionDiscountEvent.OutputTuple,
      CollectionDiscountEvent.OutputObject
    >;

    "CreateCloneEvent(address,address,address)": TypedContractEvent<
      CreateCloneEventEvent.InputTuple,
      CreateCloneEventEvent.OutputTuple,
      CreateCloneEventEvent.OutputObject
    >;
    CreateCloneEvent: TypedContractEvent<
      CreateCloneEventEvent.InputTuple,
      CreateCloneEventEvent.OutputTuple,
      CreateCloneEventEvent.OutputObject
    >;

    "CreateCollectionEvent(address,address,address)": TypedContractEvent<
      CreateCollectionEventEvent.InputTuple,
      CreateCollectionEventEvent.OutputTuple,
      CreateCollectionEventEvent.OutputObject
    >;
    CreateCollectionEvent: TypedContractEvent<
      CreateCollectionEventEvent.InputTuple,
      CreateCollectionEventEvent.OutputTuple,
      CreateCollectionEventEvent.OutputObject
    >;

    "DiscountGranted(address,address,address,uint96)": TypedContractEvent<
      DiscountGrantedEvent.InputTuple,
      DiscountGrantedEvent.OutputTuple,
      DiscountGrantedEvent.OutputObject
    >;
    DiscountGranted: TypedContractEvent<
      DiscountGrantedEvent.InputTuple,
      DiscountGrantedEvent.OutputTuple,
      DiscountGrantedEvent.OutputObject
    >;

    "InitCollectionEvent(address,address)": TypedContractEvent<
      InitCollectionEventEvent.InputTuple,
      InitCollectionEventEvent.OutputTuple,
      InitCollectionEventEvent.OutputObject
    >;
    InitCollectionEvent: TypedContractEvent<
      InitCollectionEventEvent.InputTuple,
      InitCollectionEventEvent.OutputTuple,
      InitCollectionEventEvent.OutputObject
    >;

    "InitOwnerEvent(address)": TypedContractEvent<
      InitOwnerEventEvent.InputTuple,
      InitOwnerEventEvent.OutputTuple,
      InitOwnerEventEvent.OutputObject
    >;
    InitOwnerEvent: TypedContractEvent<
      InitOwnerEventEvent.InputTuple,
      InitOwnerEventEvent.OutputTuple,
      InitOwnerEventEvent.OutputObject
    >;

    "Log(string,uint256)": TypedContractEvent<
      LogEvent.InputTuple,
      LogEvent.OutputTuple,
      LogEvent.OutputObject
    >;
    Log: TypedContractEvent<
      LogEvent.InputTuple,
      LogEvent.OutputTuple,
      LogEvent.OutputObject
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

    "WithdrawPartner(address,address,uint256)": TypedContractEvent<
      WithdrawPartnerEvent.InputTuple,
      WithdrawPartnerEvent.OutputTuple,
      WithdrawPartnerEvent.OutputObject
    >;
    WithdrawPartner: TypedContractEvent<
      WithdrawPartnerEvent.InputTuple,
      WithdrawPartnerEvent.OutputTuple,
      WithdrawPartnerEvent.OutputObject
    >;

    "WithdrawReferral(address,address,uint256)": TypedContractEvent<
      WithdrawReferralEvent.InputTuple,
      WithdrawReferralEvent.OutputTuple,
      WithdrawReferralEvent.OutputObject
    >;
    WithdrawReferral: TypedContractEvent<
      WithdrawReferralEvent.InputTuple,
      WithdrawReferralEvent.OutputTuple,
      WithdrawReferralEvent.OutputObject
    >;
  };
}
