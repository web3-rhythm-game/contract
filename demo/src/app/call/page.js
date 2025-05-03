// app/tester/page.js
import ContractABICall from '../components/ContractTester';

export default function ContractTesterPage() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <h1 className="text-4xl font-bold text-blue-800 mb-8">Contract ABI call</h1>
      <ContractABICall />
    </div>
  );
}
