// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/LYKToken.sol";

contract VaultTest is Test {
    LYKToken immutable lyktoken;
    Vault immutable vault;
    
    function setUp() public {
        lyktoken = new LYKToken();
        vault = new Vault(address(lyktoken));
    }

    function testDeposit() public {
        lyktoken.approve()
        // counter.increment();
        // assertEq(counter.number(), 1);
    }

    function testWithdraw(uint256 x) public {
        counter.setNumber(x);
        // assertEq(counter.number(), x);
    }
}