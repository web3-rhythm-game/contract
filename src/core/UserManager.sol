// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IGameCore.sol"; 

contract UserManager {
    struct User {
        string name;
        string bio;
        address wallet;
        string email;
        string avatar;
        uint40 joinedAt;
    }

    mapping(address => User) public users;
    address public gameCore;

    event UserRegistered(address indexed userAddress, string name, string email, string avatar);

    constructor(address _gameCore) {
        gameCore = _gameCore;
    }

    modifier onlyGameCoreOwner(address gameCore) {
		    require(IGameCore(gameCore).owner() == msg.sender, "Unauthorized: not GameCore owner");
		    _;
		}


    function registerUser() external onlyGameCoreOwner(msg.sender) {
        require(users[msg.sender].wallet == address(0), "UserAlreadyRegistered");
        users[msg.sender] = User({
            name: "Unknown",
            bio: "",
            wallet: msg.sender,
            email: "",
            avatar: "",
            joinedAt: uint40(block.timestamp)
        });
        emit UserRegistered(msg.sender, "Unknown", "", "");
    }

    function updateUser(string calldata name, string calldata bio, string calldata email, string calldata avatar) external onlyGameCoreOwner(msg.sender) {
        require(users[msg.sender].wallet != address(0), "UserNotFound");
        users[msg.sender].name = name;
        users[msg.sender].bio = bio;
        users[msg.sender].email = email;
        users[msg.sender].avatar = avatar;
    }

    function getUser(address userAddress) external view returns (User memory) {
        return users[userAddress];
    }
}
