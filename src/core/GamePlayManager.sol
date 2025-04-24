// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IGameCore.sol"; 

contract GamePlayManager {
    struct GamePlay {
        uint64 id;
        uint32 playTime;
        uint40 createdAt;
        uint64 score;
        uint16 miss;
        uint16 bad;
        uint16 good;
        uint16 perfect;
        address player;
        uint64 songId;
    }

    mapping(uint64 => GamePlay) public gamePlays;
    uint64 public nextId;
    address public gameCore;

    event GamePlayRecorded(address indexed userAddress, uint64 indexed gamePlayId, uint64 songId, uint256 score, uint256 miss, uint256 bad, uint256 good, uint256 perfect);

    constructor(address _gameCore) {
        gameCore = _gameCore;
    }

    modifier onlyGameCoreOwner() {
		    require(IGameCore(gameCore).owner() == msg.sender, "Unauthorized: not GameCore owner");
		    _;
		}

    function recordGamePlay(address user, uint64 songId, uint256 score, uint256 miss, uint256 bad, uint256 good, uint256 perfect) external onlyGameCoreOwner() returns (uint64) {
        uint64 gameId = nextId++;
        gamePlays[gameId] = GamePlay({
            id: gameId,
            playTime: uint32(block.timestamp),
            createdAt: uint40(block.timestamp),
            score: uint64(score),
            miss: uint16(miss),
            bad: uint16(bad),
            good: uint16(good),
            perfect: uint16(perfect),
            player: user,
            songId: songId
        });
        emit GamePlayRecorded(user, gameId, songId, score, miss, bad, good, perfect);
        return gameId;
    }

    function getGamePlay(uint64 id) external view returns (GamePlay memory) {
        return gamePlays[id];
    }

    function getUserGamePlays(address user) external view returns (GamePlay[] memory) {
        uint64 playCount = nextId;
        GamePlay[] memory plays = new GamePlay[](playCount);
        uint64 index = 0;
        for (uint64 i = 0; i < playCount; i++) {
            if (gamePlays[i].player == user) {
                plays[index++] = gamePlays[i];
            }
        }
        return plays;
    }

    function getAllGamePlays() external view returns (GamePlay[] memory) {
        uint64 playCount = nextId;
        GamePlay[] memory plays = new GamePlay[](playCount);
        for (uint64 i = 0; i < playCount; i++) {
            plays[i] = gamePlays[i];
        }
        return plays;
    }
}
