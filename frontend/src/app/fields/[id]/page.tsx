"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { api, Course, Field } from "@/lib/api";
import { Header } from "@/components/common/Header";
import { Breadcrumb } from "@/components/common/Breadcrumb";
import { DynamicSEO, LastUpdated } from "@/components/seo";

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';
// Last major content update (1404 konkur questions added)
const LAST_CONTENT_UPDATE = '1404';

export default function FieldCoursesPage() {
  const params = useParams();
  const fieldId = params.id as string;
  const [courses, setCourses] = useState<Course[]>([]);
  const [field, setField] = useState<Field | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      api.getFields(),
      api.getCourses(fieldId)
    ])
      .then(([fields, coursesData]) => {
        setField(fields.find(f => f.id === fieldId) || null);
        setCourses(coursesData);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, [fieldId]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-gray-500">در حال بارگذاری...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50" dir="rtl">
      {field && (
        <DynamicSEO
          title={`دروس ${field.name_fa}`}
          description={`لیست دروس تخصصی رشته ${field.name_fa} برای کنکور کارشناسی ارشد - ${courses.length} درس`}
          type="field"
          itemCount={courses.length}
          dateModified={LAST_CONTENT_UPDATE}
          breadcrumbs={[
            { name: 'خانه', url: BASE_URL },
            { name: 'رشته‌ها', url: `${BASE_URL}/fields` },
            { name: field.name_fa, url: `${BASE_URL}/fields/${fieldId}` },
          ]}
        />
      )}
      <Header />
      <main className="container mx-auto px-4 py-8 pt-24">
        <Breadcrumb
          items={[
            { label: "رشته‌ها", href: "/fields" },
            { label: field?.name_fa || "" },
          ]}
        />

        <div className="flex flex-wrap items-center justify-between gap-4 mb-6">
          <h1 className="text-2xl font-bold text-gray-800">
            دروس {field?.name_fa}
          </h1>
          <LastUpdated contentDate={LAST_CONTENT_UPDATE} label="آخرین بروزرسانی محتوا" />
        </div>

        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {courses.map((course) => (
            <Link
              key={course.id}
              href={`/courses/${course.id}`}
              className="block p-6 bg-white rounded-lg border border-gray-200
                         hover:border-gray-300 hover:shadow-sm transition-all"
            >
              <h2 className="text-lg font-semibold text-gray-800">
                {course.name_fa}
              </h2>
              <p className="text-sm text-gray-500 mt-1">{course.name_en}</p>
            </Link>
          ))}
        </div>

        {courses.length === 0 && (
          <p className="text-center text-gray-500 py-8">
            درسی برای این رشته ثبت نشده است
          </p>
        )}
      </main>
    </div>
  );
}
