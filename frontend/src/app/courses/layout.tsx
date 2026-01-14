import { Metadata } from 'next';
import { ItemListSchema } from '@/components/seo';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

export const metadata: Metadata = {
  title: 'دروس تخصصی',
  description: 'لیست دروس تخصصی کنکور کارشناسی ارشد - دسترسی به سوالات و موضوعات هر درس',
  keywords: [
    'دروس کنکور ارشد',
    'دروس تخصصی',
    'سوالات درسی',
    'کنکور ارشد',
  ],
  openGraph: {
    title: 'دروس تخصصی | MDP',
    description: 'لیست دروس کنکور کارشناسی ارشد',
    url: `${BASE_URL}/courses`,
    type: 'website',
  },
  alternates: {
    canonical: `${BASE_URL}/courses`,
  },
};

export default function CoursesLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
