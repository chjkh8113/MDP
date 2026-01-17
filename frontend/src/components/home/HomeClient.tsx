"use client";

import { useEffect, useState } from "react";
import { Header } from "@/components/common/Header";
import { Hero, Stats, FAQ } from "@/components/landing";
import { QuizCard, ScoreCard } from "@/components/quiz";
import { api, Question, Stats as StatsType } from "@/lib/api";
import { platformFAQs, CredentialsSection } from "@/components/seo";

export default function HomeClient() {
  const [stats, setStats] = useState<StatsType | null>(null);
  const [quizMode, setQuizMode] = useState(false);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [currentQ, setCurrentQ] = useState(0);
  const [selected, setSelected] = useState<number | null>(null);
  const [showAnswer, setShowAnswer] = useState(false);
  const [score, setScore] = useState({ correct: 0, total: 0 });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    api.getStats().then(setStats).catch(console.error);
  }, []);

  const startQuiz = async () => {
    setLoading(true);
    try {
      const res = await api.generateQuiz(5);
      setQuestions(res.questions);
      resetQuizState();
      setQuizMode(true);
    } catch (err) {
      console.error(err);
    }
    setLoading(false);
  };

  const resetQuizState = () => {
    setCurrentQ(0);
    setSelected(null);
    setShowAnswer(false);
    setScore({ correct: 0, total: 0 });
  };

  const handleSelect = (optionIndex: number) => {
    if (!showAnswer) setSelected(optionIndex);
  };

  const handleCheck = () => {
    if (selected === null) return;
    setShowAnswer(true);
    const correct = selected === questions[currentQ].answer;
    setScore((s) => ({
      correct: s.correct + (correct ? 1 : 0),
      total: s.total + 1,
    }));
  };

  const handleNext = () => {
    if (currentQ < questions.length - 1) {
      setCurrentQ((c) => c + 1);
      setSelected(null);
      setShowAnswer(false);
    } else {
      setQuizMode(false);
    }
  };

  const handleExit = () => setQuizMode(false);

  return (
    <div className="min-h-screen flex flex-col">
      <Header />

      {quizMode && questions.length > 0 ? (
        <main className="flex-1 flex flex-col items-center justify-center p-6">
          <QuizCard
            question={questions[currentQ]}
            currentIndex={currentQ}
            totalQuestions={questions.length}
            selected={selected}
            showAnswer={showAnswer}
            onSelect={handleSelect}
            onCheck={handleCheck}
            onNext={handleNext}
            onExit={handleExit}
          />
          <div className="w-full max-w-2xl">
            <ScoreCard correct={score.correct} total={score.total} />
          </div>
        </main>
      ) : (
        <>
          <Hero onStartQuiz={startQuiz} loading={loading} />
          <Stats stats={stats} />
          <CredentialsSection />
          <FAQ faqs={platformFAQs} />
        </>
      )}
    </div>
  );
}
