// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Fun Fact: 
// This is how array slicing works in solidity.
// It currently only works on calldata arrays.


// throws error if array index is out of bounds
// array slicing only possible on calldata arrays

contract ArraySlicing {


    // Note: you need to use the the brackets [] in Remix
    // to make sure that its interpret the input as an array and not multiple numbers.
    function Slice(uint[] calldata x) public pure returns (uint[] memory) {
        // x[start:end] 
        // including start and exclusive end

        return x[2:4];
        
        // input = [0,1,2,3,4,5,6,7,8,9]
        // ouput = [2,3]
    }
}

