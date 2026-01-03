"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { api, Question, Stats } from "@/lib/api";

export default function Home() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [years] = useState([1404, 1403, 1402, 1401, 1400]);
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
      setCurrentQ(0);
      setSelected(null);
      setShowAnswer(false);
      setScore({ correct: 0, total: 0 });
      setQuizMode(true);
    } catch (err) {
      console.error(err);
    }
    setLoading(false);
  };

  const handleAnswer = (optionIndex: number) => {
    if (showAnswer) return;
    setSelected(optionIndex);
  };

  const checkAnswer = async () => {
    if (selected === null) return;
    setShowAnswer(true);
    const correct = selected === questions[currentQ].answer;
    setScore((s) => ({
      correct: s.correct + (correct ? 1 : 0),
      total: s.total + 1,
    }));
  };

  const nextQuestion = () => {
    if (currentQ < questions.length - 1) {
      setCurrentQ((c) => c + 1);
      setSelected(null);
      setShowAnswer(false);
    } else {
      setQuizMode(false);
    }
  };

  const fields = [
    { name: "فنی و مهندسی", icon: "⚙️", count: 45 },
    { name: "علوم انسانی", icon: "📚", count: 38 },
    { name: "علوم پایه", icon: "🔬", count: 32 },
    { name: "هنر و معماری", icon: "🎨", count: 25 },
  ];

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="bg-primary text-primary-foreground py-4 px-6 sticky top-0 z-50">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <h1 className="text-2xl font-bold">MDP</h1>
          <nav className="flex gap-6">
            <a href="#fields" className="hover:opacity-80">رشته‌ها</a>
            <a href="#years" className="hover:opacity-80">سال‌ها</a>
            <a href="#quiz" className="hover:opacity-80">آزمون</a>
          </nav>
        </div>
      </header>

      {/* Hero */}
      <section className="bg-gradient-to-b from-primary to-primary/80 text-primary-foreground py-20 px-6">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-4xl font-bold mb-4">آرشیو سوالات کنکور ارشد</h2>
          <p className="text-xl opacity-90 mb-6">
            دسترسی به سوالات ۵ سال اخیر آزمون کارشناسی ارشد
          </p>
          <p className="opacity-80 mb-8">
            تمامی سوالات دسته‌بندی شده بر اساس رشته، درس و موضوع
          </p>
          <Button
            size="lg"
            variant="secondary"
            onClick={startQuiz}
            disabled={loading}
          >
            {loading ? "در حال آماده‌سازی..." : "شروع آزمون آزمایشی"}
          </Button>
        </div>
      </section>

      {/* Stats */}
      {stats && (
        <section className="py-12 px-6 bg-muted/30">
          <div className="max-w-6xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-4">
            <Card>
              <CardContent className="pt-6 text-center">
                <div className="text-3xl font-bold text-primary">
                  {stats.total_questions}+
                </div>
                <div className="text-muted-foreground">سوال</div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-6 text-center">
                <div className="text-3xl font-bold text-primary">
                  {stats.total_fields}
                </div>
                <div className="text-muted-foreground">رشته</div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-6 text-center">
                <div className="text-3xl font-bold text-primary">
                  {stats.total_courses}
                </div>
                <div className="text-muted-foreground">درس</div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-6 text-center">
                <div className="text-3xl font-bold text-primary">
                  {stats.years_covered}
                </div>
                <div className="text-muted-foreground">سال</div>
              </CardContent>
            </Card>
          </div>
        </section>
      )}

      {/* Quiz Mode */}
      {quizMode && questions.length > 0 && (
        <section id="quiz" className="py-12 px-6">
          <div className="max-w-3xl mx-auto">
            <Card>
              <CardHeader>
                <div className="flex justify-between items-center">
                  <CardTitle>
                    سوال {currentQ + 1} از {questions.length}
                  </CardTitle>
                  <Badge variant="outline">سال {questions[currentQ].year}</Badge>
                </div>
                <Progress
                  value={((currentQ + 1) / questions.length) * 100}
                  className="mt-2"
                />
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-lg font-medium leading-relaxed">
                  {questions[currentQ].content}
                </p>
                <div className="space-y-2">
                  {questions[currentQ].options.map((opt, i) => (
                    <button
                      key={i}
                      onClick={() => handleAnswer(i + 1)}
                      className={`w-full text-right p-4 rounded-lg border transition-all ${
                        selected === i + 1
                          ? showAnswer
                            ? i + 1 === questions[currentQ].answer
                              ? "bg-green-100 border-green-500"
                              : "bg-red-100 border-red-500"
                            : "bg-primary/10 border-primary"
                          : showAnswer && i + 1 === questions[currentQ].answer
                          ? "bg-green-100 border-green-500"
                          : "hover:bg-muted"
                      }`}
                    >
                      <span className="inline-block w-8 h-8 rounded-full bg-muted text-center leading-8 ml-3">
                        {i + 1}
                      </span>
                      {opt}
                    </button>
                  ))}
                </div>
                <div className="flex gap-4 pt-4">
                  {!showAnswer ? (
                    <Button onClick={checkAnswer} disabled={selected === null}>
                      بررسی پاسخ
                    </Button>
                  ) : (
                    <Button onClick={nextQuestion}>
                      {currentQ < questions.length - 1
                        ? "سوال بعدی"
                        : "پایان آزمون"}
                    </Button>
                  )}
                  <Button variant="outline" onClick={() => setQuizMode(false)}>
                    انصراف
                  </Button>
                </div>
                {showAnswer && (
                  <div
                    className={`p-4 rounded-lg ${
                      selected === questions[currentQ].answer
                        ? "bg-green-50 text-green-800"
                        : "bg-red-50 text-red-800"
                    }`}
                  >
                    {selected === questions[currentQ].answer
                      ? "پاسخ صحیح!"
                      : `پاسخ نادرست. گزینه ${questions[currentQ].answer} صحیح بود.`}
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Score */}
            {score.total > 0 && (
              <Card className="mt-4">
                <CardContent className="pt-6">
                  <div className="flex justify-between items-center">
                    <span>نمره فعلی:</span>
                    <span className="font-bold text-lg">
                      {score.correct} از {score.total} (
                      {Math.round((score.correct / score.total) * 100)}%)
                    </span>
                  </div>
                </CardContent>
              </Card>
            )}
          </div>
        </section>
      )}

      {/* Fields Section */}
      {!quizMode && (
        <section id="fields" className="py-12 px-6">
          <div className="max-w-6xl mx-auto">
            <h2 className="text-2xl font-bold text-center mb-8">رشته‌های تحصیلی</h2>
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
              {fields.map((field) => (
                <Card
                  key={field.name}
                  className="cursor-pointer hover:shadow-lg transition-shadow"
                >
                  <CardContent className="pt-6 text-center">
                    <div className="text-4xl mb-3">{field.icon}</div>
                    <h3 className="font-semibold mb-2">{field.name}</h3>
                    <Badge variant="secondary">{field.count} سوال</Badge>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Years Section */}
      {!quizMode && (
        <section id="years" className="py-12 px-6 bg-muted/30">
          <div className="max-w-6xl mx-auto">
            <h2 className="text-2xl font-bold text-center mb-8">سال‌های آزمون</h2>
            <Tabs defaultValue="1404" className="w-full">
              <TabsList className="grid grid-cols-5 w-full max-w-lg mx-auto">
                {years.map((year) => (
                  <TabsTrigger key={year} value={String(year)}>
                    {year}
                  </TabsTrigger>
                ))}
              </TabsList>
              {years.map((year) => (
                <TabsContent key={year} value={String(year)} className="mt-6">
                  <Card>
                    <CardContent className="pt-6">
                      <div className="text-center">
                        <p className="text-lg mb-4">
                          سوالات کنکور ارشد سال {year}
                        </p>
                        <Button onClick={startQuiz}>
                          شروع آزمون از سوالات {year}
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                </TabsContent>
              ))}
            </Tabs>
          </div>
        </section>
      )}

      {/* Footer */}
      <footer className="bg-primary text-primary-foreground py-8 px-6">
        <div className="max-w-6xl mx-auto text-center">
          <p className="opacity-80">MDP - تمامی حقوق محفوظ است 1404</p>
        </div>
      </footer>
    </div>
  );
}
