package repository

import (
	"context"
	"math"
	"mdp-api/internal/models"
	"time"
)

// GetOrCreateUserByClientID finds or creates a user by client_id cookie value
func (r *Repository) GetOrCreateUserByClientID(clientID string) (int, error) {
	var userID int
	err := r.db.QueryRow(context.Background(),
		"SELECT id FROM users WHERE client_id = $1", clientID).Scan(&userID)
	if err == nil {
		return userID, nil
	}

	// Create new user with this client_id
	err = r.db.QueryRow(context.Background(), `
		INSERT INTO users (client_id, created_at, updated_at)
		VALUES ($1, NOW(), NOW())
		RETURNING id`, clientID).Scan(&userID)
	if err != nil {
		return 0, err
	}
	return userID, nil
}

// GetVocabularyCategories returns all vocabulary categories
func (r *Repository) GetVocabularyCategories() ([]models.VocabularyCategory, error) {
	rows, err := r.db.Query(context.Background(), `
		SELECT c.id, c.uuid, c.name_fa, c.name_en,
		       COALESCE(c.description_fa, ''), COALESCE(c.description_en, ''),
		       COALESCE(c.icon, ''), COUNT(w.id) as word_count
		FROM vocabulary_categories c
		LEFT JOIN vocabulary_words w ON w.category_id = c.id
		GROUP BY c.id, c.uuid, c.name_fa, c.name_en, c.description_fa, c.description_en, c.icon
		ORDER BY c.id`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	categories := []models.VocabularyCategory{}
	for rows.Next() {
		var c models.VocabularyCategory
		if err := rows.Scan(&c.ID, &c.UUID, &c.NameFA, &c.NameEN,
			&c.DescriptionFA, &c.DescriptionEN, &c.Icon, &c.WordCount); err != nil {
			return nil, err
		}
		categories = append(categories, c)
	}
	return categories, nil
}

// GetVocabularyWords returns words with optional category filter
func (r *Repository) GetVocabularyWords(categoryUUID string, limit, offset int) ([]models.VocabularyWord, int, error) {
	query := `
		SELECT w.id, w.uuid, w.category_id, c.name_en, w.word_en, w.meaning_fa,
		       COALESCE(w.pronunciation, ''), COALESCE(w.example_en, ''),
		       COALESCE(w.example_fa, ''), w.difficulty
		FROM vocabulary_words w
		LEFT JOIN vocabulary_categories c ON w.category_id = c.id
		WHERE 1=1`
	countQuery := "SELECT COUNT(*) FROM vocabulary_words w WHERE 1=1"
	args := []interface{}{}
	argNum := 1

	if categoryUUID != "" {
		query += " AND c.uuid = $1"
		countQuery += " AND w.category_id = (SELECT id FROM vocabulary_categories WHERE uuid = $1)"
		args = append(args, categoryUUID)
		argNum++
	}

	var total int
	r.db.QueryRow(context.Background(), countQuery, args...).Scan(&total)

	query += " ORDER BY w.id LIMIT $" + string(rune('0'+argNum)) + " OFFSET $" + string(rune('0'+argNum+1))
	args = append(args, limit, offset)

	rows, err := r.db.Query(context.Background(), query, args...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	words := []models.VocabularyWord{}
	for rows.Next() {
		var w models.VocabularyWord
		if err := rows.Scan(&w.ID, &w.UUID, &w.CategoryID, &w.CategoryName,
			&w.WordEN, &w.MeaningFA, &w.Pronunciation, &w.ExampleEN,
			&w.ExampleFA, &w.Difficulty); err != nil {
			return nil, 0, err
		}
		words = append(words, w)
	}
	return words, total, nil
}

// GetWordByUUID returns a single word by UUID
func (r *Repository) GetWordByUUID(uuid string) (*models.VocabularyWord, error) {
	var w models.VocabularyWord
	err := r.db.QueryRow(context.Background(), `
		SELECT w.id, w.uuid, w.category_id, COALESCE(c.name_en, ''), w.word_en, w.meaning_fa,
		       COALESCE(w.pronunciation, ''), COALESCE(w.example_en, ''),
		       COALESCE(w.example_fa, ''), w.difficulty
		FROM vocabulary_words w
		LEFT JOIN vocabulary_categories c ON w.category_id = c.id
		WHERE w.uuid = $1`, uuid).
		Scan(&w.ID, &w.UUID, &w.CategoryID, &w.CategoryName,
			&w.WordEN, &w.MeaningFA, &w.Pronunciation, &w.ExampleEN,
			&w.ExampleFA, &w.Difficulty)
	if err != nil {
		return nil, err
	}
	return &w, nil
}

// GetDueWords returns words due for review for a user
func (r *Repository) GetDueWords(userID, limit int) ([]models.UserVocabulary, error) {
	rows, err := r.db.Query(context.Background(), `
		SELECT uv.id, uv.user_id, uv.word_id, uv.easiness, uv.interval_days,
		       uv.repetitions, uv.next_review, uv.last_reviewed,
		       w.uuid, w.word_en, w.meaning_fa, COALESCE(w.pronunciation, ''),
		       COALESCE(w.example_en, ''), COALESCE(w.example_fa, ''), w.difficulty
		FROM user_vocabulary uv
		JOIN vocabulary_words w ON uv.word_id = w.id
		WHERE uv.user_id = $1 AND uv.next_review <= NOW()
		  AND (uv.status IS NULL OR uv.status = 'active' OR (uv.status_until IS NOT NULL AND uv.status_until <= NOW()))
		ORDER BY uv.next_review
		LIMIT $2`, userID, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := []models.UserVocabulary{}
	for rows.Next() {
		var uv models.UserVocabulary
		var w models.VocabularyWord
		if err := rows.Scan(&uv.ID, &uv.UserID, &uv.WordID, &uv.Easiness,
			&uv.IntervalDays, &uv.Repetitions, &uv.NextReview, &uv.LastReviewed,
			&w.UUID, &w.WordEN, &w.MeaningFA, &w.Pronunciation,
			&w.ExampleEN, &w.ExampleFA, &w.Difficulty); err != nil {
			return nil, err
		}
		uv.Word = &w
		result = append(result, uv)
	}
	return result, nil
}

// GetNewWords returns words not yet started by user
func (r *Repository) GetNewWords(userID, limit int, categoryUUID string) ([]models.VocabularyWord, error) {
	query := `
		SELECT w.id, w.uuid, w.category_id, COALESCE(c.name_en, ''), w.word_en, w.meaning_fa,
		       COALESCE(w.pronunciation, ''), COALESCE(w.example_en, ''),
		       COALESCE(w.example_fa, ''), w.difficulty
		FROM vocabulary_words w
		LEFT JOIN vocabulary_categories c ON w.category_id = c.id
		WHERE w.id NOT IN (
			SELECT word_id FROM user_vocabulary
			WHERE user_id = $1 AND (status IS NULL OR status = 'active' OR status = 'suspended' OR status = 'deleted')
		)`
	args := []interface{}{userID}

	if categoryUUID != "" {
		query += " AND c.uuid = $2"
		args = append(args, categoryUUID)
		query += " ORDER BY w.difficulty, w.id LIMIT $3"
		args = append(args, limit)
	} else {
		query += " ORDER BY w.difficulty, w.id LIMIT $2"
		args = append(args, limit)
	}

	rows, err := r.db.Query(context.Background(), query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	words := []models.VocabularyWord{}
	for rows.Next() {
		var w models.VocabularyWord
		if err := rows.Scan(&w.ID, &w.UUID, &w.CategoryID, &w.CategoryName,
			&w.WordEN, &w.MeaningFA, &w.Pronunciation, &w.ExampleEN,
			&w.ExampleFA, &w.Difficulty); err != nil {
			return nil, err
		}
		words = append(words, w)
	}
	return words, nil
}

// ReviewWord applies SM-2 algorithm and updates user's word progress
func (r *Repository) ReviewWord(userID int, wordUUID string, quality int) (*models.VocabularyReviewResponse, error) {
	// Get word ID
	word, err := r.GetWordByUUID(wordUUID)
	if err != nil {
		return nil, err
	}

	// Get or create user_vocabulary record
	var uv models.UserVocabulary
	err = r.db.QueryRow(context.Background(), `
		SELECT id, easiness, interval_days, repetitions
		FROM user_vocabulary WHERE user_id = $1 AND word_id = $2`,
		userID, word.ID).Scan(&uv.ID, &uv.Easiness, &uv.IntervalDays, &uv.Repetitions)

	isNew := err != nil
	if isNew {
		uv.Easiness = 2.5
		uv.IntervalDays = 1
		uv.Repetitions = 0
	}

	// Apply SM-2 algorithm
	uv.Easiness = math.Max(1.3, uv.Easiness+0.1-(5.0-float64(quality))*(0.08+(5.0-float64(quality))*0.02))

	if quality < 3 {
		uv.Repetitions = 0
		uv.IntervalDays = 1
	} else {
		uv.Repetitions++
		if uv.Repetitions == 1 {
			uv.IntervalDays = 1
		} else if uv.Repetitions == 2 {
			uv.IntervalDays = 6
		} else {
			uv.IntervalDays = int(math.Round(float64(uv.IntervalDays) * uv.Easiness))
		}
	}

	nextReview := time.Now().AddDate(0, 0, uv.IntervalDays)

	// Upsert user_vocabulary
	if isNew {
		_, err = r.db.Exec(context.Background(), `
			INSERT INTO user_vocabulary (user_id, word_id, easiness, interval_days, repetitions, next_review, last_reviewed)
			VALUES ($1, $2, $3, $4, $5, $6, NOW())`,
			userID, word.ID, uv.Easiness, uv.IntervalDays, uv.Repetitions, nextReview)
	} else {
		_, err = r.db.Exec(context.Background(), `
			UPDATE user_vocabulary
			SET easiness = $1, interval_days = $2, repetitions = $3, next_review = $4,
			    last_reviewed = NOW(), updated_at = NOW()
			WHERE user_id = $5 AND word_id = $6`,
			uv.Easiness, uv.IntervalDays, uv.Repetitions, nextReview, userID, word.ID)
	}
	if err != nil {
		return nil, err
	}

	// Calculate XP (based on quality)
	xpEarned := quality * 5
	if quality >= 4 {
		xpEarned += 10
	}

	// Update streak
	streak, err := r.UpdateUserStreak(userID, xpEarned)
	if err != nil {
		streak = 0
	}

	return &models.VocabularyReviewResponse{
		Success:      true,
		NextReview:   nextReview.Format("2006-01-02"),
		IntervalDays: uv.IntervalDays,
		Easiness:     uv.Easiness,
		XPEarned:     xpEarned,
		Streak:       streak,
	}, nil
}

// UpdateUserStreak updates user streak and XP
func (r *Repository) UpdateUserStreak(userID, xpEarned int) (int, error) {
	today := time.Now().Format("2006-01-02")

	// Try to get existing streak
	var currentStreak, longestStreak, totalXP, reviewsToday int
	var lastActivity *string
	err := r.db.QueryRow(context.Background(), `
		SELECT current_streak, longest_streak, total_xp, reviews_today, last_activity::text
		FROM user_streaks WHERE user_id = $1`, userID).
		Scan(&currentStreak, &longestStreak, &totalXP, &reviewsToday, &lastActivity)

	if err != nil {
		// Create new streak record
		_, err = r.db.Exec(context.Background(), `
			INSERT INTO user_streaks (user_id, current_streak, longest_streak, total_xp, reviews_today, last_activity)
			VALUES ($1, 1, 1, $2, 1, $3)`, userID, xpEarned, today)
		return 1, err
	}

	// Update streak logic
	newStreak := currentStreak
	newReviewsToday := reviewsToday + 1

	if lastActivity == nil || *lastActivity != today {
		yesterday := time.Now().AddDate(0, 0, -1).Format("2006-01-02")
		if lastActivity != nil && *lastActivity == yesterday {
			newStreak++
		} else if lastActivity == nil || *lastActivity != today {
			newStreak = 1
		}
		newReviewsToday = 1
	}

	if newStreak > longestStreak {
		longestStreak = newStreak
	}

	_, err = r.db.Exec(context.Background(), `
		UPDATE user_streaks
		SET current_streak = $1, longest_streak = $2, total_xp = total_xp + $3,
		    reviews_today = $4, last_activity = $5, updated_at = NOW()
		WHERE user_id = $6`,
		newStreak, longestStreak, xpEarned, newReviewsToday, today, userID)

	return newStreak, err
}

// GetVocabularyStats returns user's vocabulary learning statistics
func (r *Repository) GetVocabularyStats(userID int) (*models.VocabularyStats, error) {
	stats := &models.VocabularyStats{}

	// Get total words
	r.db.QueryRow(context.Background(), "SELECT COUNT(*) FROM vocabulary_words").Scan(&stats.TotalWords)

	// Get words learned (reviewed at least once with quality >= 3)
	r.db.QueryRow(context.Background(), `
		SELECT COUNT(*) FROM user_vocabulary
		WHERE user_id = $1 AND repetitions > 0`, userID).Scan(&stats.WordsLearned)

	// Get words due
	r.db.QueryRow(context.Background(), `
		SELECT COUNT(*) FROM user_vocabulary
		WHERE user_id = $1 AND next_review <= NOW()`, userID).Scan(&stats.WordsDue)

	// Get new words (not started)
	stats.WordsNew = stats.TotalWords - stats.WordsLearned

	// Get streak data
	var streak models.UserStreak
	err := r.db.QueryRow(context.Background(), `
		SELECT current_streak, longest_streak, total_xp, reviews_today
		FROM user_streaks WHERE user_id = $1`, userID).
		Scan(&streak.CurrentStreak, &streak.LongestStreak, &streak.TotalXP, &streak.ReviewsToday)

	if err == nil {
		stats.CurrentStreak = streak.CurrentStreak
		stats.LongestStreak = streak.LongestStreak
		stats.TotalXP = streak.TotalXP
		stats.ReviewsToday = streak.ReviewsToday
	}

	return stats, nil
}
