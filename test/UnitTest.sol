// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./BaseTest.t.sol";
import "../src/contents/Song.sol";

contract UnitTest is BaseTest {
    function testUserRegistration() public {
        vm.prank(owner);
        userManager.registerUser(user, "testUser");
        UserManager.User memory u = userManager.getUser(user);

        assertEq(u.name, "testUser");
    }

    function testRecordGamePlay() public {
        vm.prank(owner);
        userManager.registerUser(user, "testUser");

        uint64 gameId = gamePlayManager.recordGamePlay(user, 1, 1, 1, 1, 1, 1);
        address playerAddr = gamePlayManager.getGamePlay(gameId).player;
        assertEq(user, playerAddr);
    }

    function testMintBeatToUser() public {
        beat.mint(user, 1000 ether);
        assertEq(beat.balanceOf(user), 1000 ether);
    }

    function testMintAlbumToUser() public {
        album.mintAlbum(user, 1, 3);
        album.mintAlbum(user, 2, 5);
        assertEq(album.balanceOf(user, 1), 3);
    }

    function testFullFlow() public {
        // 등록
        vm.prank(owner);
        userManager.registerUser(user, "testUser");

        // 플레이 기록
        uint64 gameId = gamePlayManager.recordGamePlay(user, 1, 1, 1, 1, 1, 1);

        // 보상 지급
        beat.mint(user, 1000 ether);
        album.mintAlbum(user, 1, 3);
        album.mintAlbum(user, 2, 4);

        // 검증
        assertEq(beat.balanceOf(user), 1000 ether);
        assertEq(album.balanceOf(user, 1), 3);
        address playerAddr = gamePlayManager.getGamePlay(gameId).player;
        assertEq(user, playerAddr);
    }
}
