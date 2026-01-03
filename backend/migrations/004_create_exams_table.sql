-- Migration: 004_create_exams_table
-- Description: Create exams table (آزمون‌ها)
-- Date: 2026-01-03

CREATE TABLE IF NOT EXISTS exams (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    field_id INTEGER NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(year, field_id)
);

CREATE INDEX IF NOT EXISTS idx_exams_year ON exams(year);
CREATE INDEX IF NOT EXISTS idx_exams_field ON exams(field_id);
