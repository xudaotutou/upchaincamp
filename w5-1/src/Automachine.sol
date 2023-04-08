// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {AutomationCompatibleInterface} from "chainlink/interfaces/automation/AutomationCompatibleInterface.sol";

interface IBank {
    function collect() external;
}

contract AutoCollectUpKeep is AutomationCompatibleInterface {
    address public immutable token;
    address public immutable bank;

    constructor(address _token, address _bank) {
        token = _token;
        bank = _bank;
    }

    function checkUpkeep(bytes calldata checkData)
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {

        if (IERC20(token).balanceOf(bank) > 100e18) {
            upkeepNeeded = true;
        }
    }

    function performUpkeep(bytes calldata performData) external override {
        if (IERC20(token).balanceOf(bank) > 100e18) {
            IBank(bank).collect();
        }
    }
}
