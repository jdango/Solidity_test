// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract ArrayTypes {

    // 固定长度 Array
    uint[8] array1;
    bytes[5] array2;
    address[100] array3;

    //可变长度 Array
    uint[] array4 = [1,2,3];
    string[] array5 = ["a","b"] ;
    bytes1[] array6;
    address[] array7;
    bytes array8;

    //初始化可变长度 Array
    uint[] array9 = new uint[](5);
    bytes array10 = new bytes(9);

    //给可变长度数组赋值
    function iniArray() external pure returns (uint[] memory){
        uint[] memory x = new uint[](3);
        x[0] = 2;
        x[1] = 4;
        x[2] = 6; 
        return x ;
    }

    function arrayPush() public returns (uint[] memory) {
        uint[2] memory a = [uint(1), 2];
        array4 = a;
        array4.push(3);
        return array4 ;
    }
}

pragma solidity ^0.8.21;
contract StructTypes {
    // 结构体 Struct
    struct Student{
        uint256 id;
        uint256 score;
    }
    Student student; //初始化一个 student 结构体
    //给结构体赋值
    // 方法 1: 在函数中创造一个 storage 的 struct 引用
    function initStudent1() external  {
        Student storage _student = student; // assign a copy of student
        _student.id = 11;
        _student.score = 100;
    }

    // 方法 2: 直接引用状态变量的 struct
    function iniStudent2() external {
        student.id = 5648739 ;//可以不用 _student storage 声明
        student.score = 10;
    }

    // 方法 3: 构造函数式
    function iniStudent3() external {
        student = Student(5648739,2);//可以不用 _student storage 声明
        student.score = 10;
    }

    // 方法 4: key value
    function inistudent4() external {
        student = Student({id:4, score:100});
    }
}

pragma solidity ^0.8.21;
contract EnumTypes {
    // 将 uint 0,1,2 表示为 Buy, Hold, Sell
    enum ActionSet { Buy, Hold, Sell }
    // 创建 enum 变量 action
    ActionSet action = ActionSet.Buy;

    function enumToUint () external view returns (uint) {
        return uint(action);
    }
}