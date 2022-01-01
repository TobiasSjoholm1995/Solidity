Each Solidity file in this folder contains a fun fact about Solidity.


This file contains some famous hacks and recommendations.
The list of hacks is great to read after every contract you implemented, to make sure you are not falling victim to any of the hacks.


__Hacks:__
- Hiding code with unverified address with same abi
	
- Re-entry attack, send ether before updating state
	
- Unchecked overflow/underflow

- Front running attack

- Sandwich attack

- Block timestamp manipulation

- No private data is private

- Force send Eth with selfdestruct()

- Denail of service, can't make any external calls or send eth to another contract.
  Never assume that an external function has a correct implementation.
  DOS can cause your contract to enter a trap state where nothing can happen.
  Use Withdraw-pattern to prevent this or try-catch handling.

- tx.origin can't be trusted due to malicious forward calls.

- extcodesize() is 0 for a contract in the same transaction as it's deployed (constructor call)

- be careful assigning to multiple variables at the same time (tuple syntax) when reference types are involved, can lead to unexpected copy behaviour.

	

__Memory Types:__
	
- The 4 memory types are: Storage, Memory, Calldata, stack
	
- Variable assignment  memory ←→ storage always creates a copy
	
- Storage is default for state variables and creates high fees.
	
- Calldata can be used on function parameters that will be read-only, lower gas fees.


__Transfer ETH:__  Always read offical up-to-date documentation on how to transfer Ether.
- transfer(), not recommende anymore.
  The transfer function fails if the balance of the current contract is not large enough 
  or if the Ether transfer is rejected by the receiving account. 
  The transfer function reverts on failure.
  It uses constant gas of 2300 to prevent re-entrance attack.

- send(), not recommend anymore.
  Send is the low-level counterpart of transfer. 
  If the execution fails, the current contract will not stop with an exception, but send will return false.
  It uses constant gas of 2300 to prevent re-entrance attack.

- call{value: amount}("");
  This is the recommended way to transfer ether to another address after the Istanbul update, which increase the gas cost of SLOAD.
  Call transfer all existing gas.
  Remember the ("") part to actually make the call.


__Tips:__
	
- Use the Checks-Interactions-Effect pattern. 
  Which states that first you use your require() statements, then you change the state of the contract then last you make external call.
	
- include a fail safe mode
	
- limit the amount of money in the same contract, which will limit the amount of loss if failure/hacks happens.



