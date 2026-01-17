'use client';

import { useState } from 'react';
import { VocabularyWord, CardAction, api } from '@/lib/api';
import { cn } from '@/lib/utils';

interface FlashCardProps {
  word: VocabularyWord;
  showAnswer: boolean;
  onFlip: () => void;
}

export function FlashCard({ word, showAnswer, onFlip }: FlashCardProps) {
  // Simple approach: show one side at a time with fade transition
  // This completely avoids the 3D backface-visibility issues

  return (
    <div
      className="relative w-full max-w-md mx-auto h-64 cursor-pointer"
      onClick={onFlip}
    >
      {/* Front - English word (shown when showAnswer is false) */}
      <div
        className={cn(
          "absolute inset-0 transition-opacity duration-300",
          showAnswer ? "opacity-0 pointer-events-none" : "opacity-100"
        )}
      >
        <div className="w-full h-full bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl shadow-xl p-6 flex flex-col items-center justify-center text-white">
          <span className="text-sm opacity-80 mb-2">انگلیسی</span>
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
          <p className="text-sm opacity-70 mt-4">کلیک کنید تا معنی نمایش داده شود</p>
        </div>
      </div>

      {/* Back - Persian meaning (shown when showAnswer is true) */}
      <div
        className={cn(
          "absolute inset-0 transition-opacity duration-300",
          showAnswer ? "opacity-100" : "opacity-0 pointer-events-none"
        )}
      >
        <div className="w-full h-full bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-2xl shadow-xl p-6 flex flex-col items-center justify-center text-white">
          <span className="text-sm opacity-80 mb-2">فارسی</span>
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
    { quality: 0 as Quality, label: 'دوباره', subLabel: 'یادم نبود', color: 'bg-red-500 hover:bg-red-600' },
    { quality: 3 as Quality, label: 'سخت', subLabel: '~۱ روز', color: 'bg-orange-500 hover:bg-orange-600' },
    { quality: 4 as Quality, label: 'خوب', subLabel: '~۳ روز', color: 'bg-blue-500 hover:bg-blue-600' },
    { quality: 5 as Quality, label: 'آسان', subLabel: '~۷ روز', color: 'bg-emerald-500 hover:bg-emerald-600' },
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

// Card action buttons for suspend/bury/delete
interface CardActionsProps {
  wordId: string;
  onAction?: (action: CardAction, message: string) => void;
  disabled?: boolean;
}

export function CardActions({ wordId, onAction, disabled }: CardActionsProps) {
  const [isLoading, setIsLoading] = useState(false);

  const handleAction = async (action: CardAction) => {
    if (isLoading) return;
    setIsLoading(true);
    try {
      const response = await api.updateCardStatus(wordId, action);
      if (response.success && onAction) {
        onAction(action, response.message);
      }
    } catch (error) {
      console.error('Failed to update card status:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const actions = [
    { action: 'bury' as CardAction, icon: '⏸️', label: 'تعویق', title: 'تعویق تا فردا' },
    { action: 'suspend' as CardAction, icon: '😴', label: 'مخفی', title: 'مخفی برای ۳۰ روز' },
    { action: 'delete' as CardAction, icon: '🗑️', label: 'حذف', title: 'حذف از صف' },
  ];

  return (
    <div className="flex gap-2 justify-center">
      {actions.map((item) => (
        <button
          key={item.action}
          onClick={() => handleAction(item.action)}
          disabled={disabled || isLoading}
          title={item.title}
          className={cn(
            "flex items-center gap-1 px-3 py-1.5 rounded-lg text-sm transition-all",
            "bg-gray-100 hover:bg-gray-200 text-gray-700",
            "disabled:opacity-50 disabled:cursor-not-allowed"
          )}
        >
          <span>{item.icon}</span>
          <span>{item.label}</span>
        </button>
      ))}
    </div>
  );
}
