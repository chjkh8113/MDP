package models

import "time"

// Field represents a field of study (رشته)
type Field struct {
	ID     int    `json:"-"`
	UUID   string `json:"id"`
	NameFA string `json:"name_fa"`
	NameEN string `json:"name_en"`
}

// Course represents a course within a field (درس)
type Course struct {
	ID      int    `json:"-"`
	UUID    string `json:"id"`
	FieldID int    `json:"-"`
	NameFA  string `json:"name_fa"`
	NameEN  string `json:"name_en"`
}

// Topic represents a topic within a course (موضوع)
type Topic struct {
	ID       int    `json:"-"`
	UUID     string `json:"id"`
	CourseID int    `json:"-"`
	NameFA   string `json:"name_fa"`
}

// Exam represents a past exam
type Exam struct {
	ID      int    `json:"-"`
	UUID    string `json:"id"`
	Year    int    `json:"year"`
	FieldID int    `json:"-"`
}

// Question represents an exam question
type Question struct {
	ID        int      `json:"-"`
	UUID      string   `json:"id"`
	ExamID    int      `json:"-"`
	CourseID  int      `json:"-"`
	TopicID   *int     `json:"-"`
	Content   string   `json:"content"`
	Options   []string `json:"options"`
	Answer    int      `json:"answer"`
	Year      int      `json:"year"`
	FieldName string   `json:"field_name,omitempty"`
}

// User represents a registered user
type User struct {
	ID        int       `json:"-"`
	UUID      string    `json:"id"`
	Email     string    `json:"email"`
	Name      string    `json:"name"`
	Password  string    `json:"-"`
	CreatedAt time.Time `json:"created_at"`
}

// Attempt represents a user's answer to a question
type Attempt struct {
	ID         int       `json:"-"`
	UUID       string    `json:"id"`
	UserID     int       `json:"-"`
	QuestionID int       `json:"-"`
	Selected   int       `json:"selected"`
	Correct    bool      `json:"correct"`
	CreatedAt  time.Time `json:"created_at"`
}

// Progress represents user's overall progress
type Progress struct {
	TotalQuestions    int     `json:"total_questions"`
	CorrectAnswers    int     `json:"correct_answers"`
	IncorrectAnswers  int     `json:"incorrect_answers"`
	AccuracyPercent   float64 `json:"accuracy_percent"`
	QuestionsToReview int     `json:"questions_to_review"`
}

// QuizRequest represents a quiz generation request
type QuizRequest struct {
	FieldID  *int `json:"field_id"`
	CourseID *int `json:"course_id"`
	Year     *int `json:"year"`
	Count    int  `json:"count"`
}

// QuizResponse represents a quiz with questions
type QuizResponse struct {
	Questions []Question `json:"questions"`
	Total     int        `json:"total"`
}

// AnswerRequest represents a user's answer submission
type AnswerRequest struct {
	QuestionID int `json:"question_id"`
	Selected   int `json:"selected"`
}

// AnswerResponse represents the result of an answer
type AnswerResponse struct {
	Correct       bool   `json:"correct"`
	CorrectAnswer int    `json:"correct_answer"`
	Explanation   string `json:"explanation,omitempty"`
}

// VocabularyCategory represents a category of vocabulary words
type VocabularyCategory struct {
	ID            int    `json:"-"`
	UUID          string `json:"id"`
	NameFA        string `json:"name_fa"`
	NameEN        string `json:"name_en"`
	DescriptionFA string `json:"description_fa,omitempty"`
	DescriptionEN string `json:"description_en,omitempty"`
	Icon          string `json:"icon,omitempty"`
	WordCount     int    `json:"word_count,omitempty"`
}

// VocabularyWord represents a vocabulary word with translations
type VocabularyWord struct {
	ID            int    `json:"-"`
	UUID          string `json:"id"`
	CategoryID    int    `json:"-"`
	CategoryName  string `json:"category_name,omitempty"`
	WordEN        string `json:"word_en"`
	MeaningFA     string `json:"meaning_fa"`
	Pronunciation string `json:"pronunciation,omitempty"`
	ExampleEN     string `json:"example_en,omitempty"`
	ExampleFA     string `json:"example_fa,omitempty"`
	Difficulty    int    `json:"difficulty"`
}

// UserVocabulary represents user's progress on a specific word (SM-2 data)
type UserVocabulary struct {
	ID           int        `json:"-"`
	UserID       int        `json:"-"`
	WordID       int        `json:"-"`
	Word         *VocabularyWord `json:"word,omitempty"`
	Easiness     float64    `json:"easiness"`
	IntervalDays int        `json:"interval_days"`
	Repetitions  int        `json:"repetitions"`
	NextReview   time.Time  `json:"next_review"`
	LastReviewed *time.Time `json:"last_reviewed,omitempty"`
}

// UserStreak represents user's streak and gamification data
type UserStreak struct {
	UserID        int       `json:"-"`
	CurrentStreak int       `json:"current_streak"`
	LongestStreak int       `json:"longest_streak"`
	LastActivity  *time.Time `json:"last_activity,omitempty"`
	TotalXP       int       `json:"total_xp"`
	WordsLearned  int       `json:"words_learned"`
	ReviewsToday  int       `json:"reviews_today"`
	DailyGoal     int       `json:"daily_goal"`
}

// VocabularyReviewRequest represents a request to submit a vocabulary review
type VocabularyReviewRequest struct {
	WordUUID string `json:"word_id"`
	Quality  int    `json:"quality"` // 0-5, where 0-2 = Again, 3 = Hard, 4 = Good, 5 = Easy
}

// VocabularyReviewResponse represents the response after a review
type VocabularyReviewResponse struct {
	Success      bool    `json:"success"`
	NextReview   string  `json:"next_review"`
	IntervalDays int     `json:"interval_days"`
	Easiness     float64 `json:"easiness"`
	XPEarned     int     `json:"xp_earned"`
	Streak       int     `json:"streak"`
}

// VocabularyStats represents user's vocabulary learning statistics
type VocabularyStats struct {
	TotalWords      int     `json:"total_words"`
	WordsLearned    int     `json:"words_learned"`
	WordsDue        int     `json:"words_due"`
	WordsNew        int     `json:"words_new"`
	ReviewsToday    int     `json:"reviews_today"`
	CurrentStreak   int     `json:"current_streak"`
	LongestStreak   int     `json:"longest_streak"`
	TotalXP         int     `json:"total_xp"`
	AccuracyPercent float64 `json:"accuracy_percent"`
}
