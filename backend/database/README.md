# MDP Database Setup

## Quick Restore (Recommended)

### Step 1: Create Database
```bash
# Connect to PostgreSQL as admin
psql -U postgres

# Create database
CREATE DATABASE mdp;

# Exit
\q
```

### Step 2: Restore Dump
```bash
# Restore the database dump
psql -U postgres -d mdp -f backend/database/mdp_dump.sql
```

### Step 3: Verify
```bash
psql -U postgres -d mdp -c "SELECT COUNT(*) FROM vocabulary_words;"
# Should show: 102
```

### Step 4: Configure Backend
Set your database URL in environment or `.env` file:
```
DATABASE_URL=postgres://postgres:your_password@localhost:5432/mdp?sslmode=disable
```

---

## What's Included

The dump contains:
- **5 vocabulary categories**: IELTS Band 7, Computer Engineering, Essential Konkur Words, Academic Words, Everyday Words
- **102 vocabulary words** with Persian translations, pronunciations, and examples
- **User tables**: users, user_vocabulary, user_streaks
- **Quiz tables**: vocabulary_quiz_results

---

## Troubleshooting

### Permission denied
```bash
# Grant permissions after restore
psql -U postgres -d mdp -c "GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;"
psql -U postgres -d mdp -c "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres;"
```

### Database already exists
```bash
# Drop and recreate
psql -U postgres -c "DROP DATABASE IF EXISTS mdp;"
psql -U postgres -c "CREATE DATABASE mdp;"
```

### Using different user
```bash
# Create user first
psql -U postgres -c "CREATE USER mdp_user WITH PASSWORD 'mdp_password';"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE mdp TO mdp_user;"

# After restore, grant table access
psql -U postgres -d mdp -c "GRANT ALL ON ALL TABLES IN SCHEMA public TO mdp_user;"
psql -U postgres -d mdp -c "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO mdp_user;"
```
