// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract LiquidityPool {
    IERC20 public immutable token1;
    IERC20 public immutable token2;
    uint256 public immutable waitingTime;

    uint256 public balance1;
    uint256 public balance2;

    uint256 private _depositProduct;

    struct Provider {
        uint256 Amount;
        uint256 BlockNumber;
    }


    mapping(address => Provider) private _providers;


    constructor(address token1_, address token2_, uint256 waitingTime_) {
        require(token1_ != token2_, "Invalid arguments, token addresses can't be equal.");
        
        token1 = IERC20(token1_);
        token2 = IERC20(token2_);
        waitingTime = waitingTime_;
    }


    function swapToken1ForToken2(uint256 amount) external {
        uint256 returnAmount = getReturnAmount(amount, true);

        require(token1.allowance(msg.sender, address(this)) >= amount, "Liquidity Pool: Allowance too low.");
        require(balance2 >= returnAmount, "Liquidity Pool: Not enough tokens in the pool.");

        bool success1 = token1.transferFrom(msg.sender, address(this), amount);
        bool success2 = token2.transfer(msg.sender, returnAmount);

        require(success1 && success2, "Liquidity Pool: Transfer of tokens failed.");

        balance1 += amount;
        balance2 -= returnAmount;
    }

    function swapToken2ForToken1(uint256 amount) external {
        uint256 returnAmount = getReturnAmount(amount, false);

        require(token2.allowance(msg.sender, address(this)) >= amount, "Liquidity Pool: Allowance too low.");
        require(balance1 >= returnAmount, "Liquidity Pool: Not enough tokens in the pool.");

        bool success1 = token2.transferFrom(msg.sender, address(this), amount);
        bool success2 = token1.transfer(msg.sender, returnAmount);

        require(success1 && success2, "Liquidity Pool: Transfer of tokens failed.");

        balance1 -= returnAmount;
        balance2 += amount;
    }


    // 0.5% swap fee with minumum of 1 token (caused by round off)
    // so transfering few tokens is bad 
    function getReturnAmount(uint256 amount, bool token1ForToken2) public view returns (uint256) {
        require(balance1 != 0 && balance2 != 0, "Liquidity Pool: There is no available tokens.");
        require(amount != 0, "Liquidity Pool: Invalid argument, amount is zero.");

        // using the Constant Product Formula
        uint256 product = balance1 * balance2; 
        uint256 returnAmount = 0;
        
        if (token1ForToken2) 
            returnAmount =  balance2 - (product / (balance1 + amount) + 1);
        else
            returnAmount = balance1 - (product / (balance2 + amount) + 1);

        uint256 fee = returnAmount * 5 / 1000;

        return returnAmount - fee;
    }


    function deposit(uint256 amount) external {
        require(token1.allowance(msg.sender, address(this)) >= amount, "Liquidity Pool: Token1 allowance too low.");
        require(token2.allowance(msg.sender, address(this)) >= amount, "Liquidity Pool: Token2 allowance too low.");

        bool success1 = token1.transferFrom(msg.sender, address(this), amount);
        bool success2 = token2.transferFrom(msg.sender, address(this), amount);

        require(success1 && success2, "Liquidity Pool: Transfer of tokens failed.");

        balance1 += amount;
        balance2 += amount;
        _providers[msg.sender].Amount += amount;
        _providers[msg.sender].BlockNumber = amount;
        _depositProduct = balance1 * balance2;
    }

    function withdraw(uint256 amount) external {
        require(_providers[msg.sender].Amount >= amount, "Liquidity Pool: Withdraw amount exceeds provide amount.");
        require(_providers[msg.sender].BlockNumber +  waitingTime <= block.number, "Liquidity Pool: You need to wait before you can withdraw.");
        require(balance1 >= amount, "Liquidity Pool: There is not enough token1 balance to withdraw right now.");
        require(balance2 >= amount, "Liquidity Pool: There is not enough token2 balance to withdraw right now.");

        bool success1 = token1.transfer(msg.sender, amount);
        bool success2 = token2.transfer(msg.sender, amount);
        bool success3 = _giveReward(amount);

        require(success1 && success2 && success3, "Liquidity Pool: Transfer of tokens failed.");

        balance1 -= amount;
        balance2 -= amount;
        _providers[msg.sender].Amount -= amount;
        _depositProduct = balance1 * balance2;
    }


    function withdrawAmount(address account) external view returns (uint256) {
        return _providers[account].Amount;
    }


    function _giveReward(uint256 withdrawAmount_) private returns (bool) {
        require(balance1 != 0 && balance2 != 0, "Liquidity Pool: There is no available tokens.");
        
        uint256 currentProduct     = balance1 * balance2;
        uint256 percentTotalReward = (currentProduct * 100 / _depositProduct) - 100;
        uint256 percentUserReward  = (withdrawAmount_ + withdrawAmount_) * 100 / (balance1 + balance2);

        if (balance1 >= balance2) {
            uint256 rewardAmount1 = (percentTotalReward * (percentUserReward * balance1)) / 10000;
            balance1 -= rewardAmount1;
            return token1.transfer(msg.sender, rewardAmount1);
        }
        else {
            uint256 rewardAmount2 = (percentTotalReward * (percentUserReward * balance2)) / 10000;
            balance2 -= rewardAmount2;
            return token2.transfer(msg.sender, rewardAmount2);
        }
    }
       
    function _percent(uint256 numerator, uint256 denominator) private pure returns(uint256 quotient) {
        uint _numerator = numerator * 10 ** 2;
        uint _quotient  = _numerator / denominator;

        return _quotient;
    }
    
}
