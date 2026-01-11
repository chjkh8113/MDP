'use client';

import { useState } from 'react';
import { VocabularyWord } from '@/lib/api';
import { cn } from '@/lib/utils';

interface FlashCardProps {
  word: VocabularyWord;
  showAnswer: boolean;
  onFlip: () => void;
}

export function FlashCard({ word, showAnswer, onFlip }: FlashCardProps) {
  return (
    <div
      className="relative w-full max-w-md mx-auto h-64 cursor-pointer perspective-1000"
      onClick={onFlip}
    >
      <div
        className={cn(
          "absolute w-full h-full transition-transform duration-500 transform-style-preserve-3d",
          showAnswer && "rotate-y-180"
        )}
      >
        {/* Front - English word */}
        <div className="absolute w-full h-full backface-hidden">
          <div className="w-full h-full bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl shadow-xl p-6 flex flex-col items-center justify-center text-white">
            <span className="text-sm opacity-80 mb-2">English</span>
            <h2 className="text-3xl font-bold mb-2">{word.word_en}</h2>
            {word.pronunciation && (
              <span className="text-lg opacity-90">{word.pronunciation}</span>
            )}
            <div className="mt-4 flex items-center gap-1">
              {[...Array(5)].map((_, i) => (
                <div
                  key={i}
                  className={cn(
                    "w-2 h-2 rounded-full",
                    i < word.difficulty ? "bg-yellow-400" : "bg-white/30"
                  )}
                />
              ))}
            </div>
            <p className="text-sm opacity-70 mt-4">Click to reveal meaning</p>
          </div>
        </div>

        {/* Back - Persian meaning */}
        <div className="absolute w-full h-full backface-hidden rotate-y-180">
          <div className="w-full h-full bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-2xl shadow-xl p-6 flex flex-col items-center justify-center text-white">
            <span className="text-sm opacity-80 mb-2">Persian</span>
            <h2 className="text-2xl font-bold mb-4 text-center" dir="rtl">
              {word.meaning_fa}
            </h2>
            {word.example_en && (
              <div className="mt-2 text-center">
                <p className="text-sm opacity-90 italic">"{word.example_en}"</p>
                {word.example_fa && (
                  <p className="text-sm opacity-80 mt-1" dir="rtl">
                    {word.example_fa}
                  </p>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

// Rating quality values for SM-2 algorithm
export type Quality = 0 | 1 | 2 | 3 | 4 | 5;

interface RatingButtonsProps {
  onRate: (quality: Quality) => void;
  disabled?: boolean;
}

export function RatingButtons({ onRate, disabled }: RatingButtonsProps) {
  const buttons = [
    { quality: 0 as Quality, label: 'Again', subLabel: 'Forgot', color: 'bg-red-500 hover:bg-red-600' },
    { quality: 3 as Quality, label: 'Hard', subLabel: '~1 day', color: 'bg-orange-500 hover:bg-orange-600' },
    { quality: 4 as Quality, label: 'Good', subLabel: '~3 days', color: 'bg-blue-500 hover:bg-blue-600' },
    { quality: 5 as Quality, label: 'Easy', subLabel: '~7 days', color: 'bg-emerald-500 hover:bg-emerald-600' },
  ];

  return (
    <div className="flex flex-wrap gap-2 justify-center mt-6">
      {buttons.map((btn) => (
        <button
          key={btn.quality}
          onClick={() => onRate(btn.quality)}
          disabled={disabled}
          className={cn(
            "flex flex-col items-center px-4 py-2 rounded-lg text-white transition-all",
            "disabled:opacity-50 disabled:cursor-not-allowed",
            btn.color
          )}
        >
          <span className="font-semibold">{btn.label}</span>
          <span className="text-xs opacity-80">{btn.subLabel}</span>
        </button>
      ))}
    </div>
  );
}
