// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "lib/forge-std/src/Test.sol";
import {Box} from "../src/Box.sol";
import {GovToken} from "../src/GovToken.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {TimeLock} from "../src/TimeLock.sol";

contract MyGovernorTest is Test {
    MyGovernor governor;
    Box box;
    TimeLock timelock;
    GovToken govToken;

    // varibales for GovToken
    address public USER = makeAddr("user");
    uint256 public constant INITIAL_SUPPLY = 100 ether;

    // variables for TImeLock
    uint256 public constant MIN_DELAY = 3600; // 1 hour - after the vote passes
    address[] proposers;
    address[] executors;

    function setUp() public {
        govToken = new GovToken(); // deploy GovToken contract
        govToken.mint(USER, INITIAL_SUPPLY); // mint some tokens
        vm.startPrank(USER);
        govToken.delegate(USER); // delegate 100 tokens voting power to USER

        timelock = new TimeLock(MIN_DELAY, proposers, executors); // deploy TimeLock contract

        governor = new MyGovernor(govToken, timelock); // deploy myGovernor contract

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.TIMELOCK_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor)); // only governor can propose
        timelock.grantRole(executorRole, address(0)); // anybody can execute proposal
        timelock.revokeRole(adminRole, USER); // USER will no longer be the admin
        vm.stopPrank();
    }
}
