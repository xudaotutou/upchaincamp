// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

contract Bank {
    mapping(address => uint) private accounts;
    error NotZero();
    error NotSuccess();
    error NotEnough();

    constructor() {}

    modifier BalanceNotZero() {
        if (accounts[msg.sender] == 0 wei) revert NotZero();
        _;
    }
    modifier AmountNotZero(uint amount) {
        if (0 == amount) revert NotZero();
        _;
    }
    modifier BalanceNotEnough(uint amount) {
        if (balanceOf() < amount) revert NotEnough();
        _;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable AmountNotZero(msg.value) {
        accounts[msg.sender] += msg.value;
    }

    function transferTo(address to, uint amount)
        public
        AmountNotZero(amount)
        BalanceNotEnough(amount)
    {
        accounts[msg.sender] -= amount;
        accounts[to] += amount;
    }

    function balanceOf() public view returns (uint) {
        return accounts[msg.sender];
    }

    function withdrawSome(uint amount)
        public
        AmountNotZero(amount)
        BalanceNotEnough(amount)
    {
        accounts[msg.sender] -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) revert NotSuccess();
    }

    function withdraw() public BalanceNotZero {
        uint money = accounts[msg.sender];
        accounts[msg.sender] = 0 ether;
        (bool success, ) = payable(msg.sender).call{value: money}("");
        if (!success) revert NotSuccess();
    }
}
