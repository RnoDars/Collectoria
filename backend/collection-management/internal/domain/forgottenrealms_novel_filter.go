package domain

// ForgottenRealmsNovelFilter regroupe les critères de filtrage du catalogue de romans des Royaumes Oubliés
type ForgottenRealmsNovelFilter struct {
	Search   string // Recherche dans le titre
	Author   string // Filtrage par auteur
	BookType string // "roman" ou "recueil de romans"
	Series   string // "principal" (1-84) ou "hors-serie" (HS)
	IsOwned  *bool  // nil = tous, true = possédés, false = non possédés
	Page     int
	Limit    int
}

// ForgottenRealmsNovelPage représente une page de résultats du catalogue de romans
type ForgottenRealmsNovelPage struct {
	Novels  []ForgottenRealmsNovelWithOwnership
	Total   int
	Page    int
	HasMore bool
}
