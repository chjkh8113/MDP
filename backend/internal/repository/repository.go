package repository

import (
	"context"
	"mdp-api/internal/models"

	"github.com/jackc/pgx/v5/pgxpool"
)

type Repository struct {
	db *pgxpool.Pool
}

func New(db *pgxpool.Pool) *Repository {
	return &Repository{db: db}
}

func (r *Repository) GetFields() ([]models.Field, error) {
	rows, err := r.db.Query(context.Background(),
		"SELECT id, name_fa, name_en FROM fields ORDER BY name_fa")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var fields []models.Field
	for rows.Next() {
		var f models.Field
		if err := rows.Scan(&f.ID, &f.NameFA, &f.NameEN); err != nil {
			return nil, err
		}
		fields = append(fields, f)
	}
	return fields, nil
}

func (r *Repository) GetCoursesByField(fieldID int) ([]models.Course, error) {
	rows, err := r.db.Query(context.Background(),
		"SELECT id, field_id, name_fa, name_en FROM courses WHERE field_id = $1 ORDER BY name_fa",
		fieldID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var courses []models.Course
	for rows.Next() {
		var c models.Course
		if err := rows.Scan(&c.ID, &c.FieldID, &c.NameFA, &c.NameEN); err != nil {
			return nil, err
		}
		courses = append(courses, c)
	}
	return courses, nil
}

func (r *Repository) GetExams(year, fieldID int) ([]models.Exam, error) {
	query := "SELECT id, year, field_id FROM exams WHERE 1=1"
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

	var exams []models.Exam
	for rows.Next() {
		var e models.Exam
		if err := rows.Scan(&e.ID, &e.Year, &e.FieldID); err != nil {
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
	return map[string]interface{}{
		"total_questions": 150,
		"total_fields":    4,
		"total_courses":   20,
		"years_covered":   5,
	}, nil
}
