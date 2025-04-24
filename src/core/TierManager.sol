// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IGameCore.sol"; 

contract TierManager {
    enum Tier { Free, Rare, SuperRare, Seasonal }

    struct TierInfo {
        uint128 tokenRequired;
    }

    mapping(Tier => TierInfo) public tierInfo;

    event TokenRequiredSet(Tier tier, uint128 tokenRequired);
    
    address public gameCore;
    constructor(address _gameCore) {
        gameCore = _gameCore;
    }
    
    modifier onlyGameCoreOwner() {
		    require(IGameCore(gameCore).owner() == msg.sender, "Unauthorized: not GameCore owner");
		    _;
		}

    function setTokenRequired(Tier tier, uint128 amount) external onlyGameCoreOwner() {
        tierInfo[tier].tokenRequired = amount;
        emit TokenRequiredSet(tier, amount);
    }

    function getRequiredToken(Tier tier) external view returns (uint128) {
        return tierInfo[tier].tokenRequired;
    }
}
