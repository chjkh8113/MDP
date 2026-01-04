"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { api, Field } from "@/lib/api";
import { Header } from "@/components/common/Header";

export default function FieldsPage() {
  const [fields, setFields] = useState<Field[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.getFields()
      .then(setFields)
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

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
      <main className="container mx-auto px-4 py-8 pt-24">
        <h1 className="text-2xl font-bold text-gray-800 mb-6">
          رشته‌های تحصیلی
        </h1>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {fields.map((field) => (
            <Link
              key={field.id}
              href={`/fields/${field.id}`}
              className="block p-6 bg-white rounded-lg border border-gray-200
                         hover:border-gray-300 hover:shadow-sm transition-all"
            >
              <h2 className="text-lg font-semibold text-gray-800">
                {field.name_fa}
              </h2>
              <p className="text-sm text-gray-500 mt-1">{field.name_en}</p>
            </Link>
          ))}
        </div>
      </main>
    </div>
  );
}
