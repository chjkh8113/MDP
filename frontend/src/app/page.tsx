import HomeClient from '@/components/home/HomeClient';
import { FAQSchema, platformFAQs, HowToSchema, quizHowTo, AuthorSchema } from '@/components/seo';

export default function Home() {
  return (
    <>
      <FAQSchema faqs={platformFAQs} />
      <HowToSchema
        name={quizHowTo.name}
        description={quizHowTo.description}
        totalTime={quizHowTo.totalTime}
        steps={quizHowTo.steps}
      />
      <AuthorSchema />
      <HomeClient />
    </>
  );
}
