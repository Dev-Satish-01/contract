// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LendingPlatform {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public borrowedAmount;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "Borrowed amount must be greater than 0");
        require(amount <= (balances[msg.sender] - borrowedAmount[msg.sender]), "Cannot borrow more than available funds");
        borrowedAmount[msg.sender] += amount;
        balances[msg.sender] += amount;
        emit Borrow(msg.sender, amount);
    }

    function repay(uint256 amount) external {
        require(amount > 0, "Repayment amount must be greater than 0");
        require(amount <= borrowedAmount[msg.sender], "Cannot repay more than borrowed");
        borrowedAmount[msg.sender] -= amount;
        balances[msg.sender] -= amount;
        emit Repay(msg.sender, amount);
    }

    function checkBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
