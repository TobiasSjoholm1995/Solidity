// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";


// How to use the TokenSwap:
// 1. Anyone can create the contract and configure the tokens and amounts
// 2. Send the contract address to both traders
// 3. Both traders verify that the token address and amount is correctly configured
// 4. Both traders set their own allowence for their token
// 5. Any of the traders can call swap function, to execute the trade


contract TokenSwap {

    // The token and the expected amount is made visible
    // So the traders before they set their own allowence,
    // can see that the contract is configureed correctly

    address private immutable account1;
    IERC20 public immutable token1;
    uint256 public immutable amount1;

    address private immutable account2;
    IERC20 public immutable token2;
    uint256 public immutable amount2;

    constructor(
        address account1_, address token1_, uint256 amount1_, 
        address account2_, address token2_, uint256 amount2_)
    {
        account1 = account1_;
        token1   = IERC20(token1_);
        amount1  = amount1_;

        account2 = account2_;
        token2   = IERC20(token2_);
        amount2  = amount2_;
    }


    function swap() public {
        require(msg.sender == account1 || msg.sender == account2, "Token Swap: Not authorized.");
        require(token1.allowance(account1, address(this)) >= amount1, "Token Swap: Too low allowence for token1.");
        require(token2.allowance(account2, address(this)) >= amount2, "Token Swap: Too low allowence for token2.");

        bool success1 = token1.transferFrom(account1, account2, amount1);
        bool success2 = token2.transferFrom(account2, account1, amount2);
        require(success1 && success2, "Token Swap: Transfer failed.");
    }
}
