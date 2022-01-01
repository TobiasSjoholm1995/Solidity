// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Fun Fact: Diamond Problem
// Solidity allows for multiple inheritance
// and uses C3 linearization to resolve it.

// Solidity has a 'super' keyword
// which allows it to call a method on the next parent in an inheritance hierarchy


contract Grandpa {
    event Say(string, string);

    constructor() {
        emit Say('I am Grandpa', '');
    }

   function getName() public pure virtual returns (string memory) {
        return 'Grandpa';
    }
}

contract Mommy is Grandpa {

    constructor() {
        emit Say('I am Mommy and I call ', super.getName());
    }

    function getName() public pure virtual override returns (string memory) {
        return 'Mommy';
    }
}

contract Daddy is Grandpa {
    constructor() {
        emit Say('I am Daddy and I call ', super.getName());
    }

    function getName() public pure virtual override returns (string memory) {
        return 'Daddy';
    }
}

contract Kiddo is Mommy, Daddy {

    constructor() {
        emit Say('I am Kiddo and I call ', super.getName());
    }

    function getName() public pure virtual override(Mommy, Daddy) returns (string memory) {
        return 'Kiddo';
    }

}

// C3 linearization results in [Kiddo, Daddy, Mommy, Grandpa]

// Logs will be emitted in the following order:
// I am Grandpa
// I am Mommy and I call, Grandpa
// I am Daddy and I call, Mommy            <-- notice this line
// I am Kiddo and I call, Daddy

// When using a super keyword, 
// always keep in mind that a call to a parent
// can be substituted by a sibling’s call.
