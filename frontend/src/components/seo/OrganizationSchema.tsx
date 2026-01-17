const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

interface OrganizationSchemaProps {
  includeWebSite?: boolean;
}

export function OrganizationSchema({ includeWebSite = true }: OrganizationSchemaProps) {
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
    "description": "MDP یک پلتفرم آموزشی رایگان برای آمادگی کنکور کارشناسی ارشد است. دسترسی به بانک سوالات ۵ سال اخیر، سیستم فلش‌کارت هوشمند با الگوریتم SM-2 و آزمون آنلاین.",
    "foundingDate": "2024",
    "areaServed": {
      "@type": "Country",
      "name": "Iran",
    },
    "serviceType": [
      "آموزش آنلاین",
      "بانک سوالات کنکور",
      "فلش‌کارت لغات",
      "آزمون آنلاین"
    ],
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
            "description": "دسترسی به سوالات ۵ سال اخیر کنکور کارشناسی ارشد با پاسخ تشریحی"
          }
        },
        {
          "@type": "Offer",
          "itemOffered": {
            "@type": "Service",
            "name": "فلش‌کارت هوشمند",
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

  const webSiteSchema = {
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

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }}
      />
      {includeWebSite && (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(webSiteSchema) }}
        />
      )}
    </>
  );
}
