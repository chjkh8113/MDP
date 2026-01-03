"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Question } from "@/lib/api";

interface QuizCardProps {
  question: Question;
  currentIndex: number;
  totalQuestions: number;
  selected: number | null;
  showAnswer: boolean;
  onSelect: (index: number) => void;
  onCheck: () => void;
  onNext: () => void;
  onExit: () => void;
}

export function QuizCard({
  question,
  currentIndex,
  totalQuestions,
  selected,
  showAnswer,
  onSelect,
  onCheck,
  onNext,
  onExit,
}: QuizCardProps) {
  const isLastQuestion = currentIndex >= totalQuestions - 1;

  return (
    <Card className="w-full max-w-2xl mx-auto">
      <CardHeader>
        <div className="flex justify-between items-center">
          <CardTitle className="text-lg">
            سوال {currentIndex + 1} از {totalQuestions}
          </CardTitle>
          <Badge variant="outline">سال {question.year}</Badge>
        </div>
        <Progress
          value={((currentIndex + 1) / totalQuestions) * 100}
          className="mt-2"
        />
      </CardHeader>
      <CardContent className="space-y-4">
        <p className="text-lg font-medium leading-relaxed">{question.content}</p>

        <OptionsList
          options={question.options}
          correctAnswer={question.answer}
          selected={selected}
          showAnswer={showAnswer}
          onSelect={onSelect}
        />

        <QuizActions
          selected={selected}
          showAnswer={showAnswer}
          isLastQuestion={isLastQuestion}
          onCheck={onCheck}
          onNext={onNext}
          onExit={onExit}
        />

        {showAnswer && (
          <AnswerFeedback
            isCorrect={selected === question.answer}
            correctAnswer={question.answer}
          />
        )}
      </CardContent>
    </Card>
  );
}

function OptionsList({
  options,
  correctAnswer,
  selected,
  showAnswer,
  onSelect,
}: {
  options: string[];
  correctAnswer: number;
  selected: number | null;
  showAnswer: boolean;
  onSelect: (index: number) => void;
}) {
  return (
    <div className="space-y-2">
      {options.map((opt, i) => {
        const optionNum = i + 1;
        const isSelected = selected === optionNum;
        const isCorrect = optionNum === correctAnswer;

        let className = "w-full text-right p-4 rounded-lg border transition-all ";
        if (isSelected) {
          if (showAnswer) {
            className += isCorrect
              ? "bg-green-50 border-green-500"
              : "bg-red-50 border-red-500";
          } else {
            className += "bg-primary/5 border-primary";
          }
        } else if (showAnswer && isCorrect) {
          className += "bg-green-50 border-green-500";
        } else {
          className += "hover:bg-muted";
        }

        return (
          <button
            key={i}
            onClick={() => !showAnswer && onSelect(optionNum)}
            className={className}
            disabled={showAnswer}
          >
            <span className="inline-block w-7 h-7 rounded-full bg-muted text-center leading-7 ml-3 text-sm">
              {optionNum}
            </span>
            {opt}
          </button>
        );
      })}
    </div>
  );
}

function QuizActions({
  selected,
  showAnswer,
  isLastQuestion,
  onCheck,
  onNext,
  onExit,
}: {
  selected: number | null;
  showAnswer: boolean;
  isLastQuestion: boolean;
  onCheck: () => void;
  onNext: () => void;
  onExit: () => void;
}) {
  return (
    <div className="flex gap-4 pt-4">
      {!showAnswer ? (
        <Button onClick={onCheck} disabled={selected === null}>
          بررسی پاسخ
        </Button>
      ) : (
        <Button onClick={onNext}>
          {isLastQuestion ? "پایان آزمون" : "سوال بعدی"}
        </Button>
      )}
      <Button variant="outline" onClick={onExit}>
        انصراف
      </Button>
    </div>
  );
}

function AnswerFeedback({
  isCorrect,
  correctAnswer,
}: {
  isCorrect: boolean;
  correctAnswer: number;
}) {
  return (
    <div
      className={`p-4 rounded-lg text-sm ${
        isCorrect ? "bg-green-50 text-green-800" : "bg-red-50 text-red-800"
      }`}
    >
      {isCorrect
        ? "پاسخ صحیح"
        : `پاسخ نادرست - گزینه ${correctAnswer} صحیح بود`}
    </div>
  );
}
