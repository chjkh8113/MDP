-- Migration: 015_add_more_vocabulary
-- Description: Add more IELTS vocabulary words
-- Date: 2026-01-12

-- Get the IELTS category ID (assuming it exists)
DO $$
DECLARE
    cat_id INTEGER;
BEGIN
    SELECT id INTO cat_id FROM vocabulary_categories WHERE name_en = 'IELTS Band 7';

    IF cat_id IS NULL THEN
        INSERT INTO vocabulary_categories (uuid, name_fa, name_en, description_fa, description_en, icon)
        VALUES (gen_random_uuid(), 'آیلتس بند ۷', 'IELTS Band 7', 'لغات سطح پیشرفته آیلتس', 'Advanced IELTS vocabulary', '📚')
        RETURNING id INTO cat_id;
    END IF;

    -- Insert new vocabulary words (skip if already exists)
    INSERT INTO vocabulary_words (uuid, category_id, word_en, meaning_fa, pronunciation, example_en, example_fa, difficulty)
    VALUES
        (gen_random_uuid(), cat_id, 'sparked', 'جرقه زدن، برانگیختن', '/spɑːrkt/', 'The debate sparked a nationwide discussion.', 'این بحث یک گفتگوی سراسری را برانگیخت.', 2),
        (gen_random_uuid(), cat_id, 'serendipity', 'شانس، اتفاق خوش‌یمن', '/ˌserənˈdɪpəti/', 'Finding this job was pure serendipity.', 'پیدا کردن این شغل کاملاً شانسی بود.', 4),
        (gen_random_uuid(), cat_id, 'tranquility', 'آرامش، سکوت', '/træŋˈkwɪləti/', 'The tranquility of the countryside relaxed me.', 'آرامش روستا مرا آرام کرد.', 3),
        (gen_random_uuid(), cat_id, 'aspersion', 'تهمت، بدنامی', '/əˈspɜːrʒən/', 'He cast aspersions on her character.', 'او به شخصیت او تهمت زد.', 5),
        (gen_random_uuid(), cat_id, 'euphoria', 'سرخوشی، شادمانی شدید', '/juːˈfɔːriə/', 'The team felt euphoria after winning.', 'تیم بعد از برد احساس سرخوشی کرد.', 3),
        (gen_random_uuid(), cat_id, 'vigorous', 'پرانرژی، قوی', '/ˈvɪɡərəs/', 'She took a vigorous walk every morning.', 'او هر صبح پیاده‌روی پرانرژی داشت.', 2),
        (gen_random_uuid(), cat_id, 'reckless', 'بی‌پروا، بی‌احتیاط', '/ˈrekləs/', 'His reckless driving caused an accident.', 'رانندگی بی‌احتیاط او باعث تصادف شد.', 2),
        (gen_random_uuid(), cat_id, 'haphazard', 'بی‌نظم، تصادفی', '/hæpˈhæzərd/', 'The books were arranged in a haphazard manner.', 'کتاب‌ها به صورت بی‌نظم چیده شده بودند.', 4),
        (gen_random_uuid(), cat_id, 'tray', 'سینی', '/treɪ/', 'She carried the drinks on a tray.', 'او نوشیدنی‌ها را روی سینی حمل کرد.', 1),
        (gen_random_uuid(), cat_id, 'guise', 'ظاهر، لباس مبدل', '/ɡaɪz/', 'He appeared in the guise of a doctor.', 'او در لباس پزشک ظاهر شد.', 4),
        (gen_random_uuid(), cat_id, 'paramount', 'بسیار مهم، عالی‌ترین', '/ˈpærəmaʊnt/', 'Safety is of paramount importance.', 'ایمنی از اهمیت بسیار بالایی برخوردار است.', 3),
        (gen_random_uuid(), cat_id, 'eventually', 'سرانجام، در نهایت', '/ɪˈventʃuəli/', 'Eventually, he found what he was looking for.', 'سرانجام، او آنچه را که می‌خواست پیدا کرد.', 1),
        (gen_random_uuid(), cat_id, 'sentimentality', 'احساساتی بودن', '/ˌsentɪmenˈtæləti/', 'The movie was full of sentimentality.', 'فیلم پر از احساسات بود.', 4),
        (gen_random_uuid(), cat_id, 'dime', 'سکه ده سنتی', '/daɪm/', 'It costs only a dime.', 'فقط یک سکه ده سنتی هزینه دارد.', 2),
        (gen_random_uuid(), cat_id, 'contrary', 'برعکس، مخالف', '/ˈkɒntrəri/', 'Contrary to popular belief, it is false.', 'برخلاف باور عمومی، این غلط است.', 2),
        (gen_random_uuid(), cat_id, 'dispute', 'اختلاف، مناقشه', '/dɪˈspjuːt/', 'There was a dispute over the contract.', 'بر سر قرارداد اختلاف وجود داشت.', 2),
        (gen_random_uuid(), cat_id, 'withheld', 'خودداری کردن، نگه داشتن', '/wɪðˈheld/', 'Information was withheld from the public.', 'اطلاعات از عموم پنهان نگه داشته شد.', 3),
        (gen_random_uuid(), cat_id, 'legislative', 'قانون‌گذاری، مقننه', '/ˈledʒɪslətɪv/', 'The legislative branch makes laws.', 'قوه مقننه قوانین را وضع می‌کند.', 3),
        (gen_random_uuid(), cat_id, 'judicial', 'قضایی', '/dʒuːˈdɪʃəl/', 'The judicial system needs reform.', 'سیستم قضایی نیاز به اصلاح دارد.', 3),
        (gen_random_uuid(), cat_id, 'quarrel', 'دعوا، مشاجره', '/ˈkwɒrəl/', 'They had a quarrel over money.', 'آن‌ها بر سر پول دعوا کردند.', 2),
        (gen_random_uuid(), cat_id, 'roamed', 'پرسه زدن، گشتن', '/rəʊmd/', 'The children roamed the streets.', 'بچه‌ها در خیابان‌ها پرسه می‌زدند.', 2)
    ON CONFLICT DO NOTHING;
END $$;
