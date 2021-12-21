// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./ERC20.sol";
import "./Guardian.sol";

contract LeveragedToken is ERC20, Guardian {

    string  constant private _name        = "LeverageToken";
    string  constant private _symbol      = "LT";
    uint256 constant private _totalSupply = 1000000;

    IERC20 immutable token;
    uint256 immutable leverage;

    event Buy(address indexed buyer, uint256 value);
    event Sell(address indexed seller, uint256 value);

    constructor(address token_, uint256 leverage_) ERC20(_name, _symbol, _totalSupply) {
        require(leverage_ != 0, "Leveraged Token: Leverage can't be zero.");
        _mint(address(this), _totalSupply);

        token    = IERC20(token_);
        leverage = leverage_;
    }


    function buy(uint256 amount) external guard {
        require(amount % leverage == 0, "Leveraged Token: Amount must be even divisible with the leverage.");
        require(amount != 0, "Leveraged Token: Amount must be greater than zero.");
        require(token.allowance(msg.sender, address(this)) >= amount, "Leveraged Token: Allowance too low.");

        bool success1 = token.transferFrom(msg.sender, address(this), amount);
        bool success2 = this.transfer(msg.sender, amount / leverage);

        require(success1 && success2, "Leveraged Token: Transfer of tokens failed.");

        emit Buy(msg.sender, amount);
    }

    function sell(uint256 amount) external guard {
        require(amount != 0, "Leveraged Token: Amount must be greater than zero.");
        require(this.allowance(msg.sender, address(this)) >= amount, "Leveraged Token: Allowance too low.");

        bool success1 = this.transferFrom(msg.sender, address(this), amount);
        bool success2 = token.transfer(msg.sender, amount * leverage);

        require(success1 && success2, "Leveraged Token: Transfer of tokens failed.");

        emit Sell(msg.sender, amount * leverage);
    }
}
