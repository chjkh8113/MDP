import { Metadata } from 'next';

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

export default function FieldsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
