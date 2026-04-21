import { CollectionSummary, Collection } from '@/lib/api/collections'

/**
 * Mock data factory for CollectionSummary
 */
export function createMockCollectionSummary(
  overrides?: Partial<CollectionSummary>
): CollectionSummary {
  return {
    userId: 'user-123',
    totalCardsOwned: 150,
    totalCardsAvailable: 500,
    completionPercentage: 30,
    lastUpdated: '2024-03-15T10:00:00Z',
    ...overrides,
  }
}

/**
 * Mock data factory for Collection
 */
export function createMockCollection(
  overrides?: Partial<Collection>
): Collection {
  return {
    id: 'collection-1',
    name: 'Base Set',
    slug: 'base-set',
    description: 'The original collection from 1999',
    totalCardsOwned: 45,
    totalCardsAvailable: 102,
    completionPercentage: 44.12,
    heroImageUrl: '/images/base-set.jpg',
    lastUpdated: '2024-03-15T10:00:00Z',
    ...overrides,
  }
}

/**
 * Mock data factory for multiple Collections
 */
export function createMockCollections(count: number): Collection[] {
  return Array.from({ length: count }, (_, i) =>
    createMockCollection({
      id: `collection-${i + 1}`,
      name: `Collection ${i + 1}`,
      slug: `collection-${i + 1}`,
      totalCardsOwned: 10 + i * 5,
      totalCardsAvailable: 50 + i * 10,
      completionPercentage: Math.round(((10 + i * 5) / (50 + i * 10)) * 100),
    })
  )
}

/**
 * Wait for animations and async updates
 */
export const waitForAnimation = () => new Promise((resolve) => setTimeout(resolve, 100))
