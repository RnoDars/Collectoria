package middleware

import (
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/ulule/limiter/v3"
	"github.com/ulule/limiter/v3/drivers/store/memory"
)

// RateLimitConfig configuration du rate limiter
type RateLimitConfig struct {
	Requests int64         // Nombre de requêtes autorisées
	Window   time.Duration // Fenêtre de temps
}

// NewRateLimiter crée un middleware de rate limiting
func NewRateLimiter(config RateLimitConfig) func(http.Handler) http.Handler {
	rate := limiter.Rate{
		Period: config.Window,
		Limit:  config.Requests,
	}

	store := memory.NewStore()
	instance := limiter.New(store, rate)

	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Extraire IP client
			ip := getClientIP(r)

			// Créer contexte de limite
			limiterCtx, err := instance.Get(r.Context(), ip)
			if err != nil {
				http.Error(w, "Rate limiter error", http.StatusInternalServerError)
				return
			}

			// Ajouter headers X-RateLimit-*
			w.Header().Set("X-RateLimit-Limit", strconv.FormatInt(limiterCtx.Limit, 10))
			w.Header().Set("X-RateLimit-Remaining", strconv.FormatInt(limiterCtx.Remaining, 10))
			w.Header().Set("X-RateLimit-Reset", strconv.FormatInt(limiterCtx.Reset, 10))

			// Vérifier limite
			if limiterCtx.Reached {
				retryAfter := limiterCtx.Reset - time.Now().Unix()
				if retryAfter < 0 {
					retryAfter = 0
				}
				w.Header().Set("Retry-After", strconv.FormatInt(retryAfter, 10))
				http.Error(w, "Rate limit exceeded", http.StatusTooManyRequests)
				return
			}

			next.ServeHTTP(w, r)
		})
	}
}

// getClientIP extrait l'IP du client depuis les headers ou RemoteAddr
func getClientIP(r *http.Request) string {
	// Vérifier header X-Forwarded-For (proxy)
	if ip := r.Header.Get("X-Forwarded-For"); ip != "" {
		// Prendre la première IP de la liste (client original)
		return strings.TrimSpace(strings.Split(ip, ",")[0])
	}

	// Vérifier header X-Real-IP
	if ip := r.Header.Get("X-Real-IP"); ip != "" {
		return strings.TrimSpace(ip)
	}

	// Fallback sur RemoteAddr
	// Format peut être "IP:port", extraire juste l'IP
	ip := r.RemoteAddr
	if colon := strings.LastIndex(ip, ":"); colon != -1 {
		ip = ip[:colon]
	}

	return ip
}
