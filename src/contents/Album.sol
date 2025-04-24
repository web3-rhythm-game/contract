// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "../interfaces/IGameCore.sol"; 

contract Album is ERC1155 {
    struct AlbumData {
        uint64 songId;
        string icon;
        uint32 mintedCount;
        string title;
        string description;
    }

    mapping(uint256 => AlbumData) public albums;
    
    address public gameCore;

    constructor(address _gameCore) ERC1155("https://api.example.com/metadata/{id}.json") {
        gameCore = _gameCore;
    }
    
    modifier onlyGameCoreOwner(address gameCore) {
		    require(IGameCore(gameCore).owner() == msg.sender, "Unauthorized: not GameCore owner");
		    _;
		}

    function mintAlbum(address to, uint64 songId, uint256 amount) external onlyGameCoreOwner(msg.sender) {
        uint256 albumId = uint256(songId);
        albums[albumId].mintedCount += uint32(amount);
        _mint(to, albumId, amount, "");
        emit AlbumMinted(to, songId, amount);
    }

    function setMetadata(uint64 songId, string calldata icon, string calldata title, string calldata description) external onlyGameCoreOwner(msg.sender){
        uint256 albumId = uint256(songId);
        albums[albumId].icon = icon;
        albums[albumId].title = title;
        albums[albumId].description = description;
    }

    function uri(uint256 id) public view override returns (string memory) {
        return string(abi.encodePacked("https://api.example.com/metadata/", uint2str(id), ".json"));
    }

    function totalMinted(uint64 songId) external view returns (uint32) {
        return albums[uint256(songId)].mintedCount;
    }

    event AlbumMinted(address indexed to, uint64 indexed songId, uint256 amount);
}
