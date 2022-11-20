//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Transaction {
    uint256 public electricityPrice = 10 wei;
    address payable owner;

    uint256 internal demand = 0;
    uint256 internal supply = 0;

    mapping(address => uint256) addressToMeterId;

    constructor() {
        owner = payable(msg.sender);
    }

    function closeRelay(uint256 electricityAmount, bool incoming) internal {
        incoming ? demand -= electricityAmount : supply -= electricityAmount;
        // call api to close relay
        // ask smart meter to notify when electricityAmount has been received/sent
    }

    function openRelay() internal {
        // smart meter contacts to confirm transfer
        // call api to open relay
    }

    function buyElectricity(uint256 electricityAmount) external payable {
        demand += electricityAmount;

        require(supply > 0, "There is currently no supply.");

        uint256 totalPrice = electricityAmount * electricityPrice;
        require(msg.sender.balance >= totalPrice, "Insufficient balance");
        require(msg.value >= totalPrice, "Insufficient money sent");

        closeRelay(electricityAmount, true);
    }

    function sellElectricity(uint256 electricityAmount) external payable {
        supply += electricityAmount;

        require(demand > 0, "There is currently no demand.");

        uint256 totalPrice = electricityAmount * electricityPrice;

        closeRelay(electricityAmount, false);

        msg.sender.call{value: totalPrice}("");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
