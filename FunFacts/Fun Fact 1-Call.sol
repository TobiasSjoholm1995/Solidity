// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Fun Fact - This is how you can use the lower level function 'call'


contract DummyContract {

    function add(uint x, uint y) public pure returns (uint) {
        return x + y;
    }
}


contract TheCaller {

    address public a;

    constructor() {
        DummyContract t = new DummyContract();

        // only need the address, to test the 'call' function
        a = address(t); 
    }

    function MakeTheCall(uint x, uint y) public returns (uint) {    

        // notice how uint is written as uint256
        (bool success, bytes memory data) =  a.call(abi.encodeWithSignature("addToX(uint256, uint256)", x, y));

        require(success, "The call failed.");

        uint result = abi.decode(data, (uint));   
        return result; 
    }
}