-- Migration: 013_add_client_id_and_vocabulary
-- Description: Add client_id to users table for cookie-based identification + IELTS 7 vocabulary
-- Date: 2026-01-11

-- Add client_id column to users table (nullable for existing users)
ALTER TABLE users ADD COLUMN IF NOT EXISTS client_id VARCHAR(100) UNIQUE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Make email nullable for cookie-based users
ALTER TABLE users ALTER COLUMN email DROP NOT NULL;
ALTER TABLE users ALTER COLUMN name DROP NOT NULL;
ALTER TABLE users ALTER COLUMN password_hash DROP NOT NULL;

CREATE INDEX IF NOT EXISTS idx_users_client_id ON users(client_id);

-- Add IELTS 7 vocabulary category
INSERT INTO vocabulary_categories (uuid, name_fa, name_en, description_fa, description_en, icon)
VALUES (gen_random_uuid(), 'آیلتس سطح ۷', 'IELTS Band 7', 'لغات پیشرفته برای نمره آیلتس ۷', 'Advanced vocabulary for IELTS Band 7', '🎯')
ON CONFLICT DO NOTHING;

-- Add IELTS 7 vocabulary words
DO $$
DECLARE
    cat_id INTEGER;
BEGIN
    SELECT id INTO cat_id FROM vocabulary_categories WHERE name_en = 'IELTS Band 7';

    -- Insert IELTS 7 vocabulary words
    INSERT INTO vocabulary_words (uuid, category_id, word_en, meaning_fa, pronunciation, example_en, example_fa, difficulty) VALUES
    (gen_random_uuid(), cat_id, 'paved', 'سنگفرش شده، آسفالت شده', '/peɪvd/', 'The road was newly paved.', 'جاده تازه آسفالت شده بود.', 3),
    (gen_random_uuid(), cat_id, 'robust', 'قوی، محکم، مقاوم', '/roʊˈbʌst/', 'A robust economy can withstand crises.', 'یک اقتصاد قوی می‌تواند در برابر بحران‌ها مقاومت کند.', 3),
    (gen_random_uuid(), cat_id, 'influential', 'تأثیرگذار، بانفوذ', '/ˌɪnfluˈenʃəl/', 'She is one of the most influential leaders.', 'او یکی از تأثیرگذارترین رهبران است.', 3),
    (gen_random_uuid(), cat_id, 'fidelity', 'وفاداری، صداقت', '/fɪˈdeləti/', 'The fidelity of the translation was impressive.', 'وفاداری ترجمه قابل توجه بود.', 4),
    (gen_random_uuid(), cat_id, 'delicate', 'ظریف، حساس', '/ˈdelɪkət/', 'The situation requires delicate handling.', 'این وضعیت نیاز به رسیدگی حساس دارد.', 3),
    (gen_random_uuid(), cat_id, 'amplitude', 'دامنه، وسعت', '/ˈæmplɪtuːd/', 'The amplitude of the wave determines its energy.', 'دامنه موج انرژی آن را تعیین می‌کند.', 4),
    (gen_random_uuid(), cat_id, 'exquisitely', 'به طرز زیبایی، بی‌نظیر', '/ɪkˈskwɪzɪtli/', 'The dish was exquisitely prepared.', 'غذا به طرز بی‌نظیری آماده شده بود.', 4),
    (gen_random_uuid(), cat_id, 'implicit', 'ضمنی، مستتر', '/ɪmˈplɪsɪt/', 'There was an implicit understanding between them.', 'یک درک ضمنی بین آنها وجود داشت.', 3),
    (gen_random_uuid(), cat_id, 'optimism', 'خوش‌بینی', '/ˈɑːptɪmɪzəm/', 'Despite the challenges, she maintained her optimism.', 'علی‌رغم چالش‌ها، او خوش‌بینی خود را حفظ کرد.', 2),
    (gen_random_uuid(), cat_id, 'rhetorical', 'بلاغی، سخنورانه', '/rɪˈtɔːrɪkəl/', 'It was a rhetorical question.', 'این یک سوال بلاغی بود.', 4),
    (gen_random_uuid(), cat_id, 'conservative', 'محافظه‌کار، سنتی', '/kənˈsɜːrvətɪv/', 'The bank took a conservative approach.', 'بانک رویکرد محافظه‌کارانه‌ای اتخاذ کرد.', 3),
    (gen_random_uuid(), cat_id, 'skim', 'سرسری خواندن، بررسی سریع', '/skɪm/', 'I only had time to skim the report.', 'فقط وقت داشتم گزارش را سرسری بخوانم.', 2),
    (gen_random_uuid(), cat_id, 'inference', 'استنباط، نتیجه‌گیری', '/ˈɪnfərəns/', 'Based on the data, we can draw an inference.', 'بر اساس داده‌ها، می‌توانیم استنباط کنیم.', 3),
    (gen_random_uuid(), cat_id, 'coined', 'ابداع شده، ساخته شده', '/kɔɪnd/', 'The term was coined in the 19th century.', 'این اصطلاح در قرن نوزدهم ابداع شد.', 3),
    (gen_random_uuid(), cat_id, 'foresee', 'پیش‌بینی کردن', '/fɔːrˈsiː/', 'No one could foresee the outcome.', 'هیچ‌کس نمی‌توانست نتیجه را پیش‌بینی کند.', 3),
    (gen_random_uuid(), cat_id, 'intellect', 'هوش، خرد', '/ˈɪntəlekt/', 'Her intellect is truly remarkable.', 'هوش او واقعاً قابل توجه است.', 3),
    (gen_random_uuid(), cat_id, 'emergence', 'ظهور، پیدایش', '/ɪˈmɜːrdʒəns/', 'The emergence of new technology changed everything.', 'ظهور فناوری جدید همه چیز را تغییر داد.', 3),
    (gen_random_uuid(), cat_id, 'ameliorate', 'بهبود بخشیدن', '/əˈmiːliəreɪt/', 'Efforts to ameliorate the situation were underway.', 'تلاش‌ها برای بهبود وضعیت در جریان بود.', 5),
    (gen_random_uuid(), cat_id, 'deteriorate', 'بدتر شدن، زوال یافتن', '/dɪˈtɪriəreɪt/', 'His health began to deteriorate rapidly.', 'سلامتی او به سرعت شروع به زوال کرد.', 4),
    (gen_random_uuid(), cat_id, 'solemnize', 'رسمی برگزار کردن', '/ˈsɑːləmnaɪz/', 'The marriage was solemnized in a church.', 'ازدواج در کلیسا رسمی برگزار شد.', 5),
    (gen_random_uuid(), cat_id, 'petrify', 'متحیر کردن، سنگ کردن', '/ˈpetrɪfaɪ/', 'The news seemed to petrify everyone.', 'به نظر می‌رسید این خبر همه را متحیر کرد.', 4),
    (gen_random_uuid(), cat_id, 'restraint', 'خویشتن‌داری، محدودیت', '/rɪˈstreɪnt/', 'He showed remarkable restraint in the situation.', 'او در این وضعیت خویشتن‌داری قابل توجهی نشان داد.', 3),
    (gen_random_uuid(), cat_id, 'quarrel', 'دعوا، نزاع', '/ˈkwɔːrəl/', 'They had a quarrel over money.', 'آنها بر سر پول دعوا کردند.', 2),
    (gen_random_uuid(), cat_id, 'prevail', 'غالب شدن، پیروز شدن', '/prɪˈveɪl/', 'Justice will prevail in the end.', 'در نهایت عدالت پیروز خواهد شد.', 3),
    (gen_random_uuid(), cat_id, 'auspicious', 'خوش‌یمن، فرخنده', '/ɔːˈspɪʃəs/', 'It was an auspicious start to the year.', 'این شروع خوش‌یمنی برای سال بود.', 4),
    (gen_random_uuid(), cat_id, 'stirring', 'هیجان‌انگیز، تحریک‌کننده', '/ˈstɜːrɪŋ/', 'The speech was stirring and memorable.', 'سخنرانی هیجان‌انگیز و به یاد ماندنی بود.', 3),
    (gen_random_uuid(), cat_id, 'edifying', 'آموزنده، روشنگر', '/ˈedɪfaɪɪŋ/', 'It was an edifying experience.', 'این یک تجربه آموزنده بود.', 4),
    (gen_random_uuid(), cat_id, 'feeble', 'ضعیف، ناتوان', '/ˈfiːbl/', 'His feeble attempt at humor fell flat.', 'تلاش ضعیف او برای شوخی بی‌اثر بود.', 3),
    (gen_random_uuid(), cat_id, 'divest', 'محروم کردن، سلب کردن', '/daɪˈvest/', 'The company decided to divest its assets.', 'شرکت تصمیم گرفت دارایی‌هایش را واگذار کند.', 5),
    (gen_random_uuid(), cat_id, 'foster', 'پرورش دادن، تقویت کردن', '/ˈfɔːstər/', 'The program aims to foster creativity.', 'این برنامه هدفش پرورش خلاقیت است.', 3),
    (gen_random_uuid(), cat_id, 'deception', 'فریب، دغل', '/dɪˈsepʃn/', 'The deception was eventually uncovered.', 'در نهایت فریب آشکار شد.', 3),
    (gen_random_uuid(), cat_id, 'animosity', 'دشمنی، خصومت', '/ˌænɪˈmɑːsəti/', 'There was no animosity between them.', 'هیچ دشمنی بین آنها وجود نداشت.', 4),
    (gen_random_uuid(), cat_id, 'idyllic', 'آرام، رویایی', '/aɪˈdɪlɪk/', 'They lived in an idyllic countryside cottage.', 'آنها در کلبه‌ای رویایی در حومه شهر زندگی می‌کردند.', 4)
    ON CONFLICT DO NOTHING;
END $$;
