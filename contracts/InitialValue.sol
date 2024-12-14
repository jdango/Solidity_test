// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract InitialValue {
    bool public _bool;
    string public _string;
    int public _int;
    bytes32 public _bytes32;
    uint public _uint;
    address public _address;

    enum ActionSet { Buy, Hold, Sell}
    ActionSet public _actionSet;

    function fi() internal{} 
    function fe() external{}

    uint[8] public _staticArray;
    uint[] public _dynamicArray;
    mapping (uint => address) public _mapping;

    struct Student {
        uint256 id;
        uint256 score;
    }
    Student public student;

    bool public _bool2 = true;
    function d() external {
        delete _bool2;
    }
}