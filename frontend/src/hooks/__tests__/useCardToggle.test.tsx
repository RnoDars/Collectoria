import { describe, it, expect, vi, beforeEach } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useCardToggle } from '../useCardToggle'
import * as api from '@/lib/api/collections'
import toast from 'react-hot-toast'

// Mock toast
vi.mock('react-hot-toast', () => ({
  default: {
    success: vi.fn(),
    error: vi.fn(),
  },
}))

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

describe('useCardToggle', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('successfully toggles card to owned', async () => {
    const mockCard = {
      id: 'card-123',
      nameEn: 'Gandalf',
      nameFr: 'Gandalf',
      cardType: 'Wizard',
      series: 'MECCG',
      rarity: 'R',
      isOwned: true,
    }

    vi.spyOn(api, 'updateCardPossession').mockResolvedValue(mockCard)

    const { result } = renderHook(() => useCardToggle(), {
      wrapper: createWrapper(),
    })

    expect(result.current.isLoading).toBe(false)

    result.current.toggleCard({ cardId: 'card-123', isOwned: true })

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(api.updateCardPossession).toHaveBeenCalledWith('card-123', true)
    expect(toast.success).toHaveBeenCalledWith(
      'Carte ajoutée à votre collection !',
      expect.objectContaining({
        duration: 3000,
        position: 'bottom-right',
        icon: '✓',
      })
    )
  })

  it('successfully toggles card to not owned', async () => {
    const mockCard = {
      id: 'card-123',
      nameEn: 'Gandalf',
      nameFr: 'Gandalf',
      cardType: 'Wizard',
      series: 'MECCG',
      rarity: 'R',
      isOwned: false,
    }

    vi.spyOn(api, 'updateCardPossession').mockResolvedValue(mockCard)

    const { result } = renderHook(() => useCardToggle(), {
      wrapper: createWrapper(),
    })

    result.current.toggleCard({ cardId: 'card-123', isOwned: false })

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(api.updateCardPossession).toHaveBeenCalledWith('card-123', false)
    expect(toast.success).toHaveBeenCalledWith(
      'Carte retirée de votre collection',
      expect.objectContaining({
        duration: 3000,
        position: 'bottom-right',
        icon: '✗',
      })
    )
  })

  it('shows error toast when toggle fails', async () => {
    const error = new Error('Network error')
    vi.spyOn(api, 'updateCardPossession').mockRejectedValue(error)
    vi.spyOn(console, 'error').mockImplementation(() => {})

    const { result } = renderHook(() => useCardToggle(), {
      wrapper: createWrapper(),
    })

    result.current.toggleCard({ cardId: 'card-123', isOwned: true })

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(toast.error).toHaveBeenCalledWith(
      'Erreur lors de la mise à jour de la carte',
      expect.objectContaining({
        duration: 4000,
        position: 'bottom-right',
      })
    )
    expect(console.error).toHaveBeenCalledWith(
      'Failed to update card possession:',
      error
    )
  })

  it('invalidates queries on success', async () => {
    const mockCard = {
      id: 'card-123',
      nameEn: 'Gandalf',
      nameFr: 'Gandalf',
      cardType: 'Wizard',
      series: 'MECCG',
      rarity: 'R',
      isOwned: true,
    }

    vi.spyOn(api, 'updateCardPossession').mockResolvedValue(mockCard)

    const queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
        mutations: { retry: false },
      },
    })

    const invalidateSpy = vi.spyOn(queryClient, 'invalidateQueries')

    const wrapper = ({ children }: { children: React.ReactNode }) => (
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    )

    const { result } = renderHook(() => useCardToggle(), { wrapper })

    result.current.toggleCard({ cardId: 'card-123', isOwned: true })

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(invalidateSpy).toHaveBeenCalledWith({ queryKey: ['cards'] })
    expect(invalidateSpy).toHaveBeenCalledWith({ queryKey: ['collectionSummary'] })
  })
})
