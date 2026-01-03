import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "MDP - آرشیو سوالات کنکور ارشد",
  description: "دسترسی به سوالات ۵ سال اخیر آزمون کارشناسی ارشد",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="fa" dir="rtl">
      <head>
        <link
          href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@300;400;500;600;700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="font-[Vazirmatn] antialiased min-h-screen bg-background">
        {children}
      </body>
    </html>
  );
}
