// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Song {
    enum Tier {
        Free,
        Rare,
        SuperRare,
        Seasonal
    }

    address public owner;

    uint64 public id;
    string public title;
    string public artist;
    Tier public tier;
    uint16 public duration;
    uint16 public bpm;
    uint128 public entranceFee;
    uint40 public createdAt;
    uint40 public updatedAt;
    uint16 public gameVersion;
    address public nftRequired;

    constructor(
        uint64 _id,
        string memory _title,
        string memory _artist,
        Tier _tier,
        uint16 _duration,
        uint16 _bpm,
        uint128 _entranceFee,
        uint40 _createdAt,
        uint16 _gameVersion,
        address _nftRequired
    ) {
        owner = msg.sender;
        id = _id;
        title = _title;
        artist = _artist;
        tier = _tier;
        duration = _duration;
        bpm = _bpm;
        entranceFee = _entranceFee;
        createdAt = _createdAt;
        updatedAt = _createdAt;
        gameVersion = _gameVersion;
        nftRequired = _nftRequired;
    }
}