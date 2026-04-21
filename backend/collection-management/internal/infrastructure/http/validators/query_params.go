package validators

import (
	"fmt"
	"net/http"
	"strconv"
)

// QueryParams représente les paramètres de requête validés
type QueryParams struct {
	Limit  int
	Offset int
}

// ValidateQueryParams valide les paramètres de requête communs (limit, offset)
func ValidateQueryParams(r *http.Request) (*QueryParams, error) {
	params := &QueryParams{
		Limit:  20, // Valeur par défaut
		Offset: 0,  // Valeur par défaut
	}

	// Validation du paramètre limit
	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		limit, err := strconv.Atoi(limitStr)
		if err != nil {
			return nil, fmt.Errorf("invalid limit parameter: must be an integer")
		}
		if limit < 1 {
			return nil, fmt.Errorf("invalid limit parameter: must be greater than 0")
		}
		if limit > 100 {
			return nil, fmt.Errorf("invalid limit parameter: maximum is 100")
		}
		params.Limit = limit
	}

	// Validation du paramètre offset
	if offsetStr := r.URL.Query().Get("offset"); offsetStr != "" {
		offset, err := strconv.Atoi(offsetStr)
		if err != nil {
			return nil, fmt.Errorf("invalid offset parameter: must be an integer")
		}
		if offset < 0 {
			return nil, fmt.Errorf("invalid offset parameter: must be non-negative")
		}
		params.Offset = offset
	}

	return params, nil
}

// ValidateStringParam valide un paramètre de type string
func ValidateStringParam(value string, maxLength int) error {
	if len(value) > maxLength {
		return fmt.Errorf("parameter too long: maximum length is %d", maxLength)
	}
	return nil
}

// ValidateIDParam valide un paramètre ID
func ValidateIDParam(idStr string) (int, error) {
	if idStr == "" {
		return 0, fmt.Errorf("id parameter is required")
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		return 0, fmt.Errorf("invalid id parameter: must be an integer")
	}

	if id < 1 {
		return 0, fmt.Errorf("invalid id parameter: must be greater than 0")
	}

	return id, nil
}
