-- Migration: Add UUID columns to all tables
-- This migration adds UUID columns for external identification while keeping integer IDs for internal FK relationships

-- Add UUID columns with auto-generated values
ALTER TABLE fields ADD COLUMN IF NOT EXISTS uuid UUID DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE courses ADD COLUMN IF NOT EXISTS uuid UUID DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE topics ADD COLUMN IF NOT EXISTS uuid UUID DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE exams ADD COLUMN IF NOT EXISTS uuid UUID DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE questions ADD COLUMN IF NOT EXISTS uuid UUID DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS uuid UUID DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE attempts ADD COLUMN IF NOT EXISTS uuid UUID DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE review_schedule ADD COLUMN IF NOT EXISTS uuid UUID DEFAULT gen_random_uuid() NOT NULL;

-- Add unique indexes for UUID lookups
CREATE UNIQUE INDEX IF NOT EXISTS idx_fields_uuid ON fields(uuid);
CREATE UNIQUE INDEX IF NOT EXISTS idx_courses_uuid ON courses(uuid);
CREATE UNIQUE INDEX IF NOT EXISTS idx_topics_uuid ON topics(uuid);
CREATE UNIQUE INDEX IF NOT EXISTS idx_exams_uuid ON exams(uuid);
CREATE UNIQUE INDEX IF NOT EXISTS idx_questions_uuid ON questions(uuid);
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_uuid ON users(uuid);
CREATE UNIQUE INDEX IF NOT EXISTS idx_attempts_uuid ON attempts(uuid);
CREATE UNIQUE INDEX IF NOT EXISTS idx_review_schedule_uuid ON review_schedule(uuid);
