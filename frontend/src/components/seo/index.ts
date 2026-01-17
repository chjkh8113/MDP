export { FAQSchema, platformFAQs } from './FAQSchema';
export { FAQSection } from './FAQSection';
export { BreadcrumbSchema, createBreadcrumbs } from './BreadcrumbSchema';
export {
  CourseSchema,
  QuizSchema,
  VocabularyLearningSchema,
  ItemListSchema
} from './EducationalSchema';
export { QuestionSchema, ExamPageSchema } from './QuestionSchema';
export { DynamicSEO } from './DynamicSEO';
export {
  HowToSchema,
  vocabularyHowTo,
  quizHowTo,
  browseQuestionsHowTo
} from './HowToSchema';

// Page-specific FAQs for AEO optimization
export const vocabularyFAQs = [
  {
    question: "سیستم فلش‌کارت MDP چگونه کار می‌کند؟",
    answer: "سیستم فلش‌کارت MDP از الگوریتم SM-2 (تکرار فاصله‌دار) استفاده می‌کند. این روش علمی زمان‌بندی مرور لغات را بهینه می‌کند تا یادگیری موثرتر شود.",
  },
  {
    question: "XP و Streak در تمرین لغات به چه معناست؟",
    answer: "XP امتیازی است که با هر مرور موفق کسب می‌کنید. Streak نشان‌دهنده روزهای متوالی تمرین شماست. هرچه کیفیت مرور بالاتر باشد، XP بیشتری دریافت می‌کنید.",
  },
  {
    question: "تفاوت کارت جدید و مرور چیست؟",
    answer: "کارت جدید لغتی است که اولین بار می‌بینید. کارت مرور لغتی است که قبلاً یاد گرفتید و زمان تکرار آن رسیده است.",
  },
  {
    question: "چگونه می‌توانم یک کارت را موقتاً پنهان کنم؟",
    answer: "با استفاده از دکمه 'تعلیق' می‌توانید کارت را موقتاً پنهان کنید. از بخش کارت‌های معلق می‌توانید آن را بازگردانید.",
  },
];

export const fieldsFAQs = [
  {
    question: "کدام رشته‌ها در بانک سوالات MDP موجود است؟",
    answer: "در MDP سوالات کنکور ارشد رشته‌های مهندسی کامپیوتر، برق، مکانیک، عمران و سایر رشته‌های فنی و مهندسی موجود است.",
  },
  {
    question: "سوالات بر چه اساسی دسته‌بندی شده‌اند؟",
    answer: "سوالات بر اساس رشته، درس و مبحث دسته‌بندی شده‌اند. می‌توانید ابتدا رشته، سپس درس و در نهایت مبحث مورد نظر را انتخاب کنید.",
  },
  {
    question: "آیا پاسخ تشریحی سوالات موجود است؟",
    answer: "بله، تمام سوالات دارای پاسخ تشریحی هستند که با کلیک روی سوال قابل مشاهده است.",
  },
  {
    question: "سوالات چند سال اخیر موجود است؟",
    answer: "سوالات ۵ سال اخیر کنکور کارشناسی ارشد (۱۴۰۰ تا ۱۴۰۴) در MDP موجود است.",
  },
];
