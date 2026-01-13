-- Migration: 017_add_academic_vocabulary
-- Description: Add academic/linguistic vocabulary words
-- Date: 2026-01-13

DO $$
DECLARE
    cat_id INTEGER;
BEGIN
    -- Use Academic Words category
    SELECT id INTO cat_id FROM vocabulary_categories WHERE name_en = 'Academic Words';

    IF cat_id IS NULL THEN
        INSERT INTO vocabulary_categories (uuid, name_fa, name_en, description_fa, description_en, icon)
        VALUES (gen_random_uuid(), 'لغات آکادمیک', 'Academic Words', 'لغات تخصصی دانشگاهی', 'Academic vocabulary', '🎓')
        RETURNING id INTO cat_id;
    END IF;

    -- Insert academic vocabulary words
    INSERT INTO vocabulary_words (uuid, category_id, word_en, meaning_fa, pronunciation, example_en, example_fa, difficulty)
    VALUES
        (gen_random_uuid(), cat_id, 'insure', 'بیمه کردن، تضمین کردن', '/ɪnˈʃʊr/', 'We must insure the shipment against damage.', 'باید محموله را در برابر آسیب بیمه کنیم.', 2),
        (gen_random_uuid(), cat_id, 'projections', 'پیش‌بینی‌ها، تخمین‌ها', '/prəˈdʒekʃənz/', 'Sales projections for next year are optimistic.', 'پیش‌بینی‌های فروش برای سال آینده خوش‌بینانه است.', 3),
        (gen_random_uuid(), cat_id, 'inclinations', 'تمایلات، گرایش‌ها', '/ˌɪnklɪˈneɪʃənz/', 'He has strong inclinations toward research.', 'او تمایل شدیدی به تحقیق دارد.', 3),
        (gen_random_uuid(), cat_id, 'interventions', 'مداخلات، دخالت‌ها', '/ˌɪntərˈvenʃənz/', 'Medical interventions saved many lives.', 'مداخلات پزشکی جان بسیاری را نجات داد.', 3),
        (gen_random_uuid(), cat_id, 'premises', 'مفروضات، محل', '/ˈpremɪsɪz/', 'The argument is based on false premises.', 'این استدلال بر مفروضات غلط استوار است.', 3),
        (gen_random_uuid(), cat_id, 'exonerated', 'تبرئه شده، مبرا', '/ɪɡˈzɒnəreɪtɪd/', 'The defendant was exonerated of all charges.', 'متهم از تمام اتهامات تبرئه شد.', 4),
        (gen_random_uuid(), cat_id, 'intensified', 'تشدید شده، شدت یافته', '/ɪnˈtensɪfaɪd/', 'The conflict intensified over time.', 'درگیری با گذشت زمان تشدید شد.', 2),
        (gen_random_uuid(), cat_id, 'prosecuted', 'تحت پیگرد قرار گرفته', '/ˈprɒsɪkjuːtɪd/', 'He was prosecuted for fraud.', 'او به اتهام کلاهبرداری تحت پیگرد قرار گرفت.', 3),
        (gen_random_uuid(), cat_id, 'legitimized', 'مشروعیت بخشیده، قانونی شده', '/lɪˈdʒɪtɪmaɪzd/', 'The election legitimized the new government.', 'انتخابات به دولت جدید مشروعیت بخشید.', 4),
        (gen_random_uuid(), cat_id, 'inflammatory', 'تحریک‌آمیز، التهابی', '/ɪnˈflæmətəri/', 'His inflammatory speech caused riots.', 'سخنرانی تحریک‌آمیز او باعث شورش شد.', 3),
        (gen_random_uuid(), cat_id, 'exacerbating', 'تشدیدکننده، بدتر کننده', '/ɪɡˈzæsərbeɪtɪŋ/', 'Pollution is exacerbating health problems.', 'آلودگی مشکلات سلامتی را تشدید می‌کند.', 4),
        (gen_random_uuid(), cat_id, 'dispelling', 'از بین بردن، رفع کردن', '/dɪˈspelɪŋ/', 'The evidence succeeded in dispelling doubts.', 'شواهد در رفع تردیدها موفق شد.', 3),
        (gen_random_uuid(), cat_id, 'affirming', 'تأیید کردن، اثبات کردن', '/əˈfɜːrmɪŋ/', 'The court ruling is affirming our position.', 'حکم دادگاه موضع ما را تأیید می‌کند.', 2),
        (gen_random_uuid(), cat_id, 'captivated', 'مجذوب، شیفته', '/ˈkæptɪveɪtɪd/', 'The audience was captivated by her performance.', 'تماشاگران مجذوب اجرای او شدند.', 2),
        (gen_random_uuid(), cat_id, 'superseded', 'جایگزین شده، منسوخ', '/ˌsuːpərˈsiːdɪd/', 'The old law was superseded by new regulations.', 'قانون قدیمی با مقررات جدید جایگزین شد.', 4),
        (gen_random_uuid(), cat_id, 'commenced', 'آغاز شده، شروع شده', '/kəˈmenst/', 'The trial commenced last Monday.', 'محاکمه دوشنبه گذشته آغاز شد.', 2),
        (gen_random_uuid(), cat_id, 'aesthetic', 'زیبایی‌شناختی، هنری', '/esˈθetɪk/', 'The building has great aesthetic value.', 'این ساختمان ارزش زیبایی‌شناختی بالایی دارد.', 3),
        (gen_random_uuid(), cat_id, 'unforeseen', 'پیش‌بینی نشده، غیرمنتظره', '/ˌʌnfɔːrˈsiːn/', 'Unforeseen circumstances delayed the project.', 'شرایط پیش‌بینی نشده پروژه را به تأخیر انداخت.', 2),
        (gen_random_uuid(), cat_id, 'altruistic', 'نوع‌دوستانه، فداکارانه', '/ˌæltruˈɪstɪk/', 'Her motives were purely altruistic.', 'انگیزه‌های او کاملاً نوع‌دوستانه بود.', 4),
        (gen_random_uuid(), cat_id, 'incipient', 'نوپا، در مراحل اولیه', '/ɪnˈsɪpiənt/', 'We detected the incipient signs of disease.', 'ما نشانه‌های اولیه بیماری را تشخیص دادیم.', 5),
        (gen_random_uuid(), cat_id, 'skeptical', 'شکاک، مشکوک', '/ˈskeptɪkəl/', 'Scientists remain skeptical about the claims.', 'دانشمندان نسبت به این ادعاها شکاک هستند.', 2),
        (gen_random_uuid(), cat_id, 'ambiguous', 'مبهم، دوپهلو', '/æmˈbɪɡjuəs/', 'The contract language is ambiguous.', 'زبان قرارداد مبهم است.', 3),
        (gen_random_uuid(), cat_id, 'credible', 'معتبر، قابل باور', '/ˈkredɪbəl/', 'She is a credible witness.', 'او شاهد معتبری است.', 2),
        (gen_random_uuid(), cat_id, 'disorderly', 'بی‌نظم، آشفته', '/dɪsˈɔːrdərli/', 'The protest became disorderly.', 'اعتراض آشفته شد.', 2),
        (gen_random_uuid(), cat_id, 'apparent', 'آشکار، ظاهری', '/əˈpærənt/', 'The cause of failure is apparent.', 'علت شکست آشکار است.', 2),
        (gen_random_uuid(), cat_id, 'comprehension', 'درک، فهم', '/ˌkɒmprɪˈhenʃən/', 'Reading comprehension is a key skill.', 'درک مطلب یک مهارت کلیدی است.', 2),
        (gen_random_uuid(), cat_id, 'misspellings', 'غلط‌های املایی', '/ˌmɪsˈspelɪŋz/', 'The essay contained many misspellings.', 'مقاله شامل غلط‌های املایی زیادی بود.', 2),
        (gen_random_uuid(), cat_id, 'morphological', 'ریخت‌شناختی، صرفی', '/ˌmɔːrfəˈlɒdʒɪkəl/', 'Morphological analysis reveals word structure.', 'تحلیل ریخت‌شناختی ساختار کلمه را نشان می‌دهد.', 4),
        (gen_random_uuid(), cat_id, 'lexicon', 'واژگان، لغت‌نامه', '/ˈleksɪkɒn/', 'The lexicon of medicine is vast.', 'واژگان پزشکی بسیار گسترده است.', 3),
        (gen_random_uuid(), cat_id, 'consecutive', 'متوالی، پشت سر هم', '/kənˈsekjʊtɪv/', 'He won three consecutive matches.', 'او سه مسابقه متوالی را برد.', 2),
        (gen_random_uuid(), cat_id, 'orthographical', 'املایی، نگارشی', '/ˌɔːrθəˈɡræfɪkəl/', 'Orthographical rules vary by language.', 'قواعد املایی در هر زبان متفاوت است.', 4),
        (gen_random_uuid(), cat_id, 'hence', 'از این رو، بنابراین', '/hens/', 'He was tired, hence the mistakes.', 'او خسته بود، از این رو اشتباهات رخ داد.', 2),
        (gen_random_uuid(), cat_id, 'derivative', 'مشتق، اقتباسی', '/dɪˈrɪvətɪv/', 'This word is a derivative of Latin.', 'این کلمه مشتق از لاتین است.', 3),
        (gen_random_uuid(), cat_id, 'stem', 'ریشه، ساقه', '/stem/', 'The stem of the word reveals its origin.', 'ریشه کلمه منشأ آن را نشان می‌دهد.', 2),
        (gen_random_uuid(), cat_id, 'concatenated', 'الحاق شده، به هم پیوسته', '/kənˈkætəneɪtɪd/', 'The strings were concatenated into one.', 'رشته‌ها به یکدیگر الحاق شدند.', 4),
        (gen_random_uuid(), cat_id, 'plenty', 'فراوان، زیاد', '/ˈplenti/', 'There is plenty of time left.', 'زمان زیادی باقی مانده است.', 1),
        (gen_random_uuid(), cat_id, 'stated', 'بیان شده، اظهار شده', '/steɪtɪd/', 'As stated earlier, the deadline is Friday.', 'همانطور که قبلاً بیان شد، مهلت جمعه است.', 1),
        (gen_random_uuid(), cat_id, 'distorted', 'تحریف شده، مخدوش', '/dɪˈstɔːrtɪd/', 'The media distorted the facts.', 'رسانه‌ها حقایق را تحریف کردند.', 2),
        (gen_random_uuid(), cat_id, 'expenditure', 'هزینه، مخارج', '/ɪkˈspendɪtʃər/', 'Government expenditure has increased.', 'هزینه‌های دولت افزایش یافته است.', 3),
        (gen_random_uuid(), cat_id, 'twofold', 'دوگانه، دو برابر', '/ˈtuːfəʊld/', 'The benefits are twofold.', 'مزایا دوگانه است.', 2),
        (gen_random_uuid(), cat_id, 'perception', 'درک، ادراک', '/pərˈsepʃən/', 'Public perception of the issue changed.', 'درک عمومی از این موضوع تغییر کرد.', 2),
        (gen_random_uuid(), cat_id, 'disciplinary', 'انضباطی، تنبیهی', '/ˈdɪsəplɪnəri/', 'He faced disciplinary action.', 'او با اقدام انضباطی مواجه شد.', 3),
        (gen_random_uuid(), cat_id, 'linguistics', 'زبان‌شناسی', '/lɪŋˈɡwɪstɪks/', 'She studied linguistics at university.', 'او در دانشگاه زبان‌شناسی خواند.', 3),
        (gen_random_uuid(), cat_id, 'granted', 'اعطا شده، مسلم', '/ˈɡræntɪd/', 'Permission was granted immediately.', 'مجوز فوراً اعطا شد.', 2),
        (gen_random_uuid(), cat_id, 'inherent', 'ذاتی، درونی', '/ɪnˈhɪərənt/', 'There are inherent risks in surgery.', 'خطرات ذاتی در جراحی وجود دارد.', 3),
        (gen_random_uuid(), cat_id, 'implied', 'ضمنی، تلویحی', '/ɪmˈplaɪd/', 'The contract has implied obligations.', 'قرارداد تعهدات ضمنی دارد.', 2),
        (gen_random_uuid(), cat_id, 'yardstick', 'معیار، ملاک', '/ˈjɑːrdstɪk/', 'Profit is not the only yardstick of success.', 'سود تنها معیار موفقیت نیست.', 3),
        (gen_random_uuid(), cat_id, 'unprecedented', 'بی‌سابقه، بی‌نظیر', '/ʌnˈpresɪdentɪd/', 'The crisis reached an unprecedented scale.', 'بحران به مقیاسی بی‌سابقه رسید.', 3),
        (gen_random_uuid(), cat_id, 'weigh', 'سنجیدن، وزن کردن', '/weɪ/', 'We must weigh the pros and cons.', 'باید مزایا و معایب را بسنجیم.', 2)
    ON CONFLICT DO NOTHING;
END $$;
