package domain

// BookFilter regroupe les critères de filtrage du catalogue de livres
type BookFilter struct {
	Search   string // Recherche dans le titre
	Author   string // Filtrage par auteur
	BookType string // "roman" ou "recueil de romans"
	Series   string // "principal" (1-84) ou "hors-serie" (HS)
	IsOwned  *bool  // nil = tous, true = possédés, false = non possédés
	Page     int
	Limit    int
}

// BookPage représente une page de résultats du catalogue de livres
type BookPage struct {
	Books   []BookWithOwnership
	Total   int
	Page    int
	HasMore bool
}
