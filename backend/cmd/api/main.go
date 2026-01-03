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

	// Middleware
	app.Use(recover.New())
	app.Use(logger.New(logger.Config{
		Format:     "${time} | ${status} | ${latency} | ${method} ${path}\n",
		TimeFormat: "2006-01-02 15:04:05",
	}))
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowMethods: "GET,POST,PUT,DELETE,OPTIONS",
		AllowHeaders: "Origin,Content-Type,Accept,Authorization",
	}))

	// API Routes
	api := app.Group("/api/v1")

	// Health check
	api.Get("/health", h.HealthCheck)

	// Fields, Courses & Topics
	api.Get("/fields", h.GetFields)
	api.Get("/fields/:fieldId/courses", h.GetCourses)
	api.Get("/courses/:courseId/topics", h.GetTopics)
	api.Get("/topics/:topicId/questions", h.GetQuestionsByTopic)

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
	log.Printf("MDP API starting on port %s", cfg.Port)
	if err := app.Listen(":" + cfg.Port); err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
