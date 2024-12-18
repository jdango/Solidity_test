// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract Owner{
    address public owner;

    // 构造函数
    constructor(address initialOwner){
        owner = initialOwner;
    }

    // 定义 modifier 
    modifier onlyOwner(){
        require (msg.sender == owner,"Not allowed");
        _;
    }

    // 定义一个带 onlyOwner 修饰符的函数
    function changeOwner(address _newOwner) external onlyOwner{
        owner = _newOwner;
    }
}