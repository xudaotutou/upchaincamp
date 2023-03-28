// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { Vault } from "../src/Vault.sol";
import { LYKToken } from "../src/LYKToken.sol";

contract SigUtils {
  bytes32 internal DOMAIN_SEPARATOR;

  constructor(bytes32 _DOMAIN_SEPARATOR) {
    DOMAIN_SEPARATOR = _DOMAIN_SEPARATOR;
  }

  // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
  bytes32 public constant PERMIT_TYPEHASH =
    keccak256(
      "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
    );
  // 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

  struct Permit {
    address owner;
    address spender;
    uint256 value;
    uint256 nonce;
    uint256 deadline;
  }

  // computes the hash of a permit
  function getStructHash(
    Permit memory _permit
  ) internal pure returns (bytes32) {
    return
      keccak256(
        abi.encode(
          PERMIT_TYPEHASH,
          _permit.owner,
          _permit.spender,
          _permit.value,
          _permit.nonce,
          _permit.deadline
        )
      );
  }

  // computes the hash of the fully encoded EIP-712 message for the domain, which can be used to recover the signer
  function getTypedDataHash(
    Permit memory _permit
  ) public view returns (bytes32) {
    return
      keccak256(
        abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, getStructHash(_permit))
      );
  }
}

contract VaultTest is Test {
  LYKToken internal lyktoken;
  Vault internal vault;
  SigUtils internal sigUtils;

  address internal owner;
  uint256 internal ownerPrivateKey;

  function setUp() public {
    lyktoken = new LYKToken();
    vault = new Vault(address(lyktoken));

    sigUtils = new SigUtils(lyktoken.DOMAIN_SEPARATOR());
    ownerPrivateKey = 0xB0B;
    owner = vm.addr(ownerPrivateKey);
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

  function testPermit(uint256 amount) public {
    vm.assume(amount > 0);
    vm.assume(amount <= 100000e18);
    // 先给owner钱
    lyktoken.transfer(owner, amount);

    SigUtils.Permit memory permit = SigUtils.Permit({
      owner: owner,
      spender: address(vault),
      value: 100000e18,
      nonce: 0,
      deadline: 1 days
    });

    bytes32 digest = sigUtils.getTypedDataHash(permit);

    (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

    lyktoken.permit(owner, address(vault), 100000e18, 1 days, v, r, s);

    assertEq(lyktoken.allowance(owner, address(vault)), 100000e18);
    assertEq(lyktoken.nonces(owner), 1);
    vm.prank(owner);
    assertEq(vault.balanceOf(), 0);
    vm.prank(owner);
    vault.deposit(amount);
    vm.prank(owner);
    assertEq(vault.balanceOf(), amount);
  }

  function testPermitErr(uint256 amount) public {
    vm.assume(amount > 0);
    vm.assume(amount <= 100000e18);
    // 先给owner钱
    lyktoken.transfer(owner, amount);

    SigUtils.Permit memory permit = SigUtils.Permit({
      owner: owner,
      spender: address(vault),
      value: 100000e18,
      nonce: 0,
      deadline: 1 days
    });

    bytes32 digest = sigUtils.getTypedDataHash(permit);

    (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);
    // 签名错误
    vm.expectRevert("INVALID_SIGNER");
    lyktoken.permit(address(this), address(vault), 100000e18, 1 days, v, r, s);
    // 超时报错
    skip(1 days + 1 seconds);
    vm.expectRevert("PERMIT_DEADLINE_EXPIRED");
    lyktoken.permit(owner, address(vault), 100000e18, 1 days, v, r, s);
    
    // 重放攻击
    rewind(1 days);
    lyktoken.permit(owner, address(vault), 100000e18, 1 days, v, r, s);
    vm.expectRevert("INVALID_SIGNER");
    lyktoken.permit(owner, address(vault), 100000e18, 1 days, v, r, s);
  }
}
