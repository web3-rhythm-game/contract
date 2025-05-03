// app/register/page.js
import UserRegistration from '../components/UserRegistration';

export default function UserRegistrationPage() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <h1 className="text-4xl font-bold text-blue-800 mb-8">User Registration</h1>
      <UserRegistration />
    </div>
  );
}
