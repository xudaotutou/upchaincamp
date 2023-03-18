// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
error InvaildControl();

contract Ownerable {
    address owner;
    constructor() {
        owner = msg.sender;
    }
    modifier mustVaildControl() {
        // todo!
        if (msg.sender != owner) revert InvaildControl();
        _;
    }
}