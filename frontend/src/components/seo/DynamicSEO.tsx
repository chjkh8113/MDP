'use client';

import { useEffect } from 'react';
import { toISODate } from './LastUpdated';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

interface DynamicSEOProps {
  title: string;
  description: string;
  type?: 'field' | 'course' | 'topic' | 'exam';
  breadcrumbs?: Array<{ name: string; url: string }>;
  itemCount?: number;
  // For E-E-A-T: dateModified signals freshness to AI/search engines
  dateModified?: string | number;
  datePublished?: string | number;
}

export function DynamicSEO({
  title,
  description,
  type,
  breadcrumbs,
  itemCount,
  dateModified,
  datePublished,
}: DynamicSEOProps) {
  useEffect(() => {
    // Update document title
    document.title = `${title} | MDP`;

    // Update meta description
    let metaDesc = document.querySelector('meta[name="description"]');
    if (!metaDesc) {
      metaDesc = document.createElement('meta');
      metaDesc.setAttribute('name', 'description');
      document.head.appendChild(metaDesc);
    }
    metaDesc.setAttribute('content', description);

    // Add/update canonical
    let canonical = document.querySelector('link[rel="canonical"]');
    if (!canonical) {
      canonical = document.createElement('link');
      canonical.setAttribute('rel', 'canonical');
      document.head.appendChild(canonical);
    }
    canonical.setAttribute('href', window.location.href);

    // Add structured data
    const existingScript = document.getElementById('dynamic-structured-data');
    if (existingScript) {
      existingScript.remove();
    }

    const schemas: object[] = [];

    // Breadcrumb schema
    if (breadcrumbs && breadcrumbs.length > 0) {
      schemas.push({
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": breadcrumbs.map((item, index) => ({
          "@type": "ListItem",
          "position": index + 1,
          "name": item.name,
          "item": item.url,
        })),
      });
    }

    // Type-specific schema with dateModified for E-E-A-T freshness signals
    if (type === 'field' || type === 'course') {
      schemas.push({
        "@context": "https://schema.org",
        "@type": "CollectionPage",
        "name": title,
        "description": description,
        "url": window.location.href,
        "isPartOf": {
          "@type": "WebSite",
          "name": "MDP",
          "url": BASE_URL,
        },
        ...(itemCount && { "numberOfItems": itemCount }),
        ...(dateModified && { "dateModified": toISODate(dateModified) }),
        ...(datePublished && { "datePublished": toISODate(datePublished) }),
      });
    }

    if (type === 'topic') {
      schemas.push({
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": title,
        "description": description,
        "learningResourceType": "Practice Test",
        "educationalLevel": "graduate",
        "inLanguage": "fa-IR",
        "isAccessibleForFree": true,
        ...(itemCount && { "numberOfItems": itemCount }),
        ...(dateModified && { "dateModified": toISODate(dateModified) }),
        ...(datePublished && { "datePublished": toISODate(datePublished) }),
      });
    }

    if (schemas.length > 0) {
      const script = document.createElement('script');
      script.id = 'dynamic-structured-data';
      script.type = 'application/ld+json';
      script.textContent = JSON.stringify(schemas.length === 1 ? schemas[0] : schemas);
      document.head.appendChild(script);
    }

    return () => {
      const script = document.getElementById('dynamic-structured-data');
      if (script) script.remove();
    };
  }, [title, description, type, breadcrumbs, itemCount, dateModified, datePublished]);

  return null;
}
