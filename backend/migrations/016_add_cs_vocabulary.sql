-- Migration: 016_add_cs_vocabulary
-- Description: Add Computer Engineering vocabulary words
-- Date: 2026-01-12

DO $$
DECLARE
    cat_id INTEGER;
BEGIN
    -- Create CS category if not exists
    SELECT id INTO cat_id FROM vocabulary_categories WHERE name_en = 'Computer Engineering';

    IF cat_id IS NULL THEN
        INSERT INTO vocabulary_categories (uuid, name_fa, name_en, description_fa, description_en, icon)
        VALUES (gen_random_uuid(), 'مهندسی کامپیوتر', 'Computer Engineering', 'اصطلاحات تخصصی مهندسی کامپیوتر', 'Computer Engineering terminology', '💻')
        RETURNING id INTO cat_id;
    END IF;

    -- Insert CS vocabulary words
    INSERT INTO vocabulary_words (uuid, category_id, word_en, meaning_fa, pronunciation, example_en, example_fa, difficulty)
    VALUES
        (gen_random_uuid(), cat_id, 'glitter', 'درخشیدن، زرق و برق', '/ˈɡlɪtər/', 'The new UI design glitters with modern effects.', 'طراحی رابط کاربری جدید با جلوه‌های مدرن می‌درخشد.', 2),
        (gen_random_uuid(), cat_id, 'luster', 'درخشندگی، جلا', '/ˈlʌstər/', 'The code lost its luster after poor refactoring.', 'کد پس از بازسازی ضعیف درخشندگی خود را از دست داد.', 3),
        (gen_random_uuid(), cat_id, 'conspicuous', 'آشکار، بارز، مشهود', '/kənˈspɪkjuəs/', 'The bug was conspicuous in the error logs.', 'باگ در لاگ‌های خطا کاملاً مشهود بود.', 3),
        (gen_random_uuid(), cat_id, 'conferred', 'اعطا کردن، مشورت کردن', '/kənˈfɜːrd/', 'The degree was conferred upon completion of the thesis.', 'مدرک پس از اتمام پایان‌نامه اعطا شد.', 3),
        (gen_random_uuid(), cat_id, 'equivocated', 'مبهم صحبت کردن، طفره رفتن', '/ɪˈkwɪvəkeɪtɪd/', 'The documentation equivocated on the API behavior.', 'مستندات در مورد رفتار API مبهم بود.', 4),
        (gen_random_uuid(), cat_id, 'attained', 'دست یافتن، رسیدن به', '/əˈteɪnd/', 'The algorithm attained optimal performance.', 'الگوریتم به عملکرد بهینه دست یافت.', 2),
        (gen_random_uuid(), cat_id, 'fabricated', 'ساختگی، جعلی، ساخته شده', '/ˈfæbrɪkeɪtɪd/', 'The test data was fabricated for simulation.', 'داده‌های تست برای شبیه‌سازی ساخته شدند.', 2),
        (gen_random_uuid(), cat_id, 'compulsory', 'اجباری، الزامی', '/kəmˈpʌlsəri/', 'Error handling is compulsory in production code.', 'مدیریت خطا در کد تولید الزامی است.', 2),
        (gen_random_uuid(), cat_id, 'tuition', 'شهریه، آموزش', '/tjuːˈɪʃən/', 'Online tuition for programming has increased.', 'آموزش آنلاین برنامه‌نویسی افزایش یافته است.', 2),
        (gen_random_uuid(), cat_id, 'offspring', 'فرزند، نتیجه، محصول', '/ˈɒfsprɪŋ/', 'Child processes are offspring of the parent process.', 'پردازه‌های فرزند محصول پردازه والد هستند.', 3),
        (gen_random_uuid(), cat_id, 'debate', 'بحث، مناظره', '/dɪˈbeɪt/', 'There is ongoing debate about microservices vs monolith.', 'بحث مداومی درباره میکروسرویس‌ها در برابر مونولیت وجود دارد.', 1),
        (gen_random_uuid(), cat_id, 'esoteric', 'پیچیده، تخصصی، مبهم', '/ˌesəˈterɪk/', 'The kernel code contains esoteric optimizations.', 'کد کرنل شامل بهینه‌سازی‌های تخصصی و پیچیده است.', 4),
        (gen_random_uuid(), cat_id, 'unanimous', 'متفق‌القول، یکپارچه', '/juːˈnænɪməs/', 'The team was unanimous in choosing React.', 'تیم در انتخاب React متفق‌القول بود.', 3),
        (gen_random_uuid(), cat_id, 'pervasive', 'فراگیر، همه‌جاگیر', '/pərˈveɪsɪv/', 'Cloud computing has become pervasive in enterprises.', 'رایانش ابری در شرکت‌ها فراگیر شده است.', 3),
        (gen_random_uuid(), cat_id, 'iteration', 'تکرار، دور (در حلقه)', '/ˌɪtəˈreɪʃən/', 'Each iteration of the loop processes one element.', 'هر تکرار حلقه یک عنصر را پردازش می‌کند.', 2),
        (gen_random_uuid(), cat_id, 'iteration bug', 'باگ تکرار (خطای حلقه)', '/ˌɪtəˈreɪʃən bʌɡ/', 'Off-by-one is a common iteration bug.', 'خطای یک واحد کم یا زیاد یک باگ تکرار رایج است.', 3),
        (gen_random_uuid(), cat_id, 'possessed', 'دارا بودن، در اختیار داشتن', '/pəˈzest/', 'The object possessed all required attributes.', 'شیء تمام ویژگی‌های مورد نیاز را دارا بود.', 2),
        (gen_random_uuid(), cat_id, 'anomalies', 'ناهنجاری‌ها، موارد غیرعادی', '/əˈnɒməliz/', 'The system detected anomalies in network traffic.', 'سیستم ناهنجاری‌هایی در ترافیک شبکه شناسایی کرد.', 3),
        (gen_random_uuid(), cat_id, 'arise', 'بروز کردن، پدید آمدن', '/əˈraɪz/', 'Race conditions arise in concurrent programming.', 'شرایط رقابتی در برنامه‌نویسی همزمان بروز می‌کند.', 2),
        (gen_random_uuid(), cat_id, 'prevalent', 'رایج، شایع، غالب', '/ˈprevələnt/', 'SQL injection is still prevalent in web apps.', 'تزریق SQL هنوز در برنامه‌های وب رایج است.', 3),
        (gen_random_uuid(), cat_id, 'perilous', 'خطرناک، پرمخاطره', '/ˈperələs/', 'Deploying without tests is perilous.', 'استقرار بدون تست خطرناک است.', 3),
        (gen_random_uuid(), cat_id, 'distinct', 'متمایز، مجزا، واضح', '/dɪˈstɪŋkt/', 'Each microservice has a distinct responsibility.', 'هر میکروسرویس مسئولیت متمایزی دارد.', 2),
        (gen_random_uuid(), cat_id, 'dominated', 'تسلط داشتن، غالب بودن', '/ˈdɒmɪneɪtɪd/', 'Python dominated the data science field.', 'پایتون بر حوزه علم داده تسلط یافت.', 2),
        (gen_random_uuid(), cat_id, 'solidly', 'محکم، استوار، به طور قوی', '/ˈsɒlɪdli/', 'The architecture is solidly designed.', 'معماری به طور محکم طراحی شده است.', 2),
        (gen_random_uuid(), cat_id, 'associates', 'همکاران، شرکا', '/əˈsəʊʃieɪts/', 'Research associates contributed to the paper.', 'همکاران تحقیقاتی در مقاله مشارکت کردند.', 2),
        (gen_random_uuid(), cat_id, 'pioneering', 'پیشگامانه، نوآورانه', '/ˌpaɪəˈnɪərɪŋ/', 'Google did pioneering work in distributed systems.', 'گوگل کار پیشگامانه‌ای در سیستم‌های توزیع‌شده انجام داد.', 3),
        (gen_random_uuid(), cat_id, 'firm', 'شرکت، محکم، قاطع', '/fɜːrm/', 'The tech firm developed innovative solutions.', 'شرکت فناوری راه‌حل‌های نوآورانه توسعه داد.', 1),
        (gen_random_uuid(), cat_id, 'gleaned', 'جمع‌آوری کردن، استخراج کردن', '/ɡliːnd/', 'Insights were gleaned from the log analysis.', 'بینش‌ها از تحلیل لاگ استخراج شدند.', 3)
    ON CONFLICT DO NOTHING;
END $$;
