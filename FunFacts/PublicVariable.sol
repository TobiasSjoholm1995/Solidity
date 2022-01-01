// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Fun Fact: 
// Public variables automatically gets a getter function by the compiler
// (No setter)


contract PublicVariable {

    uint256 public MyValue = 5;


    function test() external view returns (uint) {

        // property access within the contract;
        uint v1 = MyValue;

        PublicVariable thisContract = PublicVariable(this);

        // function access outside the contract 
        uint v2 = thisContract.MyValue();
        
        // function access with the 'this' keyword 
        uint v3 = this.MyValue();

        return v1 + v2 + v3;
    }
    
}

