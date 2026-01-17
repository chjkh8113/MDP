'use client';

import { useState, useEffect, useCallback } from 'react';
import { api, StudyQueueItem, VocabularyStats as VocabStatsType } from '@/lib/api';
import { FlashCard, RatingButtons, CardActions, Quality } from '@/components/vocabulary/FlashCard';
import { CardAction } from '@/lib/api';
import { VocabularyStats } from '@/components/vocabulary/VocabularyStats';
import { Button } from '@/components/ui/button';
import { FAQSection, vocabularyFAQs, HowToSchema, vocabularyHowTo } from '@/components/seo';
import Link from 'next/link';

export default function VocabularyPage() {
  const [queue, setQueue] = useState<StudyQueueItem[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [showAnswer, setShowAnswer] = useState(false);
  const [stats, setStats] = useState<VocabStatsType | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isReviewing, setIsReviewing] = useState(false);
  const [sessionComplete, setSessionComplete] = useState(false);
  const [lastReview, setLastReview] = useState<{ xp: number; interval: number } | null>(null);
  const [cardActionMessage, setCardActionMessage] = useState<string | null>(null);

  const loadStudyQueue = useCallback(async () => {
    setIsLoading(true);
    try {
      const [queueData, statsData] = await Promise.all([
        api.getStudyQueue(10),
        api.getVocabularyStats(),
      ]);
      setQueue(queueData.queue);
      setStats(statsData);
      setCurrentIndex(0);
      setShowAnswer(false);
      setSessionComplete(queueData.queue.length === 0);
    } catch (error) {
      console.error('Failed to load study queue:', error);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    loadStudyQueue();
  }, [loadStudyQueue]);

  const handleFlip = () => {
    setShowAnswer(!showAnswer);
  };

  const handleRate = async (quality: Quality) => {
    if (!currentWord || isReviewing) return;

    setIsReviewing(true);
    try {
      const response = await api.reviewWord(currentWord.word.id, quality);
      setLastReview({ xp: response.xp_earned, interval: response.interval_days });

      // Update stats
      if (stats) {
        setStats({
          ...stats,
          current_streak: response.streak,
          total_xp: stats.total_xp + response.xp_earned,
          reviews_today: stats.reviews_today + 1,
        });
      }

      // Move to next card
      setTimeout(() => {
        if (currentIndex < queue.length - 1) {
          setCurrentIndex(currentIndex + 1);
          setShowAnswer(false);
          setLastReview(null);
        } else {
          setSessionComplete(true);
        }
        setIsReviewing(false);
      }, 800);
    } catch (error) {
      console.error('Failed to submit review:', error);
      setIsReviewing(false);
    }
  };

  const handleCardAction = (action: CardAction, message: string) => {
    setCardActionMessage(message);
    // Move to next card after action
    setTimeout(() => {
      if (currentIndex < queue.length - 1) {
        setCurrentIndex(currentIndex + 1);
        setShowAnswer(false);
      } else {
        setSessionComplete(true);
      }
      setCardActionMessage(null);
    }, 1500);
  };

  const currentWord = queue[currentIndex];
  const progress = queue.length > 0 ? ((currentIndex + 1) / queue.length) * 100 : 0;

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 p-6" dir="rtl">
        <div className="max-w-2xl mx-auto">
          <div className="animate-pulse space-y-6">
            <div className="h-8 bg-gray-200 rounded w-1/3" />
            <div className="grid grid-cols-4 gap-4">
              {[...Array(4)].map((_, i) => (
                <div key={i} className="h-24 bg-gray-200 rounded-xl" />
              ))}
            </div>
            <div className="h-64 bg-gray-200 rounded-2xl" />
          </div>
        </div>
      </div>
    );
  }

  return (
    <>
      {/* HowTo Schema for AI/Search engines */}
      <HowToSchema
        name={vocabularyHowTo.name}
        description={vocabularyHowTo.description}
        totalTime={vocabularyHowTo.totalTime}
        steps={vocabularyHowTo.steps}
      />

      <div className="min-h-screen bg-gray-50 p-6" dir="rtl">
        <div className="max-w-2xl mx-auto space-y-6">
          {/* Header */}
          <div className="flex items-center justify-between">
            <div>
              <Link href="/" className="text-2xl font-bold text-gray-900 hover:text-blue-600 transition mb-1 block">
                MDP
              </Link>
              <h1 className="text-lg text-gray-600">تمرین لغات</h1>
            </div>
            {queue.length > 0 && !sessionComplete && (
              <div className="text-sm text-gray-600">
                {currentIndex + 1} / {queue.length}
              </div>
            )}
          </div>

          {/* TL;DR - Direct answer for AI crawlers */}
          {!queue.length && !isLoading && (
          <div className="bg-green-50 border border-green-200 rounded-lg p-4">
            <p className="text-green-800 font-medium">
              سیستم فلش‌کارت MDP با الگوریتم SM-2 به شما کمک می‌کند لغات تخصصی کنکور ارشد را به صورت علمی یاد بگیرید.
            </p>
          </div>
        )}

        {/* Stats */}
        <VocabularyStats stats={stats} />

        {/* Progress bar */}
        {queue.length > 0 && !sessionComplete && (
          <div className="w-full h-2 bg-gray-200 rounded-full overflow-hidden">
            <div
              className="h-full bg-blue-500 transition-all duration-300"
              style={{ width: `${progress}%` }}
            />
          </div>
        )}

        {/* Main content */}
        {sessionComplete ? (
          <div className="bg-white rounded-2xl shadow-lg p-8 text-center">
            <div className="text-6xl mb-4">🎉</div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">جلسه تمام شد!</h2>
            <p className="text-gray-600 mb-6">
              آفرین! همه کارت‌های امروز را مرور کردید.
            </p>
            <div className="flex gap-4 justify-center">
              <Button onClick={loadStudyQueue} variant="default">
                مطالعه بیشتر
              </Button>
              <Link href="/vocabulary/quiz">
                <Button variant="outline">آزمون</Button>
              </Link>
              <Link href="/">
                <Button variant="outline">صفحه اصلی</Button>
              </Link>
            </div>
          </div>
        ) : currentWord ? (
          <div className="space-y-6">
            {/* Card type indicator */}
            <div className="flex justify-center">
              <span
                className={`px-3 py-1 rounded-full text-sm font-medium ${
                  currentWord.type === 'new'
                    ? 'bg-blue-100 text-blue-700'
                    : 'bg-amber-100 text-amber-700'
                }`}
              >
                {currentWord.type === 'new' ? 'لغت جدید' : 'مرور'}
              </span>
            </div>

            {/* Flashcard */}
            <FlashCard
              word={currentWord.word}
              showAnswer={showAnswer}
              onFlip={handleFlip}
            />

            {/* Rating buttons - only show when answer is revealed */}
            {showAnswer && (
              <div className="space-y-4">
                <RatingButtons onRate={handleRate} disabled={isReviewing} />

                {/* Last review feedback */}
                {lastReview && (
                  <div className="text-center text-sm text-gray-600 animate-fade-in">
                    +{lastReview.xp} XP · مرور بعدی در {lastReview.interval} روز
                  </div>
                )}

                {/* Card actions */}
                <div className="pt-4 border-t border-gray-200">
                  <CardActions
                    wordId={currentWord.word.id}
                    onAction={handleCardAction}
                    disabled={isReviewing}
                  />
                </div>

                {/* Card action message toast */}
                {cardActionMessage && (
                  <div className="fixed bottom-4 left-1/2 transform -translate-x-1/2 bg-gray-800 text-white px-4 py-2 rounded-lg shadow-lg z-50 animate-fade-in">
                    {cardActionMessage}
                  </div>
                )}
              </div>
            )}

            {/* Flip hint */}
            {!showAnswer && (
              <p className="text-center text-gray-500 text-sm">
                روی کارت کلیک کنید تا جواب نمایش داده شود
              </p>
            )}
          </div>
        ) : (
          <div className="bg-white rounded-2xl shadow-lg p-8 text-center">
            <div className="text-6xl mb-4">📚</div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">لغتی برای مطالعه نیست</h2>
            <p className="text-gray-600 mb-6">
              آفرین! همه مرورهای موجود را تکمیل کردید.
            </p>
            <Button onClick={loadStudyQueue}>بارگذاری مجدد</Button>
          </div>
        )}

        {/* FAQ Section for AEO - only show when not in study mode */}
        {(sessionComplete || !currentWord) && (
          <FAQSection faqs={vocabularyFAQs} title="سوالات متداول درباره تمرین لغات" />
        )}
      </div>
    </div>
    </>
  );
}
