--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attempts (
    id integer NOT NULL,
    user_id integer,
    question_id integer,
    selected integer NOT NULL,
    correct boolean NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attempts_id_seq OWNED BY public.attempts.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    field_id integer,
    name_fa character varying(100) NOT NULL,
    name_en character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: exams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exams (
    id integer NOT NULL,
    year integer NOT NULL,
    field_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: exams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exams_id_seq OWNED BY public.exams.id;


--
-- Name: fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fields (
    id integer NOT NULL,
    name_fa character varying(100) NOT NULL,
    name_en character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fields_id_seq OWNED BY public.fields.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    exam_id integer,
    course_id integer,
    topic_id integer,
    content text NOT NULL,
    options jsonb NOT NULL,
    answer integer NOT NULL,
    explanation text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: review_schedule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review_schedule (
    id integer NOT NULL,
    user_id integer,
    question_id integer,
    next_review timestamp without time zone NOT NULL,
    ease_factor numeric(3,2) DEFAULT 2.5,
    interval_days integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: review_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.review_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.review_schedule_id_seq OWNED BY public.review_schedule.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
    id integer NOT NULL,
    course_id integer,
    name_fa character varying(200) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.topics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.topics_id_seq OWNED BY public.topics.id;


--
-- Name: vocabulary_quiz_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vocabulary_quiz_results (
    id integer NOT NULL,
    user_id integer NOT NULL,
    word_id integer NOT NULL,
    quiz_type character varying(20) NOT NULL,
    correct boolean NOT NULL,
    response_time_ms integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: user_quiz_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.user_quiz_stats AS
 SELECT user_id,
    quiz_type,
    count(*) AS total_attempts,
    sum(
        CASE
            WHEN correct THEN 1
            ELSE 0
        END) AS correct_count,
    round(((100.0 * (sum(
        CASE
            WHEN correct THEN 1
            ELSE 0
        END))::numeric) / (count(*))::numeric), 1) AS accuracy_percent,
    avg(response_time_ms) AS avg_response_time
   FROM public.vocabulary_quiz_results
  GROUP BY user_id, quiz_type;


--
-- Name: user_streaks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_streaks (
    id integer NOT NULL,
    user_id integer NOT NULL,
    current_streak integer DEFAULT 0,
    longest_streak integer DEFAULT 0,
    last_activity date,
    total_xp integer DEFAULT 0,
    words_learned integer DEFAULT 0,
    reviews_today integer DEFAULT 0,
    daily_goal integer DEFAULT 10,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: user_streaks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_streaks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_streaks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_streaks_id_seq OWNED BY public.user_streaks.id;


--
-- Name: user_vocabulary; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_vocabulary (
    id integer NOT NULL,
    user_id integer NOT NULL,
    word_id integer NOT NULL,
    easiness numeric(4,2) DEFAULT 2.5,
    interval_days integer DEFAULT 1,
    repetitions integer DEFAULT 0,
    next_review timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_reviewed timestamp without time zone,
    quality_history integer[] DEFAULT '{}'::integer[],
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying,
    status_until timestamp without time zone
);


--
-- Name: user_vocabulary_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_vocabulary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_vocabulary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_vocabulary_id_seq OWNED BY public.user_vocabulary.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255),
    name character varying(100),
    password_hash character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id character varying(100),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vocabulary_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vocabulary_categories (
    id integer NOT NULL,
    uuid character varying(36) DEFAULT (gen_random_uuid())::text NOT NULL,
    name_fa character varying(100) NOT NULL,
    name_en character varying(100) NOT NULL,
    description_fa text,
    description_en text,
    icon character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: vocabulary_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vocabulary_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vocabulary_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vocabulary_categories_id_seq OWNED BY public.vocabulary_categories.id;


--
-- Name: vocabulary_quiz_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vocabulary_quiz_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vocabulary_quiz_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vocabulary_quiz_results_id_seq OWNED BY public.vocabulary_quiz_results.id;


--
-- Name: vocabulary_words; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vocabulary_words (
    id integer NOT NULL,
    uuid character varying(36) DEFAULT (gen_random_uuid())::text NOT NULL,
    category_id integer,
    word_en character varying(100) NOT NULL,
    meaning_fa character varying(255) NOT NULL,
    pronunciation character varying(100),
    example_en text,
    example_fa text,
    difficulty integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT vocabulary_words_difficulty_check CHECK (((difficulty >= 1) AND (difficulty <= 5)))
);


--
-- Name: vocabulary_words_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vocabulary_words_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vocabulary_words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vocabulary_words_id_seq OWNED BY public.vocabulary_words.id;


--
-- Name: attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempts ALTER COLUMN id SET DEFAULT nextval('public.attempts_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: exams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams ALTER COLUMN id SET DEFAULT nextval('public.exams_id_seq'::regclass);


--
-- Name: fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fields ALTER COLUMN id SET DEFAULT nextval('public.fields_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: review_schedule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_schedule ALTER COLUMN id SET DEFAULT nextval('public.review_schedule_id_seq'::regclass);


--
-- Name: topics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics ALTER COLUMN id SET DEFAULT nextval('public.topics_id_seq'::regclass);


--
-- Name: user_streaks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_streaks ALTER COLUMN id SET DEFAULT nextval('public.user_streaks_id_seq'::regclass);


--
-- Name: user_vocabulary id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocabulary ALTER COLUMN id SET DEFAULT nextval('public.user_vocabulary_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vocabulary_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_categories ALTER COLUMN id SET DEFAULT nextval('public.vocabulary_categories_id_seq'::regclass);


--
-- Name: vocabulary_quiz_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_quiz_results ALTER COLUMN id SET DEFAULT nextval('public.vocabulary_quiz_results_id_seq'::regclass);


--
-- Name: vocabulary_words id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_words ALTER COLUMN id SET DEFAULT nextval('public.vocabulary_words_id_seq'::regclass);


--
-- Data for Name: attempts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.attempts (id, user_id, question_id, selected, correct, created_at, uuid) FROM stdin;
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.courses (id, field_id, name_fa, name_en, created_at, uuid) FROM stdin;
1	1	ساختمان داده	Data Structures	2026-01-03 12:56:50.69797	6fb33fc2-9dc2-4c50-97fe-f01c1f0acaee
2	1	طراحی الگوریتم	Algorithm Design	2026-01-03 12:56:50.69797	34e5803d-1737-48a2-ae97-2ffd1aaa308f
3	1	پایگاه داده	Database	2026-01-03 12:56:50.69797	43f06ae5-1ffe-402c-9956-32cf41502c2c
4	1	شبکه	Networking	2026-01-03 12:56:50.69797	c620293d-2b33-4b36-b277-cf4c313b72db
5	1	سیستم عامل	Operating Systems	2026-01-03 12:56:50.69797	c44e9ff7-8e3e-4ffe-9f74-b5fccf20bb5d
9	1	شبکه‌های کامپیوتری	Computer Networks	2026-01-03 13:31:30.159951	273114e6-f42b-43d2-b6b1-2e79327c4140
11	1	معماری کامپیوتر	Computer Architecture	2026-01-03 13:31:30.159951	daad1d19-5ae9-44ab-953d-9c2cdeddd0c8
12	1	هوش مصنوعی	Artificial Intelligence	2026-01-03 13:31:30.159951	75f4e2af-ee23-4f6a-9879-700ed60c291a
13	1	نظریه زبان‌ها	Theory of Languages	2026-01-03 13:31:30.159951	a722a1db-0f3c-4e4a-b16d-a60c77bcb0d1
14	2	مدیریت عمومی	General Management	2026-01-03 13:31:30.167484	febfdfea-8cfd-4346-8a27-021b89b21747
15	2	اقتصاد خرد و کلان	Microeconomics and Macroeconomics	2026-01-03 13:31:30.167484	55283d4f-ade1-48cd-a45f-2356dae80ea1
16	2	روانشناسی عمومی	General Psychology	2026-01-03 13:31:30.167484	19eae7a8-7adb-4aa6-b424-5aa6da712332
17	2	حقوق اساسی	Constitutional Law	2026-01-03 13:31:30.167484	a5deb7b4-96d6-4e7a-bef5-b2ca183b7094
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.exams (id, year, field_id, created_at, uuid) FROM stdin;
1	1404	1	2026-01-03 12:56:50.713009	b020e715-75c0-455d-91bd-eb5ba995c27e
2	1403	1	2026-01-03 12:56:50.713009	622a4c90-9f5a-4805-bceb-f8f0dfc14c26
3	1402	1	2026-01-03 12:56:50.713009	c7ea513d-ff94-46fa-a22c-4217c414b776
4	1401	1	2026-01-03 12:56:50.713009	0492d3c3-df48-4435-9ea4-1ac7f0850da1
5	1400	1	2026-01-03 12:56:50.713009	35a20554-4a36-47b0-9aa4-9d41d3626d98
6	1404	1	2026-01-03 13:31:30.364894	d04abd50-9b0c-4e58-ad64-1696744489dd
7	1403	1	2026-01-03 13:31:30.364894	f10fd293-cb6b-40ef-9c1c-748c0befdf3d
8	1402	1	2026-01-03 13:31:30.364894	399a8634-f3a1-4e59-ae7c-90cc478f8c22
9	1401	1	2026-01-03 13:31:30.364894	614a0bbe-57c9-498d-aa65-3a557dc5dfde
10	1400	1	2026-01-03 13:31:30.364894	708ff7eb-be12-4c2f-a82f-3238afdc77f1
11	1404	2	2026-01-03 13:31:30.373437	cdc590d7-9c34-4988-bda7-952e6bc91d85
12	1403	2	2026-01-03 13:31:30.373437	6d1c2a6a-1f60-4a75-8b4b-492d6398e999
13	1402	2	2026-01-03 13:31:30.373437	ee89cedf-ec0a-410e-a8f2-5aa293ee9dc3
14	1401	2	2026-01-03 13:31:30.373437	3a6e396b-dcd6-438a-a74c-e9a908ba829e
15	1400	2	2026-01-03 13:31:30.373437	7f88a88d-fc94-449e-8b31-ce55437a2935
\.


--
-- Data for Name: fields; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fields (id, name_fa, name_en, created_at, uuid) FROM stdin;
1	فنی و مهندسی	Engineering	2026-01-03 12:56:50.684239	f1f2a084-4c22-4ef1-8310-c585ba6a8357
2	علوم انسانی	Humanities	2026-01-03 12:56:50.684239	8d3a72d8-a0e1-4122-bd1e-34507904c6f3
3	علوم پایه	Basic Sciences	2026-01-03 12:56:50.684239	38b39e74-8bcd-4266-90f8-601f42246100
4	هنر و معماری	Art & Architecture	2026-01-03 12:56:50.684239	3f1e6a89-b860-48a9-842b-d749c9462985
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questions (id, exam_id, course_id, topic_id, content, options, answer, explanation, created_at, uuid) FROM stdin;
4	2	2	\N	پیچیدگی زمانی الگوریتم Dijkstra با استفاده از هیپ چیست؟	["O(V²)", "O(E log V)", "O(V log V)", "O(E + V)"]	2	\N	2026-01-03 12:56:50.718008	adece4e3-5fab-446a-b5bf-396f3b9a23dd
52	3	1	1	مرتبه زمانی قطعه کد زیر چیست؟\n\nfor (i = 1; i <= n; i++)\n    for (j = 1; j <= n; j *= 2)\n        sum++;	["O(n)", "O(n log n)", "O(n²)", "O(n² log n)"]	1	حلقه بیرونی n بار و حلقه درونی log n بار اجرا می‌شود. پس مرتبه کلی O(n log n) است.	2026-01-04 09:04:15.540521	e50315e1-0ccb-4011-9eba-195977e405e3
53	3	1	1	رابطه بازگشتی T(n) = 4T(n/2) + n² چه مرتبه‌ای دارد؟	["Θ(n²)", "Θ(n² log n)", "Θ(n³)", "Θ(n² log² n)"]	1	با استفاده از قضیه اصلی: a=4, b=2, f(n)=n². داریم log₂4=2. چون f(n)=Θ(n^log_b(a)) پس T(n)=Θ(n² log n).	2026-01-04 09:04:15.558036	04d5f4f2-26ae-42d2-ba68-651788d9a7a5
54	3	1	4	اگر آرایه‌ای با n عنصر داشته باشیم، ساختن یک max-heap از این آرایه با استفاده از روش heapify چه مرتبه زمانی دارد؟	["O(n)", "O(n log n)", "O(log n)", "O(n²)"]	0	ساختن heap با روش bottom-up heapify مرتبه O(n) دارد، نه O(n log n).	2026-01-04 09:04:15.559787	47416d10-442b-4ef0-a1da-229d4dd0fa13
55	3	1	4	در یک درخت AVL با n گره، حداکثر تعداد چرخش‌های لازم برای درج یک کلید جدید چقدر است؟	["1", "2", "log n", "n"]	1	در درخت AVL برای درج یک گره جدید، حداکثر 2 چرخش (یک چرخش دوگانه) نیاز است.	2026-01-04 09:04:15.56139	3e789773-6c7f-42ab-b30f-8d6befd2d29d
56	3	1	5	الگوریتم BFS روی گراف G=(V,E) که با لیست مجاورت نمایش داده شده، چه پیچیدگی زمانی دارد؟	["O(V)", "O(E)", "O(V + E)", "O(V × E)"]	2	BFS هر رأس را یک بار و هر یال را حداکثر دو بار بررسی می‌کند. پس مرتبه O(V + E) است.	2026-01-04 09:04:15.563175	b0e02d71-9560-441a-8cc1-006e33fd0744
57	3	1	5	در گراف جهت‌دار G، الگوریتم DFS برای تشخیص وجود دور چه نوع یالی را بررسی می‌کند؟	["یال درختی (Tree Edge)", "یال برگشتی (Back Edge)", "یال پیشرو (Forward Edge)", "یال عرضی (Cross Edge)"]	1	وجود یال برگشتی (Back Edge) در DFS نشان‌دهنده وجود دور در گراف جهت‌دار است.	2026-01-04 09:04:15.564955	2b08a952-63aa-4d02-9097-f0dc71011653
58	3	1	6	میانگین پیچیدگی زمانی الگوریتم QuickSort چیست و در چه شرایطی رخ می‌دهد؟	["O(n log n) - وقتی pivot همیشه میانه باشد", "O(n²) - وقتی داده‌ها تصادفی باشند", "O(n log n) - وقتی pivot تصادفی انتخاب شود", "O(n) - وقتی داده‌ها مرتب باشند"]	2	با انتخاب تصادفی pivot، میانگین پیچیدگی O(n log n) است.	2026-01-04 09:04:15.566689	9efb4bbe-8bf2-4b44-a9b3-d15cf37def6f
59	3	1	6	کدام یک از الگوریتم‌های مرتب‌سازی زیر پایدار (Stable) نیست؟	["Merge Sort", "Insertion Sort", "Heap Sort", "Bubble Sort"]	2	Heap Sort پایدار نیست زیرا در فرآیند heapify ممکن است ترتیب عناصر برابر تغییر کند.	2026-01-04 09:04:15.568223	17c249a7-631f-46cd-be60-7199881e3f4f
60	3	1	8	در جدول درهم‌سازی با زنجیره‌سازی (Chaining)، اگر n کلید در جدولی با m خانه ذخیره شود، میانگین طول هر زنجیره چقدر است؟	["n/m", "m/n", "n×m", "log(n/m)"]	0	میانگین طول زنجیره برابر با ضریب بارگذاری α = n/m است.	2026-01-04 09:04:15.569849	eefe00dc-ac09-413a-8aef-e3040e5d2833
61	3	1	4	در یک درخت جستجوی دودویی با n گره، پیچیدگی زمانی جستجو در بدترین حالت چیست؟	["O(1)", "O(log n)", "O(n)", "O(n log n)"]	2	بدترین حالت وقتی است که درخت کاملاً نامتوازن باشد (مانند یک لیست پیوندی) که O(n) می‌شود.	2026-01-04 09:04:15.571316	8e9bc126-5c11-48dd-8aa8-797dcf86a24d
62	3	1	1	رابطه بازگشتی T(n) = T(n-1) + n چه مرتبه‌ای دارد؟	["O(n)", "O(n²)", "O(n log n)", "O(2ⁿ)"]	1	T(n) = n + (n-1) + ... + 1 = n(n+1)/2 = O(n²)	2026-01-04 09:04:15.572571	e90dc95f-6e83-46d7-aa44-24427be06d17
63	3	1	2	کدام مسئله با استفاده از پشته قابل حل نیست؟	["بررسی توازن پرانتزها", "محاسبه عبارت پسوندی (Postfix)", "پیمایش BFS گراف", "پیمایش DFS گراف"]	2	BFS از صف استفاده می‌کند نه پشته. DFS، توازن پرانتز و محاسبه Postfix همگی با پشته انجام می‌شوند.	2026-01-04 09:04:15.574079	a6af7f4e-c5cc-44b8-9add-1b643086e6c4
\.


--
-- Data for Name: review_schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.review_schedule (id, user_id, question_id, next_review, ease_factor, interval_days, created_at, uuid) FROM stdin;
\.


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.topics (id, course_id, name_fa, created_at, uuid) FROM stdin;
1	1	مرتبه زمانی و تحلیل الگوریتم	2026-01-03 13:31:30.74162	f650f648-6662-40df-a143-fed85b39d21e
2	1	پشته و صف	2026-01-03 13:31:30.74162	cb7eb56f-bafe-4b71-a5e3-73d6b6b5fed6
3	1	لیست پیوندی	2026-01-03 13:31:30.74162	89ef83cc-e0cc-4320-8e13-5e100a78b900
4	1	درخت	2026-01-03 13:31:30.74162	29d8b847-1a8e-48bb-b2a1-ab98ae940b68
5	1	گراف	2026-01-03 13:31:30.74162	8122a995-b2fd-470b-9a86-154875c142cb
6	1	مرتب‌سازی	2026-01-03 13:31:30.74162	5961349f-a81c-4fe7-98fc-650ce6a02d99
7	1	جستجو	2026-01-03 13:31:30.74162	a41bad09-5644-4156-83dc-2ce26f32951a
8	1	درهم‌سازی	2026-01-03 13:31:30.74162	3b9ec9da-f52b-4f6e-9125-167c1f3eef4b
9	2	الگوریتم‌های حریصانه	2026-01-03 13:31:30.749352	05e4f61d-705e-4948-9cf0-ae9024b94fed
10	2	برنامه‌ریزی پویا	2026-01-03 13:31:30.749352	fb0e6052-ea47-4449-8cf2-38cab90713b1
11	2	تقسیم و حل	2026-01-03 13:31:30.749352	77bbcccd-b984-4c72-b402-f745f163856e
12	2	الگوریتم‌های گراف	2026-01-03 13:31:30.749352	7c214d88-d5e2-4b36-89d6-bc1f2bc7c227
13	2	پیچیدگی محاسباتی	2026-01-03 13:31:30.749352	5340936b-570c-4fcd-8a27-e4c900f2d5ed
\.


--
-- Data for Name: user_streaks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_streaks (id, user_id, current_streak, longest_streak, last_activity, total_xp, words_learned, reviews_today, daily_goal, created_at, updated_at) FROM stdin;
40	116	2	2	2026-01-12	850	0	7	10	2026-01-11 16:34:47.615335	2026-01-12 15:11:55.753663
1	1	1	1	2026-01-11	130	0	4	10	2026-01-11 14:32:12.512477	2026-01-11 15:49:50.670356
2	18	1	1	2026-01-11	30	0	1	10	2026-01-11 16:09:28.087262	2026-01-11 16:09:28.087262
3	31	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:05.393661	2026-01-11 16:11:05.393661
4	35	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:08.108956	2026-01-11 16:11:08.108956
5	38	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:11.545579	2026-01-11 16:11:11.545579
6	39	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:13.098532	2026-01-11 16:11:13.098532
7	40	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:14.705851	2026-01-11 16:11:14.705851
8	41	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:16.272579	2026-01-11 16:11:16.272579
9	42	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:17.877288	2026-01-11 16:11:17.877288
10	43	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:19.421547	2026-01-11 16:11:19.421547
11	44	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:21.011144	2026-01-11 16:11:21.011144
12	45	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:22.582606	2026-01-11 16:11:22.582606
13	46	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:24.158788	2026-01-11 16:11:24.158788
14	47	1	1	2026-01-11	30	0	1	10	2026-01-11 16:11:25.709602	2026-01-11 16:11:25.709602
15	59	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:08.650893	2026-01-11 16:12:08.650893
16	65	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:11.70962	2026-01-11 16:12:11.70962
17	66	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:12.08706	2026-01-11 16:12:12.08706
18	67	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:13.231425	2026-01-11 16:12:13.231425
19	68	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:14.791602	2026-01-11 16:12:14.791602
20	69	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:16.314766	2026-01-11 16:12:16.314766
21	70	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:17.881406	2026-01-11 16:12:17.881406
22	71	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:19.370075	2026-01-11 16:12:19.370075
23	72	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:20.878602	2026-01-11 16:12:20.878602
24	73	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:22.396425	2026-01-11 16:12:22.396425
25	74	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:23.920884	2026-01-11 16:12:23.920884
26	75	1	1	2026-01-11	30	0	1	10	2026-01-11 16:12:25.521713	2026-01-11 16:12:25.521713
27	80	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:09.695268	2026-01-11 16:14:09.695268
28	81	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:13.422663	2026-01-11 16:14:13.422663
29	82	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:18.179659	2026-01-11 16:14:18.179659
30	83	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:22.405605	2026-01-11 16:14:22.405605
31	84	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:26.33964	2026-01-11 16:14:26.33964
32	85	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:30.096838	2026-01-11 16:14:30.096838
33	86	1	1	2026-01-11	30	0	1	10	2026-01-11 16:14:38.222417	2026-01-11 16:14:38.222417
34	87	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:42.692608	2026-01-11 16:14:42.692608
35	88	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:46.215345	2026-01-11 16:14:46.215345
36	89	1	1	2026-01-11	35	0	1	10	2026-01-11 16:14:51.736803	2026-01-11 16:14:51.736803
37	110	1	1	2026-01-11	30	0	1	10	2026-01-11 16:20:47.364361	2026-01-11 16:20:47.364361
39	115	1	1	2026-01-11	30	0	1	10	2026-01-11 16:20:51.211029	2026-01-11 16:20:51.211029
44	136	1	1	2026-01-13	70	0	3	10	2026-01-13 14:39:45.276928	2026-01-13 14:41:24.862885
38	113	1	1	2026-01-11	300	0	10	10	2026-01-11 16:20:50.789465	2026-01-11 16:21:05.182678
41	129	1	1	2026-01-11	30	0	1	10	2026-01-11 16:57:06.019795	2026-01-11 16:57:06.019795
43	134	1	1	2026-01-11	30	0	1	10	2026-01-11 16:57:09.279476	2026-01-11 16:57:09.279476
42	132	1	1	2026-01-11	300	0	10	10	2026-01-11 16:57:08.970172	2026-01-11 16:57:23.075523
\.


--
-- Data for Name: user_vocabulary; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_vocabulary (id, user_id, word_id, easiness, interval_days, repetitions, next_review, last_reviewed, quality_history, created_at, updated_at, status, status_until) FROM stdin;
9	1	1	2.50	6	2	2026-01-17 14:33:57.724627	2026-01-11 14:33:57.726759	{}	2026-01-11 14:32:12.502895	2026-01-11 14:33:57.726759	active	\N
10	1	2	2.60	1	1	2026-01-12 15:49:44.020399	2026-01-11 15:49:44.022088	{}	2026-01-11 15:49:44.022088	2026-01-11 15:49:44.022088	active	\N
11	1	7	2.60	1	1	2026-01-12 15:49:50.665036	2026-01-11 15:49:50.665839	{}	2026-01-11 15:49:50.665839	2026-01-11 15:49:50.665839	active	\N
12	18	1	2.50	1	1	2026-01-12 16:09:28.079017	2026-01-11 16:09:28.080879	{}	2026-01-11 16:09:28.080879	2026-01-11 16:09:28.080879	active	\N
13	31	1	2.50	1	1	2026-01-12 16:11:05.389162	2026-01-11 16:11:05.389821	{}	2026-01-11 16:11:05.389821	2026-01-11 16:11:05.389821	active	\N
14	35	2	2.50	1	1	2026-01-12 16:11:08.099149	2026-01-11 16:11:08.101232	{}	2026-01-11 16:11:08.101232	2026-01-11 16:11:08.101232	active	\N
15	38	2	2.50	1	1	2026-01-12 16:11:11.541884	2026-01-11 16:11:11.542155	{}	2026-01-11 16:11:11.542155	2026-01-11 16:11:11.542155	active	\N
16	39	7	2.50	1	1	2026-01-12 16:11:13.093841	2026-01-11 16:11:13.094329	{}	2026-01-11 16:11:13.094329	2026-01-11 16:11:13.094329	active	\N
17	40	14	2.50	1	1	2026-01-12 16:11:14.702279	2026-01-11 16:11:14.702717	{}	2026-01-11 16:11:14.702717	2026-01-11 16:11:14.702717	active	\N
18	41	16	2.50	1	1	2026-01-12 16:11:16.269182	2026-01-11 16:11:16.269587	{}	2026-01-11 16:11:16.269587	2026-01-11 16:11:16.269587	active	\N
19	42	19	2.50	1	1	2026-01-12 16:11:17.873018	2026-01-11 16:11:17.873856	{}	2026-01-11 16:11:17.873856	2026-01-11 16:11:17.873856	active	\N
20	43	1	2.50	1	1	2026-01-12 16:11:19.419431	2026-01-11 16:11:19.419881	{}	2026-01-11 16:11:19.419881	2026-01-11 16:11:19.419881	active	\N
21	44	4	2.50	1	1	2026-01-12 16:11:21.007867	2026-01-11 16:11:21.009024	{}	2026-01-11 16:11:21.009024	2026-01-11 16:11:21.009024	active	\N
22	45	5	2.50	1	1	2026-01-12 16:11:22.579508	2026-01-11 16:11:22.580114	{}	2026-01-11 16:11:22.580114	2026-01-11 16:11:22.580114	active	\N
23	46	6	2.50	1	1	2026-01-12 16:11:24.15615	2026-01-11 16:11:24.15637	{}	2026-01-11 16:11:24.15637	2026-01-11 16:11:24.15637	active	\N
24	47	9	2.50	1	1	2026-01-12 16:11:25.706827	2026-01-11 16:11:25.707445	{}	2026-01-11 16:11:25.707445	2026-01-11 16:11:25.707445	active	\N
25	59	1	2.50	1	1	2026-01-12 16:12:08.6282	2026-01-11 16:12:08.630358	{}	2026-01-11 16:12:08.630358	2026-01-11 16:12:08.630358	active	\N
26	65	2	2.50	1	1	2026-01-12 16:12:11.697463	2026-01-11 16:12:11.703219	{}	2026-01-11 16:12:11.703219	2026-01-11 16:12:11.703219	active	\N
27	66	2	2.50	1	1	2026-01-12 16:12:12.084257	2026-01-11 16:12:12.084837	{}	2026-01-11 16:12:12.084837	2026-01-11 16:12:12.084837	active	\N
28	67	7	2.50	1	1	2026-01-12 16:12:13.225002	2026-01-11 16:12:13.225698	{}	2026-01-11 16:12:13.225698	2026-01-11 16:12:13.225698	active	\N
29	68	14	2.50	1	1	2026-01-12 16:12:14.787778	2026-01-11 16:12:14.788412	{}	2026-01-11 16:12:14.788412	2026-01-11 16:12:14.788412	active	\N
30	69	16	2.50	1	1	2026-01-12 16:12:16.311657	2026-01-11 16:12:16.312221	{}	2026-01-11 16:12:16.312221	2026-01-11 16:12:16.312221	active	\N
31	70	19	2.50	1	1	2026-01-12 16:12:17.877619	2026-01-11 16:12:17.878553	{}	2026-01-11 16:12:17.878553	2026-01-11 16:12:17.878553	active	\N
32	71	1	2.50	1	1	2026-01-12 16:12:19.364941	2026-01-11 16:12:19.365665	{}	2026-01-11 16:12:19.365665	2026-01-11 16:12:19.365665	active	\N
33	72	4	2.50	1	1	2026-01-12 16:12:20.875951	2026-01-11 16:12:20.876432	{}	2026-01-11 16:12:20.876432	2026-01-11 16:12:20.876432	active	\N
34	73	5	2.50	1	1	2026-01-12 16:12:22.393472	2026-01-11 16:12:22.393865	{}	2026-01-11 16:12:22.393865	2026-01-11 16:12:22.393865	active	\N
35	74	6	2.50	1	1	2026-01-12 16:12:23.916985	2026-01-11 16:12:23.917532	{}	2026-01-11 16:12:23.917532	2026-01-11 16:12:23.917532	active	\N
36	75	9	2.50	1	1	2026-01-12 16:12:25.518126	2026-01-11 16:12:25.519014	{}	2026-01-11 16:12:25.519014	2026-01-11 16:12:25.519014	active	\N
37	80	2	2.60	1	1	2026-01-12 16:14:09.690446	2026-01-11 16:14:09.690946	{}	2026-01-11 16:14:09.690946	2026-01-11 16:14:09.690946	active	\N
38	81	7	2.60	1	1	2026-01-12 16:14:13.419247	2026-01-11 16:14:13.419818	{}	2026-01-11 16:14:13.419818	2026-01-11 16:14:13.419818	active	\N
39	82	14	2.60	1	1	2026-01-12 16:14:18.176257	2026-01-11 16:14:18.176738	{}	2026-01-11 16:14:18.176738	2026-01-11 16:14:18.176738	active	\N
40	83	16	2.60	1	1	2026-01-12 16:14:22.397551	2026-01-11 16:14:22.398106	{}	2026-01-11 16:14:22.398106	2026-01-11 16:14:22.398106	active	\N
41	84	19	2.60	1	1	2026-01-12 16:14:26.336628	2026-01-11 16:14:26.33692	{}	2026-01-11 16:14:26.33692	2026-01-11 16:14:26.33692	active	\N
42	85	1	2.60	1	1	2026-01-12 16:14:30.089893	2026-01-11 16:14:30.090595	{}	2026-01-11 16:14:30.090595	2026-01-11 16:14:30.090595	active	\N
43	86	4	2.50	1	1	2026-01-12 16:14:38.21339	2026-01-11 16:14:38.213826	{}	2026-01-11 16:14:38.213826	2026-01-11 16:14:38.213826	active	\N
44	87	5	2.60	1	1	2026-01-12 16:14:42.688614	2026-01-11 16:14:42.689381	{}	2026-01-11 16:14:42.689381	2026-01-11 16:14:42.689381	active	\N
45	88	6	2.60	1	1	2026-01-12 16:14:46.211292	2026-01-11 16:14:46.211555	{}	2026-01-11 16:14:46.211555	2026-01-11 16:14:46.211555	active	\N
46	89	9	2.60	1	1	2026-01-12 16:14:51.733088	2026-01-11 16:14:51.733993	{}	2026-01-11 16:14:51.733993	2026-01-11 16:14:51.733993	active	\N
47	110	1	2.50	1	1	2026-01-12 16:20:47.350313	2026-01-11 16:20:47.35226	{}	2026-01-11 16:20:47.35226	2026-01-11 16:20:47.35226	active	\N
48	113	2	2.50	1	1	2026-01-12 16:20:50.783499	2026-01-11 16:20:50.784804	{}	2026-01-11 16:20:50.784804	2026-01-11 16:20:50.784804	active	\N
49	115	2	2.50	1	1	2026-01-12 16:20:51.206872	2026-01-11 16:20:51.208003	{}	2026-01-11 16:20:51.208003	2026-01-11 16:20:51.208003	active	\N
50	113	7	2.50	1	1	2026-01-12 16:20:52.439846	2026-01-11 16:20:52.440548	{}	2026-01-11 16:20:52.440548	2026-01-11 16:20:52.440548	active	\N
51	113	14	2.50	1	1	2026-01-12 16:20:54.062161	2026-01-11 16:20:54.062702	{}	2026-01-11 16:20:54.062702	2026-01-11 16:20:54.062702	active	\N
52	113	16	2.50	1	1	2026-01-12 16:20:55.672263	2026-01-11 16:20:55.673088	{}	2026-01-11 16:20:55.673088	2026-01-11 16:20:55.673088	active	\N
53	113	19	2.50	1	1	2026-01-12 16:20:57.267162	2026-01-11 16:20:57.267852	{}	2026-01-11 16:20:57.267852	2026-01-11 16:20:57.267852	active	\N
54	113	1	2.50	1	1	2026-01-12 16:20:58.834058	2026-01-11 16:20:58.834515	{}	2026-01-11 16:20:58.834515	2026-01-11 16:20:58.834515	active	\N
55	113	4	2.50	1	1	2026-01-12 16:21:00.43309	2026-01-11 16:21:00.433504	{}	2026-01-11 16:21:00.433504	2026-01-11 16:21:00.433504	active	\N
56	113	5	2.50	1	1	2026-01-12 16:21:01.974615	2026-01-11 16:21:01.975165	{}	2026-01-11 16:21:01.975165	2026-01-11 16:21:01.975165	active	\N
57	113	6	2.50	1	1	2026-01-12 16:21:03.606496	2026-01-11 16:21:03.606805	{}	2026-01-11 16:21:03.606805	2026-01-11 16:21:03.606805	active	\N
58	113	9	2.50	1	1	2026-01-12 16:21:05.179489	2026-01-11 16:21:05.180286	{}	2026-01-11 16:21:05.180286	2026-01-11 16:21:05.180286	active	\N
59	116	2	2.60	1	1	2026-01-12 16:34:47.609865	2026-01-11 16:34:47.610556	{}	2026-01-11 16:34:47.610556	2026-01-11 16:34:47.610556	active	\N
60	116	7	2.60	1	1	2026-01-12 16:34:50.713619	2026-01-11 16:34:50.714127	{}	2026-01-11 16:34:50.714127	2026-01-11 16:34:50.714127	active	\N
61	116	14	2.60	1	1	2026-01-12 16:34:54.952794	2026-01-11 16:34:54.953291	{}	2026-01-11 16:34:54.953291	2026-01-11 16:34:54.953291	active	\N
62	116	16	2.60	1	1	2026-01-12 16:34:58.045973	2026-01-11 16:34:58.046736	{}	2026-01-11 16:34:58.046736	2026-01-11 16:34:58.046736	active	\N
63	116	19	2.60	1	1	2026-01-12 16:35:00.989971	2026-01-11 16:35:00.990476	{}	2026-01-11 16:35:00.990476	2026-01-11 16:35:00.990476	active	\N
64	116	1	2.60	1	1	2026-01-12 16:35:04.306165	2026-01-11 16:35:04.307253	{}	2026-01-11 16:35:04.307253	2026-01-11 16:35:04.307253	active	\N
65	116	4	2.50	1	1	2026-01-12 16:35:08.936863	2026-01-11 16:35:08.937504	{}	2026-01-11 16:35:08.937504	2026-01-11 16:35:08.937504	active	\N
66	116	5	2.60	1	1	2026-01-12 16:35:14.17302	2026-01-11 16:35:14.173208	{}	2026-01-11 16:35:14.173208	2026-01-11 16:35:14.173208	active	\N
67	116	6	2.60	1	1	2026-01-12 16:35:17.892409	2026-01-11 16:35:17.89315	{}	2026-01-11 16:35:17.89315	2026-01-11 16:35:17.89315	active	\N
68	116	9	2.60	1	1	2026-01-12 16:35:20.865993	2026-01-11 16:35:20.868093	{}	2026-01-11 16:35:20.868093	2026-01-11 16:35:20.868093	active	\N
69	116	10	2.60	1	1	2026-01-12 16:35:28.859856	2026-01-11 16:35:28.860535	{}	2026-01-11 16:35:28.860535	2026-01-11 16:35:28.860535	active	\N
70	116	11	2.60	1	1	2026-01-12 16:35:32.351632	2026-01-11 16:35:32.35206	{}	2026-01-11 16:35:32.35206	2026-01-11 16:35:32.35206	active	\N
71	116	12	2.60	1	1	2026-01-12 16:35:35.678464	2026-01-11 16:35:35.679187	{}	2026-01-11 16:35:35.679187	2026-01-11 16:35:35.679187	active	\N
72	116	13	2.50	1	1	2026-01-12 16:35:39.391175	2026-01-11 16:35:39.391468	{}	2026-01-11 16:35:39.391468	2026-01-11 16:35:39.391468	active	\N
73	116	15	2.60	1	1	2026-01-12 16:35:42.722042	2026-01-11 16:35:42.723411	{}	2026-01-11 16:35:42.723411	2026-01-11 16:35:42.723411	active	\N
74	116	17	2.60	1	1	2026-01-12 16:35:47.737253	2026-01-11 16:35:47.738306	{}	2026-01-11 16:35:47.738306	2026-01-11 16:35:47.738306	active	\N
75	116	18	2.50	1	1	2026-01-12 16:35:52.103606	2026-01-11 16:35:52.104369	{}	2026-01-11 16:35:52.104369	2026-01-11 16:35:52.104369	active	\N
76	116	20	2.60	1	1	2026-01-12 16:36:02.623719	2026-01-11 16:36:02.624648	{}	2026-01-11 16:36:02.624648	2026-01-11 16:36:02.624648	active	\N
77	116	29	2.50	1	1	2026-01-12 16:36:07.515106	2026-01-11 16:36:07.516477	{}	2026-01-11 16:36:07.516477	2026-01-11 16:36:07.516477	active	\N
78	116	32	2.50	1	1	2026-01-12 16:36:11.039303	2026-01-11 16:36:11.039869	{}	2026-01-11 16:36:11.039869	2026-01-11 16:36:11.039869	active	\N
79	117	5	2.50	1	0	2026-01-11 16:56:10.584817	\N	{}	2026-01-11 16:56:10.584817	2026-01-11 16:56:29.928876	active	\N
81	129	1	2.50	1	1	2026-01-12 16:57:06.002561	2026-01-11 16:57:06.005113	{}	2026-01-11 16:57:06.005113	2026-01-11 16:57:06.005113	active	\N
82	132	2	2.50	1	1	2026-01-12 16:57:08.965318	2026-01-11 16:57:08.965838	{}	2026-01-11 16:57:08.965838	2026-01-11 16:57:08.965838	active	\N
83	134	2	2.50	1	1	2026-01-12 16:57:09.275814	2026-01-11 16:57:09.27659	{}	2026-01-11 16:57:09.27659	2026-01-11 16:57:09.27659	active	\N
84	132	7	2.50	1	1	2026-01-12 16:57:10.571924	2026-01-11 16:57:10.572546	{}	2026-01-11 16:57:10.572546	2026-01-11 16:57:10.572546	active	\N
85	132	14	2.50	1	1	2026-01-12 16:57:12.126293	2026-01-11 16:57:12.126753	{}	2026-01-11 16:57:12.126753	2026-01-11 16:57:12.126753	active	\N
86	132	16	2.50	1	1	2026-01-12 16:57:13.71113	2026-01-11 16:57:13.711938	{}	2026-01-11 16:57:13.711938	2026-01-11 16:57:13.711938	active	\N
87	132	19	2.50	1	1	2026-01-12 16:57:15.276823	2026-01-11 16:57:15.277972	{}	2026-01-11 16:57:15.277972	2026-01-11 16:57:15.277972	active	\N
88	132	1	2.50	1	1	2026-01-12 16:57:16.834236	2026-01-11 16:57:16.835097	{}	2026-01-11 16:57:16.835097	2026-01-11 16:57:16.835097	active	\N
89	132	4	2.50	1	1	2026-01-12 16:57:18.389518	2026-01-11 16:57:18.389915	{}	2026-01-11 16:57:18.389915	2026-01-11 16:57:18.389915	active	\N
90	132	5	2.50	1	1	2026-01-12 16:57:19.938071	2026-01-11 16:57:19.938705	{}	2026-01-11 16:57:19.938705	2026-01-11 16:57:19.938705	active	\N
91	132	6	2.50	1	1	2026-01-12 16:57:21.509652	2026-01-11 16:57:21.510104	{}	2026-01-11 16:57:21.510104	2026-01-11 16:57:21.510104	active	\N
92	132	9	2.50	1	1	2026-01-12 16:57:23.07241	2026-01-11 16:57:23.072875	{}	2026-01-11 16:57:23.072875	2026-01-11 16:57:23.072875	active	\N
93	116	43	2.36	1	1	2026-01-13 15:09:55.810499	2026-01-12 15:09:55.815536	{}	2026-01-12 15:09:55.815536	2026-01-12 15:09:55.815536	active	\N
94	116	3	2.60	1	1	2026-01-13 15:10:02.793314	2026-01-12 15:10:02.794025	{}	2026-01-12 15:10:02.794025	2026-01-12 15:10:02.794025	active	\N
95	116	8	2.60	1	1	2026-01-13 15:10:13.834148	2026-01-12 15:10:13.835624	{}	2026-01-12 15:10:13.835624	2026-01-12 15:10:13.835624	active	\N
96	116	21	2.36	1	1	2026-01-13 15:10:33.289019	2026-01-12 15:10:33.290522	{}	2026-01-12 15:10:33.290522	2026-01-12 15:10:33.290522	active	\N
97	116	22	2.50	1	1	2026-01-13 15:10:42.171492	2026-01-12 15:10:42.172664	{}	2026-01-12 15:10:42.172664	2026-01-12 15:10:42.172664	active	\N
98	116	23	2.50	1	1	2026-01-13 15:11:20.381126	2026-01-12 15:11:20.383568	{}	2026-01-12 15:11:20.383568	2026-01-12 15:11:20.383568	active	\N
99	116	25	2.36	1	1	2026-01-13 15:11:55.748688	2026-01-12 15:11:55.749553	{}	2026-01-12 15:11:55.749553	2026-01-12 15:11:55.749553	active	\N
100	136	2	2.60	1	1	2026-01-14 14:39:45.254239	2026-01-13 14:39:45.257385	{}	2026-01-13 14:39:45.257385	2026-01-13 14:39:45.257385	active	\N
101	136	14	1.70	1	0	2026-01-14 14:40:22.551571	2026-01-13 14:40:22.55255	{}	2026-01-13 14:40:22.55255	2026-01-13 14:40:33.252798	suspended	2026-02-12 14:40:33.250347
103	136	50	2.60	1	1	2026-01-14 14:41:24.855056	2026-01-13 14:41:24.856217	{}	2026-01-13 14:41:24.856217	2026-01-13 14:41:24.856217	active	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, name, password_hash, created_at, uuid, client_id, updated_at) FROM stdin;
1	demo@test.com	Demo User	hash	2026-01-11 14:31:57.411797	2493875a-d2ff-4c64-a1ca-51ebd8052dd3	\N	2026-01-11 16:02:24.292659
2	\N	\N	\N	2026-01-11 16:08:13.144401	df670e57-4184-4489-ae64-ada80246d5dc	65bc3862-66b5-430f-81e7-b662b05e4bc4	2026-01-11 16:08:13.144401
3	\N	\N	\N	2026-01-11 16:09:11.398517	f32e4011-0e3b-4375-96e0-c85f7e3cb2b7	ae6fd6d0-286b-454d-ab98-93e179d187ce	2026-01-11 16:09:11.398517
4	\N	\N	\N	2026-01-11 16:09:11.48851	4823f2a0-1824-458d-8707-afa613717a79	7ec9de59-df59-4a4d-96ef-a9f486aeb521	2026-01-11 16:09:11.48851
5	\N	\N	\N	2026-01-11 16:09:11.502976	6bc63492-fcc0-4075-948f-ce90496aa70f	6685b1ff-9b33-4a58-9c96-f026af130295	2026-01-11 16:09:11.502976
6	\N	\N	\N	2026-01-11 16:09:11.504407	1ec49016-a74c-4cd1-9440-67ae9863875b	1ed2528c-cdb5-46a7-a056-c91550886692	2026-01-11 16:09:11.504407
7	\N	\N	\N	2026-01-11 16:09:11.508606	9ec28325-b3f3-4ed5-85d5-4e0f1492313c	abea51af-e9b4-406c-9eb9-d4e52759783e	2026-01-11 16:09:11.508606
8	\N	\N	\N	2026-01-11 16:09:11.51968	9f4f5efd-a454-4e95-ae5d-0f41041e4deb	08d643be-b674-4bf8-9b47-da25d7cb6ffa	2026-01-11 16:09:11.51968
9	\N	\N	\N	2026-01-11 16:09:11.615547	110de5a0-197a-4361-902d-57251c8abb12	4968487f-ffc4-4863-9f9b-a8d81cf68543	2026-01-11 16:09:11.615547
10	\N	\N	\N	2026-01-11 16:09:11.637495	e560c844-3b35-4f0f-b206-40f2cf5a43d0	3a1e3f31-651e-4366-972a-0556b83f26fd	2026-01-11 16:09:11.637495
11	\N	\N	\N	2026-01-11 16:09:23.009705	cf6285cf-7452-4d52-9a3b-02c8c330dfd8	92c9792e-ff50-4c7b-9374-10f3fb109431	2026-01-11 16:09:23.009705
12	\N	\N	\N	2026-01-11 16:09:23.010045	042973fd-374b-4b5f-a7c7-bfeafe4038af	5191e2fd-2296-4e9a-805d-f78d8c86b1bc	2026-01-11 16:09:23.010045
13	\N	\N	\N	2026-01-11 16:09:25.806389	437a992b-d8a9-46a5-9b63-9beb5b99db9b	7cbead97-20ca-4b4f-995f-19021dd4d1b0	2026-01-11 16:09:25.806389
14	\N	\N	\N	2026-01-11 16:09:25.807149	a660850c-8559-43b4-8601-a8011be2dbf5	7e6d8126-48ed-41cd-9336-839f76996c24	2026-01-11 16:09:25.807149
15	\N	\N	\N	2026-01-11 16:09:25.854157	6d63696e-7f35-44cd-9c11-d5f442c933c4	901f5081-5a89-4083-9855-d405962ce8a4	2026-01-11 16:09:25.854157
16	\N	\N	\N	2026-01-11 16:09:25.859822	81be46cf-f3c6-4c79-a991-526b7576209b	c0fb67ad-ed67-48c7-8186-f203cf4e437a	2026-01-11 16:09:25.859822
17	\N	\N	\N	2026-01-11 16:09:27.955191	63e71971-53dd-4e80-b77b-1ad06f378518	c331c5ac-a007-42ee-b8ca-eda76c609c81	2026-01-11 16:09:27.955191
18	\N	\N	\N	2026-01-11 16:09:28.074027	693360d8-92da-47c9-a16a-e54324d07336	be05f4f5-1332-4f84-9944-580c698abbfe	2026-01-11 16:09:28.074027
19	\N	\N	\N	2026-01-11 16:09:28.177831	d92fb123-a8aa-46e1-9cca-37cccf5844e7	c823bb30-cf69-4463-ba58-f42a2a35f31d	2026-01-11 16:09:28.177831
20	\N	\N	\N	2026-01-11 16:11:01.353465	38ae986f-ae1b-4de1-bd95-edb5d50c5e61	02c98151-ac03-4411-b720-aea8378eb4d2	2026-01-11 16:11:01.353465
21	\N	\N	\N	2026-01-11 16:11:01.356108	b74692db-a176-4911-ad61-0bac055bacd2	0e740444-3a04-4081-9083-175c7be375c3	2026-01-11 16:11:01.356108
22	\N	\N	\N	2026-01-11 16:11:01.571573	25649289-3e39-4c0b-9725-f259db282806	66076e19-a5c4-4955-9a38-e9d32cfd1c05	2026-01-11 16:11:01.571573
23	\N	\N	\N	2026-01-11 16:11:01.576652	4d90d320-90bf-4744-9ee8-16cdd431afa1	b88f933a-69a7-4690-b8e5-f2599b43a6bc	2026-01-11 16:11:01.576652
24	\N	\N	\N	2026-01-11 16:11:01.717959	8dd4caa9-840d-4903-a472-8a31e2026349	dc919fa9-5485-46ec-93b6-8f15ad1a7a9f	2026-01-11 16:11:01.717959
25	\N	\N	\N	2026-01-11 16:11:01.721729	fdfc7621-c6c1-4d68-b3bc-3ad0acfa6371	dc52a976-896d-43a8-bf18-60bb6ffd907f	2026-01-11 16:11:01.721729
26	\N	\N	\N	2026-01-11 16:11:01.766562	e7a060d1-f315-44b8-94a6-cd0ecfca0706	29184e31-dce5-4414-bc9e-63b1e373e551	2026-01-11 16:11:01.766562
27	\N	\N	\N	2026-01-11 16:11:01.766631	d67e78c3-94a5-41aa-ba08-9b063f2daace	939219a1-8b14-482c-8966-6a2b431074d4	2026-01-11 16:11:01.766631
28	\N	\N	\N	2026-01-11 16:11:03.967506	670435d4-a986-452f-9c39-b36566b51c03	6589a787-5f52-44d5-8c3c-d9c9741e41ec	2026-01-11 16:11:03.967506
29	\N	\N	\N	2026-01-11 16:11:03.967583	c7ba0cf0-2f90-4a5e-8fc4-fb54618010e3	803edb1c-b4f4-467f-9b5d-de84f4f90819	2026-01-11 16:11:03.967583
30	\N	\N	\N	2026-01-11 16:11:05.283213	13a59bf4-8fd3-4547-8a58-e59c6449b6b7	6bf4bfe6-c9f3-4d49-9be3-c84817c43051	2026-01-11 16:11:05.283213
31	\N	\N	\N	2026-01-11 16:11:05.385513	83a6cd6c-5b23-4a11-8c2f-2bd2448e248f	d679d936-6e58-4e74-846d-107a20ac227f	2026-01-11 16:11:05.385513
32	\N	\N	\N	2026-01-11 16:11:05.466844	60c06bac-dd0a-46c5-8085-e606719d5d53	b53f4151-f295-4916-b1ff-4ccbb2b18c45	2026-01-11 16:11:05.466844
33	\N	\N	\N	2026-01-11 16:11:05.601972	aea2997d-2fa8-42a5-a03d-3f8c24a69f1d	4ca16789-16f1-4e7c-9931-8830aeeb3068	2026-01-11 16:11:05.601972
34	\N	\N	\N	2026-01-11 16:11:05.606318	4cb65ccd-9763-44de-b460-45862c5deaeb	7fba763b-296d-4212-9fd8-9b3679a8b6de	2026-01-11 16:11:05.606318
35	\N	\N	\N	2026-01-11 16:11:08.09027	42583ef8-939e-4869-ac84-bee7d6eb9ada	01cc326d-4b33-4cd0-9889-28b64ccac208	2026-01-11 16:11:08.09027
36	\N	\N	\N	2026-01-11 16:11:09.310415	8a6ea368-8fa3-47ec-a040-298f56a0de3c	29036716-adfb-4302-b49f-da2f23dd584a	2026-01-11 16:11:09.310415
37	\N	\N	\N	2026-01-11 16:11:09.310314	f0073e1e-feb4-4f95-aff6-08133bf9c72b	297d67fb-58d6-43ed-989d-68d017b41fda	2026-01-11 16:11:09.310314
38	\N	\N	\N	2026-01-11 16:11:11.536499	9a266722-c74c-401f-be4d-b2a95b95cd2f	faad918b-fa25-49e4-805f-c85061bca712	2026-01-11 16:11:11.536499
39	\N	\N	\N	2026-01-11 16:11:13.089185	f86b2f0f-d984-4be9-8951-061d1f63454f	824d1074-b4d9-4216-ae88-62d0afe9d5b2	2026-01-11 16:11:13.089185
40	\N	\N	\N	2026-01-11 16:11:14.697003	e8f2da86-3517-4288-b878-029f8d71bc12	fffac473-8860-49fb-89e1-deaed916d549	2026-01-11 16:11:14.697003
41	\N	\N	\N	2026-01-11 16:11:16.264925	35e7adce-baab-42ca-8966-a74d21517472	b6e7b9bd-736b-47e5-b76e-d774c8d91d7e	2026-01-11 16:11:16.264925
42	\N	\N	\N	2026-01-11 16:11:17.86908	62326c8e-4795-44f6-99f8-93184751c5c4	a6ad9af0-764d-4661-955e-382ef2952f72	2026-01-11 16:11:17.86908
43	\N	\N	\N	2026-01-11 16:11:19.416641	f94e5d15-c069-445c-9287-21802e999c07	5886accc-2fb8-4666-87cc-73eb7390f585	2026-01-11 16:11:19.416641
44	\N	\N	\N	2026-01-11 16:11:21.003426	ce97fd25-264d-4cc3-b032-e2ba875f4978	df362d14-0316-4a35-b4dd-81ace2c4a7bb	2026-01-11 16:11:21.003426
45	\N	\N	\N	2026-01-11 16:11:22.575674	f079f6e3-cf2b-40a7-ac44-c4ed8faf3d49	cfd12b57-c0b7-47ef-93f7-6b2cb6d3064f	2026-01-11 16:11:22.575674
46	\N	\N	\N	2026-01-11 16:11:24.152403	9f69b753-e057-4c8b-9d6c-08a0e4b13ca0	1ddf6338-87d9-45ca-b954-5b01f7a0c090	2026-01-11 16:11:24.152403
47	\N	\N	\N	2026-01-11 16:11:25.703504	f3dab916-512f-4c99-8a7c-b2dbbbcfc8b9	ff2a1557-b49f-4c48-a328-f066bd21acee	2026-01-11 16:11:25.703504
49	\N	\N	\N	2026-01-11 16:12:04.241408	9f240dbd-f106-4b2d-907a-e2432c2c9834	b861524b-05a2-4250-a00c-f88685709207	2026-01-11 16:12:04.241408
48	\N	\N	\N	2026-01-11 16:12:04.241429	ad15018b-e757-43e3-881e-e54df9682750	a6d795fa-809a-45f2-9e73-d84e1c165cfd	2026-01-11 16:12:04.241429
50	\N	\N	\N	2026-01-11 16:12:04.378542	b86c2876-0b39-4c4f-99a4-e9be4df2963b	e09d358c-f1b1-4984-aa16-96fdc81315b0	2026-01-11 16:12:04.378542
51	\N	\N	\N	2026-01-11 16:12:04.378767	6f471ba4-aad6-41e2-955a-32556687cdc9	f1c60124-1f85-4abd-ac02-ab85aebabb45	2026-01-11 16:12:04.378767
52	\N	\N	\N	2026-01-11 16:12:04.380938	b20d8fe0-0935-4be7-a76f-19fba538aa19	7de9b0a0-e93b-4833-aea9-7df2b332af6e	2026-01-11 16:12:04.380938
53	\N	\N	\N	2026-01-11 16:12:04.387804	1166af29-38bd-4e0e-9750-2a219a0f067e	7c8ad6f4-e471-41de-879a-d000b351fd6d	2026-01-11 16:12:04.387804
54	\N	\N	\N	2026-01-11 16:12:04.676439	c409c1e4-dc59-40f0-87cd-496c9b5cb7b6	3f0c5446-f51b-4b52-8ce9-b191e67419dd	2026-01-11 16:12:04.676439
55	\N	\N	\N	2026-01-11 16:12:04.676812	27585adf-fea6-4e57-bd0a-c501e4c92aa3	2a83f9be-6ac3-4b53-92b3-055669545867	2026-01-11 16:12:04.676812
56	\N	\N	\N	2026-01-11 16:12:06.898433	8ba11dc4-5b98-4395-a267-22c067229e9e	00c9c8c2-2516-4e78-a55b-7247d8794cd1	2026-01-11 16:12:06.898433
57	\N	\N	\N	2026-01-11 16:12:06.899036	87a92aec-51f3-43f5-94ed-899b9cbe0b8e	8204be5c-b217-4f8f-9c54-135475813a7b	2026-01-11 16:12:06.899036
58	\N	\N	\N	2026-01-11 16:12:08.437138	6b32c030-2af1-4c39-b8c3-a0b74e01d6d8	2ee8e182-ca87-4e0a-87b9-102a3c97c018	2026-01-11 16:12:08.437138
59	\N	\N	\N	2026-01-11 16:12:08.607343	3a1643f5-b14b-4671-88ea-b2b37ba8bb26	27e9a2f1-6a58-436b-ae21-8c426ae9c64c	2026-01-11 16:12:08.607343
60	\N	\N	\N	2026-01-11 16:12:08.792032	44fc8b87-fb98-4d6f-87fe-a5f3a63ce283	eb78ae59-452f-4248-9669-9f0a7bf4834a	2026-01-11 16:12:08.792032
61	\N	\N	\N	2026-01-11 16:12:09.072122	f6edd9b7-51dc-4770-b9dc-84eadc7e2bbd	87aefd44-7ef9-471b-aafa-d8f4777510ea	2026-01-11 16:12:09.072122
62	\N	\N	\N	2026-01-11 16:12:09.081494	14d47de5-baf9-4927-9ce0-4a96fe6fe44c	46d01101-72e3-4f45-a550-150df5e7109d	2026-01-11 16:12:09.081494
63	\N	\N	\N	2026-01-11 16:12:09.408198	32c0cb75-3e1f-4750-b1a9-07723cb707a9	e0e65604-ff60-4f07-9bac-5b465fb2004c	2026-01-11 16:12:09.408198
64	\N	\N	\N	2026-01-11 16:12:09.490228	16d9be59-389e-46a0-92dd-f683ee7d9e07	479485c0-4223-45d0-9135-57da16f8262b	2026-01-11 16:12:09.490228
65	\N	\N	\N	2026-01-11 16:12:11.682832	d0d583eb-9ea5-4810-a48c-907bbe17106a	94469400-23e4-4dd5-ba69-596aa9cb5eda	2026-01-11 16:12:11.682832
66	\N	\N	\N	2026-01-11 16:12:12.079767	02c421f6-05e4-43f7-b1f4-3b55e938ad9a	258e3c0d-71b2-4657-bd50-b31cb9313bec	2026-01-11 16:12:12.079767
67	\N	\N	\N	2026-01-11 16:12:13.221274	635ea8c0-4cee-453f-81e3-5d23ed94706a	181aa8f2-d1e9-40e2-aaa9-01443cc04881	2026-01-11 16:12:13.221274
68	\N	\N	\N	2026-01-11 16:12:14.781985	49228ea1-eab7-49fe-84bf-eb8eba6d2e5a	a563c633-f1d2-458e-abe5-1b662695a25f	2026-01-11 16:12:14.781985
69	\N	\N	\N	2026-01-11 16:12:16.308492	c8c4d2b2-95f5-4289-9b1e-2a08813b0c63	d92ee7c5-474d-4851-b692-9ad36a538315	2026-01-11 16:12:16.308492
70	\N	\N	\N	2026-01-11 16:12:17.873938	8eb2ee4d-feb4-49c1-ab43-8db14a096190	777faedd-67f5-4fd7-8a62-06a817661dc7	2026-01-11 16:12:17.873938
71	\N	\N	\N	2026-01-11 16:12:19.361548	6cd8d943-7689-482b-87bc-48a4140aa292	15f620e6-3735-4210-adcc-fbe008224a37	2026-01-11 16:12:19.361548
72	\N	\N	\N	2026-01-11 16:12:20.872748	053dde9a-c115-468a-96e7-19e94ba9b8e1	9af8022d-d4be-4dd5-83ee-af697c9c6226	2026-01-11 16:12:20.872748
73	\N	\N	\N	2026-01-11 16:12:22.390044	a52c7d1a-bdbe-4c71-a155-e8cc34228a97	1f3ad948-6778-43e5-ad17-088637e9f190	2026-01-11 16:12:22.390044
74	\N	\N	\N	2026-01-11 16:12:23.91395	46f8ed83-053d-412e-bd48-ad0baffb300a	7087c212-2e04-4f42-8034-bb8c425ae589	2026-01-11 16:12:23.91395
75	\N	\N	\N	2026-01-11 16:12:25.514625	2ae07f59-12d5-4e92-8534-3b546dac47ec	6d9d9b89-4874-4e32-b999-05fed832e7e8	2026-01-11 16:12:25.514625
76	\N	\N	\N	2026-01-11 16:13:58.683731	b9d49614-e485-4d4c-9c12-fcf8c03f5ead	a0063b98-3914-4f99-87cc-10c1003b93c1	2026-01-11 16:13:58.683731
77	\N	\N	\N	2026-01-11 16:13:58.686959	01d8b9c6-966a-454a-838b-37988a722987	caa1dbe3-0caf-4514-ab8f-043dfcdafad1	2026-01-11 16:13:58.686959
78	\N	\N	\N	2026-01-11 16:13:58.696929	997388a7-c5c1-4b68-ada3-a744e27d7437	a3908618-270c-4c38-84f0-85662e9c3d93	2026-01-11 16:13:58.696929
79	\N	\N	\N	2026-01-11 16:13:58.70357	3a84e1dd-186b-49f4-af6d-cb6aa9a55c3b	b0d8e3b0-99d9-49db-b80e-da6701371135	2026-01-11 16:13:58.70357
80	\N	\N	\N	2026-01-11 16:14:09.683781	90cf43e7-f582-480b-9abd-fea2215662eb	7a3a55d4-a8cd-4df7-9f70-3a5d7a038b55	2026-01-11 16:14:09.683781
81	\N	\N	\N	2026-01-11 16:14:13.415182	3dcb57a1-b927-44fe-8c20-c026f83d184d	10fb9b60-23a4-461e-8dbd-0a72ae55ee75	2026-01-11 16:14:13.415182
82	\N	\N	\N	2026-01-11 16:14:18.170822	7a57eb81-1c26-47dc-ab46-cdcac1270cf8	9bc87557-81ae-455e-9c7f-0684beaef50a	2026-01-11 16:14:18.170822
83	\N	\N	\N	2026-01-11 16:14:22.387994	02ec8ee4-ac27-4cec-9f13-0c720cbb8892	0f5bafc5-51a0-4f8c-aca9-0b5de7682602	2026-01-11 16:14:22.387994
84	\N	\N	\N	2026-01-11 16:14:26.332196	7052bb73-0b2e-4cfd-b6fe-21cfe8e04073	12a67e90-eafe-43fd-a40c-0227623489d4	2026-01-11 16:14:26.332196
85	\N	\N	\N	2026-01-11 16:14:30.085648	1f6a7b4b-acd0-4f32-b8c0-cc65639cdcb2	6cca0181-93df-491e-b0b3-67c1a00857d3	2026-01-11 16:14:30.085648
86	\N	\N	\N	2026-01-11 16:14:38.208781	ba80b8fe-319c-447f-af10-a46e76463d9b	9835f964-3ffe-4772-8067-bb9021468ed1	2026-01-11 16:14:38.208781
87	\N	\N	\N	2026-01-11 16:14:42.683586	1f4d9b9f-02da-4d9e-a9ae-6e8a3fadf55d	e7690bea-6c45-4a95-9b79-3ec50bc633b9	2026-01-11 16:14:42.683586
88	\N	\N	\N	2026-01-11 16:14:46.19576	f8046826-16c3-4263-a88d-dbdd5a841a37	039de42a-c5a2-4cc4-8690-d0418b068ef4	2026-01-11 16:14:46.19576
89	\N	\N	\N	2026-01-11 16:14:51.726689	ad677874-f3c5-46b8-afa9-6cd05462d9ad	350340d2-e426-4144-a5e6-3c56d67754d8	2026-01-11 16:14:51.726689
90	\N	\N	\N	2026-01-11 16:14:56.802733	a8720370-53fd-4541-8e37-8cbd1183dec8	73e82219-5949-4d28-b756-815d92025d5d	2026-01-11 16:14:56.802733
91	\N	\N	\N	2026-01-11 16:14:56.815586	48c18648-e94b-4e04-880c-8ad2fa79087a	22ab27d3-3ce3-4830-8964-70d4a03dfe6e	2026-01-11 16:14:56.815586
92	\N	\N	\N	2026-01-11 16:18:41.558513	c05a337b-837b-4351-97a1-441415fcf454	25f50d6b-b5c3-4def-a4d7-4c02c399c1c2	2026-01-11 16:18:41.558513
93	\N	\N	\N	2026-01-11 16:18:50.156923	40120917-e0e4-4f1f-b26e-ff588ff61faa	eec64105-dbeb-45ed-981b-d186ca1536d6	2026-01-11 16:18:50.156923
94	\N	\N	\N	2026-01-11 16:19:03.400167	77ea4c05-8fe3-40c6-b3fd-77e22d63404c	e40e448d-6269-445a-9dd7-9a2871f9e9f2	2026-01-11 16:19:03.400167
95	\N	\N	\N	2026-01-11 16:19:44.615508	68ea693a-d1da-4d66-85ce-8444ad5f0dbf	c3298657-33e9-43b4-8ee8-d94807bcba52	2026-01-11 16:19:44.615508
96	\N	\N	\N	2026-01-11 16:19:44.66912	1d225a53-a288-491d-a7ef-7c8ee5e45a65	ce1512ac-c14b-433d-b23c-a29b88c60f9e	2026-01-11 16:19:44.66912
97	\N	\N	\N	2026-01-11 16:19:44.710076	cc3f7fc8-9532-4aaa-8900-32cad667ab65	044f70c9-6393-4aa0-b9d7-bff30f0c88a8	2026-01-11 16:19:44.710076
98	\N	\N	\N	2026-01-11 16:19:44.78683	e2b3a961-83c2-46fa-b3cf-7138597f967e	34b00aa1-e23b-44a0-9979-3dc6b810f52e	2026-01-11 16:19:44.78683
99	\N	\N	\N	2026-01-11 16:20:43.093566	911007a2-ab6e-4a7c-b0da-fa913db32fae	e829c71f-5dfd-4bfb-a7b6-21d0c7bda54c	2026-01-11 16:20:43.093566
100	\N	\N	\N	2026-01-11 16:20:43.1047	e08e33e5-ea57-4ad9-85e2-12ec0c3787da	6a39f599-76a9-4e88-b40b-34ebe3a12cc6	2026-01-11 16:20:43.1047
101	\N	\N	\N	2026-01-11 16:20:43.524996	8a4caf57-b2b4-4d11-88f2-5c1056318aea	fd50f9b0-1dfa-48ea-a004-910c741311c6	2026-01-11 16:20:43.524996
102	\N	\N	\N	2026-01-11 16:20:43.526603	0c943d7b-a6f3-43f2-8cac-2a510fd2195c	3ae7c827-4cfd-4eb3-b0f9-453237b87fcd	2026-01-11 16:20:43.526603
103	\N	\N	\N	2026-01-11 16:20:43.629336	176f14ee-afd6-4881-aa22-19ec976a8ecc	06c0def7-56d2-48c4-a4b7-df36072914c4	2026-01-11 16:20:43.629336
104	\N	\N	\N	2026-01-11 16:20:43.630588	891150ea-8cb0-4f35-9575-68aa9023b6dc	de6b5ec6-7143-438f-a42c-44aea7c73bd5	2026-01-11 16:20:43.630588
105	\N	\N	\N	2026-01-11 16:20:43.710395	f6cd1745-b357-4596-8bd6-0c57f30a0d5e	28b654f1-2925-46ad-9745-fa84aab729d8	2026-01-11 16:20:43.710395
106	\N	\N	\N	2026-01-11 16:20:43.714001	f267f273-0040-4cdb-8d34-a8519e961b96	8f0eabdd-de68-42f7-9ad0-aa0099b94651	2026-01-11 16:20:43.714001
107	\N	\N	\N	2026-01-11 16:20:46.80937	b2bd71e4-8a87-4f0a-be81-d4cd9f1bc06e	53a09cfc-0dca-455c-b66e-8eecaf92f74c	2026-01-11 16:20:46.80937
108	\N	\N	\N	2026-01-11 16:20:46.812706	b54e5ee0-21f1-40d8-9a15-ca64f3bbb898	0877a805-5a7c-4991-9c70-07d8df88ab5b	2026-01-11 16:20:46.812706
109	\N	\N	\N	2026-01-11 16:20:47.150435	865f15cd-9a92-47c2-9baa-f5d61b5cafde	25a7e27b-4233-4d20-861d-3649a1d25e60	2026-01-11 16:20:47.150435
110	\N	\N	\N	2026-01-11 16:20:47.334586	c4a5e80e-161f-4c2f-bfdb-015692b8e3a0	5f4a179a-59a8-4cf2-8a18-ade8e975d727	2026-01-11 16:20:47.334586
111	\N	\N	\N	2026-01-11 16:20:47.444656	274d7834-3cb5-4aab-a641-2635a7e705f3	0ae3d635-01df-4ae1-8638-95738130a9a4	2026-01-11 16:20:47.444656
112	\N	\N	\N	2026-01-11 16:20:48.879105	88c9a3ab-6ac7-4c9c-bf99-b8b2859368b7	5c75bde0-c9a9-4a7c-9409-10c72093b6cf	2026-01-11 16:20:48.879105
113	\N	\N	\N	2026-01-11 16:20:48.882654	675883ae-523f-43eb-88b5-ddc57aac7fd3	3229550c-e0ee-46a2-b28f-46a4f0614ad1	2026-01-11 16:20:48.882654
114	\N	\N	\N	2026-01-11 16:20:49.073099	4596ef9a-24f8-4d96-99cf-77b641dd99c9	cd9b6db8-0bf8-4c2d-b7b8-cbf87a5663a3	2026-01-11 16:20:49.073099
115	\N	\N	\N	2026-01-11 16:20:49.073905	f679d127-78b3-4ffa-a7e6-ba2f48c34fcd	10e7c140-b7f2-49a0-8d2d-a874eea9f144	2026-01-11 16:20:49.073905
116	\N	\N	\N	2026-01-11 16:34:47.601836	5925d496-dc60-49dd-8d39-b35879023319	83040f7e-3936-4c28-a8d6-ec7cd0f208f4	2026-01-11 16:34:47.601836
117	\N	\N	\N	2026-01-11 16:56:00.582133	c8858985-7fdc-4844-9d45-9231a85774e7	cc942d7c-89e4-4081-adf1-2c34466e49e2	2026-01-11 16:56:00.582133
118	\N	\N	\N	2026-01-11 16:57:02.68054	a436710d-a702-4d32-9999-4c14f30a4b8b	e723a331-08a2-421a-adf6-505e0b2a822d	2026-01-11 16:57:02.68054
119	\N	\N	\N	2026-01-11 16:57:02.705997	e6fb8d66-f214-426e-ada7-88960178b303	df6266c9-38b6-49dc-b448-bb6cada39a05	2026-01-11 16:57:02.705997
120	\N	\N	\N	2026-01-11 16:57:02.748151	a7df425c-d6f1-4a3b-8fca-ec3244cd9cab	910895f5-4a8b-42f6-8f2c-7bf2abaa4784	2026-01-11 16:57:02.748151
121	\N	\N	\N	2026-01-11 16:57:02.801656	8debacd5-dc9a-4bcc-98c4-ffa19abcfb68	a370d6f8-7231-4f61-b698-6b820384aef3	2026-01-11 16:57:02.801656
122	\N	\N	\N	2026-01-11 16:57:02.806275	37bdc6ce-2663-421c-8608-f52c32c0fcc3	1cf3c493-e1b0-4855-986e-051251ac1052	2026-01-11 16:57:02.806275
123	\N	\N	\N	2026-01-11 16:57:02.817032	477f62f8-1b75-48fa-9c32-27805998d798	04599d12-513a-4adb-bacc-a89c65a2fdde	2026-01-11 16:57:02.817032
124	\N	\N	\N	2026-01-11 16:57:02.872643	ddd6c3bf-efa8-4c09-a8a0-960b750950fd	a4cd64e6-c75b-4cc9-8bbb-2bead69cdb92	2026-01-11 16:57:02.872643
125	\N	\N	\N	2026-01-11 16:57:02.938537	b09d7765-8088-4a8f-8824-f3f5fde17178	9a9d09f7-2152-449f-ba5c-c542174d68e0	2026-01-11 16:57:02.938537
126	\N	\N	\N	2026-01-11 16:57:05.762579	2de6bba5-f13b-4c1f-acb5-e5bc73c7dfc7	18b12f83-d514-4d85-9a62-cfad146175e1	2026-01-11 16:57:05.762579
127	\N	\N	\N	2026-01-11 16:57:05.776557	fbf00276-31e6-41c8-b612-2cd8a25573e3	746d4ea3-b3c9-4290-af52-580eaae451c9	2026-01-11 16:57:05.776557
128	\N	\N	\N	2026-01-11 16:57:05.886132	89f0e540-b3a7-4861-8e26-8f76aa361235	2b51ee32-a83c-4fee-8cb0-42664bb5adae	2026-01-11 16:57:05.886132
129	\N	\N	\N	2026-01-11 16:57:05.990278	911fb1f5-159a-4c98-a6f4-2f1df3e3966e	e42ae75e-dee4-45bf-af4f-e2456a676b70	2026-01-11 16:57:05.990278
130	\N	\N	\N	2026-01-11 16:57:06.140038	2341b2c2-50eb-4538-8825-f44e154947a0	9fe6f1be-51a0-4e7a-88b2-56e37581c5ae	2026-01-11 16:57:06.140038
131	\N	\N	\N	2026-01-11 16:57:07.081166	e15a6a34-a57c-4e1f-b614-0f1f6c9190a9	89c768c8-827d-4011-a7a0-1da37b156819	2026-01-11 16:57:07.081166
132	\N	\N	\N	2026-01-11 16:57:07.083595	4a68ae0f-d332-450d-a3f1-5205b6ed79ca	d44c8703-b2d6-45dd-850c-9528e48ce4ee	2026-01-11 16:57:07.083595
133	\N	\N	\N	2026-01-11 16:57:07.09817	7524f3f6-ca5b-4d6a-bc5a-381d83516948	aab3f8a3-c422-42b2-aee9-5ae744da672d	2026-01-11 16:57:07.09817
134	\N	\N	\N	2026-01-11 16:57:07.098475	a8bd9cb4-6001-49ec-9458-e1cdd036d9e9	702ef13e-9ab9-4137-be1c-d8dd9e6d23bc	2026-01-11 16:57:07.098475
135	\N	\N	\N	2026-01-12 15:11:07.766152	364b4f65-9b6a-4a66-89d9-618b9733f93c	deca47bf-3475-4774-a91f-aa751925972d	2026-01-12 15:11:07.766152
136	\N	\N	\N	2026-01-13 14:39:17.929342	00f79ff7-144f-400f-a1b0-ccc4cc5e473e	89e5ad47-7031-47dd-9aef-52f663ad6c45	2026-01-13 14:39:17.929342
137	\N	\N	\N	2026-01-13 15:17:10.757398	2bed11e4-4895-4802-861a-f83381f2e7c3	1292bd68-cffa-4ee7-b2a2-8f9f67796e9c	2026-01-13 15:17:10.757398
138	\N	\N	\N	2026-01-13 15:17:11.389752	bbe8478a-f604-424d-ad85-7e1a63b28e86	8d507267-9ff1-4d36-94bb-e767aab8f9a7	2026-01-13 15:17:11.389752
139	\N	\N	\N	2026-01-14 12:19:47.015913	8379f8cb-f87f-48af-97a0-6e49068fea04	e22c3646-64e1-4ab0-991c-5f07327e7a9c	2026-01-14 12:19:47.015913
140	\N	\N	\N	2026-01-14 12:24:18.419871	e1a812bc-1331-4c6f-95a3-b98d977ee3c5	0582242c-7aa2-4c03-b429-ff65fbc8225d	2026-01-14 12:24:18.419871
141	\N	\N	\N	2026-01-14 12:24:27.789752	44989954-d044-4b00-829e-6ff7626d3e56	cc35b1dc-ab9e-4a3a-adf9-d4d0db48a140	2026-01-14 12:24:27.789752
142	\N	\N	\N	2026-01-14 12:25:18.774861	b9b2d9b3-b1a9-4cf6-9d9d-5f1ca2f3d349	40242706-f3f0-4784-99ee-ec1d05c5330c	2026-01-14 12:25:18.774861
143	\N	\N	\N	2026-01-14 12:25:32.080991	6306d930-c0b3-4427-82e0-ba79ae3f3a44	9f89a86f-445d-49df-ab36-bf0f5cf51507	2026-01-14 12:25:32.080991
144	\N	\N	\N	2026-01-14 12:25:32.390881	a17930b3-eaa1-4e1b-b081-e7553e19ef5c	306a37df-7c1f-46e1-bf12-7fef0b2dbdf7	2026-01-14 12:25:32.390881
145	\N	\N	\N	2026-01-14 12:26:46.999505	416e2fcc-6723-4055-b9d2-0dcce11669f2	d4ca4a50-d425-4c24-b6a0-96bf5a13f597	2026-01-14 12:26:46.999505
\.


--
-- Data for Name: vocabulary_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vocabulary_categories (id, uuid, name_fa, name_en, description_fa, description_en, icon, created_at) FROM stdin;
1	b194bcd6-c99b-4b16-b8b4-8c3adf7e00d0	لغات ضروری کنکور	Essential Konkur Words	لغات پرتکرار در آزمون‌های کنکور	Frequently used words in Konkur exams	book	2026-01-11 14:15:06.239372
2	3ffaf23f-0648-4f69-b129-4b742094077c	لغات آکادمیک	Academic Words	لغات آکادمیک برای متون دانشگاهی	Academic words for university texts	graduation-cap	2026-01-11 14:15:06.239372
3	10216f3d-ced1-4761-8e5b-4d6212432104	لغات روزمره	Everyday Words	لغات کاربردی روزمره	Practical everyday vocabulary	chat	2026-01-11 14:15:06.239372
4	cf8acc00-e291-40af-ad80-21d10272dd9c	آیلتس سطح ۷	IELTS Band 7	لغات پیشرفته برای نمره آیلتس ۷	Advanced vocabulary for IELTS Band 7	🎯	2026-01-11 16:02:24.312984
5	a93fd83b-b87d-4a12-9eaf-a3e97c96605d	مهندسی کامپیوتر	Computer Engineering	اصطلاحات تخصصی مهندسی کامپیوتر	Computer Engineering terminology	💻	2026-01-12 15:43:42.530724
\.


--
-- Data for Name: vocabulary_quiz_results; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vocabulary_quiz_results (id, user_id, word_id, quiz_type, correct, response_time_ms, created_at) FROM stdin;
1	136	2	meaning	f	2500	2026-01-13 14:40:51.390009
\.


--
-- Data for Name: vocabulary_words; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vocabulary_words (id, uuid, category_id, word_en, meaning_fa, pronunciation, example_en, example_fa, difficulty, created_at) FROM stdin;
1	25821bf3-fb0c-4be4-bdb8-eaef338f927f	1	abandon	ترک کردن، رها کردن	/əˈbændən/	He decided to abandon the project.	او تصمیم گرفت پروژه را رها کند.	2	2026-01-11 14:15:06.247007
2	34784dc2-0d46-4519-8597-02153b49f69e	1	ability	توانایی، قابلیت	/əˈbɪləti/	She has the ability to solve complex problems.	او توانایی حل مسائل پیچیده را دارد.	1	2026-01-11 14:15:06.247007
3	637a518f-9e72-4ef6-bace-e4975cfe1e44	1	abstract	انتزاعی، مجرد	/ˈæbstrækt/	Abstract art is hard to understand.	هنر انتزاعی سخت قابل درک است.	3	2026-01-11 14:15:06.247007
4	92cb419f-164c-4e9f-9f45-05346d0c76aa	1	abundant	فراوان، زیاد	/əˈbʌndənt/	The forest has abundant wildlife.	جنگل حیات وحش فراوانی دارد.	2	2026-01-11 14:15:06.247007
5	40f5b740-ce76-45f2-bea5-568f0da9d26a	1	accomplish	به انجام رساندن، موفق شدن	/əˈkɑːmplɪʃ/	She accomplished all her goals.	او به تمام اهدافش رسید.	2	2026-01-11 14:15:06.247007
6	0b46c13b-d38e-4371-8966-8090ea2e650e	1	accurate	دقیق، صحیح	/ˈækjərət/	The data must be accurate.	داده‌ها باید دقیق باشند.	2	2026-01-11 14:15:06.247007
7	61954ca7-e57b-4396-9f02-efa990ca9d73	1	achieve	دست یافتن، رسیدن	/əˈtʃiːv/	Work hard to achieve success.	سخت کار کن تا به موفقیت برسی.	1	2026-01-11 14:15:06.247007
8	7ab86518-e283-4653-bd18-c16c38f3457a	1	acknowledge	تصدیق کردن، پذیرفتن	/əkˈnɒlɪdʒ/	He acknowledged his mistake.	او اشتباهش را پذیرفت.	3	2026-01-11 14:15:06.247007
9	fd5bcbec-bbce-46f9-a4ad-97d7d5a7822c	1	acquire	به دست آوردن، کسب کردن	/əˈkwaɪər/	She acquired new skills.	او مهارت‌های جدیدی کسب کرد.	2	2026-01-11 14:15:06.247007
10	c4675290-4cd6-48cd-9f78-9ded87fa2bb7	1	adapt	سازگار شدن، تطبیق دادن	/əˈdæpt/	Animals adapt to their environment.	حیوانات با محیط خود سازگار می‌شوند.	2	2026-01-11 14:15:06.247007
11	703224f0-b11c-420c-9d6e-449556934d29	2	analyze	تجزیه و تحلیل کردن	/ˈænəlaɪz/	Scientists analyze the data carefully.	دانشمندان داده‌ها را با دقت تجزیه و تحلیل می‌کنند.	2	2026-01-11 14:15:06.247007
12	179b2672-1f52-499f-ac3a-1ab748954f9d	2	approach	رویکرد، نزدیک شدن	/əˈproʊtʃ/	We need a new approach to this problem.	ما به رویکرد جدیدی برای این مسئله نیاز داریم.	2	2026-01-11 14:15:06.247007
13	f0c02e89-ec6f-4049-ab3f-9514d86b52c1	2	assume	فرض کردن، گمان کردن	/əˈsuːm/	Don't assume anything without evidence.	بدون مدرک چیزی را فرض نکن.	2	2026-01-11 14:15:06.247007
14	cd2121c9-2a2b-4ee9-bcb6-aeab8bddc748	2	benefit	سود، فایده	/ˈbenɪfɪt/	Exercise has many health benefits.	ورزش فواید سلامتی زیادی دارد.	1	2026-01-11 14:15:06.247007
15	e2e03bd1-9bac-4f54-b2e1-3b2af1dc6f06	2	concept	مفهوم، ایده	/ˈkɒnsept/	The concept is difficult to grasp.	درک این مفهوم دشوار است.	2	2026-01-11 14:15:06.247007
16	b3b1d445-d2e6-4396-93a6-4508a26b4bf6	3	appreciate	قدردانی کردن	/əˈpriːʃieɪt/	I appreciate your help.	از کمکت قدردانی می‌کنم.	1	2026-01-11 14:15:06.247007
17	85f6547e-e79a-437d-9982-a05f5c89b9cf	3	convenient	راحت، مناسب	/kənˈviːniənt/	The location is very convenient.	موقعیت مکانی بسیار مناسب است.	2	2026-01-11 14:15:06.247007
18	0bc3d935-71ae-4d95-862f-27dc5c9fa070	3	essential	ضروری، اساسی	/ɪˈsenʃəl/	Water is essential for life.	آب برای زندگی ضروری است.	2	2026-01-11 14:15:06.247007
19	a4efefc5-924f-48aa-8d89-e73da940b084	3	familiar	آشنا	/fəˈmɪliər/	This place looks familiar.	این مکان آشنا به نظر می‌رسد.	1	2026-01-11 14:15:06.247007
20	761a0c8a-97fb-42f2-8765-14f6af8d9d8c	3	significant	مهم، قابل توجه	/sɪɡˈnɪfɪkənt/	This is a significant achievement.	این یک دستاورد مهم است.	2	2026-01-11 14:15:06.247007
21	8952b046-f73c-45d9-a54e-2483d67804bb	4	paved	سنگفرش شده، آسفالت شده	/peɪvd/	The road was newly paved.	جاده تازه آسفالت شده بود.	3	2026-01-11 16:02:24.320015
22	286384a5-a9a5-485d-bf7e-8d85ca8b7f71	4	robust	قوی، محکم، مقاوم	/roʊˈbʌst/	A robust economy can withstand crises.	یک اقتصاد قوی می‌تواند در برابر بحران‌ها مقاومت کند.	3	2026-01-11 16:02:24.320015
23	be46a819-f311-40a6-bc13-df49e52bbff9	4	influential	تأثیرگذار، بانفوذ	/ˌɪnfluˈenʃəl/	She is one of the most influential leaders.	او یکی از تأثیرگذارترین رهبران است.	3	2026-01-11 16:02:24.320015
24	e8a7ed17-990c-4e2f-b412-69bb704d18a8	4	fidelity	وفاداری، صداقت	/fɪˈdeləti/	The fidelity of the translation was impressive.	وفاداری ترجمه قابل توجه بود.	4	2026-01-11 16:02:24.320015
25	f0f554c0-701b-471b-85da-e70442353c46	4	delicate	ظریف، حساس	/ˈdelɪkət/	The situation requires delicate handling.	این وضعیت نیاز به رسیدگی حساس دارد.	3	2026-01-11 16:02:24.320015
26	31804808-7a7a-4e57-99af-fd5ec2aca5ad	4	amplitude	دامنه، وسعت	/ˈæmplɪtuːd/	The amplitude of the wave determines its energy.	دامنه موج انرژی آن را تعیین می‌کند.	4	2026-01-11 16:02:24.320015
27	b9d1e7f1-482b-499c-a917-9e818856903c	4	exquisitely	به طرز زیبایی، بی‌نظیر	/ɪkˈskwɪzɪtli/	The dish was exquisitely prepared.	غذا به طرز بی‌نظیری آماده شده بود.	4	2026-01-11 16:02:24.320015
28	e8a4d432-2b36-49ba-9fec-84b0f1a14ef0	4	implicit	ضمنی، مستتر	/ɪmˈplɪsɪt/	There was an implicit understanding between them.	یک درک ضمنی بین آنها وجود داشت.	3	2026-01-11 16:02:24.320015
29	a01786d8-43ab-43a4-846d-af18d678468f	4	optimism	خوش‌بینی	/ˈɑːptɪmɪzəm/	Despite the challenges, she maintained her optimism.	علی‌رغم چالش‌ها، او خوش‌بینی خود را حفظ کرد.	2	2026-01-11 16:02:24.320015
30	0d373e5c-0cf8-42d2-a9e2-0a10f9202ef1	4	rhetorical	بلاغی، سخنورانه	/rɪˈtɔːrɪkəl/	It was a rhetorical question.	این یک سوال بلاغی بود.	4	2026-01-11 16:02:24.320015
31	f087ed96-e2f6-498c-a6db-c56b4bc3c1ad	4	conservative	محافظه‌کار، سنتی	/kənˈsɜːrvətɪv/	The bank took a conservative approach.	بانک رویکرد محافظه‌کارانه‌ای اتخاذ کرد.	3	2026-01-11 16:02:24.320015
32	bfa4ca23-c694-46a4-b059-6c4bf2744fd8	4	skim	سرسری خواندن، بررسی سریع	/skɪm/	I only had time to skim the report.	فقط وقت داشتم گزارش را سرسری بخوانم.	2	2026-01-11 16:02:24.320015
33	8ed0ea70-15e0-43fd-8830-063aa543081e	4	inference	استنباط، نتیجه‌گیری	/ˈɪnfərəns/	Based on the data, we can draw an inference.	بر اساس داده‌ها، می‌توانیم استنباط کنیم.	3	2026-01-11 16:02:24.320015
34	550c0286-a7bb-402f-a781-fab408b49ccc	4	coined	ابداع شده، ساخته شده	/kɔɪnd/	The term was coined in the 19th century.	این اصطلاح در قرن نوزدهم ابداع شد.	3	2026-01-11 16:02:24.320015
35	559df410-9ac7-447a-8331-56fec2e060a8	4	foresee	پیش‌بینی کردن	/fɔːrˈsiː/	No one could foresee the outcome.	هیچ‌کس نمی‌توانست نتیجه را پیش‌بینی کند.	3	2026-01-11 16:02:24.320015
36	c338aa3b-e15e-4b9b-81a6-ab710bb2e23e	4	intellect	هوش، خرد	/ˈɪntəlekt/	Her intellect is truly remarkable.	هوش او واقعاً قابل توجه است.	3	2026-01-11 16:02:24.320015
37	21064b7e-8ab5-44ed-a470-ef044ae33df5	4	emergence	ظهور، پیدایش	/ɪˈmɜːrdʒəns/	The emergence of new technology changed everything.	ظهور فناوری جدید همه چیز را تغییر داد.	3	2026-01-11 16:02:24.320015
38	ec5cb5b8-5303-4b5c-a70c-9dd75c64c7c4	4	ameliorate	بهبود بخشیدن	/əˈmiːliəreɪt/	Efforts to ameliorate the situation were underway.	تلاش‌ها برای بهبود وضعیت در جریان بود.	5	2026-01-11 16:02:24.320015
39	349a253e-9703-4a71-80ba-90f2d124ed55	4	deteriorate	بدتر شدن، زوال یافتن	/dɪˈtɪriəreɪt/	His health began to deteriorate rapidly.	سلامتی او به سرعت شروع به زوال کرد.	4	2026-01-11 16:02:24.320015
40	6aab0bce-c7a5-41c0-b04b-0143a9a80394	4	solemnize	رسمی برگزار کردن	/ˈsɑːləmnaɪz/	The marriage was solemnized in a church.	ازدواج در کلیسا رسمی برگزار شد.	5	2026-01-11 16:02:24.320015
41	811c7880-2ac1-4ac4-add5-2f0e475abe16	4	petrify	متحیر کردن، سنگ کردن	/ˈpetrɪfaɪ/	The news seemed to petrify everyone.	به نظر می‌رسید این خبر همه را متحیر کرد.	4	2026-01-11 16:02:24.320015
42	0359553a-372c-4242-b4fa-8ca1b7b64586	4	restraint	خویشتن‌داری، محدودیت	/rɪˈstreɪnt/	He showed remarkable restraint in the situation.	او در این وضعیت خویشتن‌داری قابل توجهی نشان داد.	3	2026-01-11 16:02:24.320015
43	3b70480d-3989-4c6c-a700-610d95d9bc47	4	quarrel	دعوا، نزاع	/ˈkwɔːrəl/	They had a quarrel over money.	آنها بر سر پول دعوا کردند.	2	2026-01-11 16:02:24.320015
44	760f6a45-48ee-4773-9a75-2f97b2c75d05	4	prevail	غالب شدن، پیروز شدن	/prɪˈveɪl/	Justice will prevail in the end.	در نهایت عدالت پیروز خواهد شد.	3	2026-01-11 16:02:24.320015
45	ceed16ef-98ea-4922-821c-10ed36676bb4	4	auspicious	خوش‌یمن، فرخنده	/ɔːˈspɪʃəs/	It was an auspicious start to the year.	این شروع خوش‌یمنی برای سال بود.	4	2026-01-11 16:02:24.320015
46	314437c0-9151-4e3c-9a1a-e1ce76be588d	4	stirring	هیجان‌انگیز، تحریک‌کننده	/ˈstɜːrɪŋ/	The speech was stirring and memorable.	سخنرانی هیجان‌انگیز و به یاد ماندنی بود.	3	2026-01-11 16:02:24.320015
47	40081328-97db-464a-a183-f4187a53b8e9	4	edifying	آموزنده، روشنگر	/ˈedɪfaɪɪŋ/	It was an edifying experience.	این یک تجربه آموزنده بود.	4	2026-01-11 16:02:24.320015
48	e83d0b3c-d9e3-41f0-a528-d8048500daf5	4	feeble	ضعیف، ناتوان	/ˈfiːbl/	His feeble attempt at humor fell flat.	تلاش ضعیف او برای شوخی بی‌اثر بود.	3	2026-01-11 16:02:24.320015
49	8256efee-506b-4232-9920-8a4e375f99db	4	divest	محروم کردن، سلب کردن	/daɪˈvest/	The company decided to divest its assets.	شرکت تصمیم گرفت دارایی‌هایش را واگذار کند.	5	2026-01-11 16:02:24.320015
50	86ca8ff6-19a5-4f34-9b16-e4aadebc06f1	4	foster	پرورش دادن، تقویت کردن	/ˈfɔːstər/	The program aims to foster creativity.	این برنامه هدفش پرورش خلاقیت است.	3	2026-01-11 16:02:24.320015
51	531dcabc-a55b-4dcb-80c0-66163a20e156	4	deception	فریب، دغل	/dɪˈsepʃn/	The deception was eventually uncovered.	در نهایت فریب آشکار شد.	3	2026-01-11 16:02:24.320015
52	7eda4502-2f00-425d-8ac7-2b78602b60e8	4	animosity	دشمنی، خصومت	/ˌænɪˈmɑːsəti/	There was no animosity between them.	هیچ دشمنی بین آنها وجود نداشت.	4	2026-01-11 16:02:24.320015
53	ae45c3d4-a7ae-4db8-8a85-8fa41ec7ae4f	4	idyllic	آرام، رویایی	/aɪˈdɪlɪk/	They lived in an idyllic countryside cottage.	آنها در کلبه‌ای رویایی در حومه شهر زندگی می‌کردند.	4	2026-01-11 16:02:24.320015
54	a49fb238-a56d-4bb8-bf86-dd4b604f44ac	4	sparked	جرقه زدن، برانگیختن	/spɑːrkt/	The debate sparked a nationwide discussion.	این بحث یک گفتگوی سراسری را برانگیخت.	2	2026-01-12 15:10:41.443042
55	90995bd0-884c-4ede-9a79-dbf4dc85c73d	4	serendipity	شانس، اتفاق خوش‌یمن	/ˌserənˈdɪpəti/	Finding this job was pure serendipity.	پیدا کردن این شغل کاملاً شانسی بود.	4	2026-01-12 15:10:41.443042
56	6a5cd187-919b-4e5d-a173-316e243361f0	4	tranquility	آرامش، سکوت	/træŋˈkwɪləti/	The tranquility of the countryside relaxed me.	آرامش روستا مرا آرام کرد.	3	2026-01-12 15:10:41.443042
57	9a37f1da-7d2f-4706-bcf1-12424dfdcbcd	4	aspersion	تهمت، بدنامی	/əˈspɜːrʒən/	He cast aspersions on her character.	او به شخصیت او تهمت زد.	5	2026-01-12 15:10:41.443042
58	585354be-d2fe-42d2-a00c-9234f93e3d05	4	euphoria	سرخوشی، شادمانی شدید	/juːˈfɔːriə/	The team felt euphoria after winning.	تیم بعد از برد احساس سرخوشی کرد.	3	2026-01-12 15:10:41.443042
59	4061a422-8387-4a63-b784-9d51dd77f16b	4	vigorous	پرانرژی، قوی	/ˈvɪɡərəs/	She took a vigorous walk every morning.	او هر صبح پیاده‌روی پرانرژی داشت.	2	2026-01-12 15:10:41.443042
60	23720987-6e56-4db9-abf5-7c5df9aae8de	4	reckless	بی‌پروا، بی‌احتیاط	/ˈrekləs/	His reckless driving caused an accident.	رانندگی بی‌احتیاط او باعث تصادف شد.	2	2026-01-12 15:10:41.443042
61	841da3ef-3ae7-4e02-9694-a78ecfdf478a	4	haphazard	بی‌نظم، تصادفی	/hæpˈhæzərd/	The books were arranged in a haphazard manner.	کتاب‌ها به صورت بی‌نظم چیده شده بودند.	4	2026-01-12 15:10:41.443042
62	39defdf1-a4b0-4ac1-b95d-c01c5f1378f1	4	tray	سینی	/treɪ/	She carried the drinks on a tray.	او نوشیدنی‌ها را روی سینی حمل کرد.	1	2026-01-12 15:10:41.443042
63	43f07769-65fa-41c1-9008-823ea54949bc	4	guise	ظاهر، لباس مبدل	/ɡaɪz/	He appeared in the guise of a doctor.	او در لباس پزشک ظاهر شد.	4	2026-01-12 15:10:41.443042
64	a48e3111-81cb-43ce-bf6f-0b0e7e03ce32	4	paramount	بسیار مهم، عالی‌ترین	/ˈpærəmaʊnt/	Safety is of paramount importance.	ایمنی از اهمیت بسیار بالایی برخوردار است.	3	2026-01-12 15:10:41.443042
65	868b70e7-9e5f-4c97-811b-26449883d9dc	4	eventually	سرانجام، در نهایت	/ɪˈventʃuəli/	Eventually, he found what he was looking for.	سرانجام، او آنچه را که می‌خواست پیدا کرد.	1	2026-01-12 15:10:41.443042
66	e8d58403-5a7c-460d-a142-331b1c249ab3	4	sentimentality	احساساتی بودن	/ˌsentɪmenˈtæləti/	The movie was full of sentimentality.	فیلم پر از احساسات بود.	4	2026-01-12 15:10:41.443042
67	eeffdfce-2fe4-4ba9-b7c6-ae06e1e56f85	4	dime	سکه ده سنتی	/daɪm/	It costs only a dime.	فقط یک سکه ده سنتی هزینه دارد.	2	2026-01-12 15:10:41.443042
68	527de672-cc0f-46a5-8d22-449667458cd6	4	contrary	برعکس، مخالف	/ˈkɒntrəri/	Contrary to popular belief, it is false.	برخلاف باور عمومی، این غلط است.	2	2026-01-12 15:10:41.443042
69	2a098baf-cf71-4fa9-9a9f-afd309f589c1	4	dispute	اختلاف، مناقشه	/dɪˈspjuːt/	There was a dispute over the contract.	بر سر قرارداد اختلاف وجود داشت.	2	2026-01-12 15:10:41.443042
70	d5858c80-f747-46b8-928f-e45aeaab2ded	4	withheld	خودداری کردن، نگه داشتن	/wɪðˈheld/	Information was withheld from the public.	اطلاعات از عموم پنهان نگه داشته شد.	3	2026-01-12 15:10:41.443042
71	a3dc86fa-3787-490d-8167-ff172a18d400	4	legislative	قانون‌گذاری، مقننه	/ˈledʒɪslətɪv/	The legislative branch makes laws.	قوه مقننه قوانین را وضع می‌کند.	3	2026-01-12 15:10:41.443042
72	fabf20d2-3607-402a-8cea-298c27d1caf0	4	judicial	قضایی	/dʒuːˈdɪʃəl/	The judicial system needs reform.	سیستم قضایی نیاز به اصلاح دارد.	3	2026-01-12 15:10:41.443042
73	e628dd19-a536-4043-b02d-b5a7fdeb7c80	4	quarrel	دعوا، مشاجره	/ˈkwɒrəl/	They had a quarrel over money.	آن‌ها بر سر پول دعوا کردند.	2	2026-01-12 15:10:41.443042
74	870faed8-e3d0-4a89-af7f-bd1ec4ffa0d2	4	roamed	پرسه زدن، گشتن	/rəʊmd/	The children roamed the streets.	بچه‌ها در خیابان‌ها پرسه می‌زدند.	2	2026-01-12 15:10:41.443042
75	81bbb1dc-c925-4189-8fff-4c991bc44312	5	glitter	درخشیدن، زرق و برق	/ˈɡlɪtər/	The new UI design glitters with modern effects.	طراحی رابط کاربری جدید با جلوه‌های مدرن می‌درخشد.	2	2026-01-12 15:43:42.530724
76	e3cb41d0-d885-4143-ba6b-c361ae203171	5	luster	درخشندگی، جلا	/ˈlʌstər/	The code lost its luster after poor refactoring.	کد پس از بازسازی ضعیف درخشندگی خود را از دست داد.	3	2026-01-12 15:43:42.530724
77	1fec3780-f00c-4e95-a145-5417698cad17	5	conspicuous	آشکار، بارز، مشهود	/kənˈspɪkjuəs/	The bug was conspicuous in the error logs.	باگ در لاگ‌های خطا کاملاً مشهود بود.	3	2026-01-12 15:43:42.530724
78	a0350f5a-202a-44a5-bcf4-b8336d594f24	5	conferred	اعطا کردن، مشورت کردن	/kənˈfɜːrd/	The degree was conferred upon completion of the thesis.	مدرک پس از اتمام پایان‌نامه اعطا شد.	3	2026-01-12 15:43:42.530724
79	124e7aeb-af44-45c9-8ebd-ecc16be6e188	5	equivocated	مبهم صحبت کردن، طفره رفتن	/ɪˈkwɪvəkeɪtɪd/	The documentation equivocated on the API behavior.	مستندات در مورد رفتار API مبهم بود.	4	2026-01-12 15:43:42.530724
80	a7858b62-f192-40e1-a0b9-7835cfc46f97	5	attained	دست یافتن، رسیدن به	/əˈteɪnd/	The algorithm attained optimal performance.	الگوریتم به عملکرد بهینه دست یافت.	2	2026-01-12 15:43:42.530724
81	e60ed091-e4c4-47c5-b724-f53147be1316	5	fabricated	ساختگی، جعلی، ساخته شده	/ˈfæbrɪkeɪtɪd/	The test data was fabricated for simulation.	داده‌های تست برای شبیه‌سازی ساخته شدند.	2	2026-01-12 15:43:42.530724
82	d6137c8b-0e77-4873-b0ad-fbf7ba233bcb	5	compulsory	اجباری، الزامی	/kəmˈpʌlsəri/	Error handling is compulsory in production code.	مدیریت خطا در کد تولید الزامی است.	2	2026-01-12 15:43:42.530724
83	4c34406c-0624-4570-a4aa-ffe0bb7d3112	5	tuition	شهریه، آموزش	/tjuːˈɪʃən/	Online tuition for programming has increased.	آموزش آنلاین برنامه‌نویسی افزایش یافته است.	2	2026-01-12 15:43:42.530724
84	d780ab6a-71f0-4429-ba77-d0e689028651	5	offspring	فرزند، نتیجه، محصول	/ˈɒfsprɪŋ/	Child processes are offspring of the parent process.	پردازه‌های فرزند محصول پردازه والد هستند.	3	2026-01-12 15:43:42.530724
85	8eefcd4c-06de-4eb3-bdde-ccb9c8b8b216	5	debate	بحث، مناظره	/dɪˈbeɪt/	There is ongoing debate about microservices vs monolith.	بحث مداومی درباره میکروسرویس‌ها در برابر مونولیت وجود دارد.	1	2026-01-12 15:43:42.530724
86	0de773e9-d4c0-4f9e-b51a-be39372c0d0e	5	esoteric	پیچیده، تخصصی، مبهم	/ˌesəˈterɪk/	The kernel code contains esoteric optimizations.	کد کرنل شامل بهینه‌سازی‌های تخصصی و پیچیده است.	4	2026-01-12 15:43:42.530724
87	626d8b92-b11d-444d-84d4-b9d5f29f3140	5	unanimous	متفق‌القول، یکپارچه	/juːˈnænɪməs/	The team was unanimous in choosing React.	تیم در انتخاب React متفق‌القول بود.	3	2026-01-12 15:43:42.530724
88	f1fbebbe-8b9a-4ad6-aa0c-11a512a66a91	5	pervasive	فراگیر، همه‌جاگیر	/pərˈveɪsɪv/	Cloud computing has become pervasive in enterprises.	رایانش ابری در شرکت‌ها فراگیر شده است.	3	2026-01-12 15:43:42.530724
89	d1e00694-cbb7-4e34-9daa-6c6e228c7949	5	iteration	تکرار، دور (در حلقه)	/ˌɪtəˈreɪʃən/	Each iteration of the loop processes one element.	هر تکرار حلقه یک عنصر را پردازش می‌کند.	2	2026-01-12 15:43:42.530724
90	f90b94e9-9c74-48f2-b163-45db9c1bb1d1	5	iteration bug	باگ تکرار (خطای حلقه)	/ˌɪtəˈreɪʃən bʌɡ/	Off-by-one is a common iteration bug.	خطای یک واحد کم یا زیاد یک باگ تکرار رایج است.	3	2026-01-12 15:43:42.530724
91	d7dde61c-8e81-4b9a-afaa-6e677d527208	5	possessed	دارا بودن، در اختیار داشتن	/pəˈzest/	The object possessed all required attributes.	شیء تمام ویژگی‌های مورد نیاز را دارا بود.	2	2026-01-12 15:43:42.530724
92	a9afdc9c-12f0-48c1-9327-2ac003205556	5	anomalies	ناهنجاری‌ها، موارد غیرعادی	/əˈnɒməliz/	The system detected anomalies in network traffic.	سیستم ناهنجاری‌هایی در ترافیک شبکه شناسایی کرد.	3	2026-01-12 15:43:42.530724
93	8115a2aa-1cfd-4907-8416-53025cabf761	5	arise	بروز کردن، پدید آمدن	/əˈraɪz/	Race conditions arise in concurrent programming.	شرایط رقابتی در برنامه‌نویسی همزمان بروز می‌کند.	2	2026-01-12 15:43:42.530724
94	ae6d8a67-7b68-4afd-b308-17a1c5ee8ff1	5	prevalent	رایج، شایع، غالب	/ˈprevələnt/	SQL injection is still prevalent in web apps.	تزریق SQL هنوز در برنامه‌های وب رایج است.	3	2026-01-12 15:43:42.530724
95	2068f68a-3e95-48d3-8623-33a07d8c8824	5	perilous	خطرناک، پرمخاطره	/ˈperələs/	Deploying without tests is perilous.	استقرار بدون تست خطرناک است.	3	2026-01-12 15:43:42.530724
96	01a9db7c-9880-4f27-bb75-8bfb4cd3193e	5	distinct	متمایز، مجزا، واضح	/dɪˈstɪŋkt/	Each microservice has a distinct responsibility.	هر میکروسرویس مسئولیت متمایزی دارد.	2	2026-01-12 15:43:42.530724
97	6f93046a-4f92-49cf-9a4e-644ac06d42aa	5	dominated	تسلط داشتن، غالب بودن	/ˈdɒmɪneɪtɪd/	Python dominated the data science field.	پایتون بر حوزه علم داده تسلط یافت.	2	2026-01-12 15:43:42.530724
98	5d654588-d816-42b0-8eb2-05a0936bef10	5	solidly	محکم، استوار، به طور قوی	/ˈsɒlɪdli/	The architecture is solidly designed.	معماری به طور محکم طراحی شده است.	2	2026-01-12 15:43:42.530724
99	99d3ed69-df66-4627-9486-0ad981f7b981	5	associates	همکاران، شرکا	/əˈsəʊʃieɪts/	Research associates contributed to the paper.	همکاران تحقیقاتی در مقاله مشارکت کردند.	2	2026-01-12 15:43:42.530724
100	8dab13bc-92e1-46cc-91fd-f3f1f1853043	5	pioneering	پیشگامانه، نوآورانه	/ˌpaɪəˈnɪərɪŋ/	Google did pioneering work in distributed systems.	گوگل کار پیشگامانه‌ای در سیستم‌های توزیع‌شده انجام داد.	3	2026-01-12 15:43:42.530724
101	aae446b9-eadc-4a03-ad8a-2b0d52efda98	5	firm	شرکت، محکم، قاطع	/fɜːrm/	The tech firm developed innovative solutions.	شرکت فناوری راه‌حل‌های نوآورانه توسعه داد.	1	2026-01-12 15:43:42.530724
102	bd4892b7-9491-4075-af43-c353d8d841a3	5	gleaned	جمع‌آوری کردن، استخراج کردن	/ɡliːnd/	Insights were gleaned from the log analysis.	بینش‌ها از تحلیل لاگ استخراج شدند.	3	2026-01-12 15:43:42.530724
103	7f0541bd-7a47-48d8-8c2b-2b96ebee8820	2	insure	بیمه کردن، تضمین کردن	/ɪnˈʃʊr/	We must insure the shipment against damage.	باید محموله را در برابر آسیب بیمه کنیم.	2	2026-01-13 13:09:16.395326
104	9f95a288-8571-4db8-9220-3b5249bcb664	2	projections	پیش‌بینی‌ها، تخمین‌ها	/prəˈdʒekʃənz/	Sales projections for next year are optimistic.	پیش‌بینی‌های فروش برای سال آینده خوش‌بینانه است.	3	2026-01-13 13:09:16.395326
105	c1358b0e-c59d-4b8a-8812-0030b760a2a2	2	inclinations	تمایلات، گرایش‌ها	/ˌɪnklɪˈneɪʃənz/	He has strong inclinations toward research.	او تمایل شدیدی به تحقیق دارد.	3	2026-01-13 13:09:16.395326
106	cc2563dc-007b-4583-b03c-5ccec6f0a731	2	interventions	مداخلات، دخالت‌ها	/ˌɪntərˈvenʃənz/	Medical interventions saved many lives.	مداخلات پزشکی جان بسیاری را نجات داد.	3	2026-01-13 13:09:16.395326
107	3e80bfdc-7d84-4e17-8733-698bfadf985d	2	premises	مفروضات، محل	/ˈpremɪsɪz/	The argument is based on false premises.	این استدلال بر مفروضات غلط استوار است.	3	2026-01-13 13:09:16.395326
108	f70ec1d6-e688-448b-8631-b52017d1a8d8	2	exonerated	تبرئه شده، مبرا	/ɪɡˈzɒnəreɪtɪd/	The defendant was exonerated of all charges.	متهم از تمام اتهامات تبرئه شد.	4	2026-01-13 13:09:16.395326
109	333a5f28-3acc-4135-86bf-ecb62abd7de8	2	intensified	تشدید شده، شدت یافته	/ɪnˈtensɪfaɪd/	The conflict intensified over time.	درگیری با گذشت زمان تشدید شد.	2	2026-01-13 13:09:16.395326
110	0de74226-3964-4e57-bd26-5e7641973dbe	2	prosecuted	تحت پیگرد قرار گرفته	/ˈprɒsɪkjuːtɪd/	He was prosecuted for fraud.	او به اتهام کلاهبرداری تحت پیگرد قرار گرفت.	3	2026-01-13 13:09:16.395326
111	350d81fc-6f52-4720-9ae8-b9b1487c72da	2	legitimized	مشروعیت بخشیده، قانونی شده	/lɪˈdʒɪtɪmaɪzd/	The election legitimized the new government.	انتخابات به دولت جدید مشروعیت بخشید.	4	2026-01-13 13:09:16.395326
112	917dfceb-ce68-4227-97ba-a36686a5ffaf	2	inflammatory	تحریک‌آمیز، التهابی	/ɪnˈflæmətəri/	His inflammatory speech caused riots.	سخنرانی تحریک‌آمیز او باعث شورش شد.	3	2026-01-13 13:09:16.395326
113	5eeea041-c455-45e1-83c8-31a8538dad39	2	exacerbating	تشدیدکننده، بدتر کننده	/ɪɡˈzæsərbeɪtɪŋ/	Pollution is exacerbating health problems.	آلودگی مشکلات سلامتی را تشدید می‌کند.	4	2026-01-13 13:09:16.395326
114	29a1fe05-9cfa-4fab-98b0-d07be777c5ce	2	dispelling	از بین بردن، رفع کردن	/dɪˈspelɪŋ/	The evidence succeeded in dispelling doubts.	شواهد در رفع تردیدها موفق شد.	3	2026-01-13 13:09:16.395326
115	bd753b4c-c6be-47cb-8e68-7b89bb91ef90	2	affirming	تأیید کردن، اثبات کردن	/əˈfɜːrmɪŋ/	The court ruling is affirming our position.	حکم دادگاه موضع ما را تأیید می‌کند.	2	2026-01-13 13:09:16.395326
116	52548d8a-1b69-4fc8-9860-91301aa13e30	2	captivated	مجذوب، شیفته	/ˈkæptɪveɪtɪd/	The audience was captivated by her performance.	تماشاگران مجذوب اجرای او شدند.	2	2026-01-13 13:09:16.395326
117	9250ca31-940d-473d-b036-1a9808214492	2	superseded	جایگزین شده، منسوخ	/ˌsuːpərˈsiːdɪd/	The old law was superseded by new regulations.	قانون قدیمی با مقررات جدید جایگزین شد.	4	2026-01-13 13:09:16.395326
118	02da697d-5a02-466b-99ac-78574c656be0	2	commenced	آغاز شده، شروع شده	/kəˈmenst/	The trial commenced last Monday.	محاکمه دوشنبه گذشته آغاز شد.	2	2026-01-13 13:09:16.395326
119	5873a426-53fa-4dea-9aa9-5823c7fa2c67	2	aesthetic	زیبایی‌شناختی، هنری	/esˈθetɪk/	The building has great aesthetic value.	این ساختمان ارزش زیبایی‌شناختی بالایی دارد.	3	2026-01-13 13:09:16.395326
120	ee138394-74d8-4c9e-a552-accf6675620b	2	unforeseen	پیش‌بینی نشده، غیرمنتظره	/ˌʌnfɔːrˈsiːn/	Unforeseen circumstances delayed the project.	شرایط پیش‌بینی نشده پروژه را به تأخیر انداخت.	2	2026-01-13 13:09:16.395326
121	2d280900-66a7-4b0c-b761-e1802a035a43	2	altruistic	نوع‌دوستانه، فداکارانه	/ˌæltruˈɪstɪk/	Her motives were purely altruistic.	انگیزه‌های او کاملاً نوع‌دوستانه بود.	4	2026-01-13 13:09:16.395326
122	393e2f38-e3e0-40ed-842f-ed283703f4fa	2	incipient	نوپا، در مراحل اولیه	/ɪnˈsɪpiənt/	We detected the incipient signs of disease.	ما نشانه‌های اولیه بیماری را تشخیص دادیم.	5	2026-01-13 13:09:16.395326
123	41fbfda0-7b42-4936-8f3a-b7f169cb3c4d	2	skeptical	شکاک، مشکوک	/ˈskeptɪkəl/	Scientists remain skeptical about the claims.	دانشمندان نسبت به این ادعاها شکاک هستند.	2	2026-01-13 13:09:16.395326
124	4a7d1bb9-4a99-489d-8113-5086a8991e1e	2	ambiguous	مبهم، دوپهلو	/æmˈbɪɡjuəs/	The contract language is ambiguous.	زبان قرارداد مبهم است.	3	2026-01-13 13:09:16.395326
125	a86be2fb-bf25-4422-b373-285ad7cfd257	2	credible	معتبر، قابل باور	/ˈkredɪbəl/	She is a credible witness.	او شاهد معتبری است.	2	2026-01-13 13:09:16.395326
126	75f06f09-1be7-4730-8b04-08f645ee503c	2	disorderly	بی‌نظم، آشفته	/dɪsˈɔːrdərli/	The protest became disorderly.	اعتراض آشفته شد.	2	2026-01-13 13:09:16.395326
127	1e516791-901e-4e0e-8f7a-a08d889d9d1d	2	apparent	آشکار، ظاهری	/əˈpærənt/	The cause of failure is apparent.	علت شکست آشکار است.	2	2026-01-13 13:09:16.395326
128	b8b0054b-002b-4403-807e-e53d97069f83	2	comprehension	درک، فهم	/ˌkɒmprɪˈhenʃən/	Reading comprehension is a key skill.	درک مطلب یک مهارت کلیدی است.	2	2026-01-13 13:09:16.395326
129	e2040a43-28c9-464d-b157-8ac08d514e84	2	misspellings	غلط‌های املایی	/ˌmɪsˈspelɪŋz/	The essay contained many misspellings.	مقاله شامل غلط‌های املایی زیادی بود.	2	2026-01-13 13:09:16.395326
130	1a3b1531-5266-41aa-84dd-b57f781f5403	2	morphological	ریخت‌شناختی، صرفی	/ˌmɔːrfəˈlɒdʒɪkəl/	Morphological analysis reveals word structure.	تحلیل ریخت‌شناختی ساختار کلمه را نشان می‌دهد.	4	2026-01-13 13:09:16.395326
131	3a6d646f-eb92-4bc3-87fd-a099ef926a87	2	lexicon	واژگان، لغت‌نامه	/ˈleksɪkɒn/	The lexicon of medicine is vast.	واژگان پزشکی بسیار گسترده است.	3	2026-01-13 13:09:16.395326
132	39c5929d-e0ed-46a7-a3c1-88dfce9bfaed	2	consecutive	متوالی، پشت سر هم	/kənˈsekjʊtɪv/	He won three consecutive matches.	او سه مسابقه متوالی را برد.	2	2026-01-13 13:09:16.395326
133	90313d5b-6624-4269-aee2-e72c22619745	2	orthographical	املایی، نگارشی	/ˌɔːrθəˈɡræfɪkəl/	Orthographical rules vary by language.	قواعد املایی در هر زبان متفاوت است.	4	2026-01-13 13:09:16.395326
134	71f1054d-fb07-46a9-b9fb-0af1f6eb3a6c	2	hence	از این رو، بنابراین	/hens/	He was tired, hence the mistakes.	او خسته بود، از این رو اشتباهات رخ داد.	2	2026-01-13 13:09:16.395326
135	75a31104-be91-44f9-9f22-fb59b13a1673	2	derivative	مشتق، اقتباسی	/dɪˈrɪvətɪv/	This word is a derivative of Latin.	این کلمه مشتق از لاتین است.	3	2026-01-13 13:09:16.395326
136	6ba507a0-d910-4462-8e74-9c4dad16741a	2	stem	ریشه، ساقه	/stem/	The stem of the word reveals its origin.	ریشه کلمه منشأ آن را نشان می‌دهد.	2	2026-01-13 13:09:16.395326
137	794de41c-d9f9-4ef3-b827-3522f3b9188a	2	concatenated	الحاق شده، به هم پیوسته	/kənˈkætəneɪtɪd/	The strings were concatenated into one.	رشته‌ها به یکدیگر الحاق شدند.	4	2026-01-13 13:09:16.395326
138	574ffc08-6168-4665-9271-699e39690a95	2	plenty	فراوان، زیاد	/ˈplenti/	There is plenty of time left.	زمان زیادی باقی مانده است.	1	2026-01-13 13:09:16.395326
139	7a046728-2f0e-44f9-8fc4-1a20a0a8e727	2	stated	بیان شده، اظهار شده	/steɪtɪd/	As stated earlier, the deadline is Friday.	همانطور که قبلاً بیان شد، مهلت جمعه است.	1	2026-01-13 13:09:16.395326
140	9a08651f-2527-4f63-a39f-d918fa4876dc	2	distorted	تحریف شده، مخدوش	/dɪˈstɔːrtɪd/	The media distorted the facts.	رسانه‌ها حقایق را تحریف کردند.	2	2026-01-13 13:09:16.395326
141	ee760b5b-32a5-4cf0-824b-086a0d3a9e20	2	expenditure	هزینه، مخارج	/ɪkˈspendɪtʃər/	Government expenditure has increased.	هزینه‌های دولت افزایش یافته است.	3	2026-01-13 13:09:16.395326
142	97643660-bbcf-47a0-a752-ef979a336258	2	twofold	دوگانه، دو برابر	/ˈtuːfəʊld/	The benefits are twofold.	مزایا دوگانه است.	2	2026-01-13 13:09:16.395326
143	e6a96007-8831-4796-b6d1-393183ed6907	2	perception	درک، ادراک	/pərˈsepʃən/	Public perception of the issue changed.	درک عمومی از این موضوع تغییر کرد.	2	2026-01-13 13:09:16.395326
144	60c09ec6-3c7c-4a6c-b865-7b9f44829258	2	disciplinary	انضباطی، تنبیهی	/ˈdɪsəplɪnəri/	He faced disciplinary action.	او با اقدام انضباطی مواجه شد.	3	2026-01-13 13:09:16.395326
145	1469fad2-5e8c-4092-bc58-3dcd2b967aad	2	linguistics	زبان‌شناسی	/lɪŋˈɡwɪstɪks/	She studied linguistics at university.	او در دانشگاه زبان‌شناسی خواند.	3	2026-01-13 13:09:16.395326
146	b8f4fe48-3b2f-46f4-9fb9-4258871cfd10	2	granted	اعطا شده، مسلم	/ˈɡræntɪd/	Permission was granted immediately.	مجوز فوراً اعطا شد.	2	2026-01-13 13:09:16.395326
147	6ea3d7fc-8583-4c26-9194-249dfd97c022	2	inherent	ذاتی، درونی	/ɪnˈhɪərənt/	There are inherent risks in surgery.	خطرات ذاتی در جراحی وجود دارد.	3	2026-01-13 13:09:16.395326
148	92ee1658-ea1c-4817-ad4f-48fba02b01e0	2	implied	ضمنی، تلویحی	/ɪmˈplaɪd/	The contract has implied obligations.	قرارداد تعهدات ضمنی دارد.	2	2026-01-13 13:09:16.395326
149	76e63723-7c5d-4c7d-b656-544b1daecf93	2	yardstick	معیار، ملاک	/ˈjɑːrdstɪk/	Profit is not the only yardstick of success.	سود تنها معیار موفقیت نیست.	3	2026-01-13 13:09:16.395326
150	752c8696-7740-4712-bfc7-ea8bc0ff395f	2	unprecedented	بی‌سابقه، بی‌نظیر	/ʌnˈpresɪdentɪd/	The crisis reached an unprecedented scale.	بحران به مقیاسی بی‌سابقه رسید.	3	2026-01-13 13:09:16.395326
151	dd47eea6-2205-4106-9095-fd4bf752a6f0	2	weigh	سنجیدن، وزن کردن	/weɪ/	We must weigh the pros and cons.	باید مزایا و معایب را بسنجیم.	2	2026-01-13 13:09:16.395326
\.


--
-- Name: attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.attempts_id_seq', 1, false);


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.courses_id_seq', 17, true);


--
-- Name: exams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.exams_id_seq', 15, true);


--
-- Name: fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fields_id_seq', 8, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.questions_id_seq', 63, true);


--
-- Name: review_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.review_schedule_id_seq', 1, false);


--
-- Name: topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.topics_id_seq', 13, true);


--
-- Name: user_streaks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_streaks_id_seq', 44, true);


--
-- Name: user_vocabulary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_vocabulary_id_seq', 103, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 145, true);


--
-- Name: vocabulary_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.vocabulary_categories_id_seq', 5, true);


--
-- Name: vocabulary_quiz_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.vocabulary_quiz_results_id_seq', 1, true);


--
-- Name: vocabulary_words_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.vocabulary_words_id_seq', 151, true);


--
-- Name: attempts attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_pkey PRIMARY KEY (id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: fields fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fields
    ADD CONSTRAINT fields_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: review_schedule review_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_schedule
    ADD CONSTRAINT review_schedule_pkey PRIMARY KEY (id);


--
-- Name: review_schedule review_schedule_user_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_schedule
    ADD CONSTRAINT review_schedule_user_id_question_id_key UNIQUE (user_id, question_id);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: user_streaks user_streaks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_streaks
    ADD CONSTRAINT user_streaks_pkey PRIMARY KEY (id);


--
-- Name: user_streaks user_streaks_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_streaks
    ADD CONSTRAINT user_streaks_user_id_key UNIQUE (user_id);


--
-- Name: user_vocabulary user_vocabulary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocabulary
    ADD CONSTRAINT user_vocabulary_pkey PRIMARY KEY (id);


--
-- Name: user_vocabulary user_vocabulary_user_id_word_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocabulary
    ADD CONSTRAINT user_vocabulary_user_id_word_id_key UNIQUE (user_id, word_id);


--
-- Name: users users_client_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_client_id_key UNIQUE (client_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vocabulary_categories vocabulary_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_categories
    ADD CONSTRAINT vocabulary_categories_pkey PRIMARY KEY (id);


--
-- Name: vocabulary_categories vocabulary_categories_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_categories
    ADD CONSTRAINT vocabulary_categories_uuid_key UNIQUE (uuid);


--
-- Name: vocabulary_quiz_results vocabulary_quiz_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_quiz_results
    ADD CONSTRAINT vocabulary_quiz_results_pkey PRIMARY KEY (id);


--
-- Name: vocabulary_words vocabulary_words_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_words
    ADD CONSTRAINT vocabulary_words_pkey PRIMARY KEY (id);


--
-- Name: vocabulary_words vocabulary_words_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_words
    ADD CONSTRAINT vocabulary_words_uuid_key UNIQUE (uuid);


--
-- Name: idx_attempts_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attempts_created ON public.attempts USING btree (created_at);


--
-- Name: idx_attempts_question; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attempts_question ON public.attempts USING btree (question_id);


--
-- Name: idx_attempts_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attempts_user ON public.attempts USING btree (user_id);


--
-- Name: idx_attempts_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_attempts_uuid ON public.attempts USING btree (uuid);


--
-- Name: idx_courses_field; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_courses_field ON public.courses USING btree (field_id);


--
-- Name: idx_courses_name_fa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_courses_name_fa ON public.courses USING btree (name_fa);


--
-- Name: idx_courses_name_fa_field; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_courses_name_fa_field ON public.courses USING btree (name_fa, field_id);


--
-- Name: idx_courses_name_fa_field_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_courses_name_fa_field_unique ON public.courses USING btree (name_fa, field_id);


--
-- Name: idx_courses_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_courses_uuid ON public.courses USING btree (uuid);


--
-- Name: idx_exams_field; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exams_field ON public.exams USING btree (field_id);


--
-- Name: idx_exams_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_exams_uuid ON public.exams USING btree (uuid);


--
-- Name: idx_exams_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exams_year ON public.exams USING btree (year);


--
-- Name: idx_fields_name_fa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fields_name_fa ON public.fields USING btree (name_fa);


--
-- Name: idx_fields_name_fa_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_fields_name_fa_unique ON public.fields USING btree (name_fa);


--
-- Name: idx_fields_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_fields_uuid ON public.fields USING btree (uuid);


--
-- Name: idx_questions_course; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_course ON public.questions USING btree (course_id);


--
-- Name: idx_questions_exam; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_exam ON public.questions USING btree (exam_id);


--
-- Name: idx_questions_topic; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_topic ON public.questions USING btree (topic_id);


--
-- Name: idx_questions_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_questions_uuid ON public.questions USING btree (uuid);


--
-- Name: idx_quiz_results_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quiz_results_date ON public.vocabulary_quiz_results USING btree (created_at);


--
-- Name: idx_quiz_results_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quiz_results_user ON public.vocabulary_quiz_results USING btree (user_id);


--
-- Name: idx_quiz_results_word; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quiz_results_word ON public.vocabulary_quiz_results USING btree (word_id);


--
-- Name: idx_review_next; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_review_next ON public.review_schedule USING btree (next_review);


--
-- Name: idx_review_schedule_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_review_schedule_uuid ON public.review_schedule USING btree (uuid);


--
-- Name: idx_review_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_review_user ON public.review_schedule USING btree (user_id);


--
-- Name: idx_topics_course; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_topics_course ON public.topics USING btree (course_id);


--
-- Name: idx_topics_name_fa_course_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_topics_name_fa_course_unique ON public.topics USING btree (name_fa, course_id);


--
-- Name: idx_topics_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_topics_uuid ON public.topics USING btree (uuid);


--
-- Name: idx_user_streaks_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_streaks_user ON public.user_streaks USING btree (user_id);


--
-- Name: idx_user_vocab_next_review; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_vocab_next_review ON public.user_vocabulary USING btree (next_review);


--
-- Name: idx_user_vocab_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_vocab_status ON public.user_vocabulary USING btree (user_id, status);


--
-- Name: idx_user_vocab_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_vocab_user ON public.user_vocabulary USING btree (user_id);


--
-- Name: idx_user_vocab_user_next; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_vocab_user_next ON public.user_vocabulary USING btree (user_id, next_review);


--
-- Name: idx_users_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_client_id ON public.users USING btree (client_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_users_uuid ON public.users USING btree (uuid);


--
-- Name: idx_vocab_words_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vocab_words_category ON public.vocabulary_words USING btree (category_id);


--
-- Name: idx_vocab_words_difficulty; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vocab_words_difficulty ON public.vocabulary_words USING btree (difficulty);


--
-- Name: attempts attempts_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: attempts attempts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: courses courses_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.fields(id);


--
-- Name: exams exams_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.fields(id);


--
-- Name: questions questions_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: questions questions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: questions questions_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: review_schedule review_schedule_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_schedule
    ADD CONSTRAINT review_schedule_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: review_schedule review_schedule_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_schedule
    ADD CONSTRAINT review_schedule_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: topics topics_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: user_streaks user_streaks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_streaks
    ADD CONSTRAINT user_streaks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_vocabulary user_vocabulary_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocabulary
    ADD CONSTRAINT user_vocabulary_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_vocabulary user_vocabulary_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocabulary
    ADD CONSTRAINT user_vocabulary_word_id_fkey FOREIGN KEY (word_id) REFERENCES public.vocabulary_words(id) ON DELETE CASCADE;


--
-- Name: vocabulary_quiz_results vocabulary_quiz_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_quiz_results
    ADD CONSTRAINT vocabulary_quiz_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: vocabulary_quiz_results vocabulary_quiz_results_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_quiz_results
    ADD CONSTRAINT vocabulary_quiz_results_word_id_fkey FOREIGN KEY (word_id) REFERENCES public.vocabulary_words(id) ON DELETE CASCADE;


--
-- Name: vocabulary_words vocabulary_words_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocabulary_words
    ADD CONSTRAINT vocabulary_words_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.vocabulary_categories(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

