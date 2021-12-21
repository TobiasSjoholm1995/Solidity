# Solidity

I am learning Solidity and in this repo you will find the contracts I have implemented. 
Don't use them as production code, this is just for fun and to learn.


<b>IERC20:</b>

This is the interface from EIP-20.
https://eips.ethereum.org/EIPS/eip-20

<b>ERC20</b>

This is my own implementation of the ERC20 token standard. 
It's inspired by Open Zeppelin.

<b>KryptoKingsToken</b>

This is a concrete ERC20 token that can be used on any EVM compatible network. 
It is inheriting from my ERC20 token implementation. 

<b>TokenSwap</b>

The Token Swap allows 2 traders to trade with each other trustless.
Trustless means that none of the traders need to trust the other trader to transfer the tokens.
There is no "I will transfer my tokens first, then I trust you to transfer your tokens to me"
Both traders instead set allowence to the smart contract and then the smart contract execute the trade.

<b>Liquidity Pool:</b>

The idea with the liquidity pool is that it will be possible to swap 2 different tokens between each other without it being another trader on the other side.

It is an automated market maker, that will automatically adjust the price depending on the tokens balance in the pool.
The price is adjusted according to the Constant Product Formula.

Anyone can be a liquidity provider and receive rewards. 
The rewards comes from the swap fees, which is 0.5%.
It is a minumum holding time of 7 days before you can withdraw ur tokens from the pool and the reward.
