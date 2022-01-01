// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Fun Fact: 
// Public variables automatically gets a getter function by the compiler
// (No setter)


contract PublicVariable {

    uint256 public MyNumber = 5;

    uint256[] public myArray = [1,2,3,4,5];


    function testNumber() external view returns (uint) {

        // property access within the contract;
        uint v1 = MyNumber;

        PublicVariable thisContract = PublicVariable(this);

        // function access outside the contract 
        uint v2 = thisContract.MyNumber();
        
        // function access with the 'this' keyword 
        uint v3 = this.MyNumber();

        return v1 + v2 + v3;
    }

    
    function testArray() external view returns (uint) {
        PublicVariable thisContract = PublicVariable(this);

        // arrays automatically get an function that takes an parameter as input, the index 
        uint index = 2;
        uint value = thisContract.myArray(index);
        
        return value;
    }
    
}

