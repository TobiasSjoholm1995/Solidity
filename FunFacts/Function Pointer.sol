// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Fun Fact: 
// This shows how a function pointer can be used in solidity.
// In the documentation they call it the 'function type' 

contract FunctionPointer {

    uint public Value;

    // our function pointer variable
    function() returns (uint256) func;


    function setValue1() private pure returns (uint256) { return 1; }

    function setValue2() private pure returns (uint256) { return 2; }


    function CallMe() external {
        if (func == setValue1)
            func = setValue2;
        else
            func = setValue1;

        execute(func);        
    }


    // dummy method to show how the function pointer can be used as parameter
    function execute(function() returns (uint256) f) private {
        Value = f();
    }
}


// note that function pointers can be used in Structs as well
