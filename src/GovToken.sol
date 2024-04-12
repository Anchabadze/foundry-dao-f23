// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// allowing approvals to be made via signatures
// you can sign the transaction without sending it and let somebody else send the transaction
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
// This extension keeps a history (checkpoints) of each account's vote power.
// Vote power can be delegated either by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}.
// Voting power can be queried through the public accessors {getVotes} and {getPastVotes}.
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract MyToken is ERC20, ERC20Permit, ERC20Votes {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {}

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes) {
        super._update(from, to, value);
    }

    function nonces(address owner) public view override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }
}
