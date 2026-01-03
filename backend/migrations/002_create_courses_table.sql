-- Migration: 002_create_courses_table
-- Description: Create courses table (دروس)
-- Date: 2026-01-03

CREATE TABLE IF NOT EXISTS courses (
    id SERIAL PRIMARY KEY,
    field_id INTEGER NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
    name_fa VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_courses_field ON courses(field_id);
CREATE INDEX IF NOT EXISTS idx_courses_name_fa ON courses(name_fa);
