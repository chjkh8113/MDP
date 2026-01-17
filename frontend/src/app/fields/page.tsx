"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { api, Field } from "@/lib/api";
import { Header } from "@/components/common/Header";
import { FAQSection, fieldsFAQs } from "@/components/seo";

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
        {/* TL;DR Section - Direct answer for AI */}
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
          <p className="text-blue-800 font-medium">
            در بانک سوالات MDP، سوالات کنکور ارشد {fields.length} رشته تحصیلی شامل
            مهندسی کامپیوتر، برق، مکانیک و عمران موجود است.
          </p>
        </div>

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

        {/* FAQ Section for AEO */}
        <FAQSection faqs={fieldsFAQs} title="سوالات متداول درباره بانک سوالات" />
      </main>
    </div>
  );
}
