import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import HeroCard from '../HeroCard'
import { createMockCollectionSummary } from '@/tests/helpers'

describe('HeroCard', () => {
  describe('Loading State', () => {
    it('should display skeleton loader when isLoading is true', () => {
      render(<HeroCard isLoading={true} />)

      // Verify skeleton elements are present
      const skeletons = document.querySelectorAll('.skeleton')
      expect(skeletons.length).toBeGreaterThan(0)

      // Verify no actual content is shown
      expect(screen.queryByText(/Total Collection Progress/i)).not.toBeInTheDocument()
      expect(screen.queryByText(/completed/i)).not.toBeInTheDocument()
    })

    it('should not display error or empty state when loading', () => {
      render(<HeroCard isLoading={true} />)

      expect(screen.queryByText(/Unable to load collection data/i)).not.toBeInTheDocument()
      expect(screen.queryByText(/No collection data available/i)).not.toBeInTheDocument()
    })

    it('should display multiple skeleton elements for different sections', () => {
      render(<HeroCard isLoading={true} />)

      const skeletons = document.querySelectorAll('.skeleton')

      // Should have skeletons for: label, title, percentage, "completed", stats (2x), buttons (3x)
      // At least 7 skeleton elements
      expect(skeletons.length).toBeGreaterThanOrEqual(7)
    })
  })

  describe('Error State', () => {
    it('should display error message when error prop is provided', () => {
      const error = new Error('Network error occurred')
      render(<HeroCard error={error} />)

      expect(screen.getByText(/Unable to load collection data/i)).toBeInTheDocument()
      expect(screen.getByText(/Network error occurred/i)).toBeInTheDocument()
      expect(screen.getByText('⚠️')).toBeInTheDocument()
    })

    it('should display default error message when error has no message', () => {
      const error = new Error()
      render(<HeroCard error={error} />)

      expect(screen.getByText(/Something went wrong. Please try again./i)).toBeInTheDocument()
    })

    it('should display retry button when onRetry is provided', () => {
      const error = new Error('Connection failed')
      const onRetry = vi.fn()

      render(<HeroCard error={error} onRetry={onRetry} />)

      const retryButton = screen.getByRole('button', { name: /retry/i })
      expect(retryButton).toBeInTheDocument()
    })

    it('should call onRetry when retry button is clicked', async () => {
      const user = userEvent.setup()
      const error = new Error('Connection failed')
      const onRetry = vi.fn()

      render(<HeroCard error={error} onRetry={onRetry} />)

      const retryButton = screen.getByRole('button', { name: /retry/i })
      await user.click(retryButton)

      expect(onRetry).toHaveBeenCalledTimes(1)
    })

    it('should not display retry button when onRetry is not provided', () => {
      const error = new Error('Connection failed')
      render(<HeroCard error={error} />)

      expect(screen.queryByRole('button', { name: /retry/i })).not.toBeInTheDocument()
    })
  })

  describe('Empty State', () => {
    it('should display empty message when summary is not provided', () => {
      render(<HeroCard />)

      expect(screen.getByText(/No collection data available/i)).toBeInTheDocument()
    })

    it('should not display loading or error state when empty', () => {
      render(<HeroCard />)

      expect(screen.queryByText(/Unable to load collection data/i)).not.toBeInTheDocument()
      expect(document.querySelectorAll('.skeleton').length).toBe(0)
    })

    it('should display empty state even when isLoading is false', () => {
      render(<HeroCard isLoading={false} />)

      expect(screen.getByText(/No collection data available/i)).toBeInTheDocument()
    })
  })

  describe('Success State', () => {
    it('should display all collection data when summary is provided', () => {
      const summary = createMockCollectionSummary({
        totalCardsOwned: 150,
        totalCardsAvailable: 500,
        completionPercentage: 30,
      })

      render(<HeroCard summary={summary} />)

      expect(screen.getByText(/Total Collection Progress/i)).toBeInTheDocument()
      expect(screen.getByText('30%')).toBeInTheDocument()
      expect(screen.getByText(/completed/i)).toBeInTheDocument()
      expect(screen.getByText(/150/)).toBeInTheDocument()
      expect(screen.getByText(/500 Cards Owned/)).toBeInTheDocument()
    })

    it('should display correct "cards to go" count', () => {
      const summary = createMockCollectionSummary({
        totalCardsOwned: 150,
        totalCardsAvailable: 500,
      })

      render(<HeroCard summary={summary} />)

      // 500 - 150 = 350 cards to go
      expect(screen.getByText('350')).toBeInTheDocument()
      expect(screen.getByText(/to go/i)).toBeInTheDocument()
    })

    it('should not display "cards to go" when collection is complete', () => {
      const summary = createMockCollectionSummary({
        totalCardsOwned: 500,
        totalCardsAvailable: 500,
        completionPercentage: 100,
      })

      render(<HeroCard summary={summary} />)

      expect(screen.queryByText(/to go/i)).not.toBeInTheDocument()
      expect(screen.getByText('100%')).toBeInTheDocument()
    })

    it('should display Add Card link', () => {
      const summary = createMockCollectionSummary()

      render(<HeroCard summary={summary} />)

      const addCardLink = screen.getByRole('link', { name: /Add Card/i })
      expect(addCardLink).toBeInTheDocument()
      expect(addCardLink).toHaveAttribute('href', '/cards/add')
    })

    it('should round completion percentage to nearest integer', () => {
      const summary = createMockCollectionSummary({
        completionPercentage: 45.678,
      })

      render(<HeroCard summary={summary} />)

      expect(screen.getByText('46%')).toBeInTheDocument()
      expect(screen.queryByText('45.678%')).not.toBeInTheDocument()
    })

    it('should display dashboard overview label', () => {
      const summary = createMockCollectionSummary()

      render(<HeroCard summary={summary} />)

      expect(screen.getByText(/Dashboard Overview/i)).toBeInTheDocument()
    })

    it('should display emoji indicators', () => {
      const summary = createMockCollectionSummary({
        totalCardsOwned: 150,
        totalCardsAvailable: 500,
      })

      render(<HeroCard summary={summary} />)

      expect(screen.getByText('💎')).toBeInTheDocument()
      expect(screen.getByText('🎯')).toBeInTheDocument()
    })
  })

  describe('State Priority', () => {
    it('should prioritize loading state over error state', () => {
      const error = new Error('Some error')
      render(<HeroCard isLoading={true} error={error} />)

      // Should show skeleton, not error
      expect(document.querySelectorAll('.skeleton').length).toBeGreaterThan(0)
      expect(screen.queryByText(/Unable to load collection data/i)).not.toBeInTheDocument()
    })

    it('should prioritize error state over empty state', () => {
      const error = new Error('Some error')
      render(<HeroCard error={error} />)

      // Should show error, not empty
      expect(screen.getByText(/Unable to load collection data/i)).toBeInTheDocument()
      expect(screen.queryByText(/No collection data available/i)).not.toBeInTheDocument()
    })

    it('should prioritize success state over empty when summary is provided', () => {
      const summary = createMockCollectionSummary()
      render(<HeroCard summary={summary} />)

      // Should show data, not empty
      expect(screen.getByText(/Total Collection Progress/i)).toBeInTheDocument()
      expect(screen.queryByText(/No collection data available/i)).not.toBeInTheDocument()
    })
  })
})
