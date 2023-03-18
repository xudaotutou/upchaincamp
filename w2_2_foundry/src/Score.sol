// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Ownerable.sol";
error InvaildScore();
error NotFoundStudent();
error AlreadyStudent();

contract Score is Ownerable(){
    // uint public score;
    mapping(address => uint) scores;

    // constructor() {
    //     // super.constructor();
    // }
    // 由于mapping默认是0，可以让存入的数据+1，0当作是未加入
    modifier mustExistStudent(address student) {
        if (scores[student] == 0) revert NotFoundStudent();
        _;
    }
    modifier mustVaildScore(uint _score) {
        if (_score < 0 || _score > 100) revert InvaildScore();
        _;
    }
    modifier mustNotExistSutdent(address student) {
        if (scores[student] != 0) revert AlreadyStudent();
        _;
    }

    function modifyScore(address student, uint _score)
        external
        mustVaildControl
        mustVaildScore(_score)
        mustExistStudent(student)
    {
        scores[student] = _score + 1;
    }

    function addScore(address student, uint _score)
        external
        mustVaildControl
        mustVaildScore(_score)
        mustNotExistSutdent(student)
    {
        scores[student] = _score + 1;
    }

    function getMyScore()
        external
        view
        mustExistStudent(msg.sender)
        returns (uint _score)
    {
        _score = scores[msg.sender] - 1;
    }

    function getScore(address student)
        external
        view
        mustExistStudent(student)
        returns (uint _score)
    {
        _score = scores[student] - 1;
    }
}
