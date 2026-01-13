import HomeClient from '@/components/home/HomeClient';
import { FAQSchema, platformFAQs } from '@/components/seo';

export default function Home() {
  return (
    <>
      <FAQSchema faqs={platformFAQs} />
      <HomeClient />
    </>
  );
}
