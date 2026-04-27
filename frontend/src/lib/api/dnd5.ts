import { apiClient } from './client'

// ─── Types ────────────────────────────────────────────────────────────────────

export interface DnD5Book {
  id: string
  number: string
  nameEn: string
  nameFr: string | null
  bookType: string
  ownedEn: boolean | null
  ownedFr: boolean | null
  edition?: string
  publicationDate: string
  createdAt: string
  updatedAt: string
}

export interface DnD5Filters {
  search?: string
  bookType?: string
  ownedVersion?: 'en' | 'fr' | 'both' | 'none' | 'any'
  sortBy?: 'name_en' | 'name_fr' | 'number'
  page?: number
  limit?: number
}

export interface DnD5BooksResponse {
  books: DnD5Book[]
  pagination: {
    total: number
    page: number
    limit: number
    totalPages: number
  }
}

// ─── API Functions ────────────────────────────────────────────────────────────

export async function fetchBooks(filters: DnD5Filters = {}): Promise<DnD5BooksResponse> {
  const params = new URLSearchParams()

  if (filters.page) params.set('page', String(filters.page))
  if (filters.limit) params.set('limit', String(filters.limit))
  if (filters.search) params.set('search', filters.search)
  if (filters.bookType) params.set('book_type', filters.bookType)
  if (filters.ownedVersion) params.set('owned_version', filters.ownedVersion)
  if (filters.sortBy) params.set('sort_by', filters.sortBy)

  const response = await apiClient.get(`/api/v1/dnd5/books?${params.toString()}`)

  if (!response.ok) {
    throw new Error(`Failed to fetch D&D 5e books: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  return {
    books: data.books.map((b: any) => ({
      id: b.id,
      number: b.number,
      nameEn: b.name_en,
      nameFr: b.name_fr,
      bookType: b.book_type,
      ownedEn: b.owned_en,
      ownedFr: b.owned_fr,
      edition: b.edition,
      publicationDate: b.publication_date,
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

export async function updateBookOwnership(
  bookId: string,
  ownership: { ownedEn?: boolean; ownedFr?: boolean }
): Promise<DnD5Book> {
  const body: any = {}
  if (ownership.ownedEn !== undefined) body.owned_en = ownership.ownedEn
  if (ownership.ownedFr !== undefined) body.owned_fr = ownership.ownedFr

  const response = await apiClient.patch(`/api/v1/dnd5/books/${bookId}/ownership`, body)

  if (!response.ok) {
    throw new Error(`Failed to update book ownership: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  return {
    id: data.id,
    number: data.number,
    nameEn: data.name_en,
    nameFr: data.name_fr,
    bookType: data.book_type,
    ownedEn: data.owned_en,
    ownedFr: data.owned_fr,
    edition: data.edition,
    publicationDate: data.publication_date,
    createdAt: data.created_at,
    updatedAt: data.updated_at,
  }
}
