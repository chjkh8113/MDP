-- MDP Database Schema

-- Create database (run separately as postgres user)
-- CREATE DATABASE mdp;

-- Fields (رشته‌ها)
CREATE TABLE IF NOT EXISTS fields (
    id SERIAL PRIMARY KEY,
    name_fa VARCHAR(100) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses (دروس)
CREATE TABLE IF NOT EXISTS courses (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id),
    name_fa VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Topics (موضوعات)
CREATE TABLE IF NOT EXISTS topics (
    id SERIAL PRIMARY KEY,
    course_id INTEGER REFERENCES courses(id),
    name_fa VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exams (آزمون‌ها)
CREATE TABLE IF NOT EXISTS exams (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    field_id INTEGER REFERENCES fields(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Questions (سوالات)
CREATE TABLE IF NOT EXISTS questions (
    id SERIAL PRIMARY KEY,
    exam_id INTEGER REFERENCES exams(id),
    course_id INTEGER REFERENCES courses(id),
    topic_id INTEGER REFERENCES topics(id),
    content TEXT NOT NULL,
    options JSONB NOT NULL,
    answer INTEGER NOT NULL,
    explanation TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users (کاربران)
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User Attempts (پاسخ‌های کاربر)
CREATE TABLE IF NOT EXISTS attempts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    question_id INTEGER REFERENCES questions(id),
    selected INTEGER NOT NULL,
    correct BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Review Schedule for Spaced Repetition
CREATE TABLE IF NOT EXISTS review_schedule (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    question_id INTEGER REFERENCES questions(id),
    next_review TIMESTAMP NOT NULL,
    ease_factor DECIMAL(3,2) DEFAULT 2.5,
    interval_days INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, question_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_questions_exam ON questions(exam_id);
CREATE INDEX IF NOT EXISTS idx_questions_course ON questions(course_id);
CREATE INDEX IF NOT EXISTS idx_attempts_user ON attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_review_next ON review_schedule(next_review);

-- Seed data: Fields
INSERT INTO fields (name_fa, name_en) VALUES
    ('فنی و مهندسی', 'Engineering'),
    ('علوم انسانی', 'Humanities'),
    ('علوم پایه', 'Basic Sciences'),
    ('هنر و معماری', 'Art & Architecture')
ON CONFLICT DO NOTHING;

-- Seed data: Courses (Computer Engineering)
INSERT INTO courses (field_id, name_fa, name_en) VALUES
    (1, 'ساختمان داده', 'Data Structures'),
    (1, 'طراحی الگوریتم', 'Algorithm Design'),
    (1, 'پایگاه داده', 'Database'),
    (1, 'شبکه', 'Networking'),
    (1, 'سیستم عامل', 'Operating Systems')
ON CONFLICT DO NOTHING;

-- Seed data: Sample Exams
INSERT INTO exams (year, field_id) VALUES
    (1404, 1), (1403, 1), (1402, 1), (1401, 1), (1400, 1)
ON CONFLICT DO NOTHING;

-- Seed data: Sample Questions
INSERT INTO questions (exam_id, course_id, content, options, answer) VALUES
    (1, 1, 'پیچیدگی زمانی جستجوی دودویی چیست؟', '["O(n)", "O(log n)", "O(n²)", "O(1)"]', 2),
    (1, 1, 'کدام ساختار داده LIFO است؟', '["صف", "پشته", "لیست", "درخت"]', 2),
    (2, 1, 'بهترین الگوریتم مرتب‌سازی برای داده‌های تقریباً مرتب کدام است؟', '["Quick Sort", "Merge Sort", "Insertion Sort", "Heap Sort"]', 3),
    (2, 2, 'پیچیدگی زمانی الگوریتم Dijkstra با استفاده از هیپ چیست؟', '["O(V²)", "O(E log V)", "O(V log V)", "O(E + V)"]', 2),
    (3, 1, 'در درخت AVL، تفاوت ارتفاع دو زیردرخت هر گره حداکثر چقدر است؟', '["0", "1", "2", "3"]', 2)
ON CONFLICT DO NOTHING;
