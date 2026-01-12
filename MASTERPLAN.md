# MDP - Master Development Plan

## Project Overview
**MDP (Master's Degree Prep)** - A Persian/RTL educational platform for Iranian students preparing for master's degree entrance exams (Konkur).

## Tech Stack
- **Frontend**: Next.js 16.1.1, React 19, TypeScript, Tailwind CSS
- **Backend**: Go + Fiber, PostgreSQL
- **Testing**: Playwright
- **Deployment**: GitHub Actions, Self-hosted runner

## Design Guidelines
- **Direction**: RTL (Right-to-Left) for Persian content
- **Primary Colors**: Blue-500/600 for actions, Gray-50 backgrounds
- **Cards**: White, rounded-lg, border-gray-200, shadow-sm on hover
- **Typography**: Vazirmatn font family
- **Consistency**: All pages use Header component, min-h-screen bg-gray-50

---

## Phases & Status

### Phase 1: Core Question Bank [COMPLETED]
- [x] Database schema for fields, courses, topics, questions
- [x] REST API endpoints for browsing questions
- [x] Quiz generation and answer checking
- [x] Fields/Courses/Topics navigation pages
- [x] Question display with RTL support

### Phase 2: Vocabulary Flashcard System [COMPLETED]
- [x] Database tables: vocabulary_categories, vocabulary_words, user_vocabulary, user_streaks
- [x] SM-2 spaced repetition algorithm implementation
- [x] Flashcard UI with flip animation
- [x] Rating buttons (Again, Hard, Good, Easy) in Persian
- [x] Progress tracking (XP, streak, words learned)
- [x] Cookie-based user identification (before auth)
- [x] RTL/Persian vocabulary page
- [x] Header navigation icon (BookOpen)
- [x] IELTS Band 7 vocabulary (33 words)
- [x] Playwright tests (12/12 passing)

### Phase 3: Vocabulary Quiz & Card Management [COMPLETED]
- [x] Quiz Mode
  - [x] Multiple choice quiz (show English, pick Persian meaning)
  - [x] Reverse quiz (show Persian, pick English word)
  - [x] Quiz results tracking in database
  - [x] XP rewards for quiz performance (bonus for fast answers)
  - [x] Quiz UI page at /vocabulary/quiz
- [x] Card Management
  - [x] Suspend card (hide for 30 days)
  - [x] Bury card (skip until tomorrow)
  - [x] Delete from personal queue
  - [x] Restore suspended/deleted cards
  - [x] CardActions component in flashcard UI
  - [x] Database tracking of card status with status_until timestamps

### Phase 4: User Authentication [PLANNED]
- [ ] User registration/login
- [ ] Migrate cookie-based data to authenticated user
- [ ] Profile page with learning statistics
- [ ] Password reset functionality

### Phase 5: Advanced Features [PLANNED]
- [ ] Leaderboards
- [ ] Daily challenges
- [ ] Achievement badges
- [ ] Social sharing
- [ ] Mobile-responsive optimizations

---

## Database Schema

### Current Tables
```
users (id, email, name, password_hash, client_id, uuid)
vocabulary_categories (id, uuid, name_fa, name_en, description, icon)
vocabulary_words (id, uuid, category_id, word_en, meaning_fa, pronunciation, examples, difficulty)
user_vocabulary (id, user_id, word_id, easiness, interval_days, repetitions, next_review, status)
user_streaks (id, user_id, current_streak, longest_streak, total_xp, reviews_today)
vocabulary_quiz_results (id, user_id, word_id, quiz_type, correct, answered_at) [NEW]
```

### Card Status Values
- `active` - Normal review cycle
- `suspended` - Hidden for 30 days
- `buried` - Hidden until tomorrow
- `deleted` - Removed from user's queue

---

## API Endpoints

### Vocabulary (Existing)
- GET /api/v1/vocabulary/categories
- GET /api/v1/vocabulary/words
- GET /api/v1/vocabulary/study
- POST /api/v1/vocabulary/review
- GET /api/v1/vocabulary/stats

### Vocabulary Quiz & Card Actions (Phase 3)
- GET /api/v1/vocabulary/quiz?type=meaning|word&count=10
- POST /api/v1/vocabulary/quiz/answer
- POST /api/v1/vocabulary/card/action (body: {word_id, action: suspend|bury|delete|restore})
- GET /api/v1/vocabulary/card/suspended

---

## File Structure
```
frontend/
├── src/
│   ├── app/
│   │   ├── vocabulary/
│   │   │   ├── page.tsx        # Flashcard practice
│   │   │   └── quiz/page.tsx   # Quiz mode [NEW]
│   ├── components/
│   │   ├── vocabulary/
│   │   │   ├── FlashCard.tsx
│   │   │   ├── VocabularyStats.tsx
│   │   │   ├── VocabQuiz.tsx   # [NEW]
│   │   │   └── CardActions.tsx # [NEW]
│   └── lib/api.ts

backend/
├── cmd/api/main.go
├── internal/
│   ├── handlers/vocabulary.go
│   ├── repository/vocabulary.go
│   └── models/models.go
└── migrations/
    ├── 012_create_vocabulary_tables.sql
    ├── 013_add_client_id_and_vocabulary.sql
    └── 014_vocabulary_quiz_and_status.sql [NEW]
```
