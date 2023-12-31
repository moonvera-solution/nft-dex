// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.5;

import {Test, console2, Vm} from "@forge-std/Test.sol";
import {Stages, Collection, Partner, Member} from "@src/libs/MvxStruct.sol";
import {MvxFactory} from "@src/MvxFactory.sol";
import {MvxCollection} from "@src/MvxCollection.sol";

contract BaseTest is Test {
    MvxFactory public factory;
    MvxCollection public clone;

    Stages public stages;
    Collection public nftData;
    Partner public partner;
    address[] og;
    address[] wl;

    bytes32 public constant ADMIN_ROLE_TEST = keccak256("ADMIN_ROLE");
    bytes32 public constant WL_MINTER_ROLE_TEST = keccak256("WL_MINTER_ROLE");
    bytes32 public constant OG_MINTER_ROLE_TEST = keccak256("OG_MINTER_ROLE");

    Vm.Wallet public wallet1 = vm.createWallet("w1");
    Vm.Wallet public wallet5 = vm.createWallet("w5");
    Vm.Wallet public wallet3 = vm.createWallet("w3");

    address public user2 = address(2);
    address public user3 = address(3);
    address public user4 = address(4);
    address public user5 = address(5);
    address public user6 = address(6);
    address public user7 = address(7);
    address public user8 = address(8);
    address public user9 = address(9);
    address public user10 = address(10);

    function _factoryCreate(MvxFactory factory, address royaltyReiver, uint256 _deployCost)
        internal
        returns (address)
    {
        _setStages();
        _setCollectionDetails(royaltyReiver);
        (address[] memory _ogs, address[] memory _wls) = _getMinters();
        return factory.createCollection{value: _deployCost}(nftData, stages, _ogs, _wls);
    }

    event Log(string, uint40);

    function _getTime(uint8 _days) internal returns (uint256) {
        emit Log("Log time:: ", uint40(block.timestamp + (0 * 60 * 60 * 24)));
        return block.timestamp + (60 * 60 * 24 * _days);
    }

    function _setStages() public {
        stages = Stages({
            isMaxSupplyUpdatable: true,
            ogMintPrice: uint72(1 ether),
            whitelistMintPrice: uint72(1 ether),
            mintPrice: uint72(1 ether),
            mintMaxPerUser: uint16(60),
            ogMintMaxPerUser: uint16(60),
            whitelistMintMaxPerUser: uint16(50),
            ogMintStart: uint40(block.timestamp - 10),
            ogMintEnd: uint40(_getTime(1)),
            whitelistMintStart: uint40(_getTime(2)),
            whitelistMintEnd: uint40(_getTime(3)),
            mintStart: uint40(_getTime(3)),
            mintEnd: uint40(_getTime(7))
        });
    }

    function _setCollectionDetails(address royaltyReiver) public {
        nftData = Collection({
            name: "MVX ART",
            symbol: "MVX",
            baseURI: "ipfs://QmXPHaxtTKxa58ise75a4vRAhLzZK3cANKV3zWb6KMoGUU/",
            baseExt: ".json",
            maxSupply: uint128(2000),
            royaltyFee: uint128(1000),
            royaltyReceiver: royaltyReiver
        });
    }

    function _getMinters() public returns (address[] memory _initialOGMinters, address[] memory _initialWLMinters) {
        wl.push(0x5A2D11396e115aEF85Fd6f467A439fFB181478ec);
        wl.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        wl.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        wl.push(0x269b4c5537445ad08EBF6eA6D848a4866856778b);
        wl.push(0x8919Bc879C595c4F5a699A870d5211a5436cDF7E);
        wl.push(0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA);
        wl.push(0xc7468B7D4086D15bf13D025A663E46E38d945446);
        wl.push(0x40f0D8104ae5C9b9D7185Dbf1d65c2d40CA1565f);
        wl.push(0x897f1569a22Ab89ED2ED363acAF9b8613EDd27a7);
        wl.push(0x173f6e69efA3Ed13bC5b8fFa48b80cfaD5b55260);
        // wl.push(0x172e1D59AEBe8fc5d0BAc93B9E9a1ABddCc767ea);
        // wl.push(0x63c65c86cB9D25a252635c73f90516D21E344ED4);
        // wl.push(0x63e03E3e25d483D7e5c0B300C8b34b9A5f7Ead85);
        // wl.push(0x1AED3799De8416Fc7B53E75c132B4f67e5Da20B3);
        // wl.push(0xc56c40BEB87949002F00b60E4Ef575DB1E5C9F3e);
        // wl.push(0x6667cbFaF2960D62A8Af2b4896674a008e351d9F);
        // wl.push(0x2BeeFa8AdA17358D63eAaf88Aa6C2f7498130EE6);
        // wl.push(0x7dB4ca2a8096C3711F1B3B00b440d021c50821D7);
        // wl.push(0x77cb76F93Fb2a767831cc0ae2dF5023551A93270);
        // wl.push(0xB18Df5Be6A4F2B14099455B430a7846c80529951);
        // wl.push(0xfbd92d3Aaf8824201A32Aed790A12338F78C74a1);
        // wl.push(0x4cE4E56628a1ec53Ba36e984946b124176cF980d);
        // wl.push(0x126B53AaB4F50c357B543939DBb46f14C6c25a3c);
        // wl.push(0x925B51750770bD15d3477C95148D79ACD197AC8A);
        // wl.push(0x044Ffe4018944C0e309Ca0bd3e386F4d0190D379);
        // wl.push(0x26f40cA246d1fCc21A2f1d2A16880367C9658d90);
        // wl.push(0xB18Df5Be6A4F2B14099455B430a7846c80529951);
        // wl.push(0x897f1569a22Ab89ED2ED363acAF9b8613EDd27a7);
        // wl.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // wl.push(0x269b4c5537445ad08EBF6eA6D848a4866856778b);
        // wl.push(0x042985c1eB919748508b4AA028688DFE43b083aA);
        // wl.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // wl.push(0x1cBA385B069B39eDE98c555881ad76982B97B19c);
        // wl.push(0x24720B809D7168854080D638Dc125Ba81570C585);
        // wl.push(0x99D4df3258D0E35D53B1aF2A26d3570186B91161);
        // wl.push(0x63e03E3e25d483D7e5c0B300C8b34b9A5f7Ead85);
        // wl.push(0x32E7709eC2b3346cdf13E07060D4e2DFfd898685);
        // wl.push(0xEEfca716307f3472D3d3eAeb1bDeCe025188e593);
        // wl.push(0xCdD25E0b5A045fA6F6f42Fc67Ed7E633283210A6);
        // wl.push(0x1AfBbee59Df2389EE331EFA698Fa79F2968d4B5f);
        // wl.push(0xA6a1283e30B1Cb51Bb28BE2C9435D7c509eF35AF);
        // wl.push(0x49c539B40731681828fe69F6D6ac6485b05a02Bb);
        // wl.push(0xc56c40BEB87949002F00b60E4Ef575DB1E5C9F3e);
        // wl.push(0x8766B481ec28076b9C2590b58C9Cc9b733734Deb);
        // wl.push(0x6667cbFaF2960D62A8Af2b4896674a008e351d9F);
        // wl.push(0x2BeeFa8AdA17358D63eAaf88Aa6C2f7498130EE6);
        // wl.push(0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA);
        // wl.push(0x84130D507C245484ff63CfA780A39aE6ADe441bF);
        // wl.push(0xfE627D675Cc3DbaBA38CaBb6fE9fB2A34b8206a9);
        // wl.push(0x31e0D49c3dc594c24Ffc20B246bd2A4346c3eCD7);
        // wl.push(0x3C593BEF8840Ef4a10E334415562Eb8a5894816E);
        // wl.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // wl.push(0x63e03E3e25d483D7e5c0B300C8b34b9A5f7Ead85);
        // wl.push(0x6667cbFaF2960D62A8Af2b4896674a008e351d9F);
        // wl.push(0x269b4c5537445ad08EBF6eA6D848a4866856778b);
        // wl.push(0xB18Df5Be6A4F2B14099455B430a7846c80529951);
        // wl.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // wl.push(0x1AfBbee59Df2389EE331EFA698Fa79F2968d4B5f);
        // wl.push(0x38201e227eC0624906f214F4Aa4Fa6F4Cf0D1d76);
        // wl.push(0x1cBA385B069B39eDE98c555881ad76982B97B19c);
        // wl.push(0xf3Afb94f15a7F2DD4f7BE08b6d8c452811792Fd5);
        // wl.push(0xfE627D675Cc3DbaBA38CaBb6fE9fB2A34b8206a9);
        // wl.push(0xc2096B0F5c19803A385DDd47B31dd08343f5422E);
        // wl.push(0xE329E8e95B3Ed74cA80C0660644eF095F796B63a);
        // wl.push(0x399323bf4aeDB46Dc5Ea80d44e4dD9Fd5c8DCdAc);
        // wl.push(0xA4cf064D02E35Aed6340df50D0c9e121B16B1Bb6);
        // wl.push(0x4B3800dC1E8a6ebd02CA5A9C4abc81cBb82E63c3);
        // wl.push(0x42FE6ac6b89833044d867568dF66FE55DA5d8079);
        // wl.push(0x52419d6bDc34A8447d81436a87671D496D37b746);
        // wl.push(0x37667d93e047e1231e2CE3BC7a762dD36bCf6aFE);
        // wl.push(0x925B51750770bD15d3477C95148D79ACD197AC8A);
        // wl.push(0xc56c40BEB87949002F00b60E4Ef575DB1E5C9F3e);
        // wl.push(0x897f1569a22Ab89ED2ED363acAF9b8613EDd27a7);
        // wl.push(0xF7bbc8451720CDD5cFfF31CAd3b826d53E78d8c0);
        // wl.push(0x2BeeFa8AdA17358D63eAaf88Aa6C2f7498130EE6);
        // wl.push(0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA);
        // wl.push(0xFfa61B72f6A61EC5fF6957bc352E4A44414EAA66);
        // wl.push(0x84130D507C245484ff63CfA780A39aE6ADe441bF);
        // wl.push(0x7bD42e6E503E296453555D5a3e59d67B4675daF6);
        // wl.push(0xB538A75298F81c5aec361Dc827902e00fA17B4C2);
        // wl.push(0xD8d788f4BaF491DB505A496f9BD5C1D566d1c30f);
        // wl.push(0x0C8Df06bC11B39A3bEE2CD0bb816A592e65E52C8);
        // wl.push(0x0cEe40f8D595e91c3b79CbaEe7403Ec361777462);
        // wl.push(0xC12659432316dD89731220E4A309492F6a3f2629);
        // wl.push(0x3a59842fBf20b54D84c3505fc206f5cF7b56f4d9);
        // wl.push(0x580ed5585061923E5F4E3edc8038362485B452cd);
        // wl.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // wl.push(0xf3876B9E471B8EaA4e0B482e80Eb9bD819652284);
        // wl.push(0x5D30dc36255aE4aD6022c7b8bA640e709993c4D4);
        // wl.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // wl.push(0xB6Ab6ED99c21A7317c607E9243510D89b6F4b91B);
        // wl.push(0xc7468B7D4086D15bf13D025A663E46E38d945446);
        // wl.push(0xEB9b9acDF515D141e818aB8234329e92775c8603);
        // wl.push(0x35e8489eAfa4dc7f300E768deDd6f5227611e99f);
        // wl.push(0x481f90fdaCE22dc9BBC454e285CE5e0957867DF6);
        // wl.push(0x044Ffe4018944C0e309Ca0bd3e386F4d0190D379);
        // wl.push(0xaEDF74546Caa4e1e13fAa01b153c1e8099d4623b);
        // wl.push(0xCAb6193901887968cd656BBB15ffDE19b0eb1c37);
        // wl.push(0xE329E8e95B3Ed74cA80C0660644eF095F796B63a);
        // wl.push(0xa92838ed7C8e6A6CEe783f8583Ae4A7F0352cE3d);
        // wl.push(0x15c64c9000ce544525A93Ccdb87F161C0368f80c);
        // wl.push(0xf027828a6D9A0618A2f419AB71Db39cf2295f027);
        // wl.push(0xeB14ec41019b42E2c15a7ac86FD026f9bCd89883);
        // wl.push(0x44ABaa7FeD7684F5872939e2741EAbb727112010);
        // wl.push(0x042985c1eB919748508b4AA028688DFE43b083aA);
        // wl.push(0xEFd6E29eD1b602B4d0410bF008Bd667562DF1013);
        // wl.push(0x974CCBEA8d50eCE1066b4533D6bCBC465F754161);
        // wl.push(0xA31eE3270D637681488A33d9B5F4D2cD6BB9238B);
        // wl.push(0xe959112d65f49D8FF7086EED0451e5B23E5DE807);
        // wl.push(0xAe2fDf2eaF44bac2188dA7dA061968AAe4Ca41B5);
        // wl.push(0x0C70fd88783036774598ecc3C53Acd5CDCE65a4e);
        // wl.push(0xb22Ad0d340Dc2A1137fB07a1a953e810CeBb1417);
        // wl.push(0x7C44633446085F35fbEAdd503E0B8d619C74D907);
        // wl.push(0x073a1e05E32eDA11437EadC5E0f908a2Debe0a60);
        // wl.push(0x65f5Ab40a657ED48423631636040Bc3bF97bc8ef);
        // wl.push(0x80E551Ec6206F619F6cB4ee807184eD628f851a0);
        // wl.push(0x76f1441F942d50CF19fB43AbB78E3977CdC06Ee3);
        // wl.push(0xd2CB8abDCCb7ec6B0e605D372D94904051eF9F5B);
        // wl.push(0xcd1fAA80b3292E16347F31590018446552C6708f);
        // wl.push(0x5e65e345A145d2eCF31b0222aF5F13dB250cb254);
        // wl.push(0xCF2cD1F063405A0b10561a615D4A349d08417a0f);
        // wl.push(0x56CB938e4697243E59f3676b47fE48A1faA1f18a);
        // wl.push(0xEEfca716307f3472D3d3eAeb1bDeCe025188e593);
        // wl.push(0x6639F00249Db40c24e61bb5e4B980380603e7944);
        // wl.push(0x45489bE197f0A64d07f68a7dc44b60038c3429Bd);
        // wl.push(0xD3ae4f352505220142951C2bbcB005761432ADa2);
        // wl.push(0xe1C9881B973b0D973b2f714B89055e270Fbf879e);
        // wl.push(0x356E8dca95598C7A00cC3f198Af08762Ed57d050);
        // wl.push(0x967b9E8bb5F0BC2245F2A90D72Cfa1f853A56848);
        // wl.push(0x5013b2f1c3875f25dc298417eea1802010FDc9E5);
        // wl.push(0xDdB0853D197B63ec935909a8C4CAa817512136Bd);
        // wl.push(0x34B47F05fC99354DB03626EAC917348e385a64B8);
        // wl.push(0xEEAE3942B76F3720a05c92A8280716f7Dd43b059);
        // wl.push(0x9c352C3EaA9596e0055B2b0a625eB45b61273d04);
        // wl.push(0x1A469Cd50d923a59cEb654D55FA300Cd4a84FB08);
        // wl.push(0x75932A6DA9edd0726c1FFFBC7172B08fdE9Fc236);
        // wl.push(0x3dd721fE6D0C229F611a0F484Eb768673d20C80c);
        // wl.push(0x5eCAC4feFf27d45cf1755326fe4E4600cb75e655);
        // wl.push(0x8A0e8A58e89C11f4F1a66a83a4C5ae5D35570585);
        // wl.push(0x6d65c43D1F2A10185D1049DCCbDcEdB0572E9880);
        // wl.push(0x4fD0d9898cf77108452244e45F35737cFBBC19DF);
        // wl.push(0x2a7dA3360587CAF68434EB8E7103D10dbDF62233);
        // wl.push(0x7b2372943568f19c6781ac4eb4a2Fb98206D42eD);
        // wl.push(0xDf9601Afc81799916A571a20F7050199CB55bd81);
        // wl.push(0xCA7a2FdC834B911b77BfBEcc96C50B7f181d342C);
        // wl.push(0x123fFea5A1dbF4e4289173a2E455Db6180C235eb);
        // wl.push(0x72E6930A54032cb80c3c3EF00bF1Fd8A73df1962);
        // wl.push(0xd5190A43A96535f6fe19DA6dce3A05983f56634D);
        // wl.push(0xfD6300Ac8F8D128D4ad4536d66b66a13CB7dA774);
        // wl.push(0x1AED3799De8416Fc7B53E75c132B4f67e5Da20B3);
        // wl.push(0xCdD25E0b5A045fA6F6f42Fc67Ed7E633283210A6);
        // wl.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // wl.push(0x7dB4ca2a8096C3711F1B3B00b440d021c50821D7);
        // wl.push(0x77cb76F93Fb2a767831cc0ae2dF5023551A93270);
        // wl.push(0xc56c40BEB87949002F00b60E4Ef575DB1E5C9F3e);
        // wl.push(0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA);
        // wl.push(0x7bD42e6E503E296453555D5a3e59d67B4675daF6);
        // wl.push(0xB538A75298F81c5aec361Dc827902e00fA17B4C2);
        // wl.push(0xD8d788f4BaF491DB505A496f9BD5C1D566d1c30f);
        // wl.push(0x0C8Df06bC11B39A3bEE2CD0bb816A592e65E52C8);
        // wl.push(0x0cEe40f8D595e91c3b79CbaEe7403Ec361777462);
        // wl.push(0xC12659432316dD89731220E4A309492F6a3f2629);
        // wl.push(0x3a59842fBf20b54D84c3505fc206f5cF7b56f4d9);
        // wl.push(0x580ed5585061923E5F4E3edc8038362485B452cd);
        // wl.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // wl.push(0xf3876B9E471B8EaA4e0B482e80Eb9bD819652284);
        // wl.push(0x5D30dc36255aE4aD6022c7b8bA640e709993c4D4);
        // wl.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // wl.push(0xB6Ab6ED99c21A7317c607E9243510D89b6F4b91B);
        // wl.push(0xc7468B7D4086D15bf13D025A663E46E38d945446);
        // wl.push(0xA31eE3270D637681488A33d9B5F4D2cD6BB9238B);
        // wl.push(0xe959112d65f49D8FF7086EED0451e5B23E5DE807);
        // wl.push(0xAe2fDf2eaF44bac2188dA7dA061968AAe4Ca41B5);
        // wl.push(0x0C70fd88783036774598ecc3C53Acd5CDCE65a4e);
        // wl.push(0xb22Ad0d340Dc2A1137fB07a1a953e810CeBb1417);
        // wl.push(0x7C44633446085F35fbEAdd503E0B8d619C74D907);
        // wl.push(0x073a1e05E32eDA11437EadC5E0f908a2Debe0a60);
        // wl.push(0x65f5Ab40a657ED48423631636040Bc3bF97bc8ef);
        // wl.push(0x80E551Ec6206F619F6cB4ee807184eD628f851a0);
        // wl.push(0x76f1441F942d50CF19fB43AbB78E3977CdC06Ee3);
        // wl.push(0xd2CB8abDCCb7ec6B0e605D372D94904051eF9F5B);
        // wl.push(0xcd1fAA80b3292E16347F31590018446552C6708f);
        // wl.push(0x5e65e345A145d2eCF31b0222aF5F13dB250cb254);
        // wl.push(0xCF2cD1F063405A0b10561a615D4A349d08417a0f);
        // wl.push(0x56CB938e4697243E59f3676b47fE48A1faA1f18a);
        // wl.push(0xEEfca716307f3472D3d3eAeb1bDeCe025188e593);
        // wl.push(0x6639F00249Db40c24e61bb5e4B980380603e7944);
        // wl.push(0x45489Bea8d50ece1066B4533d6BcbC465F754161);
        // wl.push(0xD3ae4f352505220142951C2bbcB005761432ADa2);
        // wl.push(0xe1C9881B973b0D973b2f714B89055e270Fbf879e);
        // wl.push(0x356E8dca95598C7A00cC3f198Af08762Ed57d050);
        // wl.push(0x826a9158eCEbd405479f212A4836eB5E17880253);
        // wl.push(0x5A79B72e572427c86a28965206649cE9a12dfdfa);
        // wl.push(0x9228D10ddb805E338Fd2E9670d43996FEf89Ef6D);
        // wl.push(0x786235E5d2b1F2a8dd31D791d34726933FbA5004);
        // wl.push(0x1716Dc946d9264126412feDE8264E50E9d21c37a);
        // wl.push(0xCaF7DEF17e72fF1C9A298fB693899A5Ab3874117);
        // wl.push(0x80804B3f3a947053D0e930A231c732318c073aCF);
        // wl.push(0xa9b4bf6A5dc818fe20124012569BcfCcEBb40D77);
        // wl.push(0x48b81e5bD2a1312B6cfB353Ec9256d891248BAd0);
        // wl.push(0x924d924F243D9d0B30a93FFBAA45aEE119223BD8);

        // og.push(0x5A2D11396e115aEF85Fd6f467A439fFB181478ec);
        // og.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // og.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // og.push(0x269b4c5537445ad08EBF6eA6D848a4866856778b);
        // og.push(0x8919Bc879C595c4F5a699A870d5211a5436cDF7E);
        // og.push(0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA);
        // og.push(0xc7468B7D4086D15bf13D025A663E46E38d945446);
        // og.push(0x40f0D8104ae5C9b9D7185Dbf1d65c2d40CA1565f);
        // og.push(0x897f1569a22Ab89ED2ED363acAF9b8613EDd27a7);
        // og.push(0x173f6e69efA3Ed13bC5b8fFa48b80cfaD5b55260);
        // og.push(0x172e1D59AEBe8fc5d0BAc93B9E9a1ABddCc767ea);
        // og.push(0x63c65c86cB9D25a252635c73f90516D21E344ED4);
        // og.push(0x63e03E3e25d483D7e5c0B300C8b34b9A5f7Ead85);
        // og.push(0x1AED3799De8416Fc7B53E75c132B4f67e5Da20B3);
        // og.push(0xc56c40BEB87949002F00b60E4Ef575DB1E5C9F3e);
        // og.push(0x6667cbFaF2960D62A8Af2b4896674a008e351d9F);
        // og.push(0x2BeeFa8AdA17358D63eAaf88Aa6C2f7498130EE6);
        // og.push(0x7dB4ca2a8096C3711F1B3B00b440d021c50821D7);
        // og.push(0x77cb76F93Fb2a767831cc0ae2dF5023551A93270);
        // og.push(0xB18Df5Be6A4F2B14099455B430a7846c80529951);
        // og.push(0xfbd92d3Aaf8824201A32Aed790A12338F78C74a1);
        // og.push(0x4cE4E56628a1ec53Ba36e984946b124176cF980d);
        // og.push(0x126B53AaB4F50c357B543939DBb46f14C6c25a3c);
        // og.push(0x925B51750770bD15d3477C95148D79ACD197AC8A);
        // og.push(0x044Ffe4018944C0e309Ca0bd3e386F4d0190D379);
        // og.push(0x26f40cA246d1fCc21A2f1d2A16880367C9658d90);
        // og.push(0xB18Df5Be6A4F2B14099455B430a7846c80529951);
        // og.push(0x897f1569a22Ab89ED2ED363acAF9b8613EDd27a7);
        // og.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // og.push(0x269b4c5537445ad08EBF6eA6D848a4866856778b);
        // og.push(0x042985c1eB919748508b4AA028688DFE43b083aA);
        // og.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // og.push(0x1cBA385B069B39eDE98c555881ad76982B97B19c);
        // og.push(0x24720B809D7168854080D638Dc125Ba81570C585);
        // og.push(0x99D4df3258D0E35D53B1aF2A26d3570186B91161);
        // og.push(0x63e03E3e25d483D7e5c0B300C8b34b9A5f7Ead85);
        // og.push(0x32E7709eC2b3346cdf13E07060D4e2DFfd898685);
        // og.push(0xEEfca716307f3472D3d3eAeb1bDeCe025188e593);
        // og.push(0xCdD25E0b5A045fA6F6f42Fc67Ed7E633283210A6);
        // og.push(0x1AfBbee59Df2389EE331EFA698Fa79F2968d4B5f);
        // og.push(0xA6a1283e30B1Cb51Bb28BE2C9435D7c509eF35AF);
        // og.push(0x49c539B40731681828fe69F6D6ac6485b05a02Bb);
        // og.push(0xc56c40BEB87949002F00b60E4Ef575DB1E5C9F3e);
        // og.push(0x8766B481ec28076b9C2590b58C9Cc9b733734Deb);
        // og.push(0x6667cbFaF2960D62A8Af2b4896674a008e351d9F);
        // og.push(0x2BeeFa8AdA17358D63eAaf88Aa6C2f7498130EE6);
        // og.push(0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA);
        // og.push(0x84130D507C245484ff63CfA780A39aE6ADe441bF);
        // og.push(0xfE627D675Cc3DbaBA38CaBb6fE9fB2A34b8206a9);
        // og.push(0x31e0D49c3dc594c24Ffc20B246bd2A4346c3eCD7);
        // og.push(0x3C593BEF8840Ef4a10E334415562Eb8a5894816E);
        // og.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // og.push(0x63e03E3e25d483D7e5c0B300C8b34b9A5f7Ead85);
        // og.push(0x6667cbFaF2960D62A8Af2b4896674a008e351d9F);
        // og.push(0x269b4c5537445ad08EBF6eA6D848a4866856778b);
        // og.push(0xB18Df5Be6A4F2B14099455B430a7846c80529951);
        // og.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // og.push(0x1AfBbee59Df2389EE331EFA698Fa79F2968d4B5f);
        // og.push(0x38201e227eC0624906f214F4Aa4Fa6F4Cf0D1d76);
        // og.push(0x1cBA385B069B39eDE98c555881ad76982B97B19c);
        // og.push(0xf3Afb94f15a7F2DD4f7BE08b6d8c452811792Fd5);
        // og.push(0xfE627D675Cc3DbaBA38CaBb6fE9fB2A34b8206a9);
        // og.push(0xc2096B0F5c19803A385DDd47B31dd08343f5422E);
        // og.push(0xE329E8e95B3Ed74cA80C0660644eF095F796B63a);
        // og.push(0x399323bf4aeDB46Dc5Ea80d44e4dD9Fd5c8DCdAc);
        // og.push(0xA4cf064D02E35Aed6340df50D0c9e121B16B1Bb6);
        // og.push(0x4B3800dC1E8a6ebd02CA5A9C4abc81cBb82E63c3);
        // og.push(0x42FE6ac6b89833044d867568dF66FE55DA5d8079);
        // og.push(0x52419d6bDc34A8447d81436a87671D496D37b746);
        // og.push(0x37667d93e047e1231e2CE3BC7a762dD36bCf6aFE);
        // og.push(0x925B51750770bD15d3477C95148D79ACD197AC8A);
        // og.push(0xc56c40BEB87949002F00b60E4Ef575DB1E5C9F3e);
        // og.push(0x897f1569a22Ab89ED2ED363acAF9b8613EDd27a7);
        // og.push(0xF7bbc8451720CDD5cFfF31CAd3b826d53E78d8c0);
        // og.push(0x2BeeFa8AdA17358D63eAaf88Aa6C2f7498130EE6);
        // og.push(0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA);
        // og.push(0xFfa61B72f6A61EC5fF6957bc352E4A44414EAA66);
        // og.push(0x84130D507C245484ff63CfA780A39aE6ADe441bF);
        // og.push(0x7bD42e6E503E296453555D5a3e59d67B4675daF6);
        // og.push(0xB538A75298F81c5aec361Dc827902e00fA17B4C2);
        // og.push(0xD8d788f4BaF491DB505A496f9BD5C1D566d1c30f);
        // og.push(0x0C8Df06bC11B39A3bEE2CD0bb816A592e65E52C8);
        // og.push(0x0cEe40f8D595e91c3b79CbaEe7403Ec361777462);
        // og.push(0xC12659432316dD89731220E4A309492F6a3f2629);
        // og.push(0x3a59842fBf20b54D84c3505fc206f5cF7b56f4d9);
        // og.push(0x580ed5585061923E5F4E3edc8038362485B452cd);
        // og.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // og.push(0xf3876B9E471B8EaA4e0B482e80Eb9bD819652284);
        // og.push(0x5D30dc36255aE4aD6022c7b8bA640e709993c4D4);
        // og.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // og.push(0xB6Ab6ED99c21A7317c607E9243510D89b6F4b91B);
        // og.push(0xc7468B7D4086D15bf13D025A663E46E38d945446);
        // og.push(0xEB9b9acDF515D141e818aB8234329e92775c8603);
        // og.push(0x35e8489eAfa4dc7f300E768deDd6f5227611e99f);
        // og.push(0x481f90fdaCE22dc9BBC454e285CE5e0957867DF6);
        // og.push(0x044Ffe4018944C0e309Ca0bd3e386F4d0190D379);
        // og.push(0xaEDF74546Caa4e1e13fAa01b153c1e8099d4623b);
        // og.push(0xCAb6193901887968cd656BBB15ffDE19b0eb1c37);
        // og.push(0xE329E8e95B3Ed74cA80C0660644eF095F796B63a);
        // og.push(0xa92838ed7C8e6A6CEe783f8583Ae4A7F0352cE3d);
        // og.push(0x15c64c9000ce544525A93Ccdb87F161C0368f80c);
        // og.push(0xf027828a6D9A0618A2f419AB71Db39cf2295f027);
        // og.push(0xeB14ec41019b42E2c15a7ac86FD026f9bCd89883);
        // og.push(0x44ABaa7FeD7684F5872939e2741EAbb727112010);
        // og.push(0x042985c1eB919748508b4AA028688DFE43b083aA);
        // og.push(0xEFd6E29eD1b602B4d0410bF008Bd667562DF1013);
        // og.push(0x974CCBEA8d50eCE1066b4533D6bCBC465F754161);
        // og.push(0xA31eE3270D637681488A33d9B5F4D2cD6BB9238B);
        // og.push(0xe959112d65f49D8FF7086EED0451e5B23E5DE807);
        // og.push(0xAe2fDf2eaF44bac2188dA7dA061968AAe4Ca41B5);
        // og.push(0x0C70fd88783036774598ecc3C53Acd5CDCE65a4e);
        // og.push(0xb22Ad0d340Dc2A1137fB07a1a953e810CeBb1417);
        // og.push(0x7C44633446085F35fbEAdd503E0B8d619C74D907);
        // og.push(0x073a1e05E32eDA11437EadC5E0f908a2Debe0a60);
        // og.push(0x65f5Ab40a657ED48423631636040Bc3bF97bc8ef);
        // og.push(0x80E551Ec6206F619F6cB4ee807184eD628f851a0);
        // og.push(0x76f1441F942d50CF19fB43AbB78E3977CdC06Ee3);
        // og.push(0xd2CB8abDCCb7ec6B0e605D372D94904051eF9F5B);
        // og.push(0xcd1fAA80b3292E16347F31590018446552C6708f);
        // og.push(0x5e65e345A145d2eCF31b0222aF5F13dB250cb254);
        // og.push(0xCF2cD1F063405A0b10561a615D4A349d08417a0f);
        // og.push(0x56CB938e4697243E59f3676b47fE48A1faA1f18a);
        // og.push(0xEEfca716307f3472D3d3eAeb1bDeCe025188e593);
        // og.push(0x6639F00249Db40c24e61bb5e4B980380603e7944);
        // og.push(0x45489bE197f0A64d07f68a7dc44b60038c3429Bd);
        // og.push(0xD3ae4f352505220142951C2bbcB005761432ADa2);
        // og.push(0xe1C9881B973b0D973b2f714B89055e270Fbf879e);
        // og.push(0x356E8dca95598C7A00cC3f198Af08762Ed57d050);
        // og.push(0x967b9E8bb5F0BC2245F2A90D72Cfa1f853A56848);
        // og.push(0x5013b2f1c3875f25dc298417eea1802010FDc9E5);
        // og.push(0xDdB0853D197B63ec935909a8C4CAa817512136Bd);
        // og.push(0x34B47F05fC99354DB03626EAC917348e385a64B8);
        // og.push(0xEEAE3942B76F3720a05c92A8280716f7Dd43b059);
        // og.push(0x9c352C3EaA9596e0055B2b0a625eB45b61273d04);
        // og.push(0x1A469Cd50d923a59cEb654D55FA300Cd4a84FB08);
        // og.push(0x75932A6DA9edd0726c1FFFBC7172B08fdE9Fc236);
        // og.push(0x3dd721fE6D0C229F611a0F484Eb768673d20C80c);
        // og.push(0x5eCAC4feFf27d45cf1755326fe4E4600cb75e655);
        // og.push(0x8A0e8A58e89C11f4F1a66a83a4C5ae5D35570585);
        // og.push(0x6d65c43D1F2A10185D1049DCCbDcEdB0572E9880);
        // og.push(0x4fD0d9898cf77108452244e45F35737cFBBC19DF);
        // og.push(0x2a7dA3360587CAF68434EB8E7103D10dbDF62233);
        // og.push(0x7b2372943568f19c6781ac4eb4a2Fb98206D42eD);
        // og.push(0xDf9601Afc81799916A571a20F7050199CB55bd81);
        // og.push(0xCA7a2FdC834B911b77BfBEcc96C50B7f181d342C);
        // og.push(0x123fFea5A1dbF4e4289173a2E455Db6180C235eb);
        // og.push(0x72E6930A54032cb80c3c3EF00bF1Fd8A73df1962);
        // og.push(0xd5190A43A96535f6fe19DA6dce3A05983f56634D);
        // og.push(0xfD6300Ac8F8D128D4ad4536d66b66a13CB7dA774);
        // og.push(0x1AED3799De8416Fc7B53E75c132B4f67e5Da20B3);
        // og.push(0xCdD25E0b5A045fA6F6f42Fc67Ed7E633283210A6);
        // og.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // og.push(0x7dB4ca2a8096C3711F1B3B00b440d021c50821D7);
        // og.push(0x77cb76F93Fb2a767831cc0ae2dF5023551A93270);
        // og.push(0xc56c40BEB87949002F00b60E4Ef575DB1E5C9F3e);
        // og.push(0x6Aa9D725a023651E415CD78E9f229bD39d4a01BA);
        // og.push(0x7bD42e6E503E296453555D5a3e59d67B4675daF6);
        // og.push(0xB538A75298F81c5aec361Dc827902e00fA17B4C2);
        // og.push(0xD8d788f4BaF491DB505A496f9BD5C1D566d1c30f);
        // og.push(0x0C8Df06bC11B39A3bEE2CD0bb816A592e65E52C8);
        // og.push(0x0cEe40f8D595e91c3b79CbaEe7403Ec361777462);
        // og.push(0xC12659432316dD89731220E4A309492F6a3f2629);
        // og.push(0x3a59842fBf20b54D84c3505fc206f5cF7b56f4d9);
        // og.push(0x580ed5585061923E5F4E3edc8038362485B452cd);
        // og.push(0x328A3f8bAE2fB255a86BcDEFE9710D045F1A7603);
        // og.push(0xf3876B9E471B8EaA4e0B482e80Eb9bD819652284);
        // og.push(0x5D30dc36255aE4aD6022c7b8bA640e709993c4D4);
        // og.push(0x6df1Fd18Aaa9F1DD745e6E3Afc3ff8522a556889);
        // og.push(0xB6Ab6ED99c21A7317c607E9243510D89b6F4b91B);
        // og.push(0xc7468B7D4086D15bf13D025A663E46E38d945446);
        // og.push(0xA31eE3270D637681488A33d9B5F4D2cD6BB9238B);
        // og.push(0xe959112d65f49D8FF7086EED0451e5B23E5DE807);
        // og.push(0xAe2fDf2eaF44bac2188dA7dA061968AAe4Ca41B5);
        // og.push(0x0C70fd88783036774598ecc3C53Acd5CDCE65a4e);
        // og.push(0xb22Ad0d340Dc2A1137fB07a1a953e810CeBb1417);
        // og.push(0x7C44633446085F35fbEAdd503E0B8d619C74D907);
        // og.push(0x073a1e05E32eDA11437EadC5E0f908a2Debe0a60);
        // og.push(0x65f5Ab40a657ED48423631636040Bc3bF97bc8ef);
        // og.push(0x80E551Ec6206F619F6cB4ee807184eD628f851a0);
        // og.push(0x76f1441F942d50CF19fB43AbB78E3977CdC06Ee3);
        // og.push(0xd2CB8abDCCb7ec6B0e605D372D94904051eF9F5B);
        // og.push(0xcd1fAA80b3292E16347F31590018446552C6708f);
        // og.push(0x5e65e345A145d2eCF31b0222aF5F13dB250cb254);
        // og.push(0xCF2cD1F063405A0b10561a615D4A349d08417a0f);
        // og.push(0x56CB938e4697243E59f3676b47fE48A1faA1f18a);
        // og.push(0xEEfca716307f3472D3d3eAeb1bDeCe025188e593);
        // og.push(0x6639F00249Db40c24e61bb5e4B980380603e7944);
        // og.push(0x45489Bea8d50ece1066B4533d6BcbC465F754161);
        // og.push(0xD3ae4f352505220142951C2bbcB005761432ADa2);
        // og.push(0xe1C9881B973b0D973b2f714B89055e270Fbf879e);
        // og.push(0x356E8dca95598C7A00cC3f198Af08762Ed57d050);
        // og.push(0x826a9158eCEbd405479f212A4836eB5E17880253);
        og.push(0x5A79B72e572427c86a28965206649cE9a12dfdfa);
        og.push(0x9228D10ddb805E338Fd2E9670d43996FEf89Ef6D);
        og.push(0x786235E5d2b1F2a8dd31D791d34726933FbA5004);
        og.push(0x1716Dc946d9264126412feDE8264E50E9d21c37a);
        og.push(0xCaF7DEF17e72fF1C9A298fB693899A5Ab3874117);
        og.push(0x80804B3f3a947053D0e930A231c732318c073aCF);
        og.push(0xa9b4bf6A5dc818fe20124012569BcfCcEBb40D77);
        og.push(0x48b81e5bD2a1312B6cfB353Ec9256d891248BAd0);
        og.push(0x924d924F243D9d0B30a93FFBAA45aEE119223BD8);

        _initialOGMinters = og;
        _initialWLMinters = wl;
    }
}
