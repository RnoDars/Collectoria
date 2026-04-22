// Package main provides a simple script to generate a test JWT token
package main

import (
	"fmt"
	"os"
	"time"

	"collectoria/collection-management/internal/infrastructure/auth"
	"github.com/google/uuid"
)

func main() {
	// Use the same secret from .env
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		secret = "MzomafcEHPVju5NzrKgem16EzhxfGYfEBNdpSgj0Szm/35nALrsvO3gC4AcS5F2g"
	}

	issuer := "collectoria-api"
	expirationHours := 24

	jwtService := auth.NewJWTService(secret, issuer, expirationHours)

	// Generate a test token for a test user
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	email := "test@collectoria.com"

	token, err := jwtService.GenerateToken(userID, email)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error generating token: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("=== Test JWT Token ===")
	fmt.Printf("User ID: %s\n", userID.String())
	fmt.Printf("Email: %s\n", email)
	fmt.Printf("Expires: %s\n", time.Now().Add(time.Duration(expirationHours)*time.Hour).Format(time.RFC3339))
	fmt.Println()
	fmt.Println("Token:")
	fmt.Println(token)
	fmt.Println()
	fmt.Println("=== Usage Example ===")
	fmt.Printf("curl -X GET http://localhost:8080/api/v1/collections/summary \\\n")
	fmt.Printf("  -H \"Authorization: Bearer %s\"\n", token)
}
