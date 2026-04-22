import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor, fireEvent } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import CardsPage from '../page'
import * as cardsHook from '@/hooks/useCards'
import * as toggleHook from '@/hooks/useCardToggle'

// Mock Next.js Link
vi.mock('next/link', () => ({
  default: ({ children, href }: { children: React.ReactNode; href: string }) => (
    <a href={href}>{children}</a>
  ),
}))

// Mock toast
vi.mock('react-hot-toast', () => ({
  default: {
    success: vi.fn(),
    error: vi.fn(),
  },
  Toaster: () => null,
}))

const mockCards = [
  {
    id: '1',
    nameEn: 'Gandalf the Grey',
    nameFr: 'Gandalf le Gris',
    cardType: 'Héros / Personnage / Sorcier',
    series: 'Les Sorciers',
    rarity: 'R',
    isOwned: false,
  },
  {
    id: '2',
    nameEn: 'Aragorn',
    nameFr: 'Aragorn',
    cardType: 'Héros / Personnage',
    series: 'Les Sorciers',
    rarity: 'U',
    isOwned: true,
  },
]

function createWrapper() {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
      mutations: { retry: false },
    },
  })
  return ({ children }: { children: React.ReactNode }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  )
}

describe('CardsPage', () => {
  const mockToggleCard = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()

    // Mock useCards hook
    vi.spyOn(cardsHook, 'useCards').mockReturnValue({
      data: {
        pages: [
          {
            cards: mockCards,
            total: 2,
            page: 1,
            hasMore: false,
            timestamp: new Date().toISOString(),
          },
        ],
        pageParams: [1],
      },
      fetchNextPage: vi.fn(),
      hasNextPage: false,
      isFetchingNextPage: false,
      isLoading: false,
      isError: false,
      error: null,
    } as any)

    // Mock useCardToggle hook
    vi.spyOn(toggleHook, 'useCardToggle').mockReturnValue({
      toggleCard: mockToggleCard,
      isLoading: false,
    })
  })

  it('renders page title and back link', () => {
    render(<CardsPage />, { wrapper: createWrapper() })

    expect(screen.getByText('Gérer ma Collection')).toBeInTheDocument()
    expect(screen.getByText('← Retour au dashboard')).toBeInTheDocument()
  })

  it('displays card count', () => {
    render(<CardsPage />, { wrapper: createWrapper() })

    expect(screen.getByText('2 cartes disponibles')).toBeInTheDocument()
  })

  it('renders filter inputs', () => {
    render(<CardsPage />, { wrapper: createWrapper() })

    expect(screen.getByPlaceholderText('Rechercher une carte...')).toBeInTheDocument()
    expect(screen.getByLabelText('Filtrer par série')).toBeInTheDocument()
    expect(screen.getByLabelText('Filtrer par type')).toBeInTheDocument()
    expect(screen.getByLabelText('Filtrer par rareté')).toBeInTheDocument()
  })

  it('renders ownership filter toggle buttons', () => {
    render(<CardsPage />, { wrapper: createWrapper() })

    expect(screen.getByText('Toutes')).toBeInTheDocument()
    expect(screen.getByText('Possédées')).toBeInTheDocument()
    expect(screen.getByText('Non possédées')).toBeInTheDocument()
  })

  it('displays cards in grid', () => {
    render(<CardsPage />, { wrapper: createWrapper() })

    expect(screen.getByText('Gandalf le Gris')).toBeInTheDocument()
    // Check for both cards (Aragorn appears in the card, not in filters)
    const cards = screen.getAllByText('Aragorn')
    expect(cards.length).toBeGreaterThan(0)
  })

  it('shows owned status for each card', () => {
    render(<CardsPage />, { wrapper: createWrapper() })

    const ownedLabels = screen.getAllByText('Possédée')
    const notOwnedLabels = screen.getAllByText('Non possédée')

    expect(ownedLabels).toHaveLength(1)
    expect(notOwnedLabels).toHaveLength(1)
  })

  it('opens confirmation modal when toggle button is clicked', async () => {
    const user = userEvent.setup()
    render(<CardsPage />, { wrapper: createWrapper() })

    const toggleButtons = screen.getAllByRole('switch')
    expect(toggleButtons).toHaveLength(2)

    // Click on first card's toggle (Gandalf - not owned)
    await user.click(toggleButtons[0])

    // Modal should appear
    await waitFor(() => {
      expect(screen.getByRole('dialog')).toBeInTheDocument()
      expect(screen.getByText("Confirmer l'action")).toBeInTheDocument()
      expect(screen.getByText(/Voulez-vous marquer cette carte comme possédée/i)).toBeInTheDocument()
    })

    // Click confirm button
    const confirmButton = screen.getByRole('button', { name: /Confirmer/i })
    await user.click(confirmButton)

    // Now the API should be called
    await waitFor(() => {
      expect(mockToggleCard).toHaveBeenCalledWith(
        { cardId: '1', isOwned: true },
        expect.any(Object)
      )
    })
  })

  it('cancels toggle when modal is cancelled', async () => {
    const user = userEvent.setup()
    render(<CardsPage />, { wrapper: createWrapper() })

    const toggleButtons = screen.getAllByRole('switch')

    // Click on first card's toggle
    await user.click(toggleButtons[0])

    // Modal should appear
    await waitFor(() => {
      expect(screen.getByRole('dialog')).toBeInTheDocument()
    })

    // Click cancel button
    const cancelButton = screen.getByRole('button', { name: /Annuler/i })
    await user.click(cancelButton)

    // Modal should close and API should NOT be called
    await waitFor(() => {
      expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    })

    expect(mockToggleCard).not.toHaveBeenCalled()
  })

  it('shows loading state', () => {
    vi.spyOn(cardsHook, 'useCards').mockReturnValue({
      data: undefined,
      fetchNextPage: vi.fn(),
      hasNextPage: false,
      isFetchingNextPage: false,
      isLoading: true,
      isError: false,
      error: null,
    } as any)

    render(<CardsPage />, { wrapper: createWrapper() })

    expect(screen.getByText('Chargement...')).toBeInTheDocument()
  })

  it('shows error state', () => {
    vi.spyOn(cardsHook, 'useCards').mockReturnValue({
      data: undefined,
      fetchNextPage: vi.fn(),
      hasNextPage: false,
      isFetchingNextPage: false,
      isLoading: false,
      isError: true,
      error: new Error('Network error'),
    } as any)

    render(<CardsPage />, { wrapper: createWrapper() })

    expect(screen.getByText('Impossible de charger les cartes')).toBeInTheDocument()
    expect(screen.getByText('Network error')).toBeInTheDocument()
  })

  it('shows empty state when no cards match filters', () => {
    vi.spyOn(cardsHook, 'useCards').mockReturnValue({
      data: {
        pages: [
          {
            cards: [],
            total: 0,
            page: 1,
            hasMore: false,
            timestamp: new Date().toISOString(),
          },
        ],
        pageParams: [1],
      },
      fetchNextPage: vi.fn(),
      hasNextPage: false,
      isFetchingNextPage: false,
      isLoading: false,
      isError: false,
      error: null,
    } as any)

    render(<CardsPage />, { wrapper: createWrapper() })

    expect(screen.getByText('Aucune carte trouvée')).toBeInTheDocument()
    expect(screen.getByText('Essayez de modifier vos filtres.')).toBeInTheDocument()
  })

  it('updates search filter when typing', async () => {
    const useCardsSpy = vi.spyOn(cardsHook, 'useCards')

    render(<CardsPage />, { wrapper: createWrapper() })

    const searchInput = screen.getByPlaceholderText('Rechercher une carte...')
    fireEvent.change(searchInput, { target: { value: 'Gandalf' } })

    // Wait for debounce (300ms)
    await waitFor(
      () => {
        expect(useCardsSpy).toHaveBeenCalledWith(
          expect.objectContaining({ search: 'Gandalf' })
        )
      },
      { timeout: 500 }
    )
  })

  it('updates series filter', () => {
    const useCardsSpy = vi.spyOn(cardsHook, 'useCards')

    render(<CardsPage />, { wrapper: createWrapper() })

    const seriesSelect = screen.getByLabelText('Filtrer par série')
    fireEvent.change(seriesSelect, { target: { value: 'Les Sorciers' } })

    expect(useCardsSpy).toHaveBeenCalledWith(
      expect.objectContaining({ series: 'Les Sorciers' })
    )
  })

  it('updates ownership filter', () => {
    const useCardsSpy = vi.spyOn(cardsHook, 'useCards')

    render(<CardsPage />, { wrapper: createWrapper() })

    const ownedButton = screen.getByText('Possédées')
    fireEvent.click(ownedButton)

    expect(useCardsSpy).toHaveBeenCalledWith(
      expect.objectContaining({ owned: 'true' })
    )
  })
})
