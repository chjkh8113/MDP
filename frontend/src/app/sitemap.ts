import { MetadataRoute } from 'next'

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir'
const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8181/api/v1'

interface Field {
  id: string;
  name_fa: string;
  name_en: string;
}

async function fetchFields(): Promise<Field[]> {
  try {
    const res = await fetch(`${API_BASE}/fields`, { next: { revalidate: 3600 } });
    if (!res.ok) return [];
    return res.json();
  } catch {
    return [];
  }
}

async function fetchYears(): Promise<number[]> {
  try {
    const res = await fetch(`${API_BASE}/years`, { next: { revalidate: 3600 } });
    if (!res.ok) return [];
    return res.json();
  } catch {
    return [];
  }
}

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const currentDate = new Date().toISOString()

  // Static pages
  const staticPages: MetadataRoute.Sitemap = [
    {
      url: BASE_URL,
      lastModified: currentDate,
      changeFrequency: 'daily',
      priority: 1,
    },
    {
      url: `${BASE_URL}/fields`,
      lastModified: currentDate,
      changeFrequency: 'weekly',
      priority: 0.9,
    },
    {
      url: `${BASE_URL}/vocabulary`,
      lastModified: currentDate,
      changeFrequency: 'daily',
      priority: 0.9,
    },
    {
      url: `${BASE_URL}/vocabulary/quiz`,
      lastModified: currentDate,
      changeFrequency: 'weekly',
      priority: 0.8,
    },
  ]

  // Fetch dynamic data
  const [fields, years] = await Promise.all([fetchFields(), fetchYears()]);

  // Add field pages
  const fieldPages: MetadataRoute.Sitemap = fields.map(field => ({
    url: `${BASE_URL}/fields/${field.id}`,
    lastModified: currentDate,
    changeFrequency: 'weekly' as const,
    priority: 0.8,
  }));

  // Add year-based pages (for exam archives)
  const yearPages: MetadataRoute.Sitemap = years.map(year => ({
    url: `${BASE_URL}/exams/${year}`,
    lastModified: currentDate,
    changeFrequency: 'monthly' as const,
    priority: 0.7,
  }));

  return [...staticPages, ...fieldPages, ...yearPages];
}
