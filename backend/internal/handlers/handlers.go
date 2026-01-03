package handlers

import (
	"mdp-api/internal/models"
	"mdp-api/internal/repository"

	"github.com/gofiber/fiber/v2"
)

type Handler struct {
	repo *repository.Repository
}

func New(repo *repository.Repository) *Handler {
	return &Handler{repo: repo}
}

// Health check
func (h *Handler) HealthCheck(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"status":  "ok",
		"service": "MDP API",
		"version": "1.0.0",
	})
}

// GetFields returns all fields of study
func (h *Handler) GetFields(c *fiber.Ctx) error {
	fields, err := h.repo.GetFields()
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fields)
}

// GetCourses returns courses for a field
func (h *Handler) GetCourses(c *fiber.Ctx) error {
	fieldID, err := c.ParamsInt("fieldId")
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid field ID"})
	}

	courses, err := h.repo.GetCoursesByField(fieldID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(courses)
}

// GetExams returns exams filtered by year and/or field
func (h *Handler) GetExams(c *fiber.Ctx) error {
	year := c.QueryInt("year", 0)
	fieldID := c.QueryInt("field_id", 0)

	exams, err := h.repo.GetExams(year, fieldID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(exams)
}

// GetQuestions returns questions with filters
func (h *Handler) GetQuestions(c *fiber.Ctx) error {
	year := c.QueryInt("year", 0)
	fieldID := c.QueryInt("field_id", 0)
	courseID := c.QueryInt("course_id", 0)
	limit := c.QueryInt("limit", 20)
	offset := c.QueryInt("offset", 0)

	questions, total, err := h.repo.GetQuestions(year, fieldID, courseID, limit, offset)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{
		"questions": questions,
		"total":     total,
		"limit":     limit,
		"offset":    offset,
	})
}

// GetQuestion returns a single question by ID
func (h *Handler) GetQuestion(c *fiber.Ctx) error {
	id, err := c.ParamsInt("id")
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid question ID"})
	}

	question, err := h.repo.GetQuestionByID(id)
	if err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "Question not found"})
	}
	return c.JSON(question)
}

// GenerateQuiz creates a quiz with random questions
func (h *Handler) GenerateQuiz(c *fiber.Ctx) error {
	var req models.QuizRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
	}

	if req.Count <= 0 {
		req.Count = 10
	}
	if req.Count > 50 {
		req.Count = 50
	}

	questions, err := h.repo.GetRandomQuestions(req.FieldID, req.CourseID, req.Year, req.Count)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(models.QuizResponse{
		Questions: questions,
		Total:     len(questions),
	})
}

// SubmitAnswer checks user's answer
func (h *Handler) SubmitAnswer(c *fiber.Ctx) error {
	var req models.AnswerRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
	}

	question, err := h.repo.GetQuestionByID(req.QuestionID)
	if err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "Question not found"})
	}

	correct := req.Selected == question.Answer

	return c.JSON(models.AnswerResponse{
		Correct:       correct,
		CorrectAnswer: question.Answer,
	})
}

// GetYears returns available exam years
func (h *Handler) GetYears(c *fiber.Ctx) error {
	years, err := h.repo.GetAvailableYears()
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(years)
}

// GetStats returns overall statistics
func (h *Handler) GetStats(c *fiber.Ctx) error {
	stats, err := h.repo.GetStats()
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(stats)
}

// GetTopics returns topics for a course
func (h *Handler) GetTopics(c *fiber.Ctx) error {
	courseID, err := c.ParamsInt("courseId")
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid course ID"})
	}

	topics, err := h.repo.GetTopicsByCourse(courseID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(topics)
}

// GetQuestionsByTopic returns questions for a specific topic
func (h *Handler) GetQuestionsByTopic(c *fiber.Ctx) error {
	topicID, err := c.ParamsInt("topicId")
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid topic ID"})
	}

	questions, err := h.repo.GetQuestionsByTopic(topicID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(questions)
}
