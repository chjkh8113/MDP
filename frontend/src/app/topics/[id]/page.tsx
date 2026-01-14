"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { api, Question, Topic, Course, Field } from "@/lib/api";
import { Header } from "@/components/common/Header";
import { Breadcrumb } from "@/components/common/Breadcrumb";
import { QuestionCard } from "@/components/browse/QuestionCard";
import { DynamicSEO } from "@/components/seo";

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

export default function TopicQuestionsPage() {
  const params = useParams();
  const topicId = params.id as string;
  const [questions, setQuestions] = useState<Question[]>([]);
  const [topic, setTopic] = useState<Topic | null>(null);
  const [course, setCourse] = useState<Course | null>(null);
  const [field, setField] = useState<Field | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Find topic and its parent hierarchy
    api.getFields()
      .then(async (fields) => {
        outerLoop:
        for (const f of fields) {
          const courses = await api.getCourses(f.id);
          for (const c of courses) {
            const topics = await api.getTopics(c.id);
            const found = topics.find(t => t.id === topicId);
            if (found) {
              setField(f);
              setCourse(c);
              setTopic(found);
              break outerLoop;
            }
          }
        }
      })
      .catch(console.error);

    api.getQuestionsByTopic(topicId)
      .then(data => setQuestions(data || []))
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
      {topic && field && course && (
        <DynamicSEO
          title={`سوالات ${topic.name_fa}`}
          description={`${questions.length} سوال کنکور ارشد ${field.name_fa} - ${course.name_fa} - ${topic.name_fa} با پاسخ تشریحی`}
          type="topic"
          itemCount={questions.length}
          breadcrumbs={[
            { name: 'خانه', url: BASE_URL },
            { name: 'رشته‌ها', url: `${BASE_URL}/fields` },
            { name: field.name_fa, url: `${BASE_URL}/fields/${field.id}` },
            { name: course.name_fa, url: `${BASE_URL}/courses/${course.id}` },
            { name: topic.name_fa, url: `${BASE_URL}/topics/${topicId}` },
          ]}
        />
      )}
      <Header />
      <main className="container mx-auto px-4 py-8 pt-24">
        <Breadcrumb
          items={[
            { label: "رشته‌ها", href: "/fields" },
            { label: field?.name_fa || "", href: field ? `/fields/${field.id}` : undefined },
            { label: course?.name_fa || "", href: course ? `/courses/${course.id}` : undefined },
            { label: topic?.name_fa || "" },
          ]}
        />

        <h1 className="text-2xl font-bold text-gray-800 mb-6">
          {topic?.name_fa} ({questions.length} سوال)
        </h1>

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
