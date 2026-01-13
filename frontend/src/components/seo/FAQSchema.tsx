interface FAQItem {
  question: string;
  answer: string;
}

interface FAQSchemaProps {
  faqs: FAQItem[];
}

export function FAQSchema({ faqs }: FAQSchemaProps) {
  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": faqs.map((faq) => ({
      "@type": "Question",
      "name": faq.question,
      "acceptedAnswer": {
        "@type": "Answer",
        "text": faq.answer,
      },
    })),
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }}
    />
  );
}

// Common FAQs for the platform - for AEO optimization
export const platformFAQs: FAQItem[] = [
  {
    question: "سوالات کنکور ارشد چند سال اخیر در MDP موجود است؟",
    answer: "در MDP سوالات کنکور کارشناسی ارشد ۵ سال اخیر همراه با پاسخ تشریحی موجود است.",
  },
  {
    question: "آیا استفاده از بانک سوالات MDP رایگان است؟",
    answer: "بله، دسترسی به بانک سوالات کنکور ارشد MDP کاملاً رایگان است.",
  },
  {
    question: "چگونه می‌توانم لغات تخصصی کنکور را تمرین کنم؟",
    answer: "در بخش تمرین لغات MDP می‌توانید با سیستم فلش‌کارت هوشمند لغات تخصصی رشته خود را یاد بگیرید.",
  },
  {
    question: "آیا MDP آزمون آنلاین دارد؟",
    answer: "بله، MDP امکان شرکت در آزمون آنلاین با سوالات واقعی کنکور را فراهم می‌کند.",
  },
  {
    question: "سوالات کدام رشته‌ها در MDP موجود است؟",
    answer: "سوالات کنکور ارشد رشته‌های مهندسی کامپیوتر، برق، مکانیک، عمران و سایر رشته‌های فنی در MDP موجود است.",
  },
];
