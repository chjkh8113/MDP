const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8181/api/v1';

export interface Field {
  id: string;  // UUID
  name_fa: string;
  name_en: string;
}

export interface Course {
  id: string;  // UUID
  name_fa: string;
  name_en: string;
}

export interface Topic {
  id: string;  // UUID
  name_fa: string;
}

export interface Question {
  id: string;  // UUID
  content: string;
  options: string[];
  answer: number;
  year: number;
  field_name?: string;
  explanation?: string;
}

export interface QuizResponse {
  questions: Question[];
  total: number;
}

export interface Stats {
  total_questions: number;
  total_fields: number;
  total_courses: number;
  years_covered: number;
}

// Vocabulary Types
export interface VocabularyCategory {
  id: string;
  name_fa: string;
  name_en: string;
  description_fa?: string;
  description_en?: string;
  icon?: string;
  word_count: number;
}

export interface VocabularyWord {
  id: string;
  category_name?: string;
  word_en: string;
  meaning_fa: string;
  pronunciation?: string;
  example_en?: string;
  example_fa?: string;
  difficulty: number;
}

export interface StudyQueueItem {
  type: 'new' | 'review';
  word: VocabularyWord;
  progress: {
    easiness: number;
    interval_days: number;
    repetitions: number;
  };
}

export interface StudyQueue {
  queue: StudyQueueItem[];
  total: number;
  due_count: number;
  new_count: number;
}

export interface VocabularyReviewResponse {
  success: boolean;
  next_review: string;
  interval_days: number;
  easiness: number;
  xp_earned: number;
  streak: number;
}

export interface VocabularyStats {
  total_words: number;
  words_learned: number;
  words_due: number;
  words_new: number;
  reviews_today: number;
  current_streak: number;
  longest_streak: number;
  total_xp: number;
  accuracy_percent: number;
}

// Quiz Types
export interface VocabQuizQuestion {
  word: VocabularyWord;
  options: string[];
  type: 'meaning' | 'word'; // meaning = en->fa, word = fa->en
}

export interface VocabQuizResponse {
  questions: VocabQuizQuestion[];
  total: number;
  type: string;
}

export interface VocabQuizAnswerResponse {
  correct: boolean;
  correct_answer: string;
  xp_earned: number;
}

// Card Action Types
export type CardAction = 'suspend' | 'bury' | 'delete' | 'restore';

export interface CardActionResponse {
  success: boolean;
  message: string;
}

async function fetchAPI<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${API_BASE}${endpoint}`, {
    ...options,
    credentials: 'include', // Include cookies for user identification
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
  });

  if (!res.ok) {
    throw new Error(`API Error: ${res.status}`);
  }

  return res.json();
}

export const api = {
  // Health
  health: () => fetchAPI<{ status: string }>('/health'),

  // Fields, Courses & Topics (using UUIDs)
  getFields: () => fetchAPI<Field[]>('/fields'),
  getCourses: (fieldId: string) => fetchAPI<Course[]>(`/fields/${fieldId}/courses`),
  getTopics: (courseId: string) => fetchAPI<Topic[]>(`/courses/${courseId}/topics`),
  getQuestionsByTopic: (topicId: string) => fetchAPI<Question[]>(`/topics/${topicId}/questions`),

  // Years
  getYears: () => fetchAPI<number[]>('/years'),

  // Stats
  getStats: () => fetchAPI<Stats>('/stats'),

  // Questions
  getQuestions: (params?: { year?: number; field_id?: number; limit?: number }) => {
    const query = new URLSearchParams();
    if (params?.year) query.set('year', String(params.year));
    if (params?.field_id) query.set('field_id', String(params.field_id));
    if (params?.limit) query.set('limit', String(params.limit));
    return fetchAPI<{ questions: Question[]; total: number }>(`/questions?${query}`);
  },

  // Quiz
  generateQuiz: (count: number = 10) =>
    fetchAPI<QuizResponse>('/quiz/generate', {
      method: 'POST',
      body: JSON.stringify({ count }),
    }),

  submitAnswer: (questionId: string, selected: number) =>
    fetchAPI<{ correct: boolean; correct_answer: number }>('/quiz/answer', {
      method: 'POST',
      body: JSON.stringify({ question_id: questionId, selected }),
    }),

  // Vocabulary
  getVocabularyCategories: () =>
    fetchAPI<VocabularyCategory[]>('/vocabulary/categories'),

  getVocabularyWords: (params?: { category?: string; limit?: number; offset?: number }) => {
    const query = new URLSearchParams();
    if (params?.category) query.set('category', params.category);
    if (params?.limit) query.set('limit', String(params.limit));
    if (params?.offset) query.set('offset', String(params.offset));
    return fetchAPI<{ words: VocabularyWord[]; total: number }>(`/vocabulary/words?${query}`);
  },

  getStudyQueue: (limit: number = 10, category?: string) => {
    const query = new URLSearchParams();
    query.set('limit', String(limit));
    if (category) query.set('category', category);
    return fetchAPI<StudyQueue>(`/vocabulary/study?${query}`);
  },

  reviewWord: (wordId: string, quality: number) =>
    fetchAPI<VocabularyReviewResponse>('/vocabulary/review', {
      method: 'POST',
      body: JSON.stringify({ word_id: wordId, quality }),
    }),

  getVocabularyStats: () => fetchAPI<VocabularyStats>('/vocabulary/stats'),

  // Vocabulary Quiz
  getVocabQuiz: (type: 'meaning' | 'word' = 'meaning', count: number = 10) => {
    const query = new URLSearchParams();
    query.set('type', type);
    query.set('count', String(count));
    return fetchAPI<VocabQuizResponse>(`/vocabulary/quiz?${query}`);
  },

  submitVocabQuizAnswer: (wordId: string, answer: string, quizType: string, timeMs?: number) =>
    fetchAPI<VocabQuizAnswerResponse>('/vocabulary/quiz/answer', {
      method: 'POST',
      body: JSON.stringify({
        word_id: wordId,
        answer,
        quiz_type: quizType,
        time_ms: timeMs,
      }),
    }),

  // Card Actions
  updateCardStatus: (wordId: string, action: CardAction) =>
    fetchAPI<CardActionResponse>('/vocabulary/card/action', {
      method: 'POST',
      body: JSON.stringify({ word_id: wordId, action }),
    }),

  getSuspendedCards: () =>
    fetchAPI<{ cards: VocabularyWord[]; total: number }>('/vocabulary/card/suspended'),
};
