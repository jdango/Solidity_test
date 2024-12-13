// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract ValueTypes{
    // bool,布尔型是二值变量,取值为 true 或者 false,包括 ! (逻辑非), && (逻辑与,"and"), || (逻辑或,"or"), == (等于), != (不等于)
    // 值得注意的是: && 和 || 运算符遵循短路规则,当逻辑与(&&)的第一个条件为 false 时,就不会再去判断第二个条件;当逻辑或(||)的第一个条件为 true 时,就不会去判断第二个条件
    bool public _bool = true;
    bool public _bool1 = !_bool;
    bool public _bool2 = _bool && _bool1;
    bool public _bool3 = _bool || _bool1;
    bool public _bool4 = _bool == _bool1;
    bool public _bool5 = _bool != _bool1;

    // 整数
    //比较运算符(返回布尔值): <= , < , == , != , >= , >
    //算术运算符: + , - , * , / , %(取余) ,**(幂)
    int public _int = -1;
    uint public _uint = 1;
    uint public _number = 20231213;
    //整数运算
    uint256 public _number1 = _number + 1;
    uint256 public _number2 = 2**2;
    uint256 public _number3 = 7 % 2;
    bool public _numberbool = _number2 > _number3;

    //地址
    address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    address payable public _address1 = payable (_address); // payable address, 可以转账,查余额
    //地址类型的成员
    uint256 public balance = _address1.balance; //balance of address

    // 固定长度的字节数组
    bytes32 public _byte32 = "MiniSolidity";
    bytes1 public _byte = _byte32[0];
}