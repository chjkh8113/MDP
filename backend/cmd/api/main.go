package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"mdp-api/internal/config"
	"mdp-api/internal/handlers"
	"mdp-api/internal/repository"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/helmet"
	"github.com/gofiber/fiber/v2/middleware/limiter"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {
	cfg := config.Load()

	// Connect to database
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	pool, err := pgxpool.New(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Printf("Warning: Could not connect to database: %v", err)
		log.Println("Running in demo mode with sample data...")
		pool = nil
	} else {
		defer pool.Close()
		log.Println("Connected to PostgreSQL")
	}

	// Initialize repository and handlers
	repo := repository.New(pool)
	h := handlers.New(repo)

	// Create Fiber app
	app := fiber.New(fiber.Config{
		AppName:      "MDP API v1.0.0",
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
	})

	// Security: Recover from panics
	app.Use(recover.New())

	// Security: Rate limiting (100 requests per minute per IP)
	app.Use(limiter.New(limiter.Config{
		Max:        100,
		Expiration: 1 * time.Minute,
		KeyGenerator: func(c *fiber.Ctx) string {
			return c.IP()
		},
		LimitReached: func(c *fiber.Ctx) error {
			return c.Status(429).JSON(fiber.Map{
				"error": "Too many requests. Please try again later.",
			})
		},
	}))

	// Security: HTTP security headers
	app.Use(helmet.New(helmet.Config{
		XSSProtection:         "1; mode=block",
		ContentTypeNosniff:    "nosniff",
		XFrameOptions:         "DENY",
		ReferrerPolicy:        "strict-origin-when-cross-origin",
		CrossOriginEmbedderPolicy: "require-corp",
		CrossOriginOpenerPolicy:   "same-origin",
		CrossOriginResourcePolicy: "same-origin",
	}))

	// Logging
	app.Use(logger.New(logger.Config{
		Format:     "${time} | ${status} | ${latency} | ${ip} | ${method} ${path}\n",
		TimeFormat: "2006-01-02 15:04:05",
	}))

	// CORS - environment-aware configuration
	allowedOrigins := getEnvOrDefault("CORS_ORIGINS", "http://localhost:4444,http://localhost:3000,http://127.0.0.1:4444")
	app.Use(cors.New(cors.Config{
		AllowOrigins:     allowedOrigins,
		AllowMethods:     "GET,POST,PUT,DELETE,OPTIONS",
		AllowHeaders:     "Origin,Content-Type,Accept,Authorization",
		AllowCredentials: true,
	}))

	// API Routes
	api := app.Group("/api/v1")

	// Health check
	api.Get("/health", h.HealthCheck)

	// Fields, Courses & Topics (using UUIDs)
	api.Get("/fields", h.GetFields)
	api.Get("/fields/:uuid/courses", h.GetCourses)
	api.Get("/courses/:uuid/topics", h.GetTopics)
	api.Get("/topics/:uuid/questions", h.GetQuestionsByTopic)

	// Exams & Questions
	api.Get("/exams", h.GetExams)
	api.Get("/questions", h.GetQuestions)
	api.Get("/questions/:id", h.GetQuestion)

	// Quiz
	api.Post("/quiz/generate", h.GenerateQuiz)
	api.Post("/quiz/answer", h.SubmitAnswer)

	// Stats
	api.Get("/years", h.GetYears)
	api.Get("/stats", h.GetStats)

	// Vocabulary Learning
	vocab := api.Group("/vocabulary")
	vocab.Get("/categories", h.GetVocabularyCategories)
	vocab.Get("/words", h.GetVocabularyWords)
	vocab.Get("/words/:uuid", h.GetVocabularyWord)
	vocab.Get("/study", h.GetStudyQueue)
	vocab.Get("/due", h.GetDueWords)
	vocab.Get("/new", h.GetNewWords)
	vocab.Post("/review", h.ReviewWord)
	vocab.Get("/stats", h.GetVocabularyStats)

	// Quiz mode
	vocab.Get("/quiz", h.GetVocabQuiz)
	vocab.Post("/quiz/answer", h.SubmitVocabQuizAnswer)

	// Card actions (suspend/bury/delete/restore)
	vocab.Post("/card/action", h.UpdateCardStatus)
	vocab.Get("/card/suspended", h.GetSuspendedCards)

	// Graceful shutdown
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		<-quit
		log.Println("Shutting down server...")
		if err := app.Shutdown(); err != nil {
			log.Printf("Error shutting down: %v", err)
		}
	}()

	// Start server
	log.Printf("MDP API starting on port %s (Environment: %s)", cfg.Port, cfg.Environment)
	if err := app.Listen(":" + cfg.Port); err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}

func getEnvOrDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
