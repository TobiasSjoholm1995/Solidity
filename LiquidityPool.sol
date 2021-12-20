// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract LiquidityPool {
    IERC20 public immutable _token1;
    IERC20 public immutable _token2;

    uint256 public _balance1;
    uint256 public _balance2;

    mapping(address => uint256) private _provider;


    constructor(address token1, address token2) {
        require(token1 != token2, "Invalid arguments, token addresses can't be equal.");
        
        _token1 = IERC20(token1);
        _token2 = IERC20(token2);
    }


    function swapToken1ForToken2(uint256 amount) external {
        uint256 returnAmount = getReturnAmount(amount, true);

        require(_token1.allowance(msg.sender, address(this)) >= amount, "Liquidity Pool: Allowance too low.");
        require(_balance2 >= returnAmount, "Liquidity Pool: Not enough tokens in the pool.");

        bool success1 = _token1.transferFrom(msg.sender, address(this), amount);
        bool success2 = _token2.transfer(msg.sender, returnAmount);

        require(success1 && success2, "Liquidity Pool: Transfer of tokens failed.");

        _balance1 += amount;
        _balance2 -= returnAmount;
    }

    function swapToken2ForToken1(uint256 amount) external {
        uint256 returnAmount = getReturnAmount(amount, false);

        require(_token2.allowance(msg.sender, address(this)) >= amount, "Liquidity Pool: Allowance too low.");
        require(_balance1 >= returnAmount, "Liquidity Pool: Not enough tokens in the pool.");

        bool success1 = _token2.transferFrom(msg.sender, address(this), amount);
        bool success2 = _token1.transfer(msg.sender, returnAmount);

        require(success1 && success2, "Liquidity Pool: Transfer of tokens failed.");

        _balance1 -= returnAmount;
        _balance2 += amount;
    }


    // note that you tokens are atomic
    // so transfering few tokens is bad as it rounds towards 0
    function getReturnAmount(uint256 amount, bool token1ForToken2) public view returns (uint256) {
        require(_balance1 != 0 && _balance2 != 0, "Liquidity Pool: There is no available tokens.");

        // using the Constant Product Formula
        uint256 product = _balance1 * _balance2;  // overflow, how to handle?

        if (token1ForToken2) 
            return _balance2 - product / (_balance1 + amount);
        else
            return _balance1 - product / (_balance2 + amount);
    }

    
    function _percent(uint256 numerator, uint256 denominator) private pure returns(uint256 quotient) {
        uint _numerator = numerator * 10 ** 2;
        uint _quotient  =  _numerator / denominator;

        return _quotient;
    }


    function deposit(uint256 amount) external {
        require(_token1.allowance(msg.sender, address(this)) >= amount, "Liquidity Pool: Token1 allowance too low.");
        require(_token2.allowance(msg.sender, address(this)) >= amount, "Liquidity Pool: Token2 allowance too low.");

        bool success1 = _token1.transferFrom(msg.sender, address(this), amount);
        bool success2 = _token2.transferFrom(msg.sender, address(this), amount);

        require(success1 && success2, "Liquidity Pool: Transfer of tokens failed.");

        _balance1 += amount;
        _balance2 += amount;
        _provider[msg.sender] += amount;
    }


    function withdraw(uint256 amount) external {
        require(_provider[msg.sender] >= amount, "Liquidity Pool: Withdraw amount exceeds provide amount.");
        require(_balance1 >= amount, "Liquidity Pool: There is not enough token1 balance to withdraw right now.");
        require(_balance2 >= amount, "Liquidity Pool: There is not enough token2 balance to withdraw right now.");

        bool success1 = _token1.transfer(msg.sender, amount);
        bool success2 = _token2.transfer(msg.sender, amount);

        require(success1 && success2, "Liquidity Pool: Transfer of tokens failed.");

        _balance1 -= amount;
        _balance2 -= amount;
        _provider[msg.sender] -= amount;
    }
}
