package repository

import (
	"context"
	"math/rand"
	"mdp-api/internal/models"
	"strings"
	"time"
)

// GetQuizQuestions generates quiz questions for the user
func (r *Repository) GetQuizQuestions(userID int, quizType string, count int) ([]models.VocabQuizQuestion, error) {
	// Get random words for quiz
	// Excludes suspended/buried/deleted words, includes both new and learned words
	query := `
		SELECT w.id, w.uuid, w.word_en, w.meaning_fa, w.pronunciation, w.difficulty
		FROM vocabulary_words w
		LEFT JOIN user_vocabulary uv ON w.id = uv.word_id AND uv.user_id = $1
		WHERE uv.id IS NULL
		   OR uv.status IS NULL
		   OR uv.status = 'active'
		   OR (uv.status_until IS NOT NULL AND uv.status_until <= NOW())
		ORDER BY RANDOM()
		LIMIT $2`

	rows, err := r.db.Query(context.Background(), query, userID, count)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var words []models.VocabularyWord
	for rows.Next() {
		var w models.VocabularyWord
		if err := rows.Scan(&w.ID, &w.UUID, &w.WordEN, &w.MeaningFA, &w.Pronunciation, &w.Difficulty); err != nil {
			return nil, err
		}
		words = append(words, w)
	}

	// Get all meanings/words for generating wrong options
	allOptions, err := r.getAllOptionsForQuiz(quizType)
	if err != nil {
		return nil, err
	}

	// Generate quiz questions with options
	questions := make([]models.VocabQuizQuestion, 0, len(words))
	for _, word := range words {
		options := r.generateOptions(word, allOptions, quizType)
		questions = append(questions, models.VocabQuizQuestion{
			Word:    word,
			Options: options,
			Type:    quizType,
		})
	}

	return questions, nil
}

// getAllOptionsForQuiz gets all possible options for generating wrong answers
func (r *Repository) getAllOptionsForQuiz(quizType string) ([]string, error) {
	var query string
	if quizType == "meaning" {
		query = "SELECT DISTINCT meaning_fa FROM vocabulary_words"
	} else {
		query = "SELECT DISTINCT word_en FROM vocabulary_words"
	}

	rows, err := r.db.Query(context.Background(), query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var options []string
	for rows.Next() {
		var opt string
		if err := rows.Scan(&opt); err != nil {
			return nil, err
		}
		options = append(options, opt)
	}
	return options, nil
}

// generateOptions creates 4 options including the correct answer
func (r *Repository) generateOptions(word models.VocabularyWord, allOptions []string, quizType string) []string {
	var correctAnswer string
	if quizType == "meaning" {
		correctAnswer = word.MeaningFA
	} else {
		correctAnswer = word.WordEN
	}

	// Filter out the correct answer from options
	wrongOptions := make([]string, 0)
	for _, opt := range allOptions {
		if opt != correctAnswer {
			wrongOptions = append(wrongOptions, opt)
		}
	}

	// Shuffle and take 3 wrong options
	rand.Shuffle(len(wrongOptions), func(i, j int) {
		wrongOptions[i], wrongOptions[j] = wrongOptions[j], wrongOptions[i]
	})

	options := []string{correctAnswer}
	for i := 0; i < 3 && i < len(wrongOptions); i++ {
		options = append(options, wrongOptions[i])
	}

	// Shuffle final options
	rand.Shuffle(len(options), func(i, j int) {
		options[i], options[j] = options[j], options[i]
	})

	return options
}

// SubmitQuizAnswer records a quiz answer and returns result
func (r *Repository) SubmitQuizAnswer(userID int, wordUUID, answer, quizType string, timeMs int) (*models.VocabQuizAnswerResponse, error) {
	// Get word
	word, err := r.GetWordByUUID(wordUUID)
	if err != nil {
		return nil, err
	}

	// Check if correct
	var correctAnswer string
	if quizType == "meaning" {
		correctAnswer = word.MeaningFA
	} else {
		correctAnswer = word.WordEN
	}
	// Trim whitespace and compare (handles encoding/whitespace differences)
	isCorrect := strings.TrimSpace(answer) == strings.TrimSpace(correctAnswer)

	// Record result
	_, err = r.db.Exec(context.Background(), `
		INSERT INTO vocabulary_quiz_results (user_id, word_id, quiz_type, correct, response_time_ms)
		VALUES ($1, $2, $3, $4, $5)`,
		userID, word.ID, quizType, isCorrect, timeMs)
	if err != nil {
		return nil, err
	}

	// Calculate XP
	xpEarned := 0
	if isCorrect {
		xpEarned = 10
		if timeMs > 0 && timeMs < 3000 {
			xpEarned += 5 // Bonus for fast answer
		}
	}

	// Update streak XP
	if xpEarned > 0 {
		r.UpdateUserStreak(userID, xpEarned)
	}

	return &models.VocabQuizAnswerResponse{
		Correct:       isCorrect,
		CorrectAnswer: correctAnswer,
		XPEarned:      xpEarned,
	}, nil
}

// UpdateCardStatus changes the status of a card (suspend, bury, delete, restore)
func (r *Repository) UpdateCardStatus(userID int, wordUUID, action string) (*models.CardActionResponse, error) {
	word, err := r.GetWordByUUID(wordUUID)
	if err != nil {
		return nil, err
	}

	var status string
	var statusUntil *time.Time

	switch action {
	case "suspend":
		status = "suspended"
		t := time.Now().AddDate(0, 0, 30) // 30 days
		statusUntil = &t
	case "bury":
		status = "buried"
		t := time.Now().AddDate(0, 0, 1) // Tomorrow
		statusUntil = &t
	case "delete":
		status = "deleted"
		statusUntil = nil
	case "restore":
		status = "active"
		statusUntil = nil
	default:
		return &models.CardActionResponse{Success: false, Message: "Invalid action"}, nil
	}

	// Upsert user_vocabulary with new status
	_, err = r.db.Exec(context.Background(), `
		INSERT INTO user_vocabulary (user_id, word_id, status, status_until)
		VALUES ($1, $2, $3, $4)
		ON CONFLICT (user_id, word_id)
		DO UPDATE SET status = $3, status_until = $4, updated_at = NOW()`,
		userID, word.ID, status, statusUntil)
	if err != nil {
		return nil, err
	}

	messages := map[string]string{
		"suspend": "کارت برای ۳۰ روز مخفی شد",
		"bury":    "کارت تا فردا مخفی شد",
		"delete":  "کارت از لیست شما حذف شد",
		"restore": "کارت بازیابی شد",
	}

	return &models.CardActionResponse{
		Success: true,
		Message: messages[action],
	}, nil
}

// GetSuspendedCards returns cards that are suspended/buried/deleted for a user
func (r *Repository) GetSuspendedCards(userID int) ([]models.VocabularyWord, error) {
	rows, err := r.db.Query(context.Background(), `
		SELECT w.id, w.uuid, w.word_en, w.meaning_fa, w.pronunciation, w.difficulty, uv.status
		FROM user_vocabulary uv
		JOIN vocabulary_words w ON uv.word_id = w.id
		WHERE uv.user_id = $1 AND uv.status != 'active'
		ORDER BY uv.updated_at DESC`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var words []models.VocabularyWord
	for rows.Next() {
		var w models.VocabularyWord
		var status string
		if err := rows.Scan(&w.ID, &w.UUID, &w.WordEN, &w.MeaningFA, &w.Pronunciation, &w.Difficulty, &status); err != nil {
			return nil, err
		}
		w.CategoryName = status // Reuse field to show status
		words = append(words, w)
	}
	return words, nil
}
