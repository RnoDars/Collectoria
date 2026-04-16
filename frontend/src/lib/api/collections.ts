const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080'

export interface CollectionSummary {
  userId: string
  totalCardsOwned: number
  totalCardsAvailable: number
  completionPercentage: number
  lastUpdated: string
}

export async function fetchCollectionSummary(): Promise<CollectionSummary> {
  const response = await fetch(`${API_BASE_URL}/api/v1/collections/summary`, {
    headers: {
      'Content-Type': 'application/json',
    },
  })

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
