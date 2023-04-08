// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";
contract VaultScript is Script {
    function setUp() public {}

    function run() public {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address token_address = vm.envAddress("TOKEN_ADDRESS");
        console.log(deployerPrivateKey);
        console.log(vm.envString("ETHERSCAN_API_KEY"));
        console.log(token_address);
        vm.startBroadcast(deployerPrivateKey);

        Vault bank = new Vault(token_address);

        vm.stopBroadcast();
    }
}

