import { describe, it, expect, vi, beforeEach } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useDnD5BookToggle } from '../useDnD5BookToggle'
import { apiClient } from '@/lib/api/client'
import toast from 'react-hot-toast'

// Mock toast
vi.mock('react-hot-toast', () => ({
  default: {
    success: vi.fn(),
    error: vi.fn(),
  },
}))

// Mock apiClient
vi.mock('@/lib/api/client', () => ({
  apiClient: {
    patch: vi.fn(),
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

describe('useDnD5BookToggle', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('successfully toggles French version to owned', async () => {
    const mockResponse = {
      ok: true,
      json: vi.fn().mockResolvedValue({
        id: 'book-123',
        owned_fr: true,
      }),
    }

    vi.mocked(apiClient.patch).mockResolvedValue(mockResponse as any)

    const { result } = renderHook(() => useDnD5BookToggle(), {
      wrapper: createWrapper(),
    })

    expect(result.current.isLoading).toBe(false)

    result.current.toggleBook({ bookId: 'book-123', version: 'fr', isOwned: true })

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(apiClient.patch).toHaveBeenCalledWith(
      '/api/v1/books/book-123/possession',
      { owned_fr: true }
    )
    expect(toast.success).toHaveBeenCalledWith(
      'Version française ajoutée à votre collection !',
      expect.objectContaining({
        duration: 3000,
        position: 'bottom-right',
        icon: '✓',
      })
    )
  })

  it('successfully toggles English version to not owned', async () => {
    const mockResponse = {
      ok: true,
      json: vi.fn().mockResolvedValue({
        id: 'book-123',
        owned_en: false,
      }),
    }

    vi.mocked(apiClient.patch).mockResolvedValue(mockResponse as any)

    const { result } = renderHook(() => useDnD5BookToggle(), {
      wrapper: createWrapper(),
    })

    result.current.toggleBook({ bookId: 'book-123', version: 'en', isOwned: false })

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(apiClient.patch).toHaveBeenCalledWith(
      '/api/v1/books/book-123/possession',
      { owned_en: false }
    )
    expect(toast.success).toHaveBeenCalledWith(
      'Version anglaise retirée de votre collection',
      expect.objectContaining({
        duration: 3000,
        position: 'bottom-right',
        icon: '✗',
      })
    )
  })

  it('shows error toast when toggle fails', async () => {
    const mockResponse = {
      ok: false,
      statusText: 'Internal Server Error',
    }

    vi.mocked(apiClient.patch).mockResolvedValue(mockResponse as any)
    vi.spyOn(console, 'error').mockImplementation(() => {})

    const { result } = renderHook(() => useDnD5BookToggle(), {
      wrapper: createWrapper(),
    })

    result.current.toggleBook({ bookId: 'book-123', version: 'fr', isOwned: true })

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(toast.error).toHaveBeenCalledWith(
      'Failed to update book possession: Internal Server Error',
      expect.objectContaining({
        duration: 4000,
        position: 'bottom-right',
      })
    )
  })

  it('invalidates queries on success', async () => {
    const mockResponse = {
      ok: true,
      json: vi.fn().mockResolvedValue({
        id: 'book-123',
        owned_fr: true,
      }),
    }

    vi.mocked(apiClient.patch).mockResolvedValue(mockResponse as any)

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

    const { result } = renderHook(() => useDnD5BookToggle(), { wrapper })

    result.current.toggleBook({ bookId: 'book-123', version: 'en', isOwned: true })

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(invalidateSpy).toHaveBeenCalledWith({ queryKey: ['books'] })
    expect(invalidateSpy).toHaveBeenCalledWith({ queryKey: ['collections'] })
  })
})
