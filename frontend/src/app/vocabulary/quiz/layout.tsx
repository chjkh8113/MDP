import { Metadata } from 'next';
import { QuizSchema } from '@/components/seo';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

export const metadata: Metadata = {
  title: 'آزمون لغات',
  description: 'آزمون آنلاین لغات تخصصی کنکور ارشد - سنجش میزان یادگیری با آزمون چهارگزینه‌ای',
  keywords: [
    'آزمون لغات',
    'تست زبان',
    'کوییز انگلیسی',
    'سنجش یادگیری',
    'آزمون آنلاین',
  ],
  openGraph: {
    title: 'آزمون لغات تخصصی | MDP',
    description: 'سنجش میزان یادگیری لغات با آزمون آنلاین',
    url: `${BASE_URL}/vocabulary/quiz`,
    type: 'website',
  },
  alternates: {
    canonical: `${BASE_URL}/vocabulary/quiz`,
  },
};

export default function QuizLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <QuizSchema
        name="آزمون لغات تخصصی کنکور ارشد"
        description="آزمون چهارگزینه‌ای لغات تخصصی انگلیسی برای سنجش یادگیری"
        questionCount={10}
        url={`${BASE_URL}/vocabulary/quiz`}
      />
      {children}
    </>
  );
}
