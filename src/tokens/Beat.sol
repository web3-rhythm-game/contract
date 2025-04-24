// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../interfaces/IGameCore.sol"; 

contract Beat is ERC20 {
    address public gameCore;

		event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    constructor(address _gameCore) ERC20("Beat", "BT") {
        gameCore = _gameCore;
    }
    
    modifier onlyGameCoreOwner(address gameCore) {
		    require(IGameCore(gameCore).owner() == msg.sender, "Unauthorized: not GameCore owner");
		    _;
		}

    function mint(address to, uint256 amount) external onlyGameCoreOwner(msg.sender) {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burn(address from, uint256 amount) external onlyGameCoreOwner(msg.sender) {
        _burn(from, amount);
        emit TokensBurned(from, amount);
    }
}
