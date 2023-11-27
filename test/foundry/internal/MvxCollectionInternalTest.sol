// SPDX-License-Identifier: MIT O
pragma solidity ^0.8.20;

import {Test, console, console2, Vm, StdUtils} from "forge-std/Test.sol";

import {Stages, Collection, Partner, Member, Artist} from "@src/libs/MvxStruct.sol";
import {MvxCollection} from "@src/MvxCollection.sol";
import {Test, console2, Vm} from "@forge-std/Test.sol";

error InvalidColletion(uint8);

contract CalldataCaller is MvxCollection {
    function testing(Stages calldata _stages) public {
        // super._validateStages(_stages);
    }
}

contract MvxCollectionInternalTest is Test {
    Stages public _stages;

    function _getTime(uint8 _days) internal returns (uint256) {
        return block.timestamp + (60 * 60 * 24 * _days);
    }

    function test_validateStages() public {
        uint256 _ogMintStart = block.timestamp;
        uint256 _ogMintEnd = block.timestamp + 1 days;
        uint256 _whitelistMintStart = block.timestamp + 1 days;
        uint256 _whitelistMintEnd = block.timestamp + 2 days;
        uint256 _mintStart = block.timestamp + 2 days;
        uint256 _mintEnd = block.timestamp + 7 days;

        _stages = Stages({
            isMaxSupplyUpdatable: true,
            ogMintPrice: 1 ether,
            whitelistMintPrice: 1 ether,
            mintPrice: 1 ether,
            mintMaxPerUser: 200,
            ogMintMaxPerUser: 200,
            mintStart: uint40(_mintStart),
            mintEnd: uint40(_mintEnd),
            ogMintStart: uint40(_ogMintStart),
            ogMintEnd: uint40(_ogMintEnd),
            whitelistMintStart: uint40(_whitelistMintStart),
            whitelistMintEnd: uint40(_whitelistMintEnd),
            whitelistMintMaxPerUser: 200
        });
        CalldataCaller called = new CalldataCaller();
        // called.testing(_stages);
    }

    function test_fuzz_validateStages(
        uint256 _ogMintStart,
        uint256 _ogMintEnd,
        uint256 _whitelistMintStart,
        uint256 _whitelistMintEnd,
        uint256 _mintStart,
        uint256 _mintEnd
    ) public {
        vm.warp(block.timestamp + 18606694);
        _ogMintStart = bound(_ogMintStart, _getTime(1), _getTime(2) - 1);
        _ogMintEnd = bound(_ogMintEnd, _getTime(2), _getTime(3));
        _whitelistMintStart = bound(_whitelistMintStart, _getTime(3), _getTime(4) - 1);
        _whitelistMintEnd = bound(_whitelistMintEnd, _getTime(4), _getTime(5));
        _mintStart = bound(_mintStart, _getTime(5), _getTime(6) - 1);
        _mintEnd = bound(_mintEnd, _getTime(6), _getTime(7));

        _stages = Stages({
            isMaxSupplyUpdatable: true,
            ogMintPrice: 1 ether,
            whitelistMintPrice: 1 ether,
            mintPrice: 1 ether,
            mintMaxPerUser: 200,
            ogMintMaxPerUser: 200,
            mintStart: uint40(_mintStart),
            mintEnd: uint40(_mintEnd),
            ogMintStart: uint40(_ogMintStart),
            ogMintEnd: uint40(_ogMintEnd),
            whitelistMintStart: uint40(_whitelistMintStart),
            whitelistMintEnd: uint40(_whitelistMintEnd),
            whitelistMintMaxPerUser: 200
        });
        CalldataCaller called = new CalldataCaller();
        // called.testing(_stages);
    }

    function test_fuzz_valid_stages_no_og(
        uint256 _whitelistMintStart,
        uint256 _whitelistMintEnd,
        uint256 _mintStart,
        uint256 _mintEnd
    ) public {
        _whitelistMintStart = bound(_whitelistMintStart, _getTime(1), _getTime(2) - 1);
        _whitelistMintEnd = bound(_whitelistMintEnd, _getTime(2), _getTime(3));
        _mintStart = bound(_mintStart, _getTime(3), _getTime(4) - 1);
        _mintEnd = bound(_mintEnd, _getTime(4), _getTime(5));

        _stages = Stages({
            isMaxSupplyUpdatable: true,
            ogMintPrice: 1 ether,
            whitelistMintPrice: 1 ether,
            mintPrice: 1 ether,
            mintMaxPerUser: 200,
            ogMintMaxPerUser: 200,
            mintStart: uint40(_mintStart),
            mintEnd: uint40(_mintEnd),
            ogMintStart: uint40(0),
            ogMintEnd: uint40(0),
            whitelistMintStart: uint40(_whitelistMintStart),
            whitelistMintEnd: uint40(_whitelistMintEnd),
            whitelistMintMaxPerUser: 200
        });
        CalldataCaller called = new CalldataCaller();
        // called.testing(_stages);
    }

    function test_fuzz_valid_stages_no_wl(
        uint256 _ogMintStart,
        uint256 _ogMintEnd,
        uint256 _mintStart,
        uint256 _mintEnd
    ) public {
        _ogMintStart = bound(_ogMintStart, _getTime(1), _getTime(2) - 1);
        _ogMintEnd = bound(_ogMintEnd, _getTime(2), _getTime(3));
        _mintStart = bound(_mintStart, _getTime(3), _getTime(4) - 1);
        _mintEnd = bound(_mintEnd, _getTime(4), _getTime(7));

        _stages = Stages({
            isMaxSupplyUpdatable: true,
            ogMintPrice: 1 ether,
            whitelistMintPrice: 1 ether,
            mintPrice: 1 ether,
            mintMaxPerUser: 200,
            ogMintMaxPerUser: 200,
            mintStart: uint40(_mintStart),
            mintEnd: uint40(_mintEnd),
            ogMintStart: uint40(_ogMintStart),
            ogMintEnd: uint40(_ogMintEnd),
            whitelistMintStart: uint40(0),
            whitelistMintEnd: uint40(0),
            whitelistMintMaxPerUser: 200
        });
        CalldataCaller called = new CalldataCaller();
        // called.testing(_stages);
    }

    function test_fuzz_valid_stages_no_public(
        uint256 _whitelistMintStart,
        uint256 _whitelistMintEnd,
        uint256 _ogMintStart,
        uint256 _ogMintEnd
    ) public {
        _ogMintStart = bound(_ogMintStart, _getTime(1), _getTime(2) - 1);
        _ogMintEnd = bound(_ogMintEnd, _getTime(2), _getTime(3));
        _whitelistMintStart = bound(_whitelistMintStart, _getTime(3), _getTime(4) - 1);
        _whitelistMintEnd = bound(_whitelistMintEnd, _getTime(4), _getTime(5));

        _stages = Stages({
            isMaxSupplyUpdatable: true,
            ogMintPrice: 1 ether,
            whitelistMintPrice: 1 ether,
            mintPrice: 1 ether,
            mintMaxPerUser: 200,
            ogMintMaxPerUser: 200,
            mintStart: uint40(0),
            mintEnd: uint40(0),
            ogMintStart: uint40(_ogMintStart),
            ogMintEnd: uint40(_ogMintEnd),
            whitelistMintStart: uint40(_whitelistMintStart),
            whitelistMintEnd: uint40(_whitelistMintEnd),
            whitelistMintMaxPerUser: 200
        });
        CalldataCaller called = new CalldataCaller();
        // called.testing(_stages);
    }
}
