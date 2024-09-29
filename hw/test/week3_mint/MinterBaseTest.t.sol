// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "../../src/week3_mint/Minter.sol";
import "openzeppelin-contracts/utils/Address.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

import {Test,stdError} from "forge-std/Test.sol";

contract MinterBaseTest is Test {
 Minter public minterContract;
    address public owner = address(0x123); 
    address public attacker = address(0x456); 

    function setUp() public virtual {
        minterContract = new Minter(owner);
        vm.startPrank(owner);
        minterContract.addMinter(attacker);
        vm.stopPrank();
        bool hasMinterRole = minterContract.hasRole(minterContract.MINTER_ROLE(), attacker);
        assertTrue(hasMinterRole, "The attacker is granted the MINTER_ROLE initially.");
    }
    function test_mint() public {
        vm.startPrank(attacker);
        minterContract.mint(attacker, 1000 ether);
        vm.stopPrank();
        uint256 balance = minterContract.balanceOf(attacker);
        assertEq(balance, 1000 ether, "Received 1000 tokens");
    }

    function test_transferOwnership() public {
        address newOwner = address(0x987);
        vm.startPrank(owner);
        minterContract.transferOwnership(newOwner);
        vm.stopPrank();
        vm.startPrank(newOwner);
        minterContract.addMinter(attacker); 
        vm.stopPrank();
        bool hasMinterRole = minterContract.hasRole(minterContract.MINTER_ROLE(), attacker);
        assertTrue(hasMinterRole, "New owner should have permission to add MINTER_ROLE");
    }

    modifier checkChallengeSolved() {
    _;
    vm.expectRevert();
    vm.startPrank(attacker);
    minterContract.mint(attacker, 1000 ether);
    vm.stopPrank();
    }
}