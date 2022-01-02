// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Test {
    uint public counter = 0;
    event Log(string messsage, uint amount);

/*
        Which function is called, fallback() or receive()?

            send Ether
                |
            msg.data is empty?
                / \
                yes  no
                /     \
    receive() exists?  fallback()
            /   \
            yes   no
            /      \
        receive()   fallback()
*/

    receive() external payable 
    {
        counter++;
        emit Log("Receive", msg.value);
    }

    // also possible to use with bytes parameter: 
    // fallback(bytes calldata _input) external payable returns (bytes memory)
    fallback() external payable
    {
        counter++;
        emit Log("Fallback", msg.value);
    }

    function myMethod() external payable {
        counter++;
        emit Log("MyMethod", msg.value);
    }

    function getBalance() external view returns (uint256) { return payable(this).balance; }
}

contract Caller {

    address payable public a;

    constructor(address payable a_) {
        a = a_;
    }


    function callFallback() external payable returns (bool, bytes memory) {
        (bool success, bytes memory data) = a.call{value: msg.value}("This will call Fallback");
        return (success, data);
    }


    function callReceive() external payable returns (bool, bytes memory) {
        (bool success, bytes memory data) = a.call{value: msg.value}("");   
        return (success, data);
    }

    function callMyMethod() external payable returns (bool, bytes memory) {
        (bool success, bytes memory data) = a.call{value: msg.value}(abi.encodeWithSignature("myMethod()"));
        return (success, data);
    }

    function kill() external payable {
        selfdestruct(a); // force send ether, dont call any method
    }

}
