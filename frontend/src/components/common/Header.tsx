"use client";

import { useState } from "react";
import Link from "next/link";
import { ChevronDown } from "lucide-react";

interface MenuItem {
  label: string;
  href?: string;
  children?: { label: string; href: string; description?: string }[];
}

const menuItems: MenuItem[] = [
  {
    label: "سوالات کنکور",
    children: [
      { label: "رشته‌ها", href: "/fields", description: "مشاهده رشته‌های تحصیلی" },
    ],
  },
  {
    label: "لغات",
    children: [
      { label: "فلش‌کارت", href: "/vocabulary", description: "تمرین با فلش‌کارت" },
      { label: "آزمون", href: "/vocabulary/quiz", description: "آزمون لغات" },
    ],
  },
  {
    label: "درباره ما",
    href: "/about",
  },
];

export function Header() {
  return (
    <header className="absolute top-0 left-0 right-0 z-50 p-6">
      <div className="max-w-6xl mx-auto flex justify-between items-center">
        {/* Logo - Left */}
        <Link href="/" className="text-2xl font-bold tracking-tight">
          MDP
        </Link>

        {/* Menu - Center */}
        <nav className="hidden md:flex gap-1 text-sm font-medium items-center">
          {menuItems.map((item) => (
            <NavItem key={item.label} item={item} />
          ))}
        </nav>

        {/* Right side - placeholder for future CTA */}
        <div className="w-16" />
      </div>
    </header>
  );
}

function NavItem({ item }: { item: MenuItem }) {
  const [isOpen, setIsOpen] = useState(false);

  if (!item.children) {
    return (
      <Link
        href={item.href || "#"}
        className="px-4 py-2 rounded-lg opacity-70 hover:opacity-100 hover:bg-white/10 transition"
      >
        {item.label}
      </Link>
    );
  }

  return (
    <div
      className="relative"
      onMouseEnter={() => setIsOpen(true)}
      onMouseLeave={() => setIsOpen(false)}
    >
      <button
        className="flex items-center gap-1 px-4 py-2 rounded-lg opacity-70 hover:opacity-100 hover:bg-white/10 transition"
        onClick={() => setIsOpen(!isOpen)}
      >
        {item.label}
        <ChevronDown
          size={14}
          className={`transition-transform ${isOpen ? "rotate-180" : ""}`}
        />
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div className="absolute top-full right-0 pt-2 min-w-48">
          <div className="bg-white rounded-xl shadow-lg border border-gray-100 py-2 text-gray-800">
            {item.children.map((child) => (
              <Link
                key={child.href}
                href={child.href}
                className="block px-4 py-2 hover:bg-gray-50 transition"
              >
                <div className="font-medium">{child.label}</div>
                {child.description && (
                  <div className="text-xs text-gray-500">{child.description}</div>
                )}
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
