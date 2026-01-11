'use client';

import { useState, useEffect, useCallback } from 'react';
import { api, StudyQueueItem, VocabularyStats as VocabStatsType } from '@/lib/api';
import { FlashCard, RatingButtons, Quality } from '@/components/vocabulary/FlashCard';
import { VocabularyStats } from '@/components/vocabulary/VocabularyStats';
import { Button } from '@/components/ui/button';
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

  const currentWord = queue[currentIndex];
  const progress = queue.length > 0 ? ((currentIndex + 1) / queue.length) * 100 : 0;

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 p-6">
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
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-2xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <Link href="/" className="text-blue-600 hover:text-blue-800 text-sm mb-1 block">
              ← Back to Home
            </Link>
            <h1 className="text-2xl font-bold text-gray-900">Vocabulary Practice</h1>
          </div>
          {queue.length > 0 && !sessionComplete && (
            <div className="text-sm text-gray-600">
              {currentIndex + 1} / {queue.length}
            </div>
          )}
        </div>

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
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Session Complete!</h2>
            <p className="text-gray-600 mb-6">
              Great job! You've reviewed all your cards for now.
            </p>
            <div className="flex gap-4 justify-center">
              <Button onClick={loadStudyQueue} variant="default">
                Study More
              </Button>
              <Link href="/">
                <Button variant="outline">Back to Home</Button>
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
                {currentWord.type === 'new' ? 'New Word' : 'Review'}
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
                    +{lastReview.xp} XP · Next review in {lastReview.interval} day(s)
                  </div>
                )}
              </div>
            )}

            {/* Flip hint */}
            {!showAnswer && (
              <p className="text-center text-gray-500 text-sm">
                Click the card to reveal the answer
              </p>
            )}
          </div>
        ) : (
          <div className="bg-white rounded-2xl shadow-lg p-8 text-center">
            <div className="text-6xl mb-4">📚</div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">No Words to Study</h2>
            <p className="text-gray-600 mb-6">
              Great job! You've completed all available reviews.
            </p>
            <Button onClick={loadStudyQueue}>Refresh</Button>
          </div>
        )}
      </div>
    </div>
  );
}
