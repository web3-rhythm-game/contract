// app/song/page.js
"use client";

import React, { useState , useEffect} from "react";
import { useWriteContract, useReadContract } from "wagmi";
import { SongFactoryABI } from "../abis/SongFactoryABI";
import { SongABI } from "../abis/SongABI";
import { createPublicClient, http } from 'viem';
import { sepolia } from 'viem/chains';

// 실제 SongFactory 컨트랙트 주소로 변경하세요.
const SONG_FACTORY_ADDRESS = "0x99fc20754a02501d45e00455e470a8a3155d2784";

const TIER_LABELS = ["Free", "Rare", "SuperRare", "Seasonal"];

const TIER_OPTIONS = [
  { label: "Free", value: 0 },
  { label: "Rare", value: 1 },
  { label: "SuperRare", value: 2 },
  { label: "Seasonal", value: 3 }
];

function SongDialog({ open, onClose, songInfo }) {
  if (!open || !songInfo) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-40">
      <div className="bg-white rounded-xl shadow-lg max-w-md w-full p-6 relative">
        <button
          onClick={onClose}
          className="absolute top-2 right-2 text-gray-400 hover:text-gray-700 text-2xl"
        >
          &times;
        </button>
        <h2 className="text-2xl font-bold mb-4 text-indigo-700">{songInfo.title}</h2>
        <div className="space-y-2 text-gray-800">
          <div><span className="font-semibold">Artist:</span> {songInfo.artist}</div>
          <div><span className="font-semibold">Tier:</span> {TIER_LABELS[songInfo.tier]}</div>
          <div><span className="font-semibold">Duration:</span> {songInfo.duration} sec</div>
          <div><span className="font-semibold">BPM:</span> {songInfo.bpm}</div>
          <div><span className="font-semibold">Entrance Fee:</span> {songInfo.entranceFee}</div>
          <div><span className="font-semibold">Created At:</span> {new Date(Number(songInfo.createdAt) * 1000).toLocaleString()}</div>
          <div><span className="font-semibold">Game Version:</span> {songInfo.gameVersion}</div>
          <div><span className="font-semibold">NFT Required:</span> {songInfo.nftRequired}</div>
          <div><span className="font-semibold">Contract Address:</span> {songInfo.address}</div>
        </div>
      </div>
    </div>
  );
}

export default function SongRegisterPage() {
  const [form, setForm] = useState({
    id: "",
    title: "",
    artist: "",
    tier: 0,
    duration: "",
    bpm: "",
    entranceFee: "",
    createdAt: "",
    gameVersion: "",
    nftRequired: ""
  });

  const [songList, setSongList] = useState([]);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [selectedSong, setSelectedSong] = useState(null);

  // 곡 등록 트랜잭션
  const { writeContract, isPending, error } = useWriteContract();

  // 곡 주소 목록 조회
  const {
    data: songAddresses,
    refetch: refetchSongs,
    isLoading: isSongsLoading
  } = useReadContract({
    address: SONG_FACTORY_ADDRESS,
    abi: SongFactoryABI,
    functionName: "getAllSongs"
  });

  // 곡 주소 → 곡 이름 매핑
  useEffect(() => {
    if (!songAddresses || songAddresses.length === 0) {
      setSongList([]);
      return;
    }
    // 각 곡 주소에서 곡 정보 가져오기
    const fetchSongTitles = async () => {
      const viem = (await import("viem")).createPublicClient;
      const { http } = await import("viem");
      // Sepolia 클라이언트 설정
const client = createPublicClient({
    chain: sepolia,
    transport: http("https://eth-sepolia.g.alchemy.com/v2/Nb_H-LnqkqwPTvrxW0y0XOAPkm8zNOSF"), // 여기에 Infura API 키를 넣어주세요
});

      const promises = songAddresses.map(async (address) => {
        try {
          const [title] = await client.multicall({
            contracts: [{ address, abi: SongABI, functionName: "title" }]
          });
          return { address, title: title.result || "(제목 없음)" };
        } catch (e) {
          return { address, title: "(불러오기 실패)" };
        }
      });
      setSongList(await Promise.all(promises));
    };
    fetchSongTitles();
  }, [songAddresses]);

  // 곡 상세 정보 불러오기
  const fetchSongDetail = async (address) => {
    const viem = (await import("viem")).createPublicClient;
    const { http } = await import("viem");
    // 네트워크에 맞게 chainId, rpcUrl 수정
    const client = createPublicClient({
        chain: sepolia,
        transport: http("https://eth-sepolia.g.alchemy.com/v2/Nb_H-LnqkqwPTvrxW0y0XOAPkm8zNOSF"), // 여기에 Infura API 키를 넣어주세요
    });
    const calls = [
      { address, abi: SongABI, functionName: "title" },
      { address, abi: SongABI, functionName: "artist" },
      { address, abi: SongABI, functionName: "tier" },
      { address, abi: SongABI, functionName: "duration" },
      { address, abi: SongABI, functionName: "bpm" },
      { address, abi: SongABI, functionName: "entranceFee" },
      { address, abi: SongABI, functionName: "createdAt" },
      { address, abi: SongABI, functionName: "gameVersion" },
      { address, abi: SongABI, functionName: "nftRequired" }
    ];
    const results = await client.multicall({ contracts: calls });
    setSelectedSong({
      address,
      title: results[0].result,
      artist: results[1].result,
      tier: Number(results[2].result),
      duration: Number(results[3].result),
      bpm: Number(results[4].result),
      entranceFee: results[5].result.toString(),
      createdAt: results[6].result.toString(),
      gameVersion: Number(results[7].result),
      nftRequired: results[8].result
    });
    setIsDialogOpen(true);
  };

  // 폼 입력 핸들러
  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({
      ...prev,
      [name]: value
    }));
  };

  // 폼 제출
  const handleSubmit = async (e) => {
    e.preventDefault();
    writeContract({
      address: SONG_FACTORY_ADDRESS,
      abi: SongFactoryABI,
      functionName: "createSong",
      args: [
        BigInt(form.id),
        form.title,
        form.artist,
        Number(form.tier),
        Number(form.duration),
        Number(form.bpm),
        BigInt(form.entranceFee),
        BigInt(form.createdAt),
        Number(form.gameVersion),
        form.nftRequired
      ],
      onSuccess: () => {
        refetchSongs();
        setForm({
          id: "",
          title: "",
          artist: "",
          tier: 0,
          duration: "",
          bpm: "",
          entranceFee: "",
          createdAt: "",
          gameVersion: "",
          nftRequired: ""
        });
      }
    });
  };

  return (
    <div className="max-w-2xl mx-auto p-8 bg-white rounded-xl shadow">
      <h2 className="text-3xl font-bold mb-6 text-gray-900">Song 등록</h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        {/* ... (Song 등록 폼은 이전과 동일) ... */}
        <div>
          <label className="block font-semibold text-gray-700 mb-1">ID</label>
          <input type="number" name="id" value={form.id} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">Title</label>
          <input name="title" value={form.title} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">Artist</label>
          <input name="artist" value={form.artist} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">Tier</label>
          <select name="tier" value={form.tier} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required>
            {TIER_OPTIONS.map((opt) => (
              <option key={opt.value} value={opt.value}>{opt.label}</option>
            ))}
          </select>
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">Duration (sec)</label>
          <input type="number" name="duration" value={form.duration} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">BPM</label>
          <input type="number" name="bpm" value={form.bpm} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">Entrance Fee (wei)</label>
          <input type="number" name="entranceFee" value={form.entranceFee} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">Created At (timestamp)</label>
          <input type="number" name="createdAt" value={form.createdAt} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">Game Version</label>
          <input type="number" name="gameVersion" value={form.gameVersion} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <div>
          <label className="block font-semibold text-gray-700 mb-1">NFT Required (address)</label>
          <input name="nftRequired" value={form.nftRequired} onChange={handleChange} className="w-full border px-3 py-2 rounded text-gray-800" required />
        </div>
        <button type="submit" disabled={isPending} className="w-full bg-indigo-600 text-white py-2 rounded font-semibold hover:bg-indigo-700">
          {isPending ? "등록 중..." : "등록하기"}
        </button>
        {error && <div className="text-red-600 mt-2">{error.message}</div>}
      </form>

      <h3 className="text-xl font-bold mt-10 mb-4 text-gray-900">등록된 곡 목록</h3>
      {isSongsLoading ? (
        <div>불러오는 중...</div>
      ) : songList.length > 0 ? (
        <ul className="divide-y divide-gray-200">
          {songList.map((song, idx) => (
            <li key={song.address} className="py-2 text-indigo-700 font-semibold cursor-pointer hover:underline"
                onClick={() => fetchSongDetail(song.address)}>
              {idx + 1}. {song.title}
            </li>
          ))}
        </ul>
      ) : (
        <div className="text-gray-500">아직 곡이 없습니다.</div>
      )}

      <SongDialog open={isDialogOpen} onClose={() => setIsDialogOpen(false)} songInfo={selectedSong} />
    </div>
  );
}
