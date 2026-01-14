import { Metadata } from 'next';
import { CourseSchema, VocabularyLearningSchema } from '@/components/seo';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

export const metadata: Metadata = {
  title: 'تمرین لغات تخصصی کنکور',
  description: 'یادگیری و مرور لغات تخصصی کنکور ارشد با سیستم فلش‌کارت هوشمند - الگوریتم SM-2 برای یادگیری بهینه',
  keywords: [
    'لغات تخصصی کنکور',
    'فلش کارت',
    'یادگیری لغات',
    'زبان تخصصی',
    'کنکور ارشد',
    'SM-2',
    'spaced repetition',
  ],
  openGraph: {
    title: 'تمرین لغات تخصصی کنکور | MDP',
    description: 'یادگیری لغات تخصصی با فلش‌کارت هوشمند',
    url: `${BASE_URL}/vocabulary`,
    type: 'website',
  },
  alternates: {
    canonical: `${BASE_URL}/vocabulary`,
  },
};

export default function VocabularyLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <CourseSchema
        name="دوره یادگیری لغات تخصصی کنکور ارشد"
        description="یادگیری لغات تخصصی انگلیسی برای آزمون کارشناسی ارشد با سیستم فلش‌کارت هوشمند"
        url={`${BASE_URL}/vocabulary`}
      />
      <VocabularyLearningSchema />
      {children}
    </>
  );
}
