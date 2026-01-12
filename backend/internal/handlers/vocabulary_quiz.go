package handlers

import (
	"mdp-api/internal/models"

	"github.com/gofiber/fiber/v2"
)

// GetVocabQuiz returns quiz questions for vocabulary practice
func (h *Handler) GetVocabQuiz(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	quizType := c.Query("type", "meaning") // "meaning" (en->fa) or "word" (fa->en)
	count := c.QueryInt("count", 10)

	if count > 20 {
		count = 20
	}

	if quizType != "meaning" && quizType != "word" {
		quizType = "meaning"
	}

	questions, err := h.repo.GetQuizQuestions(userID, quizType, count)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{
		"questions": questions,
		"total":     len(questions),
		"type":      quizType,
	})
}

// SubmitVocabQuizAnswer handles quiz answer submission
func (h *Handler) SubmitVocabQuizAnswer(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	var req models.VocabQuizAnswerRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if req.WordUUID == "" || req.Answer == "" {
		return c.Status(400).JSON(fiber.Map{"error": "word_id and answer are required"})
	}

	response, err := h.repo.SubmitQuizAnswer(userID, req.WordUUID, req.Answer, req.QuizType, req.TimeMs)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(response)
}

// UpdateCardStatus handles suspend/bury/delete/restore card actions
func (h *Handler) UpdateCardStatus(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	var req models.CardActionRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if req.WordUUID == "" || req.Action == "" {
		return c.Status(400).JSON(fiber.Map{"error": "word_id and action are required"})
	}

	validActions := map[string]bool{"suspend": true, "bury": true, "delete": true, "restore": true}
	if !validActions[req.Action] {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid action. Use: suspend, bury, delete, or restore"})
	}

	response, err := h.repo.UpdateCardStatus(userID, req.WordUUID, req.Action)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(response)
}

// GetSuspendedCards returns cards that are suspended/buried/deleted
func (h *Handler) GetSuspendedCards(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	cards, err := h.repo.GetSuspendedCards(userID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{
		"cards": cards,
		"total": len(cards),
	})
}
