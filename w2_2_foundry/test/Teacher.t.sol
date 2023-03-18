// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Teacher.sol";
import "../src/Score.sol";

contract TeacherTest is Test, Teacher {
    Teacher public teacher;
    address payable[] internal users;
    function setUp() public {
        teacher = new Teacher();

        users = new address payable[](10);
        for (uint256 i = 0; i < 10; i++) {
            address payable newAddress = payable(
                address(
                    bytes20(
                        keccak256(
                            abi.encodePacked(
                                block.timestamp,
                                block.difficulty,
                                i
                            )
                        )
                    )
                )
            );
            vm.deal(newAddress, 100 ether);
            users[i] = newAddress;
        }
    }

    function testAddStudent() public {
        teacher.addStudent(users[0], 10);
        // vm.expectEmit(true, false, false, false);
        // emit Submit(0);
        // multisig.submit(address(owner2), 1 ether, "");
    }

    function testaddStudent(uint _score) public {
        vm.assume(_score >= 0);
        vm.assume(_score <= 100);
        address payable alice = users[0];
        vm.expectEmit(false, false, false, false);
        emit InvokeSuccess();
        teacher.addStudent(alice, _score);
        uint score = teacher.getStudent(alice);
        assertEq(score, _score);
    }
}
