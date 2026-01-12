"use client";

import Link from "next/link";
import { BookOpen } from "lucide-react";

export function Header() {
  return (
    <header className="absolute top-0 left-0 right-0 z-50 p-6">
      <div className="max-w-6xl mx-auto flex justify-between items-center">
        <Link href="/" className="text-2xl font-bold tracking-tight">
          MDP
        </Link>
        <nav className="flex gap-8 text-sm font-medium items-center">
          <Link href="/vocabulary" className="opacity-70 hover:opacity-100 transition" title="تمرین لغات">
            <BookOpen size={20} />
          </Link>
          <Link href="/fields" className="opacity-70 hover:opacity-100 transition">
            مشاهده سوالات
          </Link>
        </nav>
      </div>
    </header>
  );
}
