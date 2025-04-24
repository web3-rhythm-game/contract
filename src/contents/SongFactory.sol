// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Song.sol";
import "../interfaces/IGameCore.sol";

contract SongFactory {
    address public gameCore;
    address[] public songs;

    event SongCreated(address indexed song, uint64 indexed id);

    constructor(address _gameCore) {
        gameCore = _gameCore;
    }

    modifier onlyGameCoreOwner() {
        require(IGameCore(gameCore).owner() == msg.sender, "Unauthorized: not GameCore owner");
        _;
    }

    function createSong(
        uint64 id,
        string calldata title,
        string calldata artist,
        Song.Tier tier,
        uint16 duration,
        uint16 bpm,
        uint128 entranceFee,
        uint40 createdAt,
        uint16 gameVersion,
        address nftRequired
    ) external onlyGameCoreOwner returns (address) {
        Song song = new Song(
            id, title, artist, tier, duration, bpm,
            entranceFee, createdAt, gameVersion, nftRequired
        );

        songs.push(address(song));
        emit SongCreated(address(song), id);
        return address(song);
    }

    function getAllSongs() external view returns (address[] memory) {
        return songs;
    }
}