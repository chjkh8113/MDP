'use client';

import { VocabularyStats as VocabStatsType } from '@/lib/api';

interface VocabularyStatsProps {
  stats: VocabStatsType | null;
  isLoading?: boolean;
}

export function VocabularyStats({ stats, isLoading }: VocabularyStatsProps) {
  if (isLoading) {
    return (
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 animate-pulse">
        {[...Array(4)].map((_, i) => (
          <div key={i} className="bg-gray-200 rounded-xl h-24" />
        ))}
      </div>
    );
  }

  if (!stats) return null;

  const items = [
    {
      label: 'استریک',
      value: stats.current_streak,
      icon: '🔥',
      subLabel: `بهترین: ${stats.longest_streak}`,
      color: 'from-orange-400 to-red-500',
    },
    {
      label: 'لغات موعد',
      value: stats.words_due,
      icon: '📚',
      subLabel: `امروز: ${stats.reviews_today}`,
      color: 'from-blue-400 to-blue-600',
    },
    {
      label: 'یادگرفته',
      value: stats.words_learned,
      icon: '✓',
      subLabel: `از ${stats.total_words}`,
      color: 'from-emerald-400 to-emerald-600',
    },
    {
      label: 'امتیاز',
      value: stats.total_xp,
      icon: '⭐',
      subLabel: 'مجموع امتیازات',
      color: 'from-yellow-400 to-amber-500',
    },
  ];

  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
      {items.map((item) => (
        <div
          key={item.label}
          className={`bg-gradient-to-br ${item.color} rounded-xl p-4 text-white shadow-lg`}
        >
          <div className="flex items-center justify-between mb-2">
            <span className="text-2xl">{item.icon}</span>
            <span className="text-xs opacity-80">{item.label}</span>
          </div>
          <div className="text-3xl font-bold">{item.value}</div>
          <div className="text-xs opacity-80 mt-1">{item.subLabel}</div>
        </div>
      ))}
    </div>
  );
}

interface ProgressRingProps {
  progress: number;
  size?: number;
  strokeWidth?: number;
}

export function ProgressRing({ progress, size = 60, strokeWidth = 4 }: ProgressRingProps) {
  const radius = (size - strokeWidth) / 2;
  const circumference = radius * 2 * Math.PI;
  const offset = circumference - (progress / 100) * circumference;

  return (
    <svg width={size} height={size} className="transform -rotate-90">
      <circle
        className="text-gray-200"
        strokeWidth={strokeWidth}
        stroke="currentColor"
        fill="transparent"
        r={radius}
        cx={size / 2}
        cy={size / 2}
      />
      <circle
        className="text-emerald-500 transition-all duration-500"
        strokeWidth={strokeWidth}
        strokeDasharray={circumference}
        strokeDashoffset={offset}
        strokeLinecap="round"
        stroke="currentColor"
        fill="transparent"
        r={radius}
        cx={size / 2}
        cy={size / 2}
      />
    </svg>
  );
}
