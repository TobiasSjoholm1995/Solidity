// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";


// How to use the TokenSwap:
// 1. Anyone can create the contract and configure the tokens and amounts
// 2. Both traders will get the contract address and can veify that the token address and amount is correct configured
// 3. Both traders set their own allowence for their token
// 4. Any of the traders can call swap function, to execute the trade


contract TokenSwap {

    // The token and the expected amount is made visible
    // So the traders before they set their own allowence,
    // can see that the contract is configureed correctly

    address private immutable account1;
    IERC20 public immutable token1;
    uint256 public immutable expectedAmount1;

    address private immutable account2;
    IERC20 public immutable token2;
    uint256 public immutable expectedAmount2;

    constructor(
        address account1_, address token1_, uint256 expectedAmunt1_, 
        address account2_, address token2_, uint256 expectedAmunt2_)
    {
        account1        = account1_;
        token1          = IERC20(token1_);
        expectedAmount1 = expectedAmunt1_;

        account2        = account2_;
        token2          = IERC20(token2_);
        expectedAmount2 = expectedAmunt2_;
    }


    function swap(uint256 amount1, uint256 amount2) public {
        require(msg.sender == account1 || msg.sender == account2, "Not authorized.");
        require(expectedAmount1 == amount1, "Invalid amount for token1");
        require(expectedAmount2 == amount2, "Invalid amount for token2");
        require(token1.allowance(account1, address(this)) >= amount1, "Too low allowence for token1.");
        require(token2.allowance(account2, address(this)) >= amount1, "Too low allowence for token2.");

        bool success1 = token1.transferFrom(account1, account2, amount1);
        bool success2 = token2.transferFrom(account2, account1, amount2);
        require(success1 && success2, "Transfer failed.");
    }
}
