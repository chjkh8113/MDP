import { Metadata } from 'next';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

export const vocabularyMetadata: Metadata = {
  title: 'تمرین لغات تخصصی کنکور',
  description: 'یادگیری و مرور لغات تخصصی کنکور ارشد با سیستم فلش‌کارت هوشمند - الگوریتم SM-2 برای یادگیری بهینه',
  keywords: [
    'لغات تخصصی کنکور',
    'فلش کارت',
    'یادگیری لغات',
    'زبان تخصصی',
    'کنکور ارشد',
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

export const quizMetadata: Metadata = {
  title: 'آزمون لغات',
  description: 'آزمون آنلاین لغات تخصصی کنکور ارشد - سنجش میزان یادگیری با آزمون چهارگزینه‌ای',
  keywords: [
    'آزمون لغات',
    'تست زبان',
    'کوییز انگلیسی',
    'سنجش یادگیری',
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
