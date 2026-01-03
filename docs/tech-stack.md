# MDP Tech Stack Recommendation

## Overview
Modern, fast, and user-friendly tech stack for Konkur Arshad preparation platform.

---

## Recommended Stack

```
┌─────────────────────────────────────────────────────────────┐
│                        FRONTEND                              │
│  Next.js 14+ │ shadcn/ui │ Tailwind CSS │ Framer Motion     │
├─────────────────────────────────────────────────────────────┤
│                        BACKEND                               │
│  Go (Gin/Fiber) │ REST API │ JWT Auth │ Redis Cache         │
├─────────────────────────────────────────────────────────────┤
│                        DATABASE                              │
│  PostgreSQL │ Meilisearch (search) │ Redis (cache/sessions) │
├─────────────────────────────────────────────────────────────┤
│                     INFRASTRUCTURE                           │
│  Docker │ GitHub Actions │ Nginx │ Cloudflare CDN           │
└─────────────────────────────────────────────────────────────┘
```

---

## Frontend Stack

### Core: Next.js 14+ (App Router)
```
Why: SSR + SSG, fast, SEO-friendly, React ecosystem
```

### UI Components: shadcn/ui + Tailwind CSS
```
Why:
- Modern, accessible components
- Full customization (you own the code)
- RTL support for Persian
- Beautiful by default
```

**Key Libraries:**
| Library | Purpose |
|---------|---------|
| `shadcn/ui` | Base components (buttons, cards, dialogs) |
| `tailwindcss` | Utility-first CSS |
| `tailwindcss-rtl` | RTL support for Persian |
| `framer-motion` | Smooth animations |
| `lucide-react` | Icons |
| `recharts` | Progress charts |
| `react-hook-form` | Form handling |
| `zod` | Validation |

### Example Component Structure:
```
src/
├── components/
│   ├── ui/           # shadcn components
│   ├── quiz/         # Quiz-specific components
│   ├── progress/     # Progress tracking
│   └── layout/       # Header, Footer, Sidebar
├── app/
│   ├── (auth)/       # Login, Register
│   ├── (dashboard)/  # User dashboard
│   ├── exams/        # Past exams browser
│   ├── quiz/         # Quiz taking
│   └── progress/     # Progress tracking
└── lib/
    ├── api.ts        # API client
    └── utils.ts      # Helpers
```

---

## Backend Stack

### Core: Go with Gin or Fiber
```
Why:
- Blazing fast (handles thousands of concurrent users)
- Simple to deploy (single binary)
- Great for APIs
- Low memory usage
```

**Recommended: Fiber** (Express-like syntax, fastest)

### Key Libraries:
| Library | Purpose |
|---------|---------|
| `gofiber/fiber` | Web framework |
| `golang-jwt/jwt` | JWT authentication |
| `go-playground/validator` | Request validation |
| `jackc/pgx` | PostgreSQL driver |
| `redis/go-redis` | Redis client |
| `swaggo/swag` | API documentation |

### API Structure:
```
cmd/
├── api/
│   └── main.go           # Entry point
internal/
├── handlers/             # HTTP handlers
│   ├── auth.go
│   ├── exam.go
│   ├── quiz.go
│   └── progress.go
├── models/               # Data models
├── repository/           # Database queries
├── services/             # Business logic
│   └── spaced_repetition.go
└── middleware/           # Auth, logging, CORS
pkg/
├── config/               # Configuration
└── utils/                # Helpers
```

---

## Database

### Primary: PostgreSQL
```
Why:
- Reliable, battle-tested
- Great for structured data (exams, questions, users)
- Full-text search in Persian
- JSON support for flexible fields
```

### Schema Design:
```sql
-- Core tables
users (id, email, name, created_at)
fields (id, name_fa, name_en)           -- رشته‌ها
courses (id, field_id, name_fa)         -- دروس
topics (id, course_id, name_fa)         -- موضوعات

-- Exam content
exams (id, year, field_id)
questions (id, exam_id, course_id, topic_id, content, options, answer)

-- User progress
attempts (id, user_id, question_id, selected, correct, timestamp)
review_schedule (id, user_id, question_id, next_review, ease_factor)
```

### Search: Meilisearch
```
Why:
- Blazing fast (< 50ms)
- Persian/Farsi support
- Typo tolerance
- Easy to set up
```

Use for: Searching questions, filtering by topic/year/field

### Cache: Redis
```
Why:
- Session storage
- Rate limiting
- Leaderboards
- Quiz state caching
```

---

## Spaced Repetition Algorithm

### Use: FSRS (Free Spaced Repetition Scheduler)
```
Why:
- More accurate than SM-2 (Anki's algorithm)
- Open source
- Go implementation available
```

**GitHub:** https://github.com/open-spaced-repetition/go-fsrs

### How it works:
```go
// After user answers a question
scheduler := fsrs.NewFSRS(fsrs.DefaultParam())
card := GetUserCard(userID, questionID)
rating := fsrs.Good // or Again, Hard, Easy

newCard := scheduler.Review(card, rating)
SaveCard(newCard) // Save next review date
```

---

## Key Features Implementation

### 1. Quiz Engine
```
- Timer per question
- Immediate feedback
- Explanation display
- Bookmark questions
```

### 2. Progress Dashboard
```
- Charts: correct/incorrect over time
- Weak topics identification
- Study streak tracking
- Comparison with average
```

### 3. Smart Review
```
- FSRS-based scheduling
- Focus on weak areas
- Daily review queue
```

### 4. Exam Simulator
```
- Real exam conditions
- Same time limits
- Random question order
- Final score + analysis
```

---

## DevOps & Infrastructure

### Development:
```yaml
# docker-compose.yml
services:
  api:
    build: ./backend
    ports: ["8080:8080"]

  web:
    build: ./frontend
    ports: ["3000:3000"]

  postgres:
    image: postgres:16

  redis:
    image: redis:7

  meilisearch:
    image: getmeili/meilisearch
```

### Production:
```
- GitHub Actions for CI/CD
- Docker containers
- Nginx reverse proxy
- Cloudflare for CDN + DDoS protection
- Let's Encrypt SSL
```

---

## Quick Start Commands

```bash
# Frontend
npx create-next-app@latest frontend --typescript --tailwind --app
cd frontend
npx shadcn@latest init
npx shadcn@latest add button card input

# Backend
mkdir backend && cd backend
go mod init github.com/yourname/mdp-api
go get github.com/gofiber/fiber/v2
go get github.com/jackc/pgx/v5
```

---

## Cost Estimation (Monthly)

| Service | Free Tier | Paid |
|---------|-----------|------|
| Vercel (Frontend) | 100GB bandwidth | $20/mo |
| VPS (Backend) | - | $5-20/mo |
| PostgreSQL (Supabase) | 500MB | $25/mo |
| Meilisearch Cloud | 10K docs | $30/mo |
| Redis (Upstash) | 10K commands/day | $10/mo |
| **Total** | ~Free start | ~$50-100/mo |

---

## Alternative: All-in-One Options

If you want simpler setup:

### Option A: Supabase + Next.js
```
- Supabase = PostgreSQL + Auth + Storage + Realtime
- No separate backend needed
- Faster to build
```

### Option B: PocketBase + Next.js
```
- Single Go binary
- SQLite database
- Built-in auth
- REST + Realtime API
```

---

## Summary

**For MDP, I recommend:**

| Layer | Choice | Why |
|-------|--------|-----|
| Frontend | Next.js + shadcn/ui | Modern, fast, beautiful |
| Backend | Go + Fiber | Performance, simplicity |
| Database | PostgreSQL | Reliability, Persian support |
| Search | Meilisearch | Speed, Persian support |
| Algorithm | FSRS | Best spaced repetition |
| Deploy | Docker + VPS | Full control, low cost |

This stack will handle 10,000+ concurrent users easily.

---

*Last Updated: 1404/10/14 (2026-01-03)*
