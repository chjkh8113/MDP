"use client";

import { useState } from "react";
import { Question } from "@/lib/api";

interface Props {
  question: Question;
  number: number;
}

export function QuestionCard({ question, number }: Props) {
  const [selected, setSelected] = useState<number | null>(null);
  const [showAnswer, setShowAnswer] = useState(false);

  const handleSelect = (index: number) => {
    if (showAnswer) return;
    setSelected(index);
  };

  const handleShowAnswer = () => {
    setShowAnswer(true);
  };

  const getOptionClass = (index: number) => {
    const base = "w-full p-4 text-right rounded-lg border transition-all ";

    if (!showAnswer) {
      if (selected === index) {
        return base + "border-blue-500 bg-blue-50";
      }
      return base + "border-gray-200 hover:border-gray-300 hover:bg-gray-50";
    }

    // Answer revealed
    const correctIndex = question.answer - 1;
    if (index === correctIndex) {
      return base + "border-green-500 bg-green-50";
    }
    if (selected === index && index !== correctIndex) {
      return base + "border-red-500 bg-red-50";
    }
    return base + "border-gray-200 bg-gray-50";
  };

  return (
    <div className="bg-white rounded-lg border border-gray-200 p-6">
      <div className="flex items-start gap-4 mb-4">
        <span className="flex-shrink-0 w-8 h-8 rounded-full bg-gray-100
                         flex items-center justify-center text-sm font-medium text-gray-600">
          {number}
        </span>
        <div className="flex-1">
          <p className="text-gray-800 leading-relaxed whitespace-pre-line">
            {question.content}
          </p>
          <span className="inline-block mt-2 text-xs text-gray-400">
            {question.year}
          </span>
        </div>
      </div>

      <div className="space-y-2 mb-4">
        {question.options.map((option, index) => (
          <button
            key={index}
            onClick={() => handleSelect(index)}
            disabled={showAnswer}
            className={getOptionClass(index)}
          >
            <span className="inline-flex items-center gap-2">
              <span className="text-gray-400">{index + 1})</span>
              <span>{option}</span>
            </span>
          </button>
        ))}
      </div>

      {!showAnswer && selected !== null && (
        <button
          onClick={handleShowAnswer}
          className="w-full py-2 bg-gray-800 text-white rounded-lg
                     hover:bg-gray-700 transition-colors"
        >
          نمایش پاسخ
        </button>
      )}

      {showAnswer && question.explanation && (
        <div className="mt-4 p-4 bg-gray-50 rounded-lg">
          <p className="text-sm text-gray-600">{question.explanation}</p>
        </div>
      )}
    </div>
  );
}
