// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IScore {
    function modifyScore(address student, uint256 _score) external;

    function addScore(address name, uint256 _score) external;

    function getMyScore() external view;

    function getScore(address student) external view returns (uint256);
}
