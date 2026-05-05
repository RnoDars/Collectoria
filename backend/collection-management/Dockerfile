# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/api

# Final stage
FROM alpine:3.19

# Install ca-certificates and create non-root user
RUN apk --no-cache add ca-certificates wget && \
    addgroup -g 1000 collectoria && \
    adduser -D -u 1000 -G collectoria collectoria

WORKDIR /app

# Copy binary with correct ownership
COPY --from=builder --chown=collectoria:collectoria /app/main .

# Switch to non-root user
USER collectoria

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 -O- http://localhost:8080/api/v1/health || exit 1

# Run the binary
CMD ["./main"]
