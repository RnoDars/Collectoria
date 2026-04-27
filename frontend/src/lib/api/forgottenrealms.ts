import { apiClient } from './client'

// ─── Types ────────────────────────────────────────────────────────────────────

export interface ForgottenRealmsNovel {
  id: string
  number: string
  title: string
  author: string
  publicationDate: string
  bookType: string
  isOwned: boolean
  createdAt: string
  updatedAt: string
}

export interface NovelFilters {
  search?: string
  author?: string
  bookType?: string
  series?: 'principal' | 'hors-serie'
  isOwned?: boolean
  page?: number
  limit?: number
}

export interface NovelsResponse {
  novels: ForgottenRealmsNovel[]
  pagination: {
    total: number
    page: number
    limit: number
    totalPages: number
  }
}

// ─── API Functions ────────────────────────────────────────────────────────────

export async function fetchNovels(filters: NovelFilters = {}): Promise<NovelsResponse> {
  const params = new URLSearchParams()

  if (filters.page) params.set('page', String(filters.page))
  if (filters.limit) params.set('limit', String(filters.limit))
  if (filters.search) params.set('search', filters.search)
  if (filters.author) params.set('author', filters.author)
  if (filters.bookType) params.set('book_type', filters.bookType)
  if (filters.series) params.set('series', filters.series)
  if (filters.isOwned !== undefined) params.set('is_owned', String(filters.isOwned))

  const response = await apiClient.get(`/api/v1/forgottenrealms/novels?${params.toString()}`)

  if (!response.ok) {
    throw new Error(`Failed to fetch novels: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  return {
    novels: data.novels.map((n: any) => ({
      id: n.id,
      number: n.number,
      title: n.title,
      author: n.author,
      publicationDate: n.publication_date,
      bookType: n.book_type,
      isOwned: n.is_owned,
      createdAt: n.created_at,
      updatedAt: n.updated_at,
    })),
    pagination: {
      total: data.pagination.total,
      page: data.pagination.page,
      limit: data.pagination.limit,
      totalPages: data.pagination.total_pages,
    },
  }
}

export async function toggleNovelPossession(
  novelId: string,
  isOwned: boolean
): Promise<ForgottenRealmsNovel> {
  const response = await apiClient.patch(`/api/v1/forgottenrealms/novels/${novelId}/possession`, {
    is_owned: isOwned,
  })

  if (!response.ok) {
    throw new Error(`Failed to update novel possession: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  return {
    id: data.id,
    number: data.number,
    title: data.title,
    author: data.author,
    publicationDate: data.publication_date,
    bookType: data.book_type,
    isOwned: data.is_owned,
    createdAt: data.created_at,
    updatedAt: data.updated_at,
  }
}
