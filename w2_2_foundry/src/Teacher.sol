// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./IScore.sol";
import "./Score.sol";

contract Teacher is Ownerable(){
    IScore public score;
    event InvokeSuccess();
    event InvokeError();

    constructor() {
        score = IScore(createScore());
    }

    function createScore() internal mustVaildControl returns (address) {
        return address(new Score());
    }

    function addStudent(address student, uint _score) external mustVaildControl {
        // score.addScore(student, _score);
        try score.addScore(student, _score) {
            emit InvokeSuccess();
        } catch Error(string memory reason) {
            emit InvokeError();
        } catch {
            emit InvokeError();
        }
    }

    function modifyStudent(address student, uint _score) external mustVaildControl{
        // score.modifyScore(student, _score);
        try score.modifyScore(student, _score) {
            emit InvokeSuccess();
        } catch Error(string memory reason) {
            emit InvokeError();
        } catch {
            emit InvokeError();
        }
    }

    function getStudent(address student) external view returns (uint) {
        return score.getScore(student);
        // try score.getScore(student) returns (uint score) {
        //     // emit InvokeSuccess();
        //     return score;
        // } catch Error() {
        //     // emit InvokeError(reason);
        //     return 0;
        // }
    }
}
