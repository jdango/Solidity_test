// SPDX-License-Identifier: MIT
//函数的形式:function <function name>(<parameter types>) {internal|external|public|private} [pure|view|payable] [returns (<return types>)]
// 1. function: 声明函数时的固定用法
// 2. <function name>: 函数名
// 3. (<parameter types>): 圆括号内写入函数的参数,即输入到函数的变量类型和名称
// 4. {internal | external | public | private}: 函数可见性说明符,共 4 种
// - public: 内部外部均可见
// - private: 只能从合约内部访问,继承的合约也不能使用
// - external: 只能从合约外部访问(但内部可以用过 this.f() 来调用, f 是函数名)
// - internal: 只能从合约内部访问,继承的合约可以用
// 5. [pure | view | payable]: 决定函数权限/功能的关键字
// 6. [returns()]: 函数返回的变量类型和名称
pragma solidity ^0.8.21;
contract FunctionTypes{
    uint256 public number = 5;

    function add() external {
        number = number + 1;
    }

    // pure 纯牛马
    function addPure(uint256 _number) external  pure returns (uint256 new_number){ //the 'external' is optional   
        new_number = _number + 1;
    }

    //view 只读
    // view 可以通过函数名调用
    function addView() external view returns (uint256 new_number){// the view keyword makes the
    // function read-only
        new_number = number + 1;
    }

    //合约内的函数可以调用内部函数
    function minus() internal {
        number = number - 1;
    }

    function minusCall() external {
        minus();
    }

    // payable: 能给合约支付 eth 的函数
    function minusPayable() external payable returns (uint256 balance) {
        minus();
        balance = address(this).balance;
    }
}