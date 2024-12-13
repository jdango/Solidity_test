// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract StructTypes {
    struct Student{
        uint256 id;
        uint256 score; 
    }
   Student student;
   function initStudent() external{
        student.id = 100;
        student.score = 200;
        Student storage _student = student;
        _student.id = 300;
        _student.score = 400;
    }
}