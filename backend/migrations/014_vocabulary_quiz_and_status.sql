-- Migration: 014_vocabulary_quiz_and_status
-- Description: Add quiz results table and card status field
-- Date: 2026-01-11

-- Add status field to user_vocabulary for suspend/bury/delete
ALTER TABLE user_vocabulary ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active';
ALTER TABLE user_vocabulary ADD COLUMN IF NOT EXISTS status_until TIMESTAMP;

-- Index for filtering by status
CREATE INDEX IF NOT EXISTS idx_user_vocab_status ON user_vocabulary(user_id, status);

-- Quiz results tracking
CREATE TABLE IF NOT EXISTS vocabulary_quiz_results (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    word_id INTEGER NOT NULL REFERENCES vocabulary_words(id) ON DELETE CASCADE,
    quiz_type VARCHAR(20) NOT NULL, -- 'meaning' (en->fa) or 'word' (fa->en)
    correct BOOLEAN NOT NULL,
    response_time_ms INTEGER, -- How long user took to answer
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_quiz_results_user ON vocabulary_quiz_results(user_id);
CREATE INDEX IF NOT EXISTS idx_quiz_results_word ON vocabulary_quiz_results(word_id);
CREATE INDEX IF NOT EXISTS idx_quiz_results_date ON vocabulary_quiz_results(created_at);

-- User quiz statistics (aggregate view)
CREATE OR REPLACE VIEW user_quiz_stats AS
SELECT
    user_id,
    quiz_type,
    COUNT(*) as total_attempts,
    SUM(CASE WHEN correct THEN 1 ELSE 0 END) as correct_count,
    ROUND(100.0 * SUM(CASE WHEN correct THEN 1 ELSE 0 END) / COUNT(*), 1) as accuracy_percent,
    AVG(response_time_ms) as avg_response_time
FROM vocabulary_quiz_results
GROUP BY user_id, quiz_type;
