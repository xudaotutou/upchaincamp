// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
import { IERC20 } from "forge-std/interfaces/IERC20.sol";

interface TokenRecipient {
  function tokensReceived(address sender, uint amount) external returns (bool);
}
contract Vault is TokenRecipient {
  using SafeTransferLib for address;
  IERC20 immutable LYKT;
  mapping(address => uint) private accounts;
  error NotZero();
  error NotSuccess();
  error NotEnough();

  constructor(address lykt_address) {
    LYKT = IERC20(lykt_address);
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
    depositWithAddress(msg.sender, amount);
  }
  function tokensReceived(address sender,uint amount) external returns (bool) {
    depositWithAddress(sender, amount);
    return true;
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
