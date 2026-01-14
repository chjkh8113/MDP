import { Metadata } from 'next';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

export const metadata: Metadata = {
  title: 'سوالات کنکور',
  description: 'سوالات کنکور کارشناسی ارشد به تفکیک موضوع - بانک جامع سوالات با پاسخ تشریحی',
  keywords: [
    'سوالات کنکور ارشد',
    'بانک سوالات',
    'تست کنکور',
    'نمونه سوال',
    'پاسخ تشریحی',
  ],
  openGraph: {
    title: 'سوالات کنکور ارشد | MDP',
    description: 'بانک جامع سوالات کنکور کارشناسی ارشد با پاسخ تشریحی',
    url: `${BASE_URL}/topics`,
    type: 'website',
  },
  alternates: {
    canonical: `${BASE_URL}/topics`,
  },
};

export default function TopicsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
