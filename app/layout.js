import { Inter } from "next/font/google";
import "./globals.css";
import Header from "@/components/header";
import { ClerkProvider } from "@clerk/nextjs";
import { Toaster } from "sonner";
import {
  Instagram,
  Facebook,
  Linkedin,
} from "lucide-react";

const inter = Inter({
  subsets: ["latin"],
});

export const metadata = {
  title: "VehiQL",
  description: "Find your Dream Car",
};

export default function RootLayout({ children }) {
  return (
    <ClerkProvider>
      <html lang="en">
        <body className={inter.className}>
          <Header />

          <main className="min-h-screen">{children}</main>

          <Toaster richColors />

          <footer className="border-t border-slate-200 bg-slate-50 py-8">
            <div className="container mx-auto px-4">
              <div className="flex flex-col md:flex-row items-center justify-between gap-4">

                {/* Left Side */}
                <p className="text-sm text-slate-700 text-center md:text-left">
                  © 2026 VehiQL. All rights reserved.{" "}
                  <span className="font-semibold bg-gradient-to-r from-violet-600 via-blue-700 to-cyan-600 bg-clip-text text-transparent">
                    ✨ Powered by AI-driven vehicle intelligence.
                  </span>
                </p>

                {/* Right Side Social Icons */}
                <div className="flex items-center gap-5">

                  <a
                    href="https://www.instagram.com/rony.builds_03"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-slate-500 hover:text-pink-500 transition-colors"
                  >
                    <Instagram size={20} />
                  </a>

                  <a
                    href="https://www.facebook.com/deepyaman.mondal"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-slate-500 hover:text-blue-600 transition-colors"
                  >
                    <Facebook size={20} />
                  </a>

                  <a
                    href="https://www.linkedin.com/in/deepyaman-mondal-8592a3265"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-slate-500 hover:text-sky-600 transition-colors"
                  >
                    <Linkedin size={20} />
                  </a>

                  {/* X (Twitter) */}
                  <a
                    href="https://x.com/SDE_Rony"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-slate-500 hover:text-black transition-colors"
                    aria-label="X"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      className="w-5 h-5"
                    >
                      <path d="M18.244 2H21l-6.56 7.497L22 22h-5.828l-4.565-5.967L6.39 22H3.633l7.017-8.018L2 2h5.976l4.126 5.447L18.244 2z" />
                    </svg>
                  </a>

                </div>
              </div>
            </div>
          </footer>
        </body>
      </html>
    </ClerkProvider>
  );
}