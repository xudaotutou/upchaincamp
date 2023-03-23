// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { Vault } from "../src/Vault.sol";
import { LYKToken } from "../src/LYKToken.sol";

contract VaultTest is Test {
  LYKToken lyktoken;
  Vault vault;

  function setUp() public {
    lyktoken = new LYKToken();
    vault = new Vault(address(lyktoken));
  }

  function testDeposit(uint256 amount) public {
    vm.assume(amount > 0);
    vm.assume(amount <= 100000 * 10 ** 18);
    lyktoken.approve(address(vault), amount);
    vault.deposit(amount);
    assertEq(vault.balanceOf(), amount);
    // counter.increment();
    // assertEq(counter.number(), 1);
  }
  function testDepositErr() public {
    lyktoken.approve(address(vault), 10);
    vm.expectRevert(abi.encodeWithSelector(Vault.NotZero.selector));
    vault.deposit(0);

    lyktoken.approve(address(vault), 10);
    vault.deposit(5);
    vm.expectRevert(abi.encodeWithSelector(Vault.NotSuccess.selector));
    vault.deposit(10000 * 10 ** 18);
    vm.expectRevert(abi.encodeWithSelector(Vault.NotSuccess.selector));
    vault.deposit(1000000 * 10 ** 18);
    assertEq(vault.balanceOf(), 5);
  }
  function testWithdraw(uint256 x, uint256 y) public {
    vm.assume(x > 0 && x <= 100000 * 10 ** 18);
    vm.assume(y > 0 && y <= x);
    lyktoken.approve(address(vault), x);
    assertEq(lyktoken.allowance(address(this), address(vault)), x);
    vault.deposit(x);
    assertEq(lyktoken.allowance(address(this), address(vault)), 0);
    vault.withdraw(y);
    assertEq(vault.balanceOf(), x - y);
    assertEq(lyktoken.balanceOf(address(this)), 100000 * 10 ** 18 - x + y);
    assertEq(lyktoken.balanceOf(address(vault)), x - y);
  }
}
// contract ScoreTest is Test {
//     Score public score;
//     address payable[] internal users;

//     function setUp() public {
//         score = new Score();

//         users = new address payable[](10);
//         for (uint256 i = 0; i < 10; i++) {
//             address payable newAddress = payable(
//                 address(
//                     bytes20(
//                         keccak256(
//                             abi.encodePacked(
//                                 block.timestamp,
//                                 block.difficulty,
//                                 i
//                             )
//                         )
//                     )
//                 )
//             );
//             vm.deal(newAddress, 100 ether);
//             users[i] = newAddress;
//         }
//     }

//     function testAddScore(uint _score) public {
//         vm.assume(_score >= 0);
//         vm.assume(_score <= 100);
//         address payable alice = users[0];
//         score.addScore(alice, _score);
//         assertEq(score.getScore(alice), _score);
//     }

//     function testAddScoreError() public {
//         address payable alice = users[0];
//         address payable bob = users[1];
//         // 先插入一个成功的，用来判断是否存在
//         score.addScore(bob, 10);

//         // score.addScore(alice, 1000);
//         // 1个报错
//         vm.expectRevert(abi.encodeWithSelector(InvaildScore.selector));
//         score.addScore(alice, 1000);

//         vm.expectRevert(abi.encodeWithSelector(InvaildControl.selector));
//         vm.prank(alice);
//         score.addScore(alice, 100);

//         vm.expectRevert(abi.encodeWithSelector(AlreadyStudent.selector));
//         score.addScore(bob, 10);

//         // 3个报错
//         vm.expectRevert(abi.encodeWithSelector(InvaildControl.selector));
//         vm.prank(alice);
//         score.addScore(bob, 1000);

//         // right + <100
//         vm.expectRevert(abi.encodeWithSelector(InvaildControl.selector));
//         vm.prank(alice);
//         score.addScore(alice, 1000);

//         // right + not exist
//         vm.expectRevert(abi.encodeWithSelector(InvaildControl.selector));
//         vm.prank(alice);
//         score.addScore(bob, 100);

//         // not exist + <100
//         vm.expectRevert(abi.encodeWithSelector(InvaildScore.selector));
//         score.addScore(bob, 1000);
//     }

//     function testModify(uint _score) public {
//         vm.assume(_score <= 100);
//         score.addScore(users[0], 0);
//         score.modifyScore(users[0], _score);
//         assertEq(score.getScore(users[0]), _score);
//     }

//     function testModifyError() public {
//         address payable alice = users[0];
//         score.addScore(alice, 10);
//         //1个错误
//         vm.expectRevert(abi.encodeWithSelector(InvaildScore.selector));
//         score.modifyScore(alice, 1000);

//         vm.expectRevert(abi.encodeWithSelector(InvaildControl.selector));
//         vm.prank(alice);
//         score.modifyScore(alice, 100);

//         // 3个错误
//         vm.expectRevert(abi.encodeWithSelector(NotFoundStudent.selector));
//         score.modifyScore(users[2], 10);

//         // 两两组合
//         // right + <100
//         vm.expectRevert(abi.encodeWithSelector(InvaildControl.selector));
//         vm.prank(alice);
//         score.modifyScore(alice, 1000);
//         // exist + <100
//         vm.expectRevert(abi.encodeWithSelector(InvaildScore.selector));
//         score.modifyScore(users[2], 1000);
//         // exist + right
//         vm.expectRevert(abi.encodeWithSelector(InvaildControl.selector));
//         vm.prank(alice);
//         score.modifyScore(users[2], 100);
//     }

//     function testGetMyScore(uint _score) public {
//         vm.assume(_score <= 100);
//         score.addScore(address(this), _score);
//         assertEq(score.getMyScore(), _score);
//     }

//     function testGetScore(uint _score) public {
//         vm.assume(_score < 100);
//         score.addScore(users[0], _score);
//         assertEq(score.getScore(users[0]), _score);
//     }
// }