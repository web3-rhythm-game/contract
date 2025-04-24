// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IGameCore.sol";
import "forge-std/console.sol";

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

    event UserRegistered(
        address indexed userAddress,
        string name,
        string email,
        string avatar
    );

    constructor(address _gameCore) {
        gameCore = _gameCore;
    }

    modifier onlyGameCoreOwner() {
        address owner = IGameCore(gameCore).owner();
        console.log("GameCore Owner: %s", owner);
        console.log("msg.sender: %s", msg.sender);

        require(owner == msg.sender, "Unauthorized: not GameCore owner");
        _;
    }

    function registerUser(address userWalletAddr, string calldata name) external onlyGameCoreOwner {
        require(
            users[userWalletAddr].wallet == address(0),
            "UserAlreadyRegistered"
        );
        users[userWalletAddr] = User({
            name: name,
            bio: "",
            wallet: userWalletAddr,
            email: "",
            avatar: "",
            joinedAt: uint40(block.timestamp)
        });
        emit UserRegistered(userWalletAddr, name, "", "");
    }

    function updateUser(
        string calldata name,
        string calldata bio,
        string calldata email,
        string calldata avatar
    ) external onlyGameCoreOwner {
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
