"use client";

interface StatsProps {
  stats: {
    total_questions: number;
    total_fields: number;
    total_courses: number;
    years_covered: number;
  } | null;
}

export function Stats({ stats }: StatsProps) {
  if (!stats) return null;

  const items = [
    { value: stats.total_questions, label: "سوال" },
    { value: stats.total_fields, label: "رشته" },
    { value: stats.total_courses, label: "درس" },
    { value: stats.years_covered, label: "سال" },
  ];

  return (
    <div className="absolute bottom-8 left-0 right-0">
      <div className="max-w-2xl mx-auto px-6">
        <div className="flex justify-center gap-12 text-center">
          {items.map((item) => (
            <div key={item.label}>
              <div className="text-2xl font-bold">{item.value}+</div>
              <div className="text-sm text-muted-foreground">{item.label}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
