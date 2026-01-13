# MDP - Master's Degree Prep

A Persian/RTL educational platform for Iranian students preparing for master's degree entrance exams (Konkur).

## Tech Stack

- **Frontend**: Next.js 16, React 19, TypeScript, Tailwind CSS
- **Backend**: Go + Fiber, PostgreSQL
- **Testing**: Playwright

## Quick Start

### 1. Database Setup

```bash
# Create database
psql -U postgres -c "CREATE DATABASE mdp;"

# Restore dump (102 vocabulary words included)
psql -U postgres -d mdp -f backend/database/mdp_dump.sql

# Verify
psql -U postgres -d mdp -c "SELECT COUNT(*) FROM vocabulary_words;"
# Should show: 102
```

### 2. Backend Setup

```bash
cd backend

# Build
go build -o mdp-api.exe ./cmd/api

# Run (default config works if PostgreSQL password is 'postgres')
./mdp-api.exe
```

**If your PostgreSQL password is different:**

Windows PowerShell:
```powershell
$env:DATABASE_URL="postgres://postgres:YOUR_PASSWORD@localhost:5432/mdp?sslmode=disable"
./mdp-api.exe
```

Windows CMD:
```cmd
set DATABASE_URL=postgres://postgres:YOUR_PASSWORD@localhost:5432/mdp?sslmode=disable
mdp-api.exe
```

Or create `backend/.env`:
```
DATABASE_URL=postgres://postgres:YOUR_PASSWORD@localhost:5432/mdp?sslmode=disable
```

Backend runs on **http://localhost:8181**

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Run development server
npm run dev
```

Frontend runs on **http://localhost:4444**

## Features

- **Vocabulary Flashcards**: SM-2 spaced repetition algorithm
- **Quiz Mode**: Multiple choice quizzes (English ↔ Persian)
- **Card Management**: Suspend, bury, delete cards
- **Progress Tracking**: XP, streaks, statistics
- **RTL Support**: Full Persian/Farsi interface

## API Endpoints

| Endpoint | Description |
|----------|-------------|
| GET /api/v1/vocabulary/study | Get study queue |
| POST /api/v1/vocabulary/review | Submit review |
| GET /api/v1/vocabulary/quiz | Get quiz questions |
| POST /api/v1/vocabulary/quiz/answer | Submit quiz answer |
| POST /api/v1/vocabulary/card/action | Suspend/bury/delete card |
| GET /api/v1/vocabulary/stats | Get user statistics |

## Default Configuration

| Setting | Value |
|---------|-------|
| Backend Port | 8181 |
| Frontend Port | 4444 |
| Database | postgres://postgres:postgres@localhost:5432/mdp |
