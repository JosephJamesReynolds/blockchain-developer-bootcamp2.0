//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// Deposit Tokens []
// Withdraw Tokens []
// Check balances []
// Make Orders []
// Cancel Orders []
// Fill Orders []
// Charge Fees [X]
// Track Fee Account [X]

contract Exchange {
	address public feeAccount;
	uint256 public feePercent;

	constructor(address _feeAccount, uint256 _feePercent) {
		feeAccount = _feeAccount;
		feePercent = _feePercent;
	}

}
