-- Migration: 012_create_vocabulary_tables
-- Description: Create vocabulary learning system tables
-- Date: 2026-01-11

-- Vocabulary categories (e.g., "Essential IELTS", "Academic Words", "Topic-based")
CREATE TABLE IF NOT EXISTS vocabulary_categories (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT gen_random_uuid()::text,
    name_fa VARCHAR(100) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    description_fa TEXT,
    description_en TEXT,
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vocabulary words with English and Persian
CREATE TABLE IF NOT EXISTS vocabulary_words (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT gen_random_uuid()::text,
    category_id INTEGER REFERENCES vocabulary_categories(id) ON DELETE SET NULL,
    word_en VARCHAR(100) NOT NULL,
    meaning_fa VARCHAR(255) NOT NULL,
    pronunciation VARCHAR(100),
    example_en TEXT,
    example_fa TEXT,
    difficulty INTEGER DEFAULT 1 CHECK (difficulty BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User vocabulary progress (SM-2 algorithm data)
CREATE TABLE IF NOT EXISTS user_vocabulary (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    word_id INTEGER NOT NULL REFERENCES vocabulary_words(id) ON DELETE CASCADE,
    easiness DECIMAL(4,2) DEFAULT 2.5,
    interval_days INTEGER DEFAULT 1,
    repetitions INTEGER DEFAULT 0,
    next_review TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_reviewed TIMESTAMP,
    quality_history INTEGER[] DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, word_id)
);

-- User streaks and gamification stats
CREATE TABLE IF NOT EXISTS user_streaks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_activity DATE,
    total_xp INTEGER DEFAULT 0,
    words_learned INTEGER DEFAULT 0,
    reviews_today INTEGER DEFAULT 0,
    daily_goal INTEGER DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_vocab_words_category ON vocabulary_words(category_id);
CREATE INDEX IF NOT EXISTS idx_vocab_words_difficulty ON vocabulary_words(difficulty);
CREATE INDEX IF NOT EXISTS idx_user_vocab_user ON user_vocabulary(user_id);
CREATE INDEX IF NOT EXISTS idx_user_vocab_next_review ON user_vocabulary(next_review);
CREATE INDEX IF NOT EXISTS idx_user_vocab_user_next ON user_vocabulary(user_id, next_review);
CREATE INDEX IF NOT EXISTS idx_user_streaks_user ON user_streaks(user_id);

-- Insert sample vocabulary categories
INSERT INTO vocabulary_categories (name_fa, name_en, description_fa, description_en, icon) VALUES
('لغات ضروری کنکور', 'Essential Konkur Words', 'لغات پرتکرار در آزمون‌های کنکور', 'Frequently used words in Konkur exams', 'book'),
('لغات آکادمیک', 'Academic Words', 'لغات آکادمیک برای متون دانشگاهی', 'Academic words for university texts', 'graduation-cap'),
('لغات روزمره', 'Everyday Words', 'لغات کاربردی روزمره', 'Practical everyday vocabulary', 'chat');

-- Insert sample vocabulary words
INSERT INTO vocabulary_words (category_id, word_en, meaning_fa, pronunciation, example_en, example_fa, difficulty) VALUES
(1, 'abandon', 'ترک کردن، رها کردن', '/əˈbændən/', 'He decided to abandon the project.', 'او تصمیم گرفت پروژه را رها کند.', 2),
(1, 'ability', 'توانایی، قابلیت', '/əˈbɪləti/', 'She has the ability to solve complex problems.', 'او توانایی حل مسائل پیچیده را دارد.', 1),
(1, 'abstract', 'انتزاعی، مجرد', '/ˈæbstrækt/', 'Abstract art is hard to understand.', 'هنر انتزاعی سخت قابل درک است.', 3),
(1, 'abundant', 'فراوان، زیاد', '/əˈbʌndənt/', 'The forest has abundant wildlife.', 'جنگل حیات وحش فراوانی دارد.', 2),
(1, 'accomplish', 'به انجام رساندن، موفق شدن', '/əˈkɑːmplɪʃ/', 'She accomplished all her goals.', 'او به تمام اهدافش رسید.', 2),
(1, 'accurate', 'دقیق، صحیح', '/ˈækjərət/', 'The data must be accurate.', 'داده‌ها باید دقیق باشند.', 2),
(1, 'achieve', 'دست یافتن، رسیدن', '/əˈtʃiːv/', 'Work hard to achieve success.', 'سخت کار کن تا به موفقیت برسی.', 1),
(1, 'acknowledge', 'تصدیق کردن، پذیرفتن', '/əkˈnɒlɪdʒ/', 'He acknowledged his mistake.', 'او اشتباهش را پذیرفت.', 3),
(1, 'acquire', 'به دست آوردن، کسب کردن', '/əˈkwaɪər/', 'She acquired new skills.', 'او مهارت‌های جدیدی کسب کرد.', 2),
(1, 'adapt', 'سازگار شدن، تطبیق دادن', '/əˈdæpt/', 'Animals adapt to their environment.', 'حیوانات با محیط خود سازگار می‌شوند.', 2),
(2, 'analyze', 'تجزیه و تحلیل کردن', '/ˈænəlaɪz/', 'Scientists analyze the data carefully.', 'دانشمندان داده‌ها را با دقت تجزیه و تحلیل می‌کنند.', 2),
(2, 'approach', 'رویکرد، نزدیک شدن', '/əˈproʊtʃ/', 'We need a new approach to this problem.', 'ما به رویکرد جدیدی برای این مسئله نیاز داریم.', 2),
(2, 'assume', 'فرض کردن، گمان کردن', '/əˈsuːm/', 'Don''t assume anything without evidence.', 'بدون مدرک چیزی را فرض نکن.', 2),
(2, 'benefit', 'سود، فایده', '/ˈbenɪfɪt/', 'Exercise has many health benefits.', 'ورزش فواید سلامتی زیادی دارد.', 1),
(2, 'concept', 'مفهوم، ایده', '/ˈkɒnsept/', 'The concept is difficult to grasp.', 'درک این مفهوم دشوار است.', 2),
(3, 'appreciate', 'قدردانی کردن', '/əˈpriːʃieɪt/', 'I appreciate your help.', 'از کمکت قدردانی می‌کنم.', 1),
(3, 'convenient', 'راحت، مناسب', '/kənˈviːniənt/', 'The location is very convenient.', 'موقعیت مکانی بسیار مناسب است.', 2),
(3, 'essential', 'ضروری، اساسی', '/ɪˈsenʃəl/', 'Water is essential for life.', 'آب برای زندگی ضروری است.', 2),
(3, 'familiar', 'آشنا', '/fəˈmɪliər/', 'This place looks familiar.', 'این مکان آشنا به نظر می‌رسد.', 1),
(3, 'significant', 'مهم، قابل توجه', '/sɪɡˈnɪfɪkənt/', 'This is a significant achievement.', 'این یک دستاورد مهم است.', 2);
