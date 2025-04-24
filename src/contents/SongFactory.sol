// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Song.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../interfaces/IGameCore.sol"; 

contract SongFactory {
    address public implementation;
    address public gameCore;
    address[] public songs;

    event SongCreated(address indexed song, uint64 indexed id);

    constructor(address _gameCore, address _impl) {
        implementation = _impl;
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
    ) external onlyGameCoreOwner() returns (address) {
        bytes memory initData = abi.encodeWithSelector(
            Song.initialize.selector,
            id, title, artist, tier, duration, bpm,
            entranceFee, createdAt, gameVersion, nftRequired
        );

        ERC1967Proxy proxy = new ERC1967Proxy(implementation, initData);
        songs.push(address(proxy));

        emit SongCreated(address(proxy), id);
        return address(proxy);
    }

    function getAllSongs() external view returns (address[] memory) {
        return songs;
    }

    function updateImplementation(address newImpl) external {
        implementation = newImpl;
    }
}

