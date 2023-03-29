// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/LYKNFT.sol";

contract LYKTItemTest is Test {
    LYKTItem public token;
    address owner;
    uint256 ownerpublickey;
    function setUp() public {
        token = new LYKTItem();
        (owner, ownerpublickey) = makeAddrAndKey("Alice");
        changePrank(owner);
    }

    function testMint() public {
      token.mint(owner, "https://www.baidu.com");
      assertEq(token.balanceOf(owner), 1);
      // assertEq(token.)
      assertEq(token.ownerOf(0), owner);
    }
}


