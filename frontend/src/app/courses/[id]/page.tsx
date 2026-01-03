"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { api, Topic, Course } from "@/lib/api";
import { Header } from "@/components/common/Header";

export default function CourseTopicsPage() {
  const params = useParams();
  const courseId = Number(params.id);
  const [topics, setTopics] = useState<Topic[]>([]);
  const [course, setCourse] = useState<Course | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Get course info by checking all fields
    api.getFields()
      .then(async (fields) => {
        for (const field of fields) {
          const courses = await api.getCourses(field.id);
          const found = courses.find(c => c.id === courseId);
          if (found) {
            setCourse(found);
            break;
          }
        }
      })
      .catch(console.error);

    api.getTopics(courseId)
      .then(setTopics)
      .catch(console.error)
      .finally(() => setLoading(false));
  }, [courseId]);

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
          <span className="text-gray-800">{course?.name_fa}</span>
        </div>

        <h1 className="text-2xl font-bold text-gray-800 mb-6">
          موضوعات {course?.name_fa}
        </h1>

        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {topics.map((topic) => (
            <Link
              key={topic.id}
              href={`/topics/${topic.id}`}
              className="block p-6 bg-white rounded-lg border border-gray-200
                         hover:border-gray-300 hover:shadow-sm transition-all"
            >
              <h2 className="text-lg font-semibold text-gray-800">
                {topic.name_fa}
              </h2>
            </Link>
          ))}
        </div>

        {topics.length === 0 && (
          <p className="text-center text-gray-500 py-8">
            موضوعی برای این درس ثبت نشده است
          </p>
        )}
      </main>
    </div>
  );
}
