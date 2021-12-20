// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./ERC20.sol";

contract KryptoKingsToken is ERC20 {

    string  constant private _name        = "KryptoKings";
    string  constant private _symbol      = "KK";
    uint256 constant private _totalSupply = 100;

    constructor() ERC20(_name, _symbol, _totalSupply) {
        _mint(msg.sender, _totalSupply);
    }
}
