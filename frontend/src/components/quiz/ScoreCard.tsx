"use client";

import { Card, CardContent } from "@/components/ui/card";

interface ScoreCardProps {
  correct: number;
  total: number;
}

export function ScoreCard({ correct, total }: ScoreCardProps) {
  if (total === 0) return null;

  const percentage = Math.round((correct / total) * 100);

  return (
    <Card className="mt-4">
      <CardContent className="pt-6">
        <div className="flex justify-between items-center text-sm">
          <span>نمره فعلی:</span>
          <span className="font-bold">
            {correct} از {total} ({percentage}%)
          </span>
        </div>
      </CardContent>
    </Card>
  );
}
