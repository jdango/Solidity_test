// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract DataStorage{
    uint[] public x = [1,2,3];

    function fStorage() public {
        uint[] storage xStorage = x;
        xStorage[0] = 100;
    }

    function fMemory() public view {
        uint[] memory xMemory = x;
        xMemory[0] = 100;
        xMemory[1] = 200;
        uint[] memory xMemory2 = x;
        xMemory2[3] = 300;
    }

    function fCalldata(uint[] calldata _x) public pure returns (uint[] calldata){
        return _x;
    }
}

contract Variables {
    uint public x = 1;
    uint public y;
    string public z;

    function foo() external {
        x = 5;
        y = 2;
        z = "0xAA";
    }

    function bar() external pure returns (uint){
        uint xx = 1;
        uint yy = 3;
        uint zz = xx + yy;
        return zz;
    }

    function global() external view returns (address, uint, bytes memory){
        address sender = msg.sender;
        uint blockNum = block.number;
        bytes memory data = msg.data;
        return (sender, blockNum,data);
    }

    function weiUint() external pure returns (uint) {
        assert(1 wei == 1e0);
        assert(1 wei == 1);
        return 1 wei;
    }

    function gweiUint() external pure returns (uint) {
        assert(1 gwei == 1e9);
        assert(1 gwei == 1000000000);
        return 1 gwei;
    }

    function etherUint() external pure returns (uint) {
         assert(1 ether == 1e18);
         assert(1 ether == 10000000000000000000);
         return 1 ether;
    }

    function secondsUint() external  pure  returns (uint){
        assert(1 seconds == 1);
        return 1 seconds;
    }

    function minutesUint() external  pure  returns (uint) {
        assert(1 minutes == 60);
        assert(1 minutes == 60 seconds);
        return 1 minutes;
    }

    function hoursUint() external  pure  returns (uint){
         assert(1 hours ==  3600);
         //assert(1 hours=== 528974 );
         assert(1 hours == 60 minutes);
         return 1 hours;
    }

    function daysUint() external pure returns (uint){
        assert(1 days ==  3600 seconds * 24);
        //assert(1 days===8975 );
        assert(1 days == 60 minutes * 24 hours);
        assert(1 days == 86400);
        return 1 days;
    }

    function weeksUint() external pure returns (uint) {
        assert(1 weeks == 604800);
        assert(1 weeks == 7 days);
        return 1 weeks;
    }
}