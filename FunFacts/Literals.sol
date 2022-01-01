// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Fun Fact: Literals
// The compiler calculates the literals


contract Literals {

    // literals can't overflow or underflow
    uint256 public max256Value = 2**256 - 1;


    // literals can handle float numbers (solidity ^0.4.0)
    uint8 public Three = 1.5 * 2; 


    // possible to use underscore as a seperator
    uint256 public bigNumber = 1_000_000_000;


    // next line is invalid as the compiler cant implicitly convert a rational_const to uint256
    //uint256 public invalid = 1.5 + bigNumber;
    
}

