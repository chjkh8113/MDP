"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { api, Question, Topic } from "@/lib/api";
import { Header } from "@/components/common/Header";
import { QuestionCard } from "@/components/browse/QuestionCard";

export default function TopicQuestionsPage() {
  const params = useParams();
  const topicId = params.id as string;
  const [questions, setQuestions] = useState<Question[]>([]);
  const [topic, setTopic] = useState<Topic | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.getQuestionsByTopic(topicId)
      .then(setQuestions)
      .catch(console.error)
      .finally(() => setLoading(false));
  }, [topicId]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-gray-500">در حال بارگذاری...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50" dir="rtl">
      <Header />
      <main className="container mx-auto px-4 py-8">
        <div className="mb-6">
          <Link href="/fields" className="text-sm text-gray-500 hover:text-gray-700">
            رشته‌ها
          </Link>
          <span className="mx-2 text-gray-400">/</span>
          <span className="text-gray-800">سوالات</span>
        </div>

        <div className="flex items-center justify-between mb-6">
          <h1 className="text-2xl font-bold text-gray-800">
            سوالات ({questions.length})
          </h1>
        </div>

        <div className="space-y-6">
          {questions.map((question, index) => (
            <QuestionCard
              key={question.id}
              question={question}
              number={index + 1}
            />
          ))}
        </div>

        {questions.length === 0 && (
          <p className="text-center text-gray-500 py-8">
            سوالی برای این موضوع ثبت نشده است
          </p>
        )}
      </main>
    </div>
  );
}
