-- Seed: 005_topics
-- Description: Topics for Data Structures course (based on real Konkur categories)
-- Date: 2026-01-03

-- Data Structures topics (course_id = 1)
INSERT INTO topics (course_id, name_fa) VALUES
    (1, 'مرتبه زمانی و تحلیل الگوریتم'),
    (1, 'پشته و صف'),
    (1, 'لیست پیوندی'),
    (1, 'درخت'),
    (1, 'گراف'),
    (1, 'مرتب‌سازی'),
    (1, 'جستجو'),
    (1, 'درهم‌سازی')
ON CONFLICT DO NOTHING;

-- Algorithm Design topics (course_id = 2)
INSERT INTO topics (course_id, name_fa) VALUES
    (2, 'الگوریتم‌های حریصانه'),
    (2, 'برنامه‌ریزی پویا'),
    (2, 'تقسیم و حل'),
    (2, 'الگوریتم‌های گراف'),
    (2, 'پیچیدگی محاسباتی')
ON CONFLICT DO NOTHING;

