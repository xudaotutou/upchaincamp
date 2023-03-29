// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/LYKNFTMaket.sol";
import "../src/LYKNFT.sol";
import "../src/LYKToken.sol";

contract maketTest is Test {
  LYKTItem public nfttoken;
  LYKToken public token;
  LYKTItemMaket public maket;
  address owner;
  uint256 ownerpublickey;
  address other;
  uint256 otherpublickey;

  function setUp() public {
    token = new LYKToken();
    nfttoken = new LYKTItem();
    maket = new LYKTItemMaket(address(token), address(nfttoken));
    (owner, ownerpublickey) = makeAddrAndKey("Alice");
    (other, otherpublickey) = makeAddrAndKey("Bob");
    // changePrank(owner);
  }

  function testlist(uint256 amount) public {
    vm.assume(amount <= 100000e18);
    uint utfid = nfttoken.mint(owner, "https://www.baidu.com");

    changePrank(owner);
    nfttoken.approve(address(maket), utfid);
    maket.list(utfid, amount);
    assertEq(maket.balanceOf(utfid), amount);
  }

  function testBuy(uint256 amount) public {
    vm.assume(amount <= 100000e18);
    token.transfer(other, amount);
    uint utfid = nfttoken.mint(owner, "https://www.baidu.com");

    changePrank(owner);
    nfttoken.approve(address(maket), utfid);
    maket.list(utfid, amount);
    changePrank(other);
    token.approve(address(maket), amount);
    maket.buy(utfid, amount);
    assertEq(nfttoken.ownerOf(utfid), address(other));
  }

  function testBuyError() public {
    token.transfer(other, 1 ether);
    uint utfid = nfttoken.mint(owner, "https://www.baidu.com");
    assertEq(nfttoken.ownerOf(utfid), owner);
    changePrank(owner);
    nfttoken.approve(address(maket), utfid);
    maket.list(utfid, 1 ether);
    assertEq(maket.balanceOf(utfid), 1 ether);
    changePrank(other);
    token.approve(address(maket), 1 ether);
    maket.buy(utfid, 1 ether);
    assertEq(nfttoken.ownerOf(utfid), address(other));
  }
}
