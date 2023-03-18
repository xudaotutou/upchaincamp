// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;
    address owner;

    constructor() {
        owner = msg.sender;
    }
    modifier isOwner {
        require(owner == msg.sender);
        _;
    }
    function setNumber(uint256 newNumber) public isOwner{
        number = newNumber;
    }

    function increment() public isOwner {
        number++;
    }
}
