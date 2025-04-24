// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GameCore is Ownable {
    mapping(string => address) public managers;

    event ManagerSet(string key, address manager);
    
    constructor() Ownable(msg.sender) {}

    function setManager(string memory key, address manager) external onlyOwner {
        managers[key] = manager;
        emit ManagerSet(key, manager);
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        emit OwnershipTransferred(msg.sender, newOwner);
    }

    function getManager(string memory key) external view returns (address) {
        return managers[key];
    }
}
