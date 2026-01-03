-- Seed: 002_courses
-- Description: Initial courses for Engineering field
-- Date: 2026-01-03

-- Engineering courses (field_id = 1)
INSERT INTO courses (field_id, name_fa, name_en) VALUES
    (1, 'ساختمان داده', 'Data Structures'),
    (1, 'طراحی الگوریتم', 'Algorithm Design'),
    (1, 'پایگاه داده', 'Database'),
    (1, 'شبکه‌های کامپیوتری', 'Computer Networks'),
    (1, 'سیستم عامل', 'Operating Systems'),
    (1, 'معماری کامپیوتر', 'Computer Architecture'),
    (1, 'هوش مصنوعی', 'Artificial Intelligence'),
    (1, 'نظریه زبان‌ها', 'Theory of Languages')
ON CONFLICT DO NOTHING;

-- Humanities courses (field_id = 2)
INSERT INTO courses (field_id, name_fa, name_en) VALUES
    (2, 'مدیریت عمومی', 'General Management'),
    (2, 'اقتصاد خرد و کلان', 'Microeconomics and Macroeconomics'),
    (2, 'روانشناسی عمومی', 'General Psychology'),
    (2, 'حقوق اساسی', 'Constitutional Law')
ON CONFLICT DO NOTHING;
