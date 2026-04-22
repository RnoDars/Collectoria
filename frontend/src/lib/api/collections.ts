import { apiClient } from './client'

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080'

export interface CollectionSummary {
  userId: string
  totalCardsOwned: number
  totalCardsAvailable: number
  completionPercentage: number
  lastUpdated: string
}

export interface Collection {
  id: string
  name: string
  slug: string
  description: string
  totalCardsOwned: number
  totalCardsAvailable: number
  completionPercentage: number
  heroImageUrl: string
  lastUpdated: string | null
}

export interface CollectionsResponse {
  collections: Collection[]
  totalCollections: number
}

export async function fetchCollectionSummary(): Promise<CollectionSummary> {
  const response = await apiClient.get('/api/v1/collections/summary')

  if (!response.ok) {
    throw new Error(`Failed to fetch collection summary: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  return {
    userId: data.user_id,
    totalCardsOwned: data.total_cards_owned,
    totalCardsAvailable: data.total_cards_available,
    completionPercentage: data.completion_percentage,
    lastUpdated: data.last_updated,
  }
}

export interface Activity {
  id: string
  type: 'card_added' | 'milestone_reached' | 'import_completed'
  title: string
  description: string
  timestamp: string
  icon: string
  relatedCollectionId?: string
  relatedCollectionName?: string
  metadata?: Record<string, string>
}

export interface ActivityFeed {
  activities: Activity[]
  totalCount: number
  hasMore: boolean
}

export interface GrowthDataPoint {
  period: string
  label: string
  cardsAdded: number
  totalCards: number
}

export interface GrowthStats {
  period: string
  granularity: string
  dataPoints: GrowthDataPoint[]
  growthRatePercentage: number
  trend: 'increasing' | 'decreasing' | 'stable'
}

export async function fetchRecentActivities(limit = 10): Promise<ActivityFeed> {
  const response = await apiClient.get(`/api/v1/activities/recent?limit=${limit}`)
  if (!response.ok) throw new Error(`Failed to fetch activities: ${response.statusText}`)
  const data = await response.json()
  return {
    activities: data.activities.map((a: any) => ({
      id: a.id,
      type: a.type,
      title: a.title,
      description: a.description,
      timestamp: a.timestamp,
      icon: a.icon,
      relatedCollectionId: a.related_collection_id,
      relatedCollectionName: a.related_collection_name,
      metadata: a.metadata,
    })),
    totalCount: data.total_count,
    hasMore: data.has_more,
  }
}

export async function fetchGrowthStats(period = '6m', granularity = 'month'): Promise<GrowthStats> {
  const response = await apiClient.get(
    `/api/v1/statistics/growth?period=${period}&granularity=${granularity}`
  )
  if (!response.ok) throw new Error(`Failed to fetch growth stats: ${response.statusText}`)
  const data = await response.json()
  return {
    period: data.period,
    granularity: data.granularity,
    dataPoints: data.data_points.map((dp: any) => ({
      period: dp.period,
      label: dp.label,
      cardsAdded: dp.cards_added,
      totalCards: dp.total_cards,
    })),
    growthRatePercentage: data.growth_rate_percentage,
    trend: data.trend,
  }
}

// ─── Cards ────────────────────────────────────────────────────────────────────

export interface Card {
  id: string
  nameEn: string
  nameFr: string
  cardType: string
  series: string
  rarity: string
  isOwned: boolean
}

export interface CardPage {
  cards: Card[]
  total: number
  page: number
  hasMore: boolean
  timestamp: string
}

export interface CardFilters {
  search?: string
  series?: string
  type?: string
  rarity?: string
  owned?: 'true' | 'false'
}

export async function fetchCards(filters: CardFilters, page: number): Promise<CardPage> {
  const params = new URLSearchParams()
  params.set('page', String(page))
  params.set('limit', '50')
  if (filters.search)  params.set('search',  filters.search)
  if (filters.series)  params.set('series',  filters.series)
  if (filters.type)    params.set('type',    filters.type)
  if (filters.rarity)  params.set('rarity',  filters.rarity)
  if (filters.owned)   params.set('owned',   filters.owned)

  const response = await apiClient.get(`/api/v1/cards?${params.toString()}`)

  if (!response.ok) {
    throw new Error(`Failed to fetch cards: ${response.statusText}`)
  }

  const data = await response.json()

  return {
    cards: data.cards.map((c: any) => ({
      id: c.id,
      nameEn: c.name_en,
      nameFr: c.name_fr,
      cardType: c.card_type,
      series: c.series,
      rarity: c.rarity,
      isOwned: c.is_owned,
    })),
    total: data.total,
    page: data.page,
    hasMore: data.has_more,
    timestamp: data.timestamp,
  }
}

// ─── Card Possession ──────────────────────────────────────────────────────────

export async function updateCardPossession(
  cardId: string,
  isOwned: boolean
): Promise<Card> {
  const response = await apiClient.patch(`/api/v1/cards/${cardId}/possession`, {
    is_owned: isOwned,
  })

  if (!response.ok) {
    throw new Error(`Failed to update card possession: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  return {
    id: data.card.id,
    nameEn: data.card.name_en,
    nameFr: data.card.name_fr,
    cardType: data.card.card_type,
    series: data.card.series,
    rarity: data.card.rarity,
    isOwned: data.card.is_owned,
  }
}

// ─── Collections ─────────────────────────────────────────────────────────────

export async function fetchCollections(): Promise<Collection[]> {
  const response = await apiClient.get('/api/v1/collections')

  if (!response.ok) {
    throw new Error(`Failed to fetch collections: ${response.statusText}`)
  }

  const data = await response.json()

  // Convert snake_case to camelCase
  return data.collections.map((collection: any) => ({
    id: collection.id,
    name: collection.name,
    slug: collection.slug,
    description: collection.description,
    totalCardsOwned: collection.total_cards_owned,
    totalCardsAvailable: collection.total_cards_available,
    completionPercentage: collection.completion_percentage,
    heroImageUrl: collection.hero_image_url,
    lastUpdated: collection.last_updated,
  }))
}
