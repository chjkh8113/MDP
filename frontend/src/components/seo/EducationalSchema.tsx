const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

interface CourseSchemaProps {
  name: string;
  description: string;
  provider?: string;
  url?: string;
}

export function CourseSchema({ name, description, provider = 'MDP', url }: CourseSchemaProps) {
  const courseSchema = {
    "@context": "https://schema.org",
    "@type": "Course",
    "name": name,
    "description": description,
    "provider": {
      "@type": "Organization",
      "name": provider,
      "url": BASE_URL,
    },
    "url": url || BASE_URL,
    "inLanguage": "fa-IR",
    "isAccessibleForFree": true,
    "audience": {
      "@type": "EducationalAudience",
      "educationalRole": "student",
    },
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(courseSchema) }}
    />
  );
}

interface QuizSchemaProps {
  name: string;
  description: string;
  questionCount?: number;
  url?: string;
}

export function QuizSchema({ name, description, questionCount, url }: QuizSchemaProps) {
  const quizSchema = {
    "@context": "https://schema.org",
    "@type": "Quiz",
    "name": name,
    "description": description,
    "educationalLevel": "graduate",
    "learningResourceType": "Quiz",
    "isAccessibleForFree": true,
    "inLanguage": "fa-IR",
    "provider": {
      "@type": "Organization",
      "name": "MDP",
      "url": BASE_URL,
    },
    ...(questionCount && { "numberOfQuestions": questionCount }),
    ...(url && { "url": url }),
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(quizSchema) }}
    />
  );
}

export function VocabularyLearningSchema() {
  const howToSchema = {
    "@context": "https://schema.org",
    "@type": "HowTo",
    "name": "چگونه لغات تخصصی کنکور ارشد را یاد بگیریم",
    "description": "راهنمای یادگیری لغات تخصصی با سیستم فلش‌کارت هوشمند MDP",
    "inLanguage": "fa-IR",
    "totalTime": "PT30M",
    "step": [
      {
        "@type": "HowToStep",
        "position": 1,
        "name": "ورود به بخش لغات",
        "text": "به بخش تمرین لغات در سایت MDP مراجعه کنید",
        "url": `${BASE_URL}/vocabulary`,
      },
      {
        "@type": "HowToStep",
        "position": 2,
        "name": "مشاهده کارت",
        "text": "لغت انگلیسی را مشاهده کنید و سعی کنید معنی آن را به خاطر بیاورید",
      },
      {
        "@type": "HowToStep",
        "position": 3,
        "name": "بررسی پاسخ",
        "text": "روی کارت کلیک کنید تا معنی فارسی نمایش داده شود",
      },
      {
        "@type": "HowToStep",
        "position": 4,
        "name": "ارزیابی",
        "text": "میزان یادگیری خود را از ۱ تا ۵ ارزیابی کنید تا سیستم زمان مرور بعدی را تنظیم کند",
      },
    ],
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(howToSchema) }}
    />
  );
}

interface ItemListSchemaProps {
  name: string;
  description: string;
  items: Array<{ name: string; url: string; position: number }>;
}

export function ItemListSchema({ name, description, items }: ItemListSchemaProps) {
  const itemListSchema = {
    "@context": "https://schema.org",
    "@type": "ItemList",
    "name": name,
    "description": description,
    "numberOfItems": items.length,
    "itemListElement": items.map((item) => ({
      "@type": "ListItem",
      "position": item.position,
      "name": item.name,
      "url": item.url,
    })),
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(itemListSchema) }}
    />
  );
}
