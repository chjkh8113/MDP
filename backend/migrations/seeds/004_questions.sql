-- Seed: 004_questions
-- Description: Sample questions for demo
-- Date: 2026-01-03

-- Data Structures questions (course_id = 1)
INSERT INTO questions (exam_id, course_id, content, options, answer) VALUES
    (1, 1, 'پیچیدگی زمانی جستجوی دودویی چیست؟',
     '["O(n)", "O(log n)", "O(n²)", "O(1)"]', 2),

    (1, 1, 'کدام ساختار داده LIFO است؟',
     '["صف", "پشته", "لیست پیوندی", "درخت"]', 2),

    (2, 1, 'بهترین الگوریتم مرتب‌سازی برای داده‌های تقریباً مرتب کدام است؟',
     '["Quick Sort", "Merge Sort", "Insertion Sort", "Heap Sort"]', 3),

    (2, 1, 'در درخت AVL، تفاوت ارتفاع دو زیردرخت هر گره حداکثر چقدر است؟',
     '["0", "1", "2", "3"]', 2),

    (3, 1, 'پیچیدگی زمانی عملیات درج در هش با روش زنجیره‌ای چیست؟',
     '["O(1)", "O(n)", "O(log n)", "O(n²)"]', 1)
ON CONFLICT DO NOTHING;

-- Algorithm Design questions (course_id = 2)
INSERT INTO questions (exam_id, course_id, content, options, answer) VALUES
    (1, 2, 'الگوریتم Dijkstra برای چه مسئله‌ای استفاده می‌شود؟',
     '["کوتاه‌ترین مسیر", "درخت پوشا", "مرتب‌سازی", "جستجو"]', 1),

    (2, 2, 'پیچیدگی زمانی الگوریتم Dijkstra با هیپ چیست؟',
     '["O(V²)", "O(E log V)", "O(V log V)", "O(E + V)"]', 2)
ON CONFLICT DO NOTHING;
