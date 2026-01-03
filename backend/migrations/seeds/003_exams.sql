-- Seed: 003_exams
-- Description: Initial exams for 5 years
-- Date: 2026-01-03

-- Engineering exams (field_id = 1)
INSERT INTO exams (year, field_id) VALUES
    (1404, 1),
    (1403, 1),
    (1402, 1),
    (1401, 1),
    (1400, 1)
ON CONFLICT DO NOTHING;

-- Humanities exams (field_id = 2)
INSERT INTO exams (year, field_id) VALUES
    (1404, 2),
    (1403, 2),
    (1402, 2),
    (1401, 2),
    (1400, 2)
ON CONFLICT DO NOTHING;
