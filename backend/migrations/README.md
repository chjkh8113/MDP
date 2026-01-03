# Database Migrations

## Structure

```
migrations/
├── 001_create_fields_table.sql
├── 002_create_courses_table.sql
├── 003_create_topics_table.sql
├── 004_create_exams_table.sql
├── 005_create_questions_table.sql
├── 006_create_users_table.sql
├── 007_create_attempts_table.sql
├── 008_create_review_schedule_table.sql
└── seeds/
    ├── 001_fields.sql
    ├── 002_courses.sql
    ├── 003_exams.sql
    ├── 004_topics.sql
    └── 005_questions.sql
```

## Running Migrations

```bash
# Create database
psql -U postgres -c "CREATE DATABASE mdp;"

# Run DDL migrations in order
for f in migrations/0*.sql; do
  psql -U postgres -d mdp -f "$f"
done

# Run seed data
for f in migrations/seeds/*.sql; do
  psql -U postgres -d mdp -f "$f"
done
```

## Adding New Migrations

1. Create new file with next sequence number: `009_description.sql`
2. Add DDL statements (CREATE TABLE, ALTER TABLE, etc.)
3. For seed data, add to `seeds/` directory
