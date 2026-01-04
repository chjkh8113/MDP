-- Real Konkur Questions for ساختمان داده ها
-- Based on actual Konkur ارشد patterns from 1402-1403

-- Delete existing sample questions for course_id=1 to replace with real ones
DELETE FROM questions WHERE course_id = 1;

-- Question 1: Time Complexity - Code Analysis (کنکور ۱۴۰۲)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 1,
    'مرتبه زمانی قطعه کد زیر چیست؟

for (i = 1; i <= n; i++)
    for (j = 1; j <= n; j *= 2)
        sum++;',
    '["O(n)", "O(n log n)", "O(n²)", "O(n² log n)"]',
    1,
    'حلقه بیرونی n بار و حلقه درونی log n بار اجرا می‌شود. پس مرتبه کلی O(n log n) است.'
);

-- Question 2: Master Theorem (کنکور ۱۴۰۲)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 1,
    'رابطه بازگشتی T(n) = 4T(n/2) + n² چه مرتبه‌ای دارد؟',
    '["Θ(n²)", "Θ(n² log n)", "Θ(n³)", "Θ(n² log² n)"]',
    1,
    'با استفاده از قضیه اصلی: a=4, b=2, f(n)=n². داریم log₂4=2. چون f(n)=Θ(n^log_b(a)) پس T(n)=Θ(n² log n).'
);

-- Question 3: Heap Operations (کنکور ۱۴۰۳)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 4,
    'اگر آرایه‌ای با n عنصر داشته باشیم، ساختن یک max-heap از این آرایه با استفاده از روش heapify چه مرتبه زمانی دارد؟',
    '["O(n)", "O(n log n)", "O(log n)", "O(n²)"]',
    0,
    'ساختن heap با روش bottom-up heapify مرتبه O(n) دارد، نه O(n log n).'
);

-- Question 4: AVL Tree (کنکور ۱۴۰۲)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 4,
    'در یک درخت AVL با n گره، حداکثر تعداد چرخش‌های لازم برای درج یک کلید جدید چقدر است؟',
    '["1", "2", "log n", "n"]',
    1,
    'در درخت AVL برای درج یک گره جدید، حداکثر 2 چرخش (یک چرخش دوگانه) نیاز است.'
);

-- Question 5: Graph BFS (کنکور ۱۴۰۳)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 5,
    'الگوریتم BFS روی گراف G=(V,E) که با لیست مجاورت نمایش داده شده، چه پیچیدگی زمانی دارد؟',
    '["O(V)", "O(E)", "O(V + E)", "O(V × E)"]',
    2,
    'BFS هر رأس را یک بار و هر یال را حداکثر دو بار بررسی می‌کند. پس مرتبه O(V + E) است.'
);

-- Question 6: Graph DFS - Cycle Detection (کنکور ۱۴۰۲)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 5,
    'در گراف جهت‌دار G، الگوریتم DFS برای تشخیص وجود دور چه نوع یالی را بررسی می‌کند؟',
    '["یال درختی (Tree Edge)", "یال برگشتی (Back Edge)", "یال پیشرو (Forward Edge)", "یال عرضی (Cross Edge)"]',
    1,
    'وجود یال برگشتی (Back Edge) در DFS نشان‌دهنده وجود دور در گراف جهت‌دار است.'
);

-- Question 7: Sorting - QuickSort (کنکور ۱۴۰۳)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 6,
    'میانگین پیچیدگی زمانی الگوریتم QuickSort چیست و در چه شرایطی رخ می‌دهد؟',
    '["O(n log n) - وقتی pivot همیشه میانه باشد", "O(n²) - وقتی داده‌ها تصادفی باشند", "O(n log n) - وقتی pivot تصادفی انتخاب شود", "O(n) - وقتی داده‌ها مرتب باشند"]',
    2,
    'با انتخاب تصادفی pivot، میانگین پیچیدگی O(n log n) است.'
);

-- Question 8: Sorting - Stability (کنکور ۱۴۰۲)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 6,
    'کدام یک از الگوریتم‌های مرتب‌سازی زیر پایدار (Stable) نیست؟',
    '["Merge Sort", "Insertion Sort", "Heap Sort", "Bubble Sort"]',
    2,
    'Heap Sort پایدار نیست زیرا در فرآیند heapify ممکن است ترتیب عناصر برابر تغییر کند.'
);

-- Question 9: Hash Table (کنکور ۱۴۰۳)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 8,
    'در جدول درهم‌سازی با زنجیره‌سازی (Chaining)، اگر n کلید در جدولی با m خانه ذخیره شود، میانگین طول هر زنجیره چقدر است؟',
    '["n/m", "m/n", "n×m", "log(n/m)"]',
    0,
    'میانگین طول زنجیره برابر با ضریب بارگذاری α = n/m است.'
);

-- Question 10: Binary Search Tree (کنکور ۱۴۰۲)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 4,
    'در یک درخت جستجوی دودویی با n گره، پیچیدگی زمانی جستجو در بدترین حالت چیست؟',
    '["O(1)", "O(log n)", "O(n)", "O(n log n)"]',
    2,
    'بدترین حالت وقتی است که درخت کاملاً نامتوازن باشد (مانند یک لیست پیوندی) که O(n) می‌شود.'
);

-- Question 11: Recurrence Relation (کنکور ۱۴۰۳)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 1,
    'رابطه بازگشتی T(n) = T(n-1) + n چه مرتبه‌ای دارد؟',
    '["O(n)", "O(n²)", "O(n log n)", "O(2ⁿ)"]',
    1,
    'T(n) = n + (n-1) + ... + 1 = n(n+1)/2 = O(n²)'
);

-- Question 12: Stack Application (کنکور ۱۴۰۲)
INSERT INTO questions (exam_id, course_id, topic_id, content, options, answer, explanation)
VALUES (
    3, 1, 2,
    'کدام مسئله با استفاده از پشته قابل حل نیست؟',
    '["بررسی توازن پرانتزها", "محاسبه عبارت پسوندی (Postfix)", "پیمایش BFS گراف", "پیمایش DFS گراف"]',
    2,
    'BFS از صف استفاده می‌کند نه پشته. DFS، توازن پرانتز و محاسبه Postfix همگی با پشته انجام می‌شوند.'
);
