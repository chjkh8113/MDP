import { Metadata } from 'next';
import { ItemListSchema } from '@/components/seo';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

export const metadata: Metadata = {
  title: 'رشته‌های تحصیلی',
  description: 'لیست رشته‌های تحصیلی کنکور کارشناسی ارشد - دسترسی به سوالات و منابع هر رشته',
  keywords: [
    'رشته کنکور ارشد',
    'مهندسی کامپیوتر',
    'مهندسی برق',
    'رشته‌های فنی',
    'انتخاب رشته',
  ],
  openGraph: {
    title: 'رشته‌های تحصیلی | MDP',
    description: 'لیست رشته‌های کنکور کارشناسی ارشد',
    url: `${BASE_URL}/fields`,
    type: 'website',
  },
  alternates: {
    canonical: `${BASE_URL}/fields`,
  },
};

// Static list of main fields for SEO
const mainFields = [
  { name: 'مهندسی کامپیوتر', url: `${BASE_URL}/fields/computer-engineering`, position: 1 },
  { name: 'مهندسی برق', url: `${BASE_URL}/fields/electrical-engineering`, position: 2 },
  { name: 'مهندسی صنایع', url: `${BASE_URL}/fields/industrial-engineering`, position: 3 },
  { name: 'مهندسی مکانیک', url: `${BASE_URL}/fields/mechanical-engineering`, position: 4 },
  { name: 'مهندسی عمران', url: `${BASE_URL}/fields/civil-engineering`, position: 5 },
];

export default function FieldsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <ItemListSchema
        name="رشته‌های کنکور کارشناسی ارشد"
        description="لیست رشته‌های تحصیلی کنکور ارشد ایران"
        items={mainFields}
      />
      {children}
    </>
  );
}
