// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Fun Fact: Anonymous Events


contract AnonymousEvents {

    // An anonymous event can have 4 indexed parameters but a regular event can only have 3.
    // Unlike regular events, anonymous events do not contain an indexed keccak of their signature.
    event AnonymusMessage(uint indexed id, uint indexed start, uint indexed middle, uint indexed end, string message) anonymous;

    function test() external {
        emit AnonymusMessage(1,2,3,4, "Hi");
    }
}

