import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import DnD5Page from '../page'
import * as useBooks from '@/hooks/useBooks'
import * as useDnD5BookToggle from '@/hooks/useDnD5BookToggle'
import { Book } from '@/lib/api/books'

// Mock router
vi.mock('next/navigation', () => ({
  usePathname: () => '/dnd5',
}))

// Mock toast
vi.mock('react-hot-toast', () => ({
  default: {
    success: vi.fn(),
    error: vi.fn(),
  },
}))

describe('DnD5Page', () => {
  const mockDnD5Books: Book[] = [
    {
      id: 'book-1',
      collectionId: '33333333-3333-3333-3333-333333333333',
      number: '1',
      title: 'Player Handbook',
      nameEn: "Player's Handbook",
      nameFr: 'Manuel des Joueurs',
      author: 'Wizards of the Coast',
      publicationDate: '2014-08-19',
      edition: '5e Edition',
      bookType: 'Core Rules',
      ownedFr: true,
      ownedEn: false,
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
    },
    {
      id: 'book-2',
      collectionId: '33333333-3333-3333-3333-333333333333',
      number: '2',
      title: 'Monster Manual',
      nameEn: 'Monster Manual',
      nameFr: 'Bestiaire',
      author: 'Wizards of the Coast',
      publicationDate: '2014-09-30',
      edition: '5e Edition',
      bookType: 'Core Rules',
      ownedFr: false,
      ownedEn: true,
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
    },
    {
      id: 'book-3',
      collectionId: '33333333-3333-3333-3333-333333333333',
      number: '3',
      title: 'Curse of Strahd',
      nameEn: 'Curse of Strahd',
      nameFr: undefined,
      author: 'Wizards of the Coast',
      publicationDate: '2016-03-15',
      edition: '5e Edition',
      bookType: 'Campagnes',
      ownedFr: undefined,
      ownedEn: false,
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
    },
  ]

  const mockToggleBook = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()

    vi.spyOn(useBooks, 'useBooks').mockReturnValue({
      data: {
        books: mockDnD5Books,
        pagination: {
          total: 3,
          page: 1,
          limit: 500,
          totalPages: 1,
        },
      },
      isLoading: false,
      isError: false,
      error: null,
    } as any)

    vi.spyOn(useDnD5BookToggle, 'useDnD5BookToggle').mockReturnValue({
      toggleBook: mockToggleBook,
      isLoading: false,
    })
  })

  it('renders page title and stats', () => {
    render(<DnD5Page />)

    expect(screen.getByText('Collection D&D 5e')).toBeInTheDocument()
    expect(screen.getByText('Total:')).toBeInTheDocument()
    expect(screen.getByText('53 livres')).toBeInTheDocument()
  })

  it('displays correct ownership stats', () => {
    render(<DnD5Page />)

    expect(screen.getByText(/Affichés:/)).toBeInTheDocument()
    expect(screen.getByText(/Version FR:/)).toBeInTheDocument()
    expect(screen.getByText(/Version EN:/)).toBeInTheDocument()

    // Find the stats section
    const stats = screen.getByText(/Affichés:/).closest('div')
    expect(stats).toHaveTextContent('3 livres')
  })

  it('renders all D&D 5e books', () => {
    render(<DnD5Page />)

    expect(screen.getByText('Manuel des Joueurs')).toBeInTheDocument()
    expect(screen.getByText('Bestiaire')).toBeInTheDocument()
    expect(screen.getByText('Curse of Strahd')).toBeInTheDocument()
  })

  it('displays "Non traduit" badge for untranslated books', () => {
    render(<DnD5Page />)

    const badges = screen.getAllByText('Non traduit')
    expect(badges.length).toBeGreaterThan(0)
  })

  it('filters books by type', async () => {
    render(<DnD5Page />)

    const typeSelect = screen.getByLabelText('Filtrer par type')
    fireEvent.change(typeSelect, { target: { value: 'Campagnes' } })

    // After filtering, useBooks should be called with the correct filter
    await waitFor(() => {
      expect(useBooks.useBooks).toHaveBeenCalledWith(
        expect.objectContaining({
          bookType: 'Campagnes',
        })
      )
    })
  })

  it('filters books by ownership status - Version FR', async () => {
    render(<DnD5Page />)

    const frButton = screen.getByRole('button', { name: /Version FR/ })
    fireEvent.click(frButton)

    await waitFor(() => {
      expect(screen.getByText('Manuel des Joueurs')).toBeInTheDocument()
      expect(screen.queryByText('Bestiaire')).not.toBeInTheDocument()
    })
  })

  it('filters books by ownership status - Version EN', async () => {
    render(<DnD5Page />)

    const enButton = screen.getByRole('button', { name: /Version EN/ })
    fireEvent.click(enButton)

    await waitFor(() => {
      expect(screen.getByText('Bestiaire')).toBeInTheDocument()
      expect(screen.queryByText('Manuel des Joueurs')).not.toBeInTheDocument()
    })
  })

  it('filters books by ownership status - None', async () => {
    render(<DnD5Page />)

    const noneButton = screen.getByRole('button', { name: /Non possédé/ })
    fireEvent.click(noneButton)

    await waitFor(() => {
      expect(screen.getByText('Curse of Strahd')).toBeInTheDocument()
      expect(screen.queryByText('Manuel des Joueurs')).not.toBeInTheDocument()
    })
  })

  it('searches books by name', async () => {
    render(<DnD5Page />)

    const searchInput = screen.getByPlaceholderText('Rechercher un livre...')
    fireEvent.change(searchInput, { target: { value: 'Manuel' } })

    await waitFor(() => {
      // Search is debounced, so we need to wait
      expect(useBooks.useBooks).toHaveBeenCalledWith(
        expect.objectContaining({
          search: 'Manuel',
        })
      )
    }, { timeout: 500 })
  })

  it('shows loading skeletons while fetching', () => {
    vi.spyOn(useBooks, 'useBooks').mockReturnValue({
      data: undefined,
      isLoading: true,
      isError: false,
      error: null,
    } as any)

    render(<DnD5Page />)

    const skeletons = screen.getAllByRole('generic').filter(el =>
      el.style.height === '280px'
    )
    expect(skeletons.length).toBeGreaterThan(0)
  })

  it('shows error state when fetch fails', () => {
    vi.spyOn(useBooks, 'useBooks').mockReturnValue({
      data: undefined,
      isLoading: false,
      isError: true,
      error: new Error('Network error'),
    } as any)

    render(<DnD5Page />)

    expect(screen.getByText('Impossible de charger les livres')).toBeInTheDocument()
    expect(screen.getByText('Network error')).toBeInTheDocument()
  })

  it('shows empty state when no books match filters', () => {
    vi.spyOn(useBooks, 'useBooks').mockReturnValue({
      data: {
        books: [],
        pagination: { total: 0, page: 1, limit: 500, totalPages: 1 },
      },
      isLoading: false,
      isError: false,
      error: null,
    } as any)

    render(<DnD5Page />)

    expect(screen.getByText('Aucun livre trouvé')).toBeInTheDocument()
    expect(screen.getByText('Essayez de modifier vos filtres.')).toBeInTheDocument()
  })

  it('passes correct collection_id filter to useBooks', () => {
    const useBooksSpy = vi.spyOn(useBooks, 'useBooks')

    render(<DnD5Page />)

    expect(useBooksSpy).toHaveBeenCalledWith(
      expect.objectContaining({
        collectionId: '33333333-3333-3333-3333-333333333333',
      })
    )
  })
})
