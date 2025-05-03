// components/UserRegistration.js
'use client';
import React, { useState } from "react";
import { useAccount, useWriteContract, useReadContract } from "wagmi";
import { UserManagerABI } from "../abis/UserManagerABI";

const userManagerAddress = '0x9c1ad93d0646d6403aa34be6f725aeeb1c78d952';  // 여기에 배포된 컨트랙트 주소를 넣어주세요

export default function UserRegistration() {
  const { address } = useAccount();
  const [name, setName] = useState("");
  const [registerArgs, setRegisterArgs] = useState(null);

  // 유저 등록 트랜잭션
  const {
    writeContract,
    isPending: isRegistering,
    error: registerError,
    data: txHash,
  } = useWriteContract();

  // 유저 정보 읽기
  const {
    data: user,
    refetch,
    isLoading: isUserLoading,
  } = useReadContract({
    address: userManagerAddress,
    abi: UserManagerABI,
    functionName: "getUser",
    args: address ? [address] : undefined,
    query: { enabled: !!address },
  });

  // 폼 제출
  const handleSubmit = (e) => {
    e.preventDefault();
    if (!address || !name) return;
    writeContract({
      address: userManagerAddress,
      abi: UserManagerABI,
      functionName: "registerUser",
      args: [address, name],
    });
    setTimeout(refetch, 2000); // 등록 후 유저 정보 새로고침
  };

  return (
    <div className="max-w-xl mx-auto p-8 bg-white rounded shadow">
  <h2 className="text-3xl font-bold mb-4 text-gray-900">유저 가입</h2> {/* title 키우고 폰트 색깔 진하게 변경 */}
  <form onSubmit={handleSubmit} className="space-y-4">
    <label className="block font-semibold text-gray-700">이름:</label> {/* label 폰트 굵게, 색깔 진하게 */}
    <input
      className="w-full border px-3 py-2 rounded text-gray-800" /* input 폰트 색깔 진하게 */
      placeholder="이름"
      value={name}
      onChange={e => setName(e.target.value)}
    />
    <button
      type="submit"
      disabled={isRegistering}
      className="w-full bg-indigo-600 text-white py-2 rounded hover:bg-indigo-700 font-semibold" /* button 폰트 굵게 */
    >
      {isRegistering ? "가입 중..." : "가입하기"}
    </button>
    {registerError && (
      <div className="text-red-600">{registerError.message}</div>
    )}
  </form>

  <div className="mt-8">
    <h3 className="text-xl font-semibold mb-2 text-gray-900">내 정보</h3> {/* 정보 title 키우고 폰트 색깔 진하게 변경 */}
    {isUserLoading ? (
      <div>불러오는 중...</div>
    ) : user && user.wallet !== "0x0000000000000000000000000000000000000000" ? (
      <div className="border rounded p-4 text-gray-800"> {/* 정보 폰트 색깔 진하게 */}
        <div>이름: {user.name}</div>
        <div>지갑: {user.wallet}</div>
        <div>가입일: {user.joinedAt}</div>
      </div>
    ) : (
      <div>아직 가입되지 않았습니다.</div>
    )}
  </div>
</div>

  );
}