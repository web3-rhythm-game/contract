'use client';

// components/ContractTester.js
import React, { useState } from 'react';
import { useWriteContract } from 'wagmi';
import { ConnectButton } from '@rainbow-me/rainbowkit';

export default function ContractTester() {
  const [contractAddress, setContractAddress] = useState('');
  const [abi, setAbi] = useState('');
  const [functionName, setFunctionName] = useState('');
  const [args, setArgs] = useState('');
  const [txResult, setTxResult] = useState(null);

  const { writeContractAsync, isPending, error } = useWriteContract();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setTxResult(null);

    try {
      const parsedArgs = args ? JSON.parse(args) : [];
      const abiObj = JSON.parse(abi);

      const result = await writeContractAsync({
        address: contractAddress,
        abi: abiObj,
        functionName,
        args: parsedArgs,
      });
      setTxResult(result);
    } catch (err) {
      setTxResult({ error: err.message });
    }
  };

  return (
    <div className="max-w-2xl mx-auto p-6 bg-white rounded-xl shadow-md">
      <div className="mb-6 flex justify-between items-center">
        <h2 className="text-2xl font-bold text-gray-800">Web3 Rhythm Game Tester</h2>
        <ConnectButton />
      </div>
      
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Contract Address</label>
          <input
            type="text"
            value={contractAddress}
            onChange={(e) => setContractAddress(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">ABI (JSON)</label>
          <textarea
            value={abi}
            onChange={(e) => setAbi(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 h-32"
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Function Name</label>
          <input
            type="text"
            value={functionName}
            onChange={(e) => setFunctionName(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Arguments (JSON array)</label>
          <input
            type="text"
            value={args}
            onChange={(e) => setArgs(e.target.value)}
            placeholder='예: ["0x123...", 100]'
            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          />
        </div>
        
        <button
          type="submit"
          disabled={isPending}
          className={`w-full py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors ${isPending ? 'opacity-70 cursor-not-allowed' : ''}`}
        >
          {isPending ? '처리 중...' : 'Execute Transaction'}
        </button>
        
        {error && (
          <div className="p-3 bg-red-50 text-red-700 rounded-md text-sm">
            {error.message}
          </div>
        )}
        
        {txResult && (
          <div className="mt-4 p-4 bg-gray-50 rounded-md overflow-x-auto">
            <h3 className="text-sm font-medium text-gray-700 mb-2">Transaction Result:</h3>
            <pre className="text-xs text-gray-600">{JSON.stringify(txResult, null, 2)}</pre>
          </div>
        )}
      </form>
    </div>
  );
}
