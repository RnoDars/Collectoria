import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import DnD5BookCard from '../DnD5BookCard'
import { Book } from '@/lib/api/books'

describe('DnD5BookCard', () => {
  const mockOnToggleFr = vi.fn()
  const mockOnToggleEn = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
  })

  const baseDnD5Book: Book = {
    id: 'book-123',
    collectionId: '33333333-3333-3333-3333-333333333333',
    number: '1',
    title: 'Player Handbook',
    nameEn: "Player's Handbook",
    nameFr: 'Manuel des Joueurs',
    author: 'Wizards of the Coast',
    publicationDate: '2014-08-19',
    edition: '5e Edition',
    bookType: 'Core Rules',
    ownedFr: false,
    ownedEn: false,
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
  }

  it('renders book title in French (priority)', () => {
    render(
      <DnD5BookCard
        book={baseDnD5Book}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    expect(screen.getByText('Manuel des Joueurs')).toBeInTheDocument()
  })

  it('renders English title in italics below French title', () => {
    render(
      <DnD5BookCard
        book={baseDnD5Book}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    const enTitle = screen.getByText("Player's Handbook")
    expect(enTitle).toBeInTheDocument()
    expect(enTitle).toHaveStyle({ fontStyle: 'italic' })
  })

  it('displays English title as primary when French is missing', () => {
    const untranslatedBook: Book = {
      ...baseDnD5Book,
      nameFr: undefined,
    }

    render(
      <DnD5BookCard
        book={untranslatedBook}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    // Should display English title as primary (bold)
    const titleElement = screen.getByText("Player's Handbook")
    expect(titleElement).toHaveStyle({ fontWeight: '700' })
  })

  it('displays "Non traduit" badge when French translation is missing', () => {
    const untranslatedBook: Book = {
      ...baseDnD5Book,
      nameFr: undefined,
    }

    render(
      <DnD5BookCard
        book={untranslatedBook}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    expect(screen.getByText('Non traduit')).toBeInTheDocument()
  })

  it('displays edition and year', () => {
    render(
      <DnD5BookCard
        book={baseDnD5Book}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    expect(screen.getByText(/5e Edition/)).toBeInTheDocument()
    expect(screen.getByText(/2014/)).toBeInTheDocument()
  })

  it('displays book type badge', () => {
    render(
      <DnD5BookCard
        book={baseDnD5Book}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    expect(screen.getByText('Core Rules')).toBeInTheDocument()
  })

  it('renders both version toggles', () => {
    render(
      <DnD5BookCard
        book={baseDnD5Book}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    expect(screen.getByText('Version FR')).toBeInTheDocument()
    expect(screen.getByText('Version EN')).toBeInTheDocument()
  })

  it('calls onToggleFr when French toggle is clicked', () => {
    render(
      <DnD5BookCard
        book={baseDnD5Book}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    const frToggle = screen.getByLabelText('Ajouter version FR')
    fireEvent.click(frToggle)

    expect(mockOnToggleFr).toHaveBeenCalledWith(baseDnD5Book)
    expect(mockOnToggleEn).not.toHaveBeenCalled()
  })

  it('calls onToggleEn when English toggle is clicked', () => {
    render(
      <DnD5BookCard
        book={baseDnD5Book}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    const enToggle = screen.getByLabelText('Ajouter version EN')
    fireEvent.click(enToggle)

    expect(mockOnToggleEn).toHaveBeenCalledWith(baseDnD5Book)
    expect(mockOnToggleFr).not.toHaveBeenCalled()
  })

  it('disables French toggle when book is untranslated', () => {
    const untranslatedBook: Book = {
      ...baseDnD5Book,
      nameFr: undefined,
    }

    render(
      <DnD5BookCard
        book={untranslatedBook}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    const frToggle = screen.getByLabelText('Ajouter version FR')
    expect(frToggle).toBeDisabled()

    const enToggle = screen.getByLabelText('Ajouter version EN')
    expect(enToggle).not.toBeDisabled()
  })

  it('shows correct toggle states for owned versions', () => {
    const ownedBook: Book = {
      ...baseDnD5Book,
      ownedFr: true,
      ownedEn: true,
    }

    render(
      <DnD5BookCard
        book={ownedBook}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    const frToggle = screen.getByLabelText('Retirer version FR')
    expect(frToggle).toHaveAttribute('aria-pressed', 'true')

    const enToggle = screen.getByLabelText('Retirer version EN')
    expect(enToggle).toHaveAttribute('aria-pressed', 'true')
  })

  it('disables all toggles when toggling is in progress', () => {
    render(
      <DnD5BookCard
        book={baseDnD5Book}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
        isTogglingId="book-123"
      />
    )

    const frToggle = screen.getByLabelText('Ajouter version FR')
    const enToggle = screen.getByLabelText('Ajouter version EN')

    // Both toggles should be disabled during toggling
    expect(enToggle).toBeDisabled()
  })

  it('allows both versions to be owned simultaneously', () => {
    const dualOwnedBook: Book = {
      ...baseDnD5Book,
      ownedFr: true,
      ownedEn: true,
    }

    render(
      <DnD5BookCard
        book={dualOwnedBook}
        onToggleFr={mockOnToggleFr}
        onToggleEn={mockOnToggleEn}
      />
    )

    // Both toggles should show "Retirer" state
    expect(screen.getByLabelText('Retirer version FR')).toBeInTheDocument()
    expect(screen.getByLabelText('Retirer version EN')).toBeInTheDocument()
  })
})
