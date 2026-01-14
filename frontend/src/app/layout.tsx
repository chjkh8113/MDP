import type { Metadata, Viewport } from "next";
import "./globals.css";

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir'

export const metadata: Metadata = {
  metadataBase: new URL(BASE_URL),
  title: {
    default: "MDP - آرشیو سوالات کنکور ارشد",
    template: "%s | MDP",
  },
  description: "بانک جامع سوالات کنکور کارشناسی ارشد ایران - دسترسی رایگان به سوالات ۵ سال اخیر با پاسخ تشریحی، تمرین لغات تخصصی، و آزمون آنلاین",
  keywords: [
    "کنکور ارشد",
    "سوالات کنکور",
    "آزمون کارشناسی ارشد",
    "بانک سوالات",
    "لغات تخصصی",
    "آزمون آنلاین",
    "تست کنکور",
    "کنکور ایران",
  ],
  authors: [{ name: "MDP Team" }],
  creator: "MDP",
  publisher: "MDP",
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  alternates: {
    canonical: BASE_URL,
    languages: {
      'fa-IR': BASE_URL,
    },
  },
  openGraph: {
    type: 'website',
    locale: 'fa_IR',
    url: BASE_URL,
    siteName: 'MDP',
    title: 'MDP - آرشیو سوالات کنکور ارشد',
    description: 'بانک جامع سوالات کنکور کارشناسی ارشد ایران - دسترسی رایگان به سوالات ۵ سال اخیر',
    images: [
      {
        url: '/og-image.png',
        width: 1200,
        height: 630,
        alt: 'MDP - آرشیو سوالات کنکور ارشد',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'MDP - آرشیو سوالات کنکور ارشد',
    description: 'بانک جامع سوالات کنکور کارشناسی ارشد ایران',
    images: ['/og-image.png'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  verification: {
    google: process.env.NEXT_PUBLIC_GOOGLE_VERIFICATION,
  },
};

export const viewport: Viewport = {
  themeColor: '#3b82f6',
  width: 'device-width',
  initialScale: 1,
};

// JSON-LD Structured Data for SEO/AEO/GEO
function JsonLdSchema() {
  const organizationSchema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "MDP",
    "url": BASE_URL,
    "logo": `${BASE_URL}/logo.png`,
    "description": "بانک جامع سوالات کنکور کارشناسی ارشد ایران",
    "sameAs": [],
  };

  const websiteSchema = {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "MDP - آرشیو سوالات کنکور ارشد",
    "url": BASE_URL,
    "description": "بانک جامع سوالات کنکور کارشناسی ارشد ایران",
    "inLanguage": "fa-IR",
    "potentialAction": {
      "@type": "SearchAction",
      "target": {
        "@type": "EntryPoint",
        "urlTemplate": `${BASE_URL}/fields?q={search_term_string}`
      },
      "query-input": "required name=search_term_string"
    }
  };

  const educationalSchema = {
    "@context": "https://schema.org",
    "@type": "EducationalOrganization",
    "name": "MDP",
    "url": BASE_URL,
    "description": "پلتفرم آموزشی آمادگی کنکور کارشناسی ارشد",
    "educationalCredentialAwarded": "آمادگی کنکور کارشناسی ارشد",
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteSchema) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(educationalSchema) }}
      />
    </>
  );
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="fa" dir="rtl">
      <head>
        {/* Core Web Vitals: Preconnect to external origins */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link rel="dns-prefetch" href="https://fonts.googleapis.com" />
        <link rel="dns-prefetch" href="https://fonts.gstatic.com" />

        {/* Font with display=swap for better CLS */}
        <link
          href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@300;400;500;600;700&display=swap"
          rel="stylesheet"
        />

        {/* PWA and icons */}
        <link rel="manifest" href="/manifest.json" />
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />

        {/* Structured data */}
        <JsonLdSchema />
      </head>
      <body className="font-[Vazirmatn] antialiased min-h-screen bg-background">
        {children}
      </body>
    </html>
  );
}
