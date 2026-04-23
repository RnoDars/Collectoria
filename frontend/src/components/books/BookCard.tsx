'use client'

import { Book } from '@/lib/api/books'

interface BookCardProps {
  book: Book
  onToggle: (bookId: string, isOwned: boolean) => void
  isTogglingId?: string
}

export default function BookCard({ book, onToggle, isTogglingId }: BookCardProps) {
  const isToggling = isTogglingId === book.id

  // Format publication date (YYYY-MM-DD -> DD/MM/YYYY)
  const formatDate = (dateStr: string) => {
    if (!dateStr) return 'Date inconnue'
    const date = new Date(dateStr)
    return date.toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    })
  }

  // Toggle component
  const toggleStyle: React.CSSProperties = {
    position: 'relative',
    width: '48px',
    height: '26px',
    background: book.isOwned
      ? 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
      : 'var(--surface-container-highest)',
    borderRadius: '13px',
    border: 'none',
    cursor: isToggling ? 'not-allowed' : 'pointer',
    opacity: isToggling ? 0.6 : 1,
    transition: 'all 0.3s ease',
    boxShadow: book.isOwned
      ? '0 4px 12px rgba(102, 126, 234, 0.4)'
      : '0 2px 6px rgba(25, 28, 29, 0.1)',
  }

  const knobStyle: React.CSSProperties = {
    position: 'absolute',
    top: '3px',
    left: book.isOwned ? '25px' : '3px',
    width: '20px',
    height: '20px',
    background: '#ffffff',
    borderRadius: '50%',
    transition: 'left 0.3s ease',
    boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)',
  }

  // Card styles - same style for all books (no conditional based on ownership)
  const cardStyle: React.CSSProperties = {
    background: 'var(--surface-container-lowest)',
    borderRadius: '12px',
    padding: '1.25rem',
    display: 'flex',
    flexDirection: 'column',
    gap: '1rem',
    boxShadow: '0 4px 12px rgba(25, 28, 29, 0.06)',
    transition: 'all 0.2s',
    position: 'relative',
  }

  const numberBadgeStyle: React.CSSProperties = {
    position: 'absolute',
    top: '0.75rem',
    right: '0.75rem',
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '700',
    fontSize: '0.6875rem',
    letterSpacing: '0.04em',
    padding: '0.25rem 0.625rem',
    borderRadius: '8px',
    background: 'var(--surface-container-high)',
    color: 'var(--on-surface-variant)',
  }

  const titleStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '700',
    fontSize: '1rem',
    color: 'var(--on-surface)',
    marginBottom: '0.25rem',
    lineHeight: '1.3',
    paddingRight: '3rem', // Space for number badge
  }

  const metaStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.8125rem',
    color: 'var(--on-surface-variant)',
    marginBottom: '0.125rem',
  }

  const typeBadgeStyle: React.CSSProperties = {
    display: 'inline-block',
    fontFamily: 'Inter, sans-serif',
    fontWeight: '600',
    fontSize: '0.6875rem',
    letterSpacing: '0.02em',
    padding: '0.25rem 0.625rem',
    borderRadius: '6px',
    background:
      book.bookType === 'roman'
        ? 'var(--surface-container-high)'
        : 'rgba(102, 126, 234, 0.15)',
    color:
      book.bookType === 'roman'
        ? 'var(--on-surface-variant)'
        : '#667eea',
  }

  return (
    <div style={cardStyle}>
      <span style={numberBadgeStyle}>#{book.number}</span>

      <div style={{ flex: 1 }}>
        <div style={titleStyle}>{book.title}</div>

        <div style={metaStyle}>
          <strong>Auteur:</strong> {book.author}
        </div>

        <div style={metaStyle}>
          <strong>Publication:</strong> {formatDate(book.publicationDate)}
        </div>

        <div style={{ marginTop: '0.5rem' }}>
          <span style={typeBadgeStyle}>
            {book.bookType === 'roman' ? 'Roman' : 'Recueil de romans'}
          </span>
        </div>
      </div>

      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          paddingTop: '0.75rem',
          borderTop: '1px solid var(--surface-container-high)',
        }}
      >
        <span
          style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.8125rem',
            fontWeight: '600',
            color: 'var(--on-surface-variant)',
          }}
        >
          {book.isOwned ? 'Possédé' : 'Non possédé'}
        </span>

        <button
          onClick={() => !isToggling && onToggle(book.id, !book.isOwned)}
          disabled={isToggling}
          style={toggleStyle}
          aria-label={book.isOwned ? 'Retirer de la collection' : 'Ajouter à la collection'}
          aria-pressed={book.isOwned}
          role="switch"
        >
          <div style={knobStyle} />
        </button>
      </div>
    </div>
  )
}
