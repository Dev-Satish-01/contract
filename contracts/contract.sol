// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LendingPlatform {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public borrowedAmount;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);

    receive() external payable {}

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient funds");
        
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "Borrowed amount must be greater than 0");
        require(amount <= address(this).balance, "Insufficient liquidity");

        borrowedAmount[msg.sender] += amount;
        balances[msg.sender] += amount;
        emit Borrow(msg.sender, amount);
    }

    function repay(uint256 amount) external {
        require(amount > 0, "Repayment amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient funds");
        require(amount <= borrowedAmount[msg.sender], "Invalid repayment amount");

        balances[msg.sender] -= amount;
        borrowedAmount[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Repay(msg.sender, amount);
    }

    function checkBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
