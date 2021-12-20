// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

interface IERC20 {
    
    // From EIP 20, https://eips.ethereum.org/EIPS/eip-20

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IOptionalERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function circulatingSupply() external view returns (uint256);


    // NOTE: These 2 functions are here due to the security flaw in allowence-function in IERC20
    // https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.d485qg6c4olu

    function increaseAllowance(address spender, uint256 amount) external returns (bool);
    function decreaseAllowance(address spender, uint256 amount) external returns (bool);
}

