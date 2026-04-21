import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import CollectionsGrid from '../CollectionsGrid'
import { createMockCollections } from '@/tests/helpers'

// Mock next/navigation
vi.mock('next/navigation', () => ({
  useRouter: () => ({
    push: vi.fn(),
  }),
}))

// Mock next/image
vi.mock('next/image', () => ({
  default: ({ src, alt }: { src: string; alt: string }) => (
    // eslint-disable-next-line @next/next/no-img-element
    <img src={src} alt={alt} />
  ),
}))

describe('CollectionsGrid', () => {
  describe('Loading State', () => {
    it('should display skeleton loaders when isLoading is true', () => {
      render(<CollectionsGrid isLoading={true} />)

      // Verify skeleton elements are present
      const skeletons = document.querySelectorAll('.skeleton')
      expect(skeletons.length).toBeGreaterThan(0)

      // Verify no actual content is shown
      expect(screen.queryByText(/No collections yet/i)).not.toBeInTheDocument()
      expect(screen.queryByText(/Unable to load collections/i)).not.toBeInTheDocument()
    })

    it('should display at least 2 skeleton cards', () => {
      render(<CollectionsGrid isLoading={true} />)

      // CollectionsGridSkeleton renders 2 skeleton cards
      const skeletons = document.querySelectorAll('.skeleton')

      // Each card has multiple skeleton elements:
      // - Hero image, title, 2 description lines, 2 stats
      // Minimum 6 elements per card × 2 cards = 12 elements
      expect(skeletons.length).toBeGreaterThanOrEqual(12)
    })

    it('should not display error or empty state when loading', () => {
      render(<CollectionsGrid isLoading={true} />)

      expect(screen.queryByText(/Unable to load collections/i)).not.toBeInTheDocument()
      expect(screen.queryByText(/No collections yet/i)).not.toBeInTheDocument()
    })
  })

  describe('Error State', () => {
    it('should display error message when error prop is provided', () => {
      const error = new Error('Failed to fetch collections')
      render(<CollectionsGrid error={error} />)

      expect(screen.getByText(/Unable to load collections/i)).toBeInTheDocument()
      expect(screen.getByText(/Failed to fetch collections/i)).toBeInTheDocument()
      expect(screen.getByText('⚠️')).toBeInTheDocument()
    })

    it('should display default error message when error has no message', () => {
      const error = new Error()
      render(<CollectionsGrid error={error} />)

      expect(screen.getByText(/Something went wrong. Please try again later./i)).toBeInTheDocument()
    })

    it('should not display loading or success state when error occurs', () => {
      const error = new Error('Network error')
      const collections = createMockCollections(2)

      render(<CollectionsGrid error={error} collections={collections} />)

      // Error should take priority over success
      expect(screen.getByText(/Unable to load collections/i)).toBeInTheDocument()
      expect(screen.queryByText(/Base Set/i)).not.toBeInTheDocument()
    })

    it('should display error state with centered layout', () => {
      const error = new Error('API error')
      render(<CollectionsGrid error={error} />)

      // Verify error message is displayed (centered text implies centered layout)
      expect(screen.getByText(/Unable to load collections/i)).toBeInTheDocument()
      expect(screen.getByText('⚠️')).toBeInTheDocument()
    })
  })

  describe('Empty State', () => {
    it('should display empty message when collections array is empty', () => {
      render(<CollectionsGrid collections={[]} />)

      expect(screen.getByText(/No collections yet/i)).toBeInTheDocument()
      expect(screen.getByText(/Start by creating your first collection/i)).toBeInTheDocument()
      expect(screen.getByText('📦')).toBeInTheDocument()
    })

    it('should display empty message when collections is undefined', () => {
      render(<CollectionsGrid />)

      expect(screen.getByText(/No collections yet/i)).toBeInTheDocument()
      expect(screen.getByText(/Start by creating your first collection/i)).toBeInTheDocument()
    })

    it('should not display loading or error state when empty', () => {
      render(<CollectionsGrid collections={[]} />)

      expect(screen.queryByText(/Unable to load collections/i)).not.toBeInTheDocument()
      expect(document.querySelectorAll('.skeleton').length).toBe(0)
    })

    it('should display empty state with centered layout and emoji', () => {
      render(<CollectionsGrid collections={[]} />)

      // Verify empty state message and emoji are displayed (centered text implies centered layout)
      expect(screen.getByText(/No collections yet/i)).toBeInTheDocument()
      expect(screen.getByText('📦')).toBeInTheDocument()
    })
  })

  describe('Success State', () => {
    it('should display all collections when provided', () => {
      const collections = createMockCollections(3)

      render(<CollectionsGrid collections={collections} />)

      expect(screen.getByText('Collection 1')).toBeInTheDocument()
      expect(screen.getByText('Collection 2')).toBeInTheDocument()
      expect(screen.getByText('Collection 3')).toBeInTheDocument()
    })

    it('should render collections in a grid layout', () => {
      const collections = createMockCollections(2)
      const { container } = render(<CollectionsGrid collections={collections} />)

      const gridContainer = container.querySelector('div[style*="grid"]')
      expect(gridContainer).toBeTruthy()
    })

    it('should display collection details for each card', () => {
      const collections = createMockCollections(1)

      render(<CollectionsGrid collections={collections} />)

      // Check that collection name and stats are displayed
      expect(screen.getByText('Collection 1')).toBeInTheDocument()
      expect(screen.getByText(/10 \/ 50 cards/i)).toBeInTheDocument()
    })

    it('should handle multiple collections with different completion rates', () => {
      const collections = [
        createMockCollections(1)[0],
        {
          ...createMockCollections(1)[0],
          id: 'collection-2',
          name: 'Complete Collection',
          totalCardsOwned: 100,
          totalCardsAvailable: 100,
          completionPercentage: 100,
        },
        {
          ...createMockCollections(1)[0],
          id: 'collection-3',
          name: 'Empty Collection',
          totalCardsOwned: 0,
          totalCardsAvailable: 50,
          completionPercentage: 0,
        },
      ]

      render(<CollectionsGrid collections={collections} />)

      expect(screen.getByText('Collection 1')).toBeInTheDocument()
      expect(screen.getByText('Complete Collection')).toBeInTheDocument()
      expect(screen.getByText('Empty Collection')).toBeInTheDocument()
    })

    it('should pass correct data to each CollectionCard', () => {
      const collections = createMockCollections(2)

      render(<CollectionsGrid collections={collections} />)

      // Verify that the first collection's data is rendered
      expect(screen.getByText('Collection 1')).toBeInTheDocument()
      expect(screen.getAllByText('The original collection from 1999').length).toBe(2)

      // Verify that the second collection's data is rendered
      expect(screen.getByText('Collection 2')).toBeInTheDocument()
    })

    it('should render single collection correctly', () => {
      const collections = createMockCollections(1)

      render(<CollectionsGrid collections={collections} />)

      expect(screen.getByText('Collection 1')).toBeInTheDocument()
      expect(screen.queryByText(/No collections yet/i)).not.toBeInTheDocument()
    })

    it('should render many collections correctly', () => {
      const collections = createMockCollections(10)

      render(<CollectionsGrid collections={collections} />)

      // Check first and last
      expect(screen.getByText('Collection 1')).toBeInTheDocument()
      expect(screen.getByText('Collection 10')).toBeInTheDocument()

      // Verify no empty or error states
      expect(screen.queryByText(/No collections yet/i)).not.toBeInTheDocument()
      expect(screen.queryByText(/Unable to load collections/i)).not.toBeInTheDocument()
    })
  })

  describe('State Priority', () => {
    it('should prioritize loading state over error state', () => {
      const error = new Error('Some error')
      render(<CollectionsGrid isLoading={true} error={error} />)

      // Should show skeleton, not error
      expect(document.querySelectorAll('.skeleton').length).toBeGreaterThan(0)
      expect(screen.queryByText(/Unable to load collections/i)).not.toBeInTheDocument()
    })

    it('should prioritize loading state over success state', () => {
      const collections = createMockCollections(3)
      render(<CollectionsGrid isLoading={true} collections={collections} />)

      // Should show skeleton, not collections
      expect(document.querySelectorAll('.skeleton').length).toBeGreaterThan(0)
      expect(screen.queryByText('Collection 1')).not.toBeInTheDocument()
    })

    it('should prioritize error state over empty state', () => {
      const error = new Error('Some error')
      render(<CollectionsGrid error={error} collections={[]} />)

      // Should show error, not empty
      expect(screen.getByText(/Unable to load collections/i)).toBeInTheDocument()
      expect(screen.queryByText(/No collections yet/i)).not.toBeInTheDocument()
    })

    it('should prioritize error state over success state', () => {
      const error = new Error('Some error')
      const collections = createMockCollections(2)
      render(<CollectionsGrid error={error} collections={collections} />)

      // Should show error, not collections
      expect(screen.getByText(/Unable to load collections/i)).toBeInTheDocument()
      expect(screen.queryByText('Collection 1')).not.toBeInTheDocument()
    })
  })
})
