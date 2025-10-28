// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AidLedger
 * @dev A transparent donation and fund tracking system on blockchain.
 */
contract AidLedger {
    address public owner;
    uint256 public totalDonations;

    struct Donation {
        address donor;
        uint256 amount;
        uint256 timestamp;
        string message;
    }

    Donation[] public donations;
    mapping(address => uint256) public donorBalances;

    event DonationReceived(address indexed donor, uint256 amount, string message);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Allows users to donate to the aid fund.
     * @param _message Optional message from the donor.
     */
    function donate(string calldata _message) external payable {
        require(msg.value > 0, "Donation must be greater than 0");

        donations.push(Donation(msg.sender, msg.value, block.timestamp, _message));
        donorBalances[msg.sender] += msg.value;
        totalDonations += msg.value;

        emit DonationReceived(msg.sender, msg.value, _message);
    }

    /**
     * @dev Allows the owner to withdraw funds for verified aid distribution.
     * @param _amount Amount to withdraw in wei.
     */
    function withdraw(uint256 _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Insufficient funds");
        payable(owner).transfer(_amount);

        emit FundsWithdrawn(owner, _amount);
    }

    /**
     * @dev Returns the total number of donations.
     */
    function getDonationCount() external view returns (uint256) {
        return donations.length;
    }
}
