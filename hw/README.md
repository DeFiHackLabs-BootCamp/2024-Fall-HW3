# HW3 Solution 

## Task 1: LenderPool

### Description

This task involves three contracts: a token contract issued according to the ERC20 standard, a lending contract that provides services, and a user contract that interacts with the lending contract.

The attacker initially has 100 ether.

LenderPool initially holds 1,000,000 ether and provides free flash loans.

Write your solution in `Lender.t.sol`, without modifying other code.  
Try to pass the tests in `LenderBaseTest.t.sol`.


### Solution 
The LenderPool.sol contains two main functions:

- `depositTokens`: Allows users to deposit a specified amount of tokens into the pool.
- `flashLoan`: Allows users to borrow tokens and return them within a single transaction.

`assert(poolBalance == balanceBefore);` enforces that the internal record `poolBalance` must precisely match the current actual token balance `balanceBefore`. An attacker can easily disrupt this check by sending 1 ether to the pool, altering the `balanceBefore` value and causing the check to fail, which prevents other users from accessing the `flashLoan()` function.

## Task 2: Minter

### Description

Minter is a contract with functions for token minting, role-based access management, airdrop distribution, and ownership transfer. Initially, the attacker is similar to a regular user and is granted authorization to obtain the minting role.

Please fix the errors in `Minter.sol`.

Write your solution in `Minterer.t.sol`.  
Try to pass the tests in `MinterBaseTest.t.sol`.

### Solution 

The `Minter` contract uses OpenZeppelin's [`AccessControl`](https://docs.openzeppelin.com/contracts/5.x/access-control#role_admins_and_guardians) to manage roles. This includes assigning specific permissions for `MINTER_ROLE` and `STAKER_ROLE`, allowing addresses with these roles to perform certain actions. As mentioned in OpenZeppelin's `AccessControl` documentation, "`AccessControl` includes a special role, called `DEFAULT_ADMIN_ROLE`, which acts as the default admin role for all roles. An account with this role will be able to manage any other role."

When designing permission controls in a contract, it's essential to consider the flexibility of role permissions and potential future security issues, following the principle of least privilege.

In the current `Minter.sol`, roles such as `MINTER_ROLE` and `STAKER_ROLE` are granted unilaterally. This means that once an address is assigned a role, it cannot be revoked. If these addresses become malicious in the future, their permissions can never be revoked.

Please add this code snippet to `Minter.t.sol`:

```solidity
function test_cannnot_revoke() public {
    emit log_named_bytes32("admin role of MINTER_ROLE", minterContract.getRoleAdmin(keccak256("MINTER_ROLE")));
    vm.startPrank(owner);
    vm.expectRevert();
    minterContract.revokeRole(keccak256("MINTER_ROLE"), attacker);
    vm.stopPrank(); 
}
```

![](/hw/minter.jpg)


The `DEFAULT_ADMIN_ROLE` has never been set, so the roles `MINTER_ROLE` and `STAKER_ROLE` cannot be revoked.

- **Minter.sol**: Properly initialize `DEFAULT_ADMIN_ROLE` or add a function to allow revoking previously granted roles.
- **Minter.t.sol**: Revoke privileges from addresses with special roles if they become malicious.

## 🥚 Easter egg 🥚 
Task 2 is drawn from the findings of TaiChi's Audit Group white hats. Feel free to check out the [full details](https://github.com/TaiChiAuditGroup/Portfolio/blob/main/Code4rena/2024-02-ai-arena/2024-02-ai-arena.md#m-02--the-setups-of-privileged-roles-for-multi-contracts-are-uni-lateral-and-can-not-be-revoked)!
