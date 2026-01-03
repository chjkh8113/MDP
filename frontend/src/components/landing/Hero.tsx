"use client";

import { Button } from "@/components/ui/button";
import Link from "next/link";

interface HeroProps {
  onStartQuiz: () => void;
  loading?: boolean;
}

export function Hero({ onStartQuiz, loading }: HeroProps) {
  return (
    <section className="flex-1 flex items-center justify-center px-6">
      <div className="max-w-2xl text-center">
        <h1 className="text-5xl md:text-6xl font-bold tracking-tight mb-6">
          کنکور ارشد
        </h1>
        <p className="text-xl text-muted-foreground mb-8 leading-relaxed">
          آرشیو سوالات ۵ سال اخیر
          <br />
          دسته‌بندی شده بر اساس رشته و درس
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Button size="lg" onClick={onStartQuiz} disabled={loading}>
            {loading ? "در حال آماده‌سازی..." : "شروع آزمون"}
          </Button>
          <Button size="lg" variant="outline" asChild>
            <Link href="/exams">مشاهده سوالات</Link>
          </Button>
        </div>
      </div>
    </section>
  );
}
