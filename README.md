# DECENTRALIZED-ESCROW
A decentralized escrow uses smart contracts on a blockchain to securely hold funds until agreed conditions are met, without the need for a trusted intermediary. The process is automated and trustless, with funds released once conditions (like delivery or service completion) are verified.

## Escrow Contract

This is a smart contract for decentralized escrow services on the Ethereum blockchain. The contract allows a buyer and a worker to securely manage funds during a transaction. The buyer deposits funds, and the worker can complete the task. Once the task is completed, the buyer can release the funds. If the task isn't completed in time, the buyer can request a refund.

## Overview

The primary objective of the Escrow Contract is to securely facilitate transactions between a buyer and a worker using blockchain technology. The contract ensures that funds are held in escrow until the buyer confirms task completion or requests a refund. The system eliminates the need for intermediaries, making the process decentralized, transparent, and trustless. The contract also protects against reentrancy attacks by using OpenZeppelin's `ReentrancyGuard`.

## Features

- **Deposit Funds**: The buyer deposits funds into the contract, locking the amount until the task is completed or refunded.
- **Task Completion**: The worker can mark the task as completed, starting a 3-day period for the buyer to confirm or request a refund.
- **Refund Mechanism**: If the task isn't completed within the specified time frame, the buyer can request a refund.
- **Reentrancy Guard**: Prevents reentrancy attacks by using OpenZeppelin's `ReentrancyGuard`.
- **Events**: Tracks actions like deposits, task completion, work confirmation, and refunds.

## Technologies Used

- **Solidity**: The smart contract is written in Solidity, the primary language for developing Ethereum smart contracts.
- **OpenZeppelin**: Utilizes OpenZeppelin's `ReentrancyGuard` for secure and safe contract execution.
- **Ethereum Testnet**: The contract is deployed and tested on an Ethereum test network before deploying to the Ethereum mainnet.
- **MetaMask**: A popular cryptocurrency wallet and browser extension used to interact with the Ethereum testnet and manage transactions during deployment.
