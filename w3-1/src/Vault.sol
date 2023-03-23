// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "std-interfaces";
import { SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
import { LYKToken } from "./LYKToken.sol";

// interface IERC2612 is IERC20 {
//     function permit(
//         address owner,
//         address spender,
//         uint256 value,
//         uint256 deadline,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external virtual;
//     function DOMAIN_SEPARATOR() external view virtual returns (bytes32);
// }
// import "forge-std";
contract Vault is Icb {
  using SafeTransferLib for address;
  LYKToken immutable LYKT;
  mapping(address => uint) private accounts;
  error NotZero();
  error NotSuccess();
  error NotEnough();

  constructor(address lykt_address) {
    LYKT = LYKToken(lykt_address);
  }

  modifier BalanceNotZero() {
    if (accounts[msg.sender] == 0 wei) revert NotZero();
    _;
  }
  modifier AmountNotZero(uint amount) {
    if (0 == amount) revert NotZero();
    _;
  }
  modifier BalanceNotEnough(uint amount) {
    if (accounts[msg.sender] < amount) revert NotEnough();
    _;
  }

  receive() external payable {
    revert NotSuccess();
  }

  function deposit(uint amount) external AmountNotZero(amount) {
    depositWithAddress(msg.sender, amount)
  }
  function depositWithAddress(address account, uint amount) public AmountNotZero(amount) {
    try LYKT.transferFrom(account, address(this), amount) {
      accounts[account] += amount;
    } catch {
      revert NotSuccess();
    }
  }
  function balanceOf() external view returns (uint) {
    return accounts[msg.sender];
  }

  function withdraw(
    uint amount
  ) external AmountNotZero(amount) BalanceNotEnough(amount) {
    accounts[msg.sender] -= amount;
    try LYKT.transfer(msg.sender, amount) {

    } catch {
      revert NotSuccess();
    }
  }
}
