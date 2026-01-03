-- Migration: 001_create_fields_table
-- Description: Create fields table for study fields (رشته‌ها)
-- Date: 2026-01-03

CREATE TABLE IF NOT EXISTS fields (
    id SERIAL PRIMARY KEY,
    name_fa VARCHAR(100) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_fields_name_fa ON fields(name_fa);
