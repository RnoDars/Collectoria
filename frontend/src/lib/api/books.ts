import { apiClient } from './client'

// ─── Types ────────────────────────────────────────────────────────────────────

export interface Book {
  id: string
  collectionId: string
  number: string
  title: string
  author: string
  publicationDate: string
  bookType: 'roman' | 'recueil de romans'
  isOwned: boolean
  createdAt: string
  updatedAt: string
}

export interface BookFilters {
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
      author: b.author,
      publicationDate: b.publication_date,
      bookType: b.book_type,
      isOwned: b.is_owned,
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
  return {
    id: data.book.id,
    collectionId: data.book.collection_id,
    number: data.book.number,
    title: data.book.title,
    author: data.book.author,
    publicationDate: data.book.publication_date,
    bookType: data.book.book_type,
    isOwned: data.book.is_owned,
    createdAt: data.book.created_at,
    updatedAt: data.book.updated_at,
  }
}
