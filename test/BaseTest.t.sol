// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/core/GameCore.sol";
import "../src/core/UserManager.sol";
import "../src/core/GamePlayManager.sol";
import "../src/tokens/Beat.sol";
import "../src/contents/Album.sol";
import "../src/contents/SongFactory.sol";
import "../src/contents/Song.sol";

contract BaseTest is Test {
    address owner;
    address user;

    GameCore gameCore;
    UserManager userManager;
    GamePlayManager gamePlayManager;
    SongFactory songFactory;
    Beat beat;
    Album album;
    Song song1;
    Song song2;

    function setUp() public {
        owner = address(this);
        user = address(0xBEEF);

        vm.prank(owner);

        // 모듈들 배포
        gameCore = new GameCore();
        userManager = new UserManager(address(gameCore));
        gamePlayManager = new GamePlayManager(address(gameCore));
        beat = new Beat(address(gameCore));
        album = new Album(address(gameCore));
        songFactory = new SongFactory(address(gameCore));

        // GameCore에 모듈 등록
        gameCore.setManager("UserManager", address(userManager));
        gameCore.setManager("GamePlayManager", address(gamePlayManager));
        gameCore.setManager("SongFactory", address(songFactory));
        gameCore.setManager("Beat", address(beat));
        gameCore.setManager("Album", address(album));

        address song1Addr = songFactory.createSong(
            1, // id
            "Superbeat", // title
            "ArtistA", // artist
            Song.Tier.Rare, // tier
            180, // duration (초)
            120, // bpm
            0.01 ether, // entranceFee
            uint40(block.timestamp), // createdAt
            1, // gameVersion
            address(0) // nftRequired
        );

        address song2Addr = songFactory.createSong(
            2,
            "MegaRhythm",
            "ArtistB",
            Song.Tier.SuperRare,
            200,
            128,
            0.02 ether,
            uint40(block.timestamp),
            1,
            address(0)
        );

        song1 = Song(song1Addr);
        song2 = Song(song2Addr);
    }
}
