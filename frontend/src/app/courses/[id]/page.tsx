"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { api, Topic, Course, Field } from "@/lib/api";
import { Header } from "@/components/common/Header";
import { Breadcrumb } from "@/components/common/Breadcrumb";

export default function CourseTopicsPage() {
  const params = useParams();
  const courseId = params.id as string;
  const [topics, setTopics] = useState<Topic[]>([]);
  const [course, setCourse] = useState<Course | null>(null);
  const [field, setField] = useState<Field | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Get course and field info by checking all fields
    api.getFields()
      .then(async (fields) => {
        for (const f of fields) {
          const courses = await api.getCourses(f.id);
          const found = courses.find(c => c.id === courseId);
          if (found) {
            setCourse(found);
            setField(f);
            break;
          }
        }
      })
      .catch(console.error);

    api.getTopics(courseId)
      .then(data => setTopics(data || []))
      .catch(err => {
        console.error(err);
        setTopics([]);
      })
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
        <Breadcrumb
          items={[
            { label: "رشته‌ها", href: "/fields" },
            { label: field?.name_fa || "", href: field ? `/fields/${field.id}` : undefined },
            { label: course?.name_fa || "" },
          ]}
        />

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
