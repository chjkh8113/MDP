const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8181/api/v1';

export interface Field {
  id: number;
  name_fa: string;
  name_en: string;
}

export interface Course {
  id: number;
  field_id: number;
  name_fa: string;
  name_en: string;
}

export interface Question {
  id: number;
  content: string;
  options: string[];
  answer: number;
  year: number;
  field_name?: string;
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

async function fetchAPI<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${API_BASE}${endpoint}`, {
    ...options,
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

  // Fields & Courses
  getFields: () => fetchAPI<Field[]>('/fields'),
  getCourses: (fieldId: number) => fetchAPI<Course[]>(`/fields/${fieldId}/courses`),

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

  submitAnswer: (questionId: number, selected: number) =>
    fetchAPI<{ correct: boolean; correct_answer: number }>('/quiz/answer', {
      method: 'POST',
      body: JSON.stringify({ question_id: questionId, selected }),
    }),
};
