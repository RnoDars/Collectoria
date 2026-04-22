# Authentication - Collection Management API

## Overview

The Collection Management API uses **JWT (JSON Web Token)** authentication to secure all endpoints except `/health` and `/auth/login`.

## Configuration

### Environment Variables

```bash
# JWT Secret (REQUIRED - minimum 32 characters)
JWT_SECRET=your-super-secret-key-at-least-32-characters-long

# Token expiration in hours (default: 24)
JWT_EXPIRATION_HOURS=24

# Token issuer identifier (default: collectoria-api)
JWT_ISSUER=collectoria-api
```

### Generating a Secure Secret

```bash
# Generate a random 64-character base64 secret
openssl rand -base64 48
```

**IMPORTANT**: Never commit `JWT_SECRET` to version control. Always use environment variables or a secrets manager.

## Authentication Flow

### 1. Login

**Endpoint**: `POST /api/v1/auth/login`

**Request**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_at": "2026-04-23T15:00:00Z"
}
```

**Note**: For MVP, this endpoint performs mock authentication (no password verification). Production implementation should validate against a user database.

### 2. Using the Token

Include the token in the `Authorization` header of all requests to protected endpoints:

```bash
Authorization: Bearer <token>
```

**Example**:
```bash
curl -X GET http://localhost:8080/api/v1/collections/summary \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

## Endpoints

### Public Endpoints (No Authentication Required)

- `GET /api/v1/health` - Health check
- `POST /api/v1/auth/login` - Login

### Protected Endpoints (Authentication Required)

All other endpoints require a valid JWT token:

- `GET /api/v1/collections/summary` - Get collection summary
- `GET /api/v1/collections` - List all collections
- `GET /api/v1/cards` - Get cards catalog
- `PATCH /api/v1/cards/:id/possession` - Update card possession
- `GET /api/v1/activities/recent` - Get recent activities
- `GET /api/v1/statistics/growth` - Get growth statistics

## Error Responses

### 401 Unauthorized - Missing Token

**Request without Authorization header**:
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Missing authorization header"
  }
}
```

### 401 Unauthorized - Invalid Token Format

**Request with malformed token**:
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid authorization format"
  }
}
```

### 401 Unauthorized - Invalid or Expired Token

**Request with invalid/expired token**:
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or expired token"
  }
}
```

## JWT Token Structure

### Claims

The JWT token contains the following claims:

```json
{
  "user_id": "00000000-0000-0000-0000-000000000001",
  "email": "user@example.com",
  "iss": "collectoria-api",
  "iat": 1776863251,
  "exp": 1776949651
}
```

- `user_id`: User UUID
- `email`: User email address
- `iss`: Issuer (from `JWT_ISSUER` env var)
- `iat`: Issued At (Unix timestamp)
- `exp`: Expiration (Unix timestamp)

### Algorithm

- **Signing Algorithm**: HS256 (HMAC with SHA-256)
- **Secret**: Configured via `JWT_SECRET` environment variable

## Testing

### Generate Test Token

```bash
go run scripts/generate_test_token.go
```

This will output:
- User ID
- Email
- Expiration time
- JWT token
- Example curl command

### Manual Testing Script

```bash
./scripts/test_auth.sh
```

This script tests:
1. Public health check
2. Protected endpoint without token (should fail)
3. Login to get token
4. Protected endpoints with valid token
5. Invalid token scenarios

### Test with curl

```bash
# 1. Login
TOKEN=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@collectoria.com","password":"test123"}' | jq -r '.token')

# 2. Use token
curl -X GET http://localhost:8080/api/v1/collections/summary \
  -H "Authorization: Bearer $TOKEN"
```

## Security Best Practices

### Production Deployment

1. **Secret Management**:
   - Use a secrets manager (AWS Secrets Manager, HashiCorp Vault, etc.)
   - Rotate secrets regularly (every 90 days)
   - Never log or expose secrets

2. **HTTPS Only**:
   - Always use HTTPS in production
   - JWT tokens are vulnerable to interception over HTTP

3. **Token Expiration**:
   - Keep expiration time reasonable (24 hours recommended)
   - Implement token refresh mechanism if needed

4. **Rate Limiting**:
   - Implement rate limiting on `/auth/login` endpoint
   - Prevent brute force attacks

5. **Token Storage** (Frontend):
   - Store tokens in `httpOnly` cookies or secure storage
   - Never store in localStorage (XSS vulnerable)

## Development

### Running Tests

```bash
# Run all JWT-related tests
go test -v ./internal/infrastructure/auth/...
go test -v ./internal/infrastructure/http/middleware/...
go test -v ./internal/infrastructure/http/handlers/...
```

### Code Examples

#### Generating a Token (Go)

```go
import "collectoria/collection-management/internal/infrastructure/auth"

jwtService := auth.NewJWTService(secret, issuer, expirationHours)
token, err := jwtService.GenerateToken(userID, email)
```

#### Validating a Token (Go)

```go
claims, err := jwtService.ValidateToken(tokenString)
if err != nil {
    // Invalid token
}
userID := claims.UserID
```

#### Extracting UserID from Context (Handler)

```go
import "collectoria/collection-management/internal/infrastructure/http/middleware"

func (h *Handler) SomeHandler(w http.ResponseWriter, r *http.Request) {
    userID, err := middleware.GetUserID(r.Context())
    if err != nil {
        // User not authenticated
        return
    }
    // Use userID...
}
```

## Future Improvements

- [ ] Implement real user authentication with password hashing
- [ ] Add refresh token mechanism
- [ ] Implement token revocation/blacklist
- [ ] Add OAuth2/OpenID Connect support
- [ ] Implement multi-factor authentication (MFA)
- [ ] Add role-based access control (RBAC)

## References

- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)
- [OWASP JWT Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html)
- [golang-jwt Documentation](https://github.com/golang-jwt/jwt)
