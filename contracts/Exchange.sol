//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";


// Deposit Tokens [X]
// Withdraw Tokens [X]
// Check balances [X]
// Make Orders [X]
// Cancel Orders [X]
// Fill Orders []
// Charge Fees []
// Track Fee Account [X]

contract Exchange {
	address public feeAccount;
	uint256 public feePercent;
	mapping(address => mapping(address => uint256)) public tokens;
	mapping(uint256 => _Order) public orders;
	uint256 public orderCount;
	mapping(uint256 => bool) public orderCancelled; // True or false (bool)


	// Orders mapping

	event Deposit(address token,
		address user, 
		uint256 amount,
		uint256 balance);

	event Withdraw(
		address token,
		address user,
		uint256 amount,
		uint256 balance
	
	);
	event Order (
		uint256 id, 
		address user, 
		address tokenGet, 
		uint256 amountGet, 
		address tokenGive, 
		uint256 amountGive, 
		uint256 timestamp 
	);
	event Cancel (
		uint256 id, 
		address user, 
		address tokenGet, 
		uint256 amountGet, 
		address tokenGive, 
		uint256 amountGive, 
		uint256 timestamp 
	);
		
	// A way to model the order
	struct _Order {
		// Attributes of an order
		uint256 id; // Unique identifier for order
		address user; // user who made the order
		address tokenGet; // Address of the tokens they receive
		uint256 amountGet; // Amount they receive
		address tokenGive; // Address of the token they give
		uint256 amountGive; // Amount they give
		uint256 timestamp; // When order was created
	}

	constructor
	(address _feeAccount, uint256 _feePercent) 
	{
		feeAccount = _feeAccount;
		feePercent = _feePercent;
	}

	// -------------------------
	// Deposit  & withdraw Token

	function depositToken(address _token, uint256 _amount) public 
	{
	// Transfer Tokens to Exchange
	require(Token(_token).transferFrom(msg.sender, address(this), _amount));
	
	// Update user balance
	tokens[_token][msg.sender] = tokens[_token][msg.sender] + _amount;

	// Emit an event
	emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);

	}

	function withdrawToken(address _token, uint256 _amount) public {
		// Ensure user has enough tokens to withdraw
		require(tokens[_token][msg.sender] >= _amount);

		// Transfer Tokens to user
		Token(_token).transfer(msg.sender, _amount);

		// Update user balance 
		tokens[_token][msg.sender] = tokens[_token][msg.sender] - _amount;


		// Emit Event
		emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);


	}

	// Check balances
	function balanceOf(address _token, address _user)
		public
		view
		returns (uint256)
	{
		return tokens[_token][_user];
	}	


	//------------------------
	// MAKE AND CANCELL ORDERS
	function makeOrder(
		address _tokenGet,
		uint256 _amountGet,
		address _tokenGive,
		uint256 _amountGive
	)public {

		// Require Token balance 
		require(balanceOf(_tokenGive, msg.sender) >= _amountGive);

		
		// Instantiate a new order
		orderCount = orderCount + 1;
		orders[orderCount] = _Order(
		 	 orderCount, 
		 	 msg.sender, 
		 	_tokenGet, 
		 	_amountGet,
		 	_tokenGive,
		 	_amountGive,
		 	block.timestamp 
		 );

		// Emit event
		emit Order(
			orderCount, 
		 	 msg.sender, 
		 	_tokenGet, 
		 	_amountGet,
		 	_tokenGive,
		 	_amountGive,
		 	block.timestamp 
		 );
	}

	function cancelOrder(uint256 _id) public {
		// Fetching the order 
		_Order storage _order = orders[_id];

		// Ensure the caller of the function is the owner of the order
		require(address(_order.user) == msg.sender);

		// Order must exist
		require(_order.id == _id);

		// Cancel the order
		orderCancelled[_id] = true;

		// Emit event
		emit Cancel(
			_order.id, 
		 	msg.sender, 
		 	_order.tokenGet, 
		 	_order.amountGet,
		 	_order.tokenGive,
		 	_order.amountGive,
		 	block.timestamp 
		 );
	}


	// ---------------------------
	// Executing orders

	function fillOrder(uint256 _id) public {
		// Fetch order 
		_Order storage _order = orders[_id];

		// Executing the trade
		_trade(
			_order.id,
			_order.user,
			_order.tokenGet,
			_order.tokenGive,
			_order._amountGive
		);
	}

	function _trade(
		uint256 _orderId,
		address _user,
		address _tokenGet,
		uint256 _amountGet,
		address _tokenGive,
		uint256 _amountGive
	) internal {
		// Fee is paid by the user who filled the order (msg.sender)
		// Fee is deducted from _amountGet
		uint256 _feeAmount = (_amountGet * fee percent) / 100;


		// Execute the trade
		// msg.sender is the user who filled the order, while _user is who created the order
		tokens[_tokenGet][msg.sender] =
		tokens[_tokenGet][msg.sender] - 
		(_amountGet + _feeAmount);
		
		tokens[_tokenGet][_user] = tokens[_tokenGet][_user] + _amountGet;

		// Charge the fees
		tokens[_tokenGet][feeAccount] =
		tokens[_tokenGet][feeAccount] +
		_feeAmount; 

		tokens[_tokenGive][_user] =tokens[_tokenGive][_user] - amountGive;	
		tokens[_tokenGive][msg.sender] =
		tokens[_tokenGive][msg.sender] +
		_amountGive;
	}

}
