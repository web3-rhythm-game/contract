// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {GameCore} from "../src/core/GameCore.sol";
import {UserManager} from "../src/core/UserManager.sol";
import {GamePlayManager} from "../src/core/GamePlayManager.sol";
import {TierManager} from "../src/core/TierManager.sol";
import {Beat} from "../src/tokens/Beat.sol";
import {BeatGem} from "../src/tokens/BeatGem.sol";
import {Album} from "../src/contents/Album.sol";
import {Song} from "../src/contents/Song.sol";
import {SongFactory} from "../src/contents/SongFactory.sol";
import {IGameCore} from "../src/interfaces/IGameCore.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        // 1. Core Contracts
        GameCore gameCore = new GameCore();
        UserManager userManager = new UserManager(address(gameCore));
        GamePlayManager gamePlayManager = new GamePlayManager(
            address(gameCore)
        );
        TierManager tierManager = new TierManager(address(gameCore));
        Album album = new Album(address(gameCore));
        Beat beat = new Beat(address(gameCore));
        BeatGem beatGem = new BeatGem(address(gameCore));

        // 2. SongFactory와 Song 직접 배포
        SongFactory songFactory = new SongFactory(address(gameCore));

        // GameCore에 모듈 등록
        gameCore.setManager("UserManager", address(userManager));
        gameCore.setManager("GamePlayManager", address(gamePlayManager));
        gameCore.setManager("TierManager", address(tierManager));
        gameCore.setManager("Album", address(album));
        gameCore.setManager("Beat", address(beat));
        gameCore.setManager("BeatGem", address(beatGem));
        gameCore.setManager("SongFactory", address(songFactory));

        // 3. 예시 Song 생성
        songFactory.createSong(
            1,
            "Superbeat",
            "ArtistA",
            Song.Tier.Rare,
            180,
            120,
            0.01 ether,
            uint40(block.timestamp),
            1,
            address(0)
        );

        songFactory.createSong(
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

        vm.stopBroadcast();
    }
}
