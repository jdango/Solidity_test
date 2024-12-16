// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract Constant {
    // constant 变量必须在声明的时候初始化,之后不能变化
    uint256 public constant CONSTANT_NUM = 43971;
    string public constant CONSTANT_STRING = "0xAA";
    bytes public constant CONSTANT_BYTES = "WTF";
    address public constant CONSTANT_ADDRESS = 0x0000000000000000000000000000000000000000;

    // immutable 变量可以在 constructor 里初始化,之后不能变化
    uint256 public immutable IMMUTABLE_NUM = 1897341 ;
    address public immutable IMMUTABLE_ADDRESS;
    uint256 public immutable IMMUTABLE_BLOCK;
    uint256 public immutable IMMUTABLE_TEST;

    //利用 constructor 初始化 immutable变量,因此可以利用
    constructor(){
        IMMUTABLE_ADDRESS = address(this);
        IMMUTABLE_NUM = 110;
        IMMUTABLE_TEST = test();
    }

    function test() public pure returns (uint256) {
        uint256 what = 9;
        return what ;
    }
}