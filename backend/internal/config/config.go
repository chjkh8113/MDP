package config

import (
	"log"
	"os"
)

type Config struct {
	Port        string
	DatabaseURL string
	JWTSecret   string
	Environment string
}

func Load() *Config {
	env := getEnv("ENVIRONMENT", "development")

	cfg := &Config{
		Port:        getEnv("PORT", "8181"),
		DatabaseURL: getDatabaseURL(env),
		JWTSecret:   getJWTSecret(env),
		Environment: env,
	}

	// Validate required config in production
	if env == "production" {
		if cfg.JWTSecret == "" {
			log.Fatal("CRITICAL: JWT_SECRET environment variable is required in production")
		}
		if cfg.DatabaseURL == "" {
			log.Fatal("CRITICAL: DATABASE_URL environment variable is required in production")
		}
	}

	return cfg
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getDatabaseURL(env string) string {
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL != "" {
		return dbURL
	}

	// Only allow default in development
	if env == "development" {
		log.Println("WARNING: Using default database credentials (development only)")
		return "postgres://postgres:postgres@localhost:5432/mdp?sslmode=disable"
	}

	return ""
}

func getJWTSecret(env string) string {
	secret := os.Getenv("JWT_SECRET")
	if secret != "" {
		return secret
	}

	// Only allow default in development
	if env == "development" {
		log.Println("WARNING: Using default JWT secret (development only)")
		return "dev-secret-do-not-use-in-production"
	}

	return ""
}
