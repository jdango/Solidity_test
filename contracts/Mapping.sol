// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract Mapping {
    mapping (uint => address) public idToAddress;
    mapping (address => address) public swapPair;

    function writeMap (uint _key, address _Value) public {
        idToAddress[_key] = _Value;
    }
    
    function readMap (uint key ) external view returns(address){
        return idToAddress[key];
    }
}