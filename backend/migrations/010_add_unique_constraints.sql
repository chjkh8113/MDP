-- Migration: Add unique constraints to prevent duplicate entries

-- Unique constraint on field names
CREATE UNIQUE INDEX IF NOT EXISTS idx_fields_name_fa_unique ON fields(name_fa);

-- Unique constraint on course names per field
CREATE UNIQUE INDEX IF NOT EXISTS idx_courses_name_fa_field_unique ON courses(name_fa, field_id);

-- Unique constraint on topic names per course
CREATE UNIQUE INDEX IF NOT EXISTS idx_topics_name_fa_course_unique ON topics(name_fa, course_id);
