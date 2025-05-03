import '@rainbow-me/rainbowkit/styles.css';
import { Providers } from './provider.js';
import './globals.css';
import Link from 'next/link';

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <Providers>
          <div className="flex flex-col min-h-screen">
            <header className="bg-white shadow-md py-4">
              <div className="container mx-auto px-4">
                <nav className="flex items-center justify-between">
                  <Link href="/" className="text-2xl font-bold text-gray-800">
                    Web3 Rhythm Game
                  </Link>
                  <div className="flex space-x-4">
                    <Link href="/call" className="text-blue-600 hover:text-blue-800">
                      Contract call
                    </Link>
                    <Link href="/register" className="text-blue-600 hover:text-blue-800">
                      User Registration
                    </Link>
                    <Link href="/song" className="text-blue-600 hover:text-blue-800">
                      Song
                    </Link>
                    <Link href="/music_search" className="text-blue-600 hover:text-blue-800">
                      music_search
                    </Link>
                  </div>
                </nav>
              </div>
            </header>
            <main className="flex-grow">
              <div className="container mx-auto p-8">
                {children}
              </div>
            </main>
            <footer className="bg-gray-200 text-center py-4">
              <p className="text-gray-600">
                © 2025 Web3 Rhythm Game
              </p>
            </footer>
          </div>
        </Providers>
      </body>
    </html>
  );
}