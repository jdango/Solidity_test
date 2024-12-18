// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract Event{
    // 定义 balances 映射变量,记录每个地址的持币数量
    mapping (address=>uint) public balanceOf;

    // 定义 transfer event,记录 transfer 交易的转账地址,接收地址和转账数量
    event Transfer(address indexed from, address indexed to, uint amount);

    // 定义_transfer 函数,执行转账逻辑
    function _transfer(address _from, address _to, uint _amount) external {
        balanceOf[_from] = 1000000;
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(_from, _to, _amount);
    }
}