// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20, IOptionalERC20 {

    string private _name;
    string private _symbol;

    uint256 private _circulatingSupply;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balance;
    mapping(address => mapping(address =>uint256)) private _allowence;

    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) {
        _name        = name_;
        _symbol      = symbol_;
        _totalSupply = totalSupply_;
    }



    // implementation of the tokenomics, mint and burn

    function _mint(address receiver, uint256 amount) internal {
        require(receiver != address(0), "ERC20: Zero address is not allowed to receive tokens.");
        require(_totalSupply >= _circulatingSupply + amount, "ERC20: Failed to mint new tokens, exceeds total supply.");
        // note that the line above throws an error if the new circulating supply overflows

        unchecked {
            _circulatingSupply += amount;
            _balance[receiver] += amount;
        }

        emit Transfer(address(0), receiver, amount);
    }

    function _burn(uint256 amount) internal {
        require(msg.sender != address(0),     "ERC20: Zero address is not allowed to burn tokens.");
        require(amount <= _circulatingSupply, "ERC20: Failed to burn tokens, amount exceeds circulating supply.");

        unchecked {
            _circulatingSupply -= amount;
            _balance[msg.sender] -= amount;
        }

        emit Transfer(msg.sender, address(0), amount);
    }




    // Implementation of IOptionalERC20

    function name() public view override virtual returns (string memory) {
        return _name;
    }

    function symbol() public view override virtual returns (string memory) {
        return _symbol;
    }

    function circulatingSupply() public view virtual override returns (uint256) {
        return _circulatingSupply;
    }

    function increaseAllowance(address spender, uint256 amount) public virtual override returns (bool) 
    {
        uint256 currentAllowence = _allowence[msg.sender][spender];

        _approve(spender, currentAllowence + amount);
        return true;
    }

    function decreaseAllowance(address spender, uint256 amount) public virtual override returns (bool) 
    {
        uint256 currentAllowence = _allowence[msg.sender][spender];

        require(currentAllowence >= amount, "Not enough allowence to decrease");

        _approve(spender, currentAllowence - amount);
        return true;
    }



    // Implementation of IERC20 

    function totalSupply() external view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view virtual override returns (uint256) {
        return _balance[account];
    }

    function transfer(address recipient, uint256 amount) external virtual override returns (bool) 
    {      
        return _transfer(msg.sender, recipient, amount);
    }

    function allowance(address owner, address spender) external view virtual override returns (uint256) {
        return _allowence[owner][spender];
    }

    function approve(address spender, uint256 amount) external virtual override returns (bool) 
    {
        return _approve(spender, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
        require(_allowence[sender][msg.sender] >= amount, "ERC20: Transer amount exceeds allowance");
       
        bool success = _transfer(sender, recipient, amount);

        if (success) {
            unchecked {
                _allowence[sender][msg.sender] -= amount;
            }
        }

        return success;
    }

    function _transfer(address sender, address receiver, uint256 amount) private returns (bool) 
    {
        require(sender   != address(0),       "ERC20: Zero address is not allowed to send tokens.");
        require(receiver != address(0),       "ERC20: Zero address is not allowed to receive tokens.");
        require(amount <= _circulatingSupply, "ERC20: Invalid amount, it exceeds circulating supply.");
        require(amount <= _totalSupply,       "ERC20: Invalid amount, it exceeds total supply.");
        require(_balance[sender] >= amount,   "ERC20: Sender balance enough tokens to complete transfer.");

        unchecked {
            _balance[sender] -= amount;
            _balance[receiver] += amount;
        }
        
        emit Transfer(sender, receiver, amount);
        return true;
    }  

    function _approve(address spender, uint256 amount) private returns (bool) 
    {
        require(msg.sender != address(0),     "ERC20: Zero address is not allowed to send tokens.");
        require(spender != address(0),        "ERC20: Zero address is not allowed to spend tokens.");
        require(amount <= _circulatingSupply, "ERC20: Invalid amount, it exceeds circulating supply.");

        _allowence[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }
}
