// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Counter {
    uint256 number = 0;

    function add(uint256 num) public {
        number += num;
    }

    function retrieve() public view returns (uint256) {
        return numb
    }

    function reset() public {
        number = 0;
    }
}
