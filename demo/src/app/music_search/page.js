'use client'

import { useState } from 'react'

export default function MusicSearchPage() {
    const [cid, setCid] = useState('')
    const [input, setInput] = useState('')

    const handleSearch = () => {
        if (!input) return
        setCid(input.trim())
    }

    return (
        <div className="min-h-screen bg-gray-100 flex items-center justify-center px-4">
            <div className="bg-white p-8 rounded-2xl shadow-xl w-full max-w-md space-y-6">
                <h1 className="text-2xl font-bold text-center">🎵 IPFS 음악 검색기</h1>

                <input
                    type="text"
                    placeholder="IPFS 해시 (CID)를 입력하세요"
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                    className="w-full px-4 py-2 border rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                />

                <button
                    onClick={handleSearch}
                    className="w-full bg-blue-600 text-white py-2 rounded-xl hover:bg-blue-700 transition"
                >
                    재생하기
                </button>

                {cid && (
                    <div className="space-y-4">
                        <p className="text-sm text-gray-500 break-all">CID: {cid}</p>
                        <audio controls className="w-full">
                            <source src={`https://ipfs.io/ipfs/${cid}`} type="audio/mpeg" />
                            브라우저가 오디오 태그를 지원하지 않습니다.</audio>
                        {/* <audio controls className="w-full">
                            <source src={`https://cloudflare-ipfs.com/ipfs/${cid}`} type="audio/mpeg" />
                            브라우저가 오디오 태그를 지원하지 않습니다.</audio>
                        <audio controls className="w-full">
                            <source src={`https://gateway.pinata.cloud/ipfs/${cid}`} type="audio/mpeg" />
                            브라우저가 오디오 태그를 지원하지 않습니다.</audio> */}

                    </div>
                )}
            </div>
        </div>
    )
}
