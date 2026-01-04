package repository

import (
	"context"
	"encoding/json"
	"mdp-api/internal/models"

	"github.com/jackc/pgx/v5/pgxpool"
)

func parseJSONOptions(jsonStr string, options *[]string) error {
	return json.Unmarshal([]byte(jsonStr), options)
}

type Repository struct {
	db *pgxpool.Pool
}

func New(db *pgxpool.Pool) *Repository {
	return &Repository{db: db}
}

func (r *Repository) GetFields() ([]models.Field, error) {
	rows, err := r.db.Query(context.Background(),
		"SELECT id, uuid, name_fa, name_en FROM fields ORDER BY name_fa")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	fields := []models.Field{}
	for rows.Next() {
		var f models.Field
		if err := rows.Scan(&f.ID, &f.UUID, &f.NameFA, &f.NameEN); err != nil {
			return nil, err
		}
		fields = append(fields, f)
	}
	return fields, nil
}

func (r *Repository) GetFieldByUUID(uuid string) (*models.Field, error) {
	var f models.Field
	err := r.db.QueryRow(context.Background(),
		"SELECT id, uuid, name_fa, name_en FROM fields WHERE uuid = $1", uuid).
		Scan(&f.ID, &f.UUID, &f.NameFA, &f.NameEN)
	if err != nil {
		return nil, err
	}
	return &f, nil
}

func (r *Repository) GetCoursesByField(fieldID int) ([]models.Course, error) {
	rows, err := r.db.Query(context.Background(),
		"SELECT id, uuid, field_id, name_fa, name_en FROM courses WHERE field_id = $1 ORDER BY name_fa",
		fieldID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	courses := []models.Course{}
	for rows.Next() {
		var c models.Course
		if err := rows.Scan(&c.ID, &c.UUID, &c.FieldID, &c.NameFA, &c.NameEN); err != nil {
			return nil, err
		}
		courses = append(courses, c)
	}
	return courses, nil
}

func (r *Repository) GetCourseByUUID(uuid string) (*models.Course, error) {
	var c models.Course
	err := r.db.QueryRow(context.Background(),
		"SELECT id, uuid, field_id, name_fa, name_en FROM courses WHERE uuid = $1", uuid).
		Scan(&c.ID, &c.UUID, &c.FieldID, &c.NameFA, &c.NameEN)
	if err != nil {
		return nil, err
	}
	return &c, nil
}

func (r *Repository) GetExams(year, fieldID int) ([]models.Exam, error) {
	query := "SELECT id, uuid, year, field_id FROM exams WHERE 1=1"
	args := []interface{}{}
	argNum := 1

	if year > 0 {
		query += " AND year = $" + string(rune('0'+argNum))
		args = append(args, year)
		argNum++
	}
	if fieldID > 0 {
		query += " AND field_id = $" + string(rune('0'+argNum))
		args = append(args, fieldID)
	}
	query += " ORDER BY year DESC"

	rows, err := r.db.Query(context.Background(), query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	exams := []models.Exam{}
	for rows.Next() {
		var e models.Exam
		if err := rows.Scan(&e.ID, &e.UUID, &e.Year, &e.FieldID); err != nil {
			return nil, err
		}
		exams = append(exams, e)
	}
	return exams, nil
}

func (r *Repository) GetQuestions(year, fieldID, courseID, limit, offset int) ([]models.Question, int, error) {
	// For now, return sample data since we'll seed the database separately
	questions := []models.Question{
		{
			ID:       1,
			Content:  "کدام گزینه در مورد ساختار داده صحیح است؟",
			Options:  []string{"آرایه", "لیست پیوندی", "درخت", "همه موارد"},
			Answer:   4,
			Year:     1403,
			ExamID:   1,
			CourseID: 1,
		},
	}
	return questions, len(questions), nil
}

func (r *Repository) GetQuestionByID(id int) (*models.Question, error) {
	// Sample question
	return &models.Question{
		ID:       id,
		Content:  "کدام گزینه در مورد ساختار داده صحیح است؟",
		Options:  []string{"آرایه", "لیست پیوندی", "درخت", "همه موارد"},
		Answer:   4,
		Year:     1403,
		ExamID:   1,
		CourseID: 1,
	}, nil
}

func (r *Repository) GetRandomQuestions(fieldID, courseID, year *int, count int) ([]models.Question, error) {
	// Sample questions for quiz
	questions := []models.Question{
		{
			ID:       1,
			Content:  "پیچیدگی زمانی جستجوی دودویی چیست؟",
			Options:  []string{"O(n)", "O(log n)", "O(n²)", "O(1)"},
			Answer:   2,
			Year:     1403,
			ExamID:   1,
			CourseID: 1,
		},
		{
			ID:       2,
			Content:  "کدام ساختار داده LIFO است؟",
			Options:  []string{"صف", "پشته", "لیست", "درخت"},
			Answer:   2,
			Year:     1402,
			ExamID:   2,
			CourseID: 1,
		},
		{
			ID:       3,
			Content:  "بهترین الگوریتم مرتب‌سازی برای داده‌های تقریباً مرتب کدام است؟",
			Options:  []string{"Quick Sort", "Merge Sort", "Insertion Sort", "Heap Sort"},
			Answer:   3,
			Year:     1401,
			ExamID:   3,
			CourseID: 1,
		},
	}

	if count > len(questions) {
		count = len(questions)
	}
	return questions[:count], nil
}

func (r *Repository) GetAvailableYears() ([]int, error) {
	return []int{1404, 1403, 1402, 1401, 1400}, nil
}

func (r *Repository) GetStats() (map[string]interface{}, error) {
	var totalQuestions, totalFields, totalCourses int

	r.db.QueryRow(context.Background(), "SELECT COUNT(*) FROM questions").Scan(&totalQuestions)
	r.db.QueryRow(context.Background(), "SELECT COUNT(*) FROM fields").Scan(&totalFields)
	r.db.QueryRow(context.Background(), "SELECT COUNT(*) FROM courses").Scan(&totalCourses)

	return map[string]interface{}{
		"total_questions": totalQuestions,
		"total_fields":    totalFields,
		"total_courses":   totalCourses,
		"years_covered":   5,
	}, nil
}

func (r *Repository) GetTopicsByCourse(courseID int) ([]models.Topic, error) {
	rows, err := r.db.Query(context.Background(),
		"SELECT id, uuid, course_id, name_fa FROM topics WHERE course_id = $1 ORDER BY id",
		courseID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	topics := []models.Topic{}
	for rows.Next() {
		var t models.Topic
		if err := rows.Scan(&t.ID, &t.UUID, &t.CourseID, &t.NameFA); err != nil {
			return nil, err
		}
		topics = append(topics, t)
	}
	return topics, nil
}

func (r *Repository) GetTopicByUUID(uuid string) (*models.Topic, error) {
	var t models.Topic
	err := r.db.QueryRow(context.Background(),
		"SELECT id, uuid, course_id, name_fa FROM topics WHERE uuid = $1", uuid).
		Scan(&t.ID, &t.UUID, &t.CourseID, &t.NameFA)
	if err != nil {
		return nil, err
	}
	return &t, nil
}

func (r *Repository) GetQuestionsByTopic(topicID int) ([]models.Question, error) {
	rows, err := r.db.Query(context.Background(), `
		SELECT q.id, q.uuid, q.exam_id, q.course_id, q.topic_id, q.content,
		       q.options, q.answer, COALESCE(q.explanation, ''), e.year
		FROM questions q
		JOIN exams e ON q.exam_id = e.id
		WHERE q.topic_id = $1
		ORDER BY e.year DESC`, topicID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	questions := []models.Question{}
	for rows.Next() {
		var q models.Question
		var optionsJSON string
		var explanation string
		if err := rows.Scan(&q.ID, &q.UUID, &q.ExamID, &q.CourseID, &q.TopicID,
			&q.Content, &optionsJSON, &q.Answer, &explanation, &q.Year); err != nil {
			return nil, err
		}
		// Parse JSON options
		if err := parseJSONOptions(optionsJSON, &q.Options); err != nil {
			return nil, err
		}
		questions = append(questions, q)
	}
	return questions, nil
}
