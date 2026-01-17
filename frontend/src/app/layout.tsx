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

// JSON-LD Structured Data for SEO/AEO/GEO - Enhanced for E-E-A-T
function JsonLdSchema() {
  // Comprehensive Organization Schema with E-E-A-T signals
  const organizationSchema = {
    "@context": "https://schema.org",
    "@type": "EducationalOrganization",
    "@id": `${BASE_URL}/#organization`,
    "name": "MDP - بانک سوالات کنکور ارشد",
    "alternateName": ["MDP", "Master's Degree Preparation", "ام دی پی"],
    "url": BASE_URL,
    "logo": {
      "@type": "ImageObject",
      "url": `${BASE_URL}/icon-512.png`,
      "width": 512,
      "height": 512,
    },
    "image": `${BASE_URL}/og-image.png`,
    "description": "MDP یک پلتفرم آموزشی رایگان برای آمادگی کنکور کارشناسی ارشد است. دسترسی به بانک سوالات ۵ سال اخیر، سیستم فلش‌کارت هوشمند با الگوریتم SM-2 و آزمون آنلاین.",
    "foundingDate": "2024",
    "areaServed": {
      "@type": "Country",
      "name": "Iran",
    },
    "knowsAbout": [
      "کنکور کارشناسی ارشد",
      "مهندسی کامپیوتر",
      "مهندسی برق",
      "مهندسی مکانیک",
      "مهندسی عمران",
      "ساختمان داده",
      "الگوریتم",
      "لغات تخصصی انگلیسی"
    ],
    "slogan": "آمادگی هوشمند برای کنکور ارشد",
    "hasOfferCatalog": {
      "@type": "OfferCatalog",
      "name": "خدمات آموزشی MDP",
      "itemListElement": [
        {
          "@type": "Offer",
          "itemOffered": {
            "@type": "Service",
            "name": "بانک سوالات کنکور ارشد",
            "description": "دسترسی رایگان به سوالات ۵ سال اخیر کنکور کارشناسی ارشد با پاسخ تشریحی"
          }
        },
        {
          "@type": "Offer",
          "itemOffered": {
            "@type": "Service",
            "name": "فلش‌کارت هوشمند SM-2",
            "description": "یادگیری لغات تخصصی با الگوریتم SM-2 تکرار فاصله‌دار"
          }
        },
        {
          "@type": "Offer",
          "itemOffered": {
            "@type": "Service",
            "name": "آزمون آنلاین",
            "description": "آزمون آنلاین با سوالات واقعی کنکور و بازخورد فوری"
          }
        }
      ]
    }
  };

  // WebSite Schema with search action
  const websiteSchema = {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "@id": `${BASE_URL}/#website`,
    "url": BASE_URL,
    "name": "MDP - بانک سوالات کنکور ارشد",
    "description": "پلتفرم رایگان آمادگی کنکور کارشناسی ارشد با بانک سوالات، فلش‌کارت و آزمون آنلاین",
    "publisher": {
      "@id": `${BASE_URL}/#organization`
    },
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

  // WebApplication Schema for the platform
  const webAppSchema = {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "MDP",
    "url": BASE_URL,
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "IRR"
    },
    "featureList": [
      "بانک سوالات کنکور ارشد ۵ سال اخیر",
      "فلش‌کارت هوشمند با الگوریتم SM-2",
      "آزمون آنلاین با بازخورد فوری",
      "دسته‌بندی بر اساس رشته، درس و مبحث"
    ]
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
        dangerouslySetInnerHTML={{ __html: JSON.stringify(webAppSchema) }}
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
