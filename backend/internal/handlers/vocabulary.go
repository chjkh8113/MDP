package handlers

import (
	"mdp-api/internal/models"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// getUserFromCookie gets or creates a user based on client_id cookie
func (h *Handler) getUserFromCookie(c *fiber.Ctx) (int, error) {
	clientID := c.Cookies("client_id")
	if clientID == "" {
		// Generate new client ID
		clientID = uuid.New().String()
		c.Cookie(&fiber.Cookie{
			Name:     "client_id",
			Value:    clientID,
			MaxAge:   365 * 24 * 60 * 60, // 1 year
			HTTPOnly: false,
			SameSite: "Lax",
		})
	}

	// Get or create user by client ID
	userID, err := h.repo.GetOrCreateUserByClientID(clientID)
	if err != nil {
		return 0, err
	}
	return userID, nil
}

// GetVocabularyCategories returns all vocabulary categories
func (h *Handler) GetVocabularyCategories(c *fiber.Ctx) error {
	categories, err := h.repo.GetVocabularyCategories()
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(categories)
}

// GetVocabularyWords returns vocabulary words with optional category filter
func (h *Handler) GetVocabularyWords(c *fiber.Ctx) error {
	categoryUUID := c.Query("category")
	limit := c.QueryInt("limit", 20)
	offset := c.QueryInt("offset", 0)

	if limit > 100 {
		limit = 100
	}

	words, total, err := h.repo.GetVocabularyWords(categoryUUID, limit, offset)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{
		"words":  words,
		"total":  total,
		"limit":  limit,
		"offset": offset,
	})
}

// GetVocabularyWord returns a single word by UUID
func (h *Handler) GetVocabularyWord(c *fiber.Ctx) error {
	uuid := c.Params("uuid")
	if uuid == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Word UUID required"})
	}

	word, err := h.repo.GetWordByUUID(uuid)
	if err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "Word not found"})
	}
	return c.JSON(word)
}

// GetDueWords returns words due for review
func (h *Handler) GetDueWords(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	limit := c.QueryInt("limit", 10)
	if limit > 50 {
		limit = 50
	}

	dueWords, err := h.repo.GetDueWords(userID, limit)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{
		"words": dueWords,
		"count": len(dueWords),
	})
}

// GetNewWords returns words not yet started by user
func (h *Handler) GetNewWords(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	limit := c.QueryInt("limit", 10)
	categoryUUID := c.Query("category")

	if limit > 50 {
		limit = 50
	}

	words, err := h.repo.GetNewWords(userID, limit, categoryUUID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{
		"words": words,
		"count": len(words),
	})
}

// GetStudyQueue returns combined due and new words for study session
func (h *Handler) GetStudyQueue(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	limit := c.QueryInt("limit", 10)
	categoryUUID := c.Query("category")

	if limit > 50 {
		limit = 50
	}

	// First get due words (priority)
	dueWords, err := h.repo.GetDueWords(userID, limit)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	// Fill remaining slots with new words
	remaining := limit - len(dueWords)
	var newWords []models.VocabularyWord
	if remaining > 0 {
		newWords, err = h.repo.GetNewWords(userID, remaining, categoryUUID)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": err.Error()})
		}
	}

	// Combine into study queue
	queue := []fiber.Map{}

	for _, w := range dueWords {
		queue = append(queue, fiber.Map{
			"type": "review",
			"word": w.Word,
			"progress": fiber.Map{
				"easiness":      w.Easiness,
				"interval_days": w.IntervalDays,
				"repetitions":   w.Repetitions,
			},
		})
	}

	for _, w := range newWords {
		queue = append(queue, fiber.Map{
			"type": "new",
			"word": w,
			"progress": fiber.Map{
				"easiness":      2.5,
				"interval_days": 1,
				"repetitions":   0,
			},
		})
	}

	return c.JSON(fiber.Map{
		"queue":      queue,
		"total":      len(queue),
		"due_count":  len(dueWords),
		"new_count":  len(newWords),
	})
}

// ReviewWord submits a review for a word
func (h *Handler) ReviewWord(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	var req models.VocabularyReviewRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if req.WordUUID == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Word ID required"})
	}

	if req.Quality < 0 || req.Quality > 5 {
		return c.Status(400).JSON(fiber.Map{"error": "Quality must be between 0 and 5"})
	}

	response, err := h.repo.ReviewWord(userID, req.WordUUID, req.Quality)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(response)
}

// GetVocabularyStats returns user's vocabulary learning statistics
func (h *Handler) GetVocabularyStats(c *fiber.Ctx) error {
	userID, err := h.getUserFromCookie(c)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to identify user"})
	}

	stats, err := h.repo.GetVocabularyStats(userID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(stats)
}
