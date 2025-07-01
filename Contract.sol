// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

// Importing ReentrancyGuard from OpenZeppelin for preventing reentrancy attacks
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Contract for an escrow system between a buyer and a worker
contract Escrow is ReentrancyGuard {
    // Public variables to store buyer, worker addresses, amount, and task status
    address public buyer;
    address public worker;
    uint public amount;
    bool public taskCompleted = false;  // Default task status is not completed
    uint256 public taskCompletionTime;  // Stores the time when the task is completed
    uint256 public refundDeadline;      // Deadline for refund requests after task completion

    // Constructor that initializes the buyer, worker, and the agreed amount
    constructor(address _worker, uint256 _amount) {
        buyer = msg.sender; // Set the buyer as the address that deploys the contract
        worker = _worker;   // Set the worker's address from the constructor argument
        amount = _amount;    // Set the amount that the buyer and worker have agreed upon
    }

    // Event to log when the buyer adds money to the contract
    event addMoney(address indexed buyer, uint amount);
    
    // Event to log when the worker completes the task
    event taskComplete(address indexed worker, uint completionTime);
    
    // Event to log when the buyer confirms the completion of the task
    event WorkConfirmed(address indexed buyer, address indexed worker, uint256 confirmationTime);
    
    // Event to log when the buyer requests a refund
    event refunding(address indexed buyer, address indexed worker, uint amount);

    // Modifier to allow only the buyer to call certain functions
    modifier onlyBuyer() {
        require(buyer == msg.sender, "You are not the buyer");
        _;
    }
    
    // Modifier to allow only the worker to call certain functions
    modifier onlyWorker() {
        require(worker == msg.sender, "You are not the worker");
        _;
    }

    // Function for the buyer to deposit the agreed amount to the contract
    function amountAdd() public payable onlyBuyer {
        require(msg.value == amount, "Incorrect amount sent"); // Ensures the buyer sends the correct amount
        emit addMoney(msg.sender, msg.value); // Log the event
    }

    // Function for the worker to mark the task as completed
    function completetask() public onlyWorker {
        taskCompleted = true; // Mark the task as completed
        taskCompletionTime = block.timestamp; // Record the timestamp of task completion
        refundDeadline = taskCompletionTime + 3 days; // Set the refund deadline (3 days from completion)
        emit taskComplete(worker, taskCompletionTime); // Log the task completion event
    }

    // Function for the buyer to confirm the task and release funds to the worker
    // Added nonReentrant to prevent reentrancy attacks
    function confirmWork() public onlyBuyer nonReentrant {
        require(taskCompleted, "Task not completed yet"); // Ensure the task is completed before confirming
        require(block.timestamp <= refundDeadline, "Refund window has closed"); // Ensure refund window is still open
        payable(worker).transfer(amount); // Transfer the agreed amount to the worker
        emit WorkConfirmed(msg.sender, worker, block.timestamp); // Log the work confirmation event
    }

    // Function for the buyer to request a refund (if the task is not completed)
    // Added nonReentrant to prevent reentrancy attacks
    function refund() public onlyBuyer nonReentrant {
        require(!taskCompleted, "Task is already completed, no refund allowed"); // Refund only if task is not completed
        require(block.timestamp <= refundDeadline, "Refund window has closed"); // Refund window should still be open
        emit refunding(buyer, worker, amount); // Log the refund event
        payable(buyer).transfer(amount); // Transfer the amount back to the buyer
    }

    // Function to view the current balance of the contract (how much funds are in escrow)
    function contractBalance() external view returns (uint256) {
        return address(this).balance; // Return the contract's current balance
    }
}

