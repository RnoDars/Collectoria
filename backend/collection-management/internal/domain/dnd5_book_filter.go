package domain

// DnD5BookFilter regroupe les critères de filtrage du catalogue de livres D&D 5e
type DnD5BookFilter struct {
	Search       string // Recherche dans le titre (EN ou FR)
	BookType     string // "Core Rules", "Supplément de règles", "Setting", "Campagnes", "Recueil d'aventures", "Starter Set"
	OwnedVersion string // "en", "fr", "both", "none", "any"
	SortBy       string // "name_en", "name_fr", "number"
	Page         int
	Limit        int
}

// DnD5BookPage représente une page de résultats du catalogue de livres D&D 5e
type DnD5BookPage struct {
	Books   []DnD5BookWithOwnership
	Total   int
	Page    int
	HasMore bool
}
