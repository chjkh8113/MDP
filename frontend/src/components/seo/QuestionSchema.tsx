const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

interface ExamQuestion {
  id: string;
  text: string;
  options?: string[];
  correctAnswer?: string;
  year?: number;
  topicName?: string;
}

interface QuestionSchemaProps {
  questions: ExamQuestion[];
  topicName: string;
  courseName: string;
  fieldName: string;
}

export function QuestionSchema({ questions, topicName, courseName, fieldName }: QuestionSchemaProps) {
  // Create Quiz schema with questions for AEO
  const quizSchema = {
    "@context": "https://schema.org",
    "@type": "Quiz",
    "name": `سوالات ${topicName} - ${courseName}`,
    "description": `سوالات کنکور ارشد ${fieldName} - ${courseName} - ${topicName}`,
    "educationalLevel": "graduate",
    "learningResourceType": "Practice Test",
    "isAccessibleForFree": true,
    "inLanguage": "fa-IR",
    "provider": {
      "@type": "Organization",
      "name": "MDP",
      "url": BASE_URL,
    },
    "numberOfQuestions": questions.length,
    "hasPart": questions.slice(0, 10).map((q, idx) => ({
      "@type": "Question",
      "position": idx + 1,
      "text": q.text?.substring(0, 200) || `سوال ${idx + 1}`,
      ...(q.year && { "dateCreated": `${q.year}` }),
    })),
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(quizSchema) }}
    />
  );
}

interface ExamPageSchemaProps {
  examYear: number;
  fieldName: string;
  questionCount: number;
  url: string;
}

export function ExamPageSchema({ examYear, fieldName, questionCount, url }: ExamPageSchemaProps) {
  const examSchema = {
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": `سوالات کنکور ارشد ${fieldName} - سال ${examYear}`,
    "description": `${questionCount} سوال کنکور کارشناسی ارشد ${fieldName} سال ${examYear}`,
    "learningResourceType": "Practice Test",
    "educationalLevel": "graduate",
    "inLanguage": "fa-IR",
    "datePublished": `${examYear}`,
    "isAccessibleForFree": true,
    "url": url,
    "provider": {
      "@type": "Organization",
      "name": "MDP",
      "url": BASE_URL,
    },
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(examSchema) }}
    />
  );
}
