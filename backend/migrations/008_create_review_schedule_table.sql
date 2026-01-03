-- Migration: 008_create_review_schedule_table
-- Description: Create review schedule table for spaced repetition
-- Date: 2026-01-03

CREATE TABLE IF NOT EXISTS review_schedule (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    next_review TIMESTAMP NOT NULL,
    ease_factor DECIMAL(3,2) DEFAULT 2.5,
    interval_days INTEGER DEFAULT 1,
    repetitions INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_review_user ON review_schedule(user_id);
CREATE INDEX IF NOT EXISTS idx_review_next ON review_schedule(next_review);
