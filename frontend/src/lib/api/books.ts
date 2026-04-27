import { apiClient } from './client'

// ─── Types ────────────────────────────────────────────────────────────────────

export interface Book {
  id: string
  collectionId: string
  number: string
  title: string
  nameEn?: string
  nameFr?: string
  author: string
  publicationDate: string
  edition?: string
  bookType: string
  isOwned?: boolean
  ownedEn?: boolean
  ownedFr?: boolean
  createdAt: string
  updatedAt: string
}

export interface BookFilters {
  collectionId?: string
  search?: string
  author?: string
  bookType?: string
  series?: 'principal' | 'hors-serie'
  isOwned?: boolean
  page?: number
  limit?: number
}

export interface BooksResponse {
  books: Book[]
  pagination: {
    total: number
    page: number
    limit: number
    totalPages: number
  }
}

// ─── API Functions ────────────────────────────────────────────────────────────

export async function fetchBooks(filters: BookFilters = {}): Promise<BooksResponse> {
  const params = new URLSearchParams()

  if (filters.collectionId) params.set('collection_id', filters.collectionId)
  if (filters.page) params.set('page', String(filters.page))
  if (filters.limit) params.set('limit', String(filters.limit))
  if (filters.search) params.set('search', filters.search)
  if (filters.author) params.set('author', filters.author)
  if (filters.bookType) params.set('book_type', filters.bookType)
  if (filters.series) params.set('series', filters.series)
  if (filters.isOwned !== undefined) params.set('is_owned', String(filters.isOwned))

  const response = await apiClient.get(`/api/v1/books?${params.toString()}`)

  if (!response.ok) {
    throw new Error(`Failed to fetch books: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  return {
    books: data.books.map((b: any) => ({
      id: b.id,
      collectionId: b.collection_id,
      number: b.number,
      title: b.title,
      nameEn: b.name_en,
      nameFr: b.name_fr,
      author: b.author,
      publicationDate: b.publication_date,
      edition: b.edition,
      bookType: b.book_type,
      isOwned: b.is_owned,
      ownedEn: b.owned_en,
      ownedFr: b.owned_fr,
      createdAt: b.created_at,
      updatedAt: b.updated_at,
    })),
    pagination: {
      total: data.pagination.total,
      page: data.pagination.page,
      limit: data.pagination.limit,
      totalPages: data.pagination.total_pages,
    },
  }
}

export async function toggleBookPossession(
  bookId: string,
  isOwned: boolean
): Promise<Book> {
  const response = await apiClient.patch(`/api/v1/books/${bookId}/possession`, {
    is_owned: isOwned,
  })

  if (!response.ok) {
    throw new Error(`Failed to update book possession: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  // Backend returns Book object directly (not wrapped in {book: ...})
  return {
    id: data.id,
    collectionId: data.collection_id,
    number: data.number,
    title: data.title,
    nameEn: data.name_en,
    nameFr: data.name_fr,
    author: data.author,
    publicationDate: data.publication_date,
    edition: data.edition,
    bookType: data.book_type,
    isOwned: data.is_owned,
    ownedEn: data.owned_en,
    ownedFr: data.owned_fr,
    createdAt: data.created_at,
    updatedAt: data.updated_at,
  }
}
