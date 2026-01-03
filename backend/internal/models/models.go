package models

import "time"

// Field represents a field of study (رشته)
type Field struct {
	ID     int    `json:"id"`
	NameFA string `json:"name_fa"`
	NameEN string `json:"name_en"`
}

// Course represents a course within a field (درس)
type Course struct {
	ID      int    `json:"id"`
	FieldID int    `json:"field_id"`
	NameFA  string `json:"name_fa"`
	NameEN  string `json:"name_en"`
}

// Topic represents a topic within a course (موضوع)
type Topic struct {
	ID       int    `json:"id"`
	CourseID int    `json:"course_id"`
	NameFA   string `json:"name_fa"`
}

// Exam represents a past exam
type Exam struct {
	ID      int `json:"id"`
	Year    int `json:"year"`
	FieldID int `json:"field_id"`
}

// Question represents an exam question
type Question struct {
	ID        int      `json:"id"`
	ExamID    int      `json:"exam_id"`
	CourseID  int      `json:"course_id"`
	TopicID   *int     `json:"topic_id,omitempty"`
	Content   string   `json:"content"`
	Options   []string `json:"options"`
	Answer    int      `json:"answer"`
	Year      int      `json:"year"`
	FieldName string   `json:"field_name,omitempty"`
}

// User represents a registered user
type User struct {
	ID        int       `json:"id"`
	Email     string    `json:"email"`
	Name      string    `json:"name"`
	Password  string    `json:"-"`
	CreatedAt time.Time `json:"created_at"`
}

// Attempt represents a user's answer to a question
type Attempt struct {
	ID         int       `json:"id"`
	UserID     int       `json:"user_id"`
	QuestionID int       `json:"question_id"`
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
