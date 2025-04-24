// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Song is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    enum Tier {
        Free,
        Rare,
        SuperRare,
        Seasonal
    }

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

    struct SongParams {
        uint64 id;
        string title;
        string artist;
        Tier tier;
        uint16 duration;
        uint16 bpm;
        uint128 entranceFee;
        uint40 createdAt;
        uint16 gameVersion;
        address nftRequired;
    }

    function initialize(SongParams calldata params) external initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        id = params.id;
        title = params.title;
        artist = params.artist;
        tier = params.tier;
        duration = params.duration;
        bpm = params.bpm;
        entranceFee = params.entranceFee;
        createdAt = params.createdAt;
        updatedAt = params.createdAt;
        gameVersion = params.gameVersion;
        nftRequired = params.nftRequired;
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

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
