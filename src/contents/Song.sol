// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Song is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    enum Tier { Free, Rare, SuperRare, Seasonal }

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

    function initialize(
        uint64 _id,
        string calldata _title,
        string calldata _artist,
        Tier _tier,
        uint16 _duration,
        uint16 _bpm,
        uint128 _entranceFee,
        uint40 _createdAt,
        uint16 _gameVersion,
        address _nftRequired
    ) external initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

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

    function setTitle(string calldata _title) external onlyOwner {
        title = _title;
        updatedAt = uint40(block.timestamp);
    }

    function setArtist(string calldata _artist) external onlyOwner {
        artist = _artist;
        updatedAt = uint40(block.timestamp);
    }

    function setTier(Tier _tier) external onlyOwner {
        tier = _tier;
        updatedAt = uint40(block.timestamp);
    }

    function setDuration(uint16 _duration) external onlyOwner {
        duration = _duration;
        updatedAt = uint40(block.timestamp);
    }

    function setBpm(uint16 _bpm) external onlyOwner {
        bpm = _bpm;
        updatedAt = uint40(block.timestamp);
    }

    function setEntranceFee(uint128 _fee) external onlyOwner {
        entranceFee = _fee;
        updatedAt = uint40(block.timestamp);
    }

    function setGameVersion(uint16 _version) external onlyOwner {
        gameVersion = _version;
        updatedAt = uint40(block.timestamp);
    }

    function setNftRequired(address _nft) external onlyOwner {
        nftRequired = _nft;
        updatedAt = uint40(block.timestamp);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
