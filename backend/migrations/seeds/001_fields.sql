-- Seed: 001_fields
-- Description: Initial study fields (رشته‌ها)
-- Date: 2026-01-03

INSERT INTO fields (name_fa, name_en) VALUES
    ('فنی و مهندسی', 'Engineering'),
    ('علوم انسانی', 'Humanities'),
    ('علوم پایه', 'Basic Sciences'),
    ('هنر و معماری', 'Art and Architecture')
ON CONFLICT DO NOTHING;
