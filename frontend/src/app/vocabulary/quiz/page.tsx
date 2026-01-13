'use client';

import { useState, useEffect, useCallback, useRef } from 'react';
import { api, VocabQuizQuestion, VocabularyStats as VocabStatsType } from '@/lib/api';
import { VocabularyStats } from '@/components/vocabulary/VocabularyStats';
import { Button } from '@/components/ui/button';
import Link from 'next/link';
import { cn } from '@/lib/utils';

type QuizType = 'meaning' | 'word';

export default function VocabQuizPage() {
  const [questions, setQuestions] = useState<VocabQuizQuestion[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null);
  const [correctAnswer, setCorrectAnswer] = useState<string | null>(null);
  const [stats, setStats] = useState<VocabStatsType | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [quizType, setQuizType] = useState<QuizType>('meaning');
  const [sessionComplete, setSessionComplete] = useState(false);
  const [sessionStats, setSessionStats] = useState({ correct: 0, total: 0, xp: 0 });
  const startTimeRef = useRef<number>(0);

  const loadQuiz = useCallback(async (type: QuizType) => {
    setIsLoading(true);
    try {
      const [quizData, statsData] = await Promise.all([
        api.getVocabQuiz(type, 10),
        api.getVocabularyStats(),
      ]);
      setQuestions(quizData.questions);
      setStats(statsData);
      setCurrentIndex(0);
      setSelectedAnswer(null);
      setIsCorrect(null);
      setCorrectAnswer(null);
      setSessionComplete(false);
      setSessionStats({ correct: 0, total: 0, xp: 0 });
      startTimeRef.current = Date.now();
    } catch (error) {
      console.error('Failed to load quiz:', error);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    loadQuiz(quizType);
  }, [loadQuiz, quizType]);

  const handleAnswerSelect = async (answer: string) => {
    if (selectedAnswer !== null) return; // Already answered

    const timeMs = Date.now() - startTimeRef.current;
    setSelectedAnswer(answer);

    try {
      const currentQuestion = questions[currentIndex];
      const response = await api.submitVocabQuizAnswer(
        currentQuestion.word.id,
        answer,
        currentQuestion.type,
        timeMs
      );

      setIsCorrect(response.correct);
      setCorrectAnswer(response.correct_answer);
      setSessionStats(prev => ({
        correct: prev.correct + (response.correct ? 1 : 0),
        total: prev.total + 1,
        xp: prev.xp + response.xp_earned,
      }));

      // Update stats with XP
      if (stats && response.xp_earned > 0) {
        setStats({
          ...stats,
          total_xp: stats.total_xp + response.xp_earned,
        });
      }
    } catch (error) {
      console.error('Failed to submit answer:', error);
    }
  };

  const handleNext = () => {
    if (currentIndex < questions.length - 1) {
      setCurrentIndex(currentIndex + 1);
      setSelectedAnswer(null);
      setIsCorrect(null);
      setCorrectAnswer(null);
      startTimeRef.current = Date.now();
    } else {
      setSessionComplete(true);
    }
  };

  const currentQuestion = questions[currentIndex];
  const progress = questions.length > 0 ? ((currentIndex + 1) / questions.length) * 100 : 0;

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
    <div className="min-h-screen bg-gray-50 p-6" dir="rtl">
      <div className="max-w-2xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <Link href="/" className="text-2xl font-bold text-gray-900 hover:text-blue-600 transition mb-1 block">
              MDP
            </Link>
            <h1 className="text-lg text-gray-600">آزمون لغات</h1>
          </div>
          <div className="flex items-center gap-4">
            {/* Quiz type selector */}
            <div className="flex gap-2">
              <button
                onClick={() => setQuizType('meaning')}
                className={cn(
                  "px-3 py-1 rounded-lg text-sm transition",
                  quizType === 'meaning'
                    ? "bg-blue-500 text-white"
                    : "bg-gray-200 text-gray-700 hover:bg-gray-300"
                )}
              >
                معنی
              </button>
              <button
                onClick={() => setQuizType('word')}
                className={cn(
                  "px-3 py-1 rounded-lg text-sm transition",
                  quizType === 'word'
                    ? "bg-blue-500 text-white"
                    : "bg-gray-200 text-gray-700 hover:bg-gray-300"
                )}
              >
                کلمه
              </button>
            </div>
            {questions.length > 0 && !sessionComplete && (
              <div className="text-sm text-gray-600">
                {currentIndex + 1} / {questions.length}
              </div>
            )}
          </div>
        </div>

        {/* Stats */}
        <VocabularyStats stats={stats} />

        {/* Progress bar */}
        {questions.length > 0 && !sessionComplete && (
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
            <div className="text-6xl mb-4">
              {sessionStats.correct >= sessionStats.total * 0.8 ? '🏆' :
               sessionStats.correct >= sessionStats.total * 0.5 ? '👍' : '📚'}
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">آزمون تمام شد!</h2>
            <div className="text-lg text-gray-600 mb-4">
              <p>{sessionStats.correct} از {sessionStats.total} صحیح</p>
              <p className="text-emerald-600 font-semibold">+{sessionStats.xp} XP</p>
            </div>
            <div className="w-full bg-gray-200 rounded-full h-4 mb-6">
              <div
                className={cn(
                  "h-full rounded-full transition-all",
                  sessionStats.correct >= sessionStats.total * 0.8 ? "bg-emerald-500" :
                  sessionStats.correct >= sessionStats.total * 0.5 ? "bg-amber-500" : "bg-red-500"
                )}
                style={{ width: `${(sessionStats.correct / sessionStats.total) * 100}%` }}
              />
            </div>
            <div className="flex gap-4 justify-center">
              <Button onClick={() => loadQuiz(quizType)} variant="default">
                آزمون جدید
              </Button>
              <Link href="/vocabulary">
                <Button variant="outline">فلش کارت</Button>
              </Link>
              <Link href="/">
                <Button variant="outline">صفحه اصلی</Button>
              </Link>
            </div>
          </div>
        ) : currentQuestion ? (
          <div className="space-y-6">
            {/* Question card */}
            <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl shadow-xl p-8 text-center text-white">
              <span className="text-sm opacity-80 mb-2 block">
                {quizType === 'meaning' ? 'معنی این کلمه چیست؟' : 'کدام کلمه این معنی را دارد؟'}
              </span>
              <h2 className="text-3xl font-bold mb-2">
                {quizType === 'meaning' ? currentQuestion.word.word_en : currentQuestion.word.meaning_fa}
              </h2>
              {quizType === 'meaning' && currentQuestion.word.pronunciation && (
                <span className="text-lg opacity-90">{currentQuestion.word.pronunciation}</span>
              )}
            </div>

            {/* Options */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {currentQuestion.options.map((option, index) => {
                const isSelected = selectedAnswer === option;
                const isCorrectOption = correctAnswer === option;
                const isWaiting = selectedAnswer !== null && correctAnswer === null;
                const showResult = selectedAnswer !== null && correctAnswer !== null;

                return (
                  <button
                    key={index}
                    onClick={() => handleAnswerSelect(option)}
                    disabled={selectedAnswer !== null}
                    className={cn(
                      "p-4 rounded-xl text-lg font-medium transition-all",
                      "border-2",
                      // Default state
                      selectedAnswer === null && "bg-white border-gray-200 hover:border-blue-400 hover:bg-blue-50",
                      // Waiting for API response - show selected with neutral color
                      isWaiting && isSelected && "bg-blue-100 border-blue-400 text-blue-700",
                      isWaiting && !isSelected && "bg-gray-100 border-gray-200 text-gray-500",
                      // Show results after API response
                      showResult && isCorrectOption && "bg-emerald-100 border-emerald-500 text-emerald-700",
                      showResult && isSelected && !isCorrectOption && "bg-red-100 border-red-500 text-red-700",
                      showResult && !isSelected && !isCorrectOption && "bg-gray-100 border-gray-200 text-gray-500"
                    )}
                  >
                    <span dir={quizType === 'meaning' ? 'rtl' : 'ltr'}>{option}</span>
                    {showResult && isCorrectOption && <span className="mr-2">✓</span>}
                    {showResult && isSelected && !isCorrectOption && <span className="mr-2">✗</span>}
                  </button>
                );
              })}
            </div>

            {/* Result and Next button */}
            {selectedAnswer !== null && correctAnswer !== null && (
              <div className="text-center space-y-4">
                <div className={cn(
                  "text-lg font-semibold",
                  isCorrect ? "text-emerald-600" : "text-red-600"
                )}>
                  {isCorrect ? '✓ آفرین! درست بود' : '✗ اشتباه بود'}
                </div>
                <Button onClick={handleNext} variant="default" size="lg">
                  {currentIndex < questions.length - 1 ? 'سوال بعدی' : 'نمایش نتیجه'}
                </Button>
              </div>
            )}
            {selectedAnswer !== null && correctAnswer === null && (
              <div className="text-center">
                <div className="text-gray-500">در حال بررسی...</div>
              </div>
            )}
          </div>
        ) : (
          <div className="bg-white rounded-2xl shadow-lg p-8 text-center">
            <div className="text-6xl mb-4">📚</div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">سوالی موجود نیست</h2>
            <p className="text-gray-600 mb-6">
              ابتدا باید لغاتی به مجموعه خود اضافه کنید.
            </p>
            <Link href="/vocabulary">
              <Button>شروع یادگیری</Button>
            </Link>
          </div>
        )}

        {/* Navigation */}
        <div className="flex justify-center gap-4 pt-4">
          <Link href="/vocabulary">
            <Button variant="outline" size="sm">فلش کارت</Button>
          </Link>
        </div>
      </div>
    </div>
  );
}
