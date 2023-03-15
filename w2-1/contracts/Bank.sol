// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

contract Bank {
  mapping (address => uint) private accounts;
  constructor() {
  }
  function deposit() payable public{
    require(msg.value > 0 wei, "save too less");
    accounts[msg.sender] += msg.value;
  }
  function balanceOf() public view returns(uint) {
    return accounts[msg.sender];
  }
  function withdraw() payable public {
    require(accounts[msg.sender] > 0 wei, "withdraw too more");
    address payable account = payable(msg.sender);
    uint money = accounts[msg.sender];
    accounts[msg.sender] = 0 ether;
    account.transfer(money);
  }
}