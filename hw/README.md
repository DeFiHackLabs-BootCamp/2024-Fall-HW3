# HW3

## Task 1: LenderPool

### Description

This task involves three contracts: a token contract issued according to the ERC20 standard, a lending contract that provides services, and a user contract that interacts with the lending contract.

The attacker initially has 100 ether.

LenderPool initially holds 1,000,000 ether and provides free flash loans.

Write your solution in `Lender.t.sol`, without modifying other code.  
Try to pass the tests in `LenderBaseTest.t.sol`.

## Task 2: Minter

### Description

Minter is a contract with functions for token minting, role-based access management, airdrop distribution, and ownership transfer. Initially, the attacker is similar to a regular user and is granted authorization to obtain the minting role.

Please fix the errors in `Minter.sol`.

Write your solution in `Minterer.t.sol`.  
Try to pass the tests in `MinterBaseTest.t.sol`.

### Passing Criteria

- Successfully pass the tests in `LenderBaseTest.t.sol` and `MinterBaseTest.t.sol`.