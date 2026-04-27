'use client'

import { DnD5Book } from '@/lib/api/dnd5'

interface DnD5BookCardProps {
  book: DnD5Book
  onToggleFr: (book: DnD5Book) => void
  onToggleEn: (book: DnD5Book) => void
  isTogglingId?: string
}

export default function DnD5BookCard({
  book,
  onToggleFr,
  onToggleEn,
  isTogglingId
}: DnD5BookCardProps) {
  const isToggling = isTogglingId === book.id

  // Determine display names
  const displayNameFr = book.nameFr || null
  const displayNameEn = book.nameEn
  const isUntranslated = !displayNameFr

  // Format publication date (YYYY-MM-DD -> YYYY)
  const formatYear = (dateStr: string) => {
    if (!dateStr) return 'Date inconnue'
    return new Date(dateStr).getFullYear().toString()
  }

  // Book type badge colors
  const getTypeColors = (type: string) => {
    const typeMap: Record<string, { bg: string; color: string }> = {
      'Core Rules': { bg: 'rgba(102, 126, 234, 0.15)', color: '#667eea' },
      'Starter Set': { bg: 'rgba(118, 75, 162, 0.15)', color: '#764ba2' },
      'Supplément de règles': { bg: 'var(--surface-container-high)', color: 'var(--on-surface-variant)' },
      'Setting': { bg: 'rgba(236, 72, 153, 0.15)', color: '#ec4899' },
      'Campagnes': { bg: 'rgba(34, 197, 94, 0.15)', color: '#22c55e' },
      'Recueil d\'aventures': { bg: 'rgba(249, 115, 22, 0.15)', color: '#f97316' },
    }
    return typeMap[type] || { bg: 'var(--surface-container-high)', color: 'var(--on-surface-variant)' }
  }

  const typeColors = getTypeColors(book.bookType)

  // Toggle component
  const createToggleStyle = (isOwned?: boolean): React.CSSProperties => ({
    position: 'relative',
    width: '48px',
    height: '26px',
    background: isOwned
      ? 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
      : 'var(--surface-container-highest)',
    borderRadius: '13px',
    border: 'none',
    cursor: isToggling ? 'not-allowed' : 'pointer',
    opacity: isToggling ? 0.6 : 1,
    transition: 'all 0.3s ease',
    boxShadow: isOwned
      ? '0 4px 12px rgba(102, 126, 234, 0.4)'
      : '0 2px 6px rgba(25, 28, 29, 0.1)',
  })

  const createKnobStyle = (isOwned?: boolean): React.CSSProperties => ({
    position: 'absolute',
    top: '3px',
    left: isOwned ? '25px' : '3px',
    width: '20px',
    height: '20px',
    background: '#ffffff',
    borderRadius: '50%',
    transition: 'left 0.3s ease',
    boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)',
  })

  // Card styles
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

  const titleFrStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '700',
    fontSize: '1rem',
    color: 'var(--on-surface)',
    lineHeight: '1.3',
    paddingRight: '3rem',
  }

  const titleEnStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '500',
    fontSize: '0.875rem',
    color: 'var(--on-surface-variant)',
    fontStyle: 'italic',
    lineHeight: '1.3',
    marginTop: '0.25rem',
    paddingRight: '3rem',
  }

  const metaStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.8125rem',
    color: 'var(--on-surface-variant)',
    marginBottom: '0.125rem',
  }

  const badgeStyle: React.CSSProperties = {
    display: 'inline-block',
    fontFamily: 'Inter, sans-serif',
    fontWeight: '600',
    fontSize: '0.6875rem',
    letterSpacing: '0.02em',
    padding: '0.25rem 0.625rem',
    borderRadius: '6px',
    background: typeColors.bg,
    color: typeColors.color,
    marginRight: '0.5rem',
  }

  const untranslatedBadgeStyle: React.CSSProperties = {
    display: 'inline-block',
    fontFamily: 'Inter, sans-serif',
    fontWeight: '600',
    fontSize: '0.6875rem',
    letterSpacing: '0.02em',
    padding: '0.25rem 0.625rem',
    borderRadius: '6px',
    background: 'rgba(249, 115, 22, 0.15)',
    color: '#f97316',
  }

  const toggleSectionStyle: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    gap: '0.75rem',
    paddingTop: '0.75rem',
  }

  const toggleRowStyle: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
  }

  const toggleLabelStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.8125rem',
    fontWeight: '600',
    color: 'var(--on-surface-variant)',
  }

  return (
    <div style={cardStyle}>
      <span style={numberBadgeStyle}>#{book.number}</span>

      <div style={{ flex: 1 }}>
        {/* Title FR (primary) or EN if no FR */}
        <div style={titleFrStyle}>
          {displayNameFr || displayNameEn}
        </div>

        {/* Title EN (if different from FR) */}
        {displayNameFr && displayNameEn !== displayNameFr && (
          <div style={titleEnStyle}>{displayNameEn}</div>
        )}

        {/* Edition & Year */}
        {book.edition && (
          <div style={metaStyle}>
            <strong>Édition:</strong> {book.edition}
          </div>
        )}

        <div style={metaStyle}>
          <strong>Année:</strong> {formatYear(book.publicationDate)}
        </div>

        {/* Badges */}
        <div style={{ marginTop: '0.5rem' }}>
          <span style={badgeStyle}>{book.bookType}</span>
          {isUntranslated && (
            <span style={untranslatedBadgeStyle}>Non traduit</span>
          )}
        </div>
      </div>

      {/* Dual Toggle Section */}
      <div style={toggleSectionStyle}>
        {/* French Version Toggle */}
        <div style={toggleRowStyle}>
          <span style={toggleLabelStyle}>Version FR</span>
          <button
            onClick={() => !isToggling && onToggleFr(book)}
            disabled={isToggling || isUntranslated}
            style={createToggleStyle(book.ownedFr ?? undefined)}
            aria-label={book.ownedFr ? 'Retirer version FR' : 'Ajouter version FR'}
            aria-pressed={book.ownedFr ?? false}
            role="switch"
          >
            <div style={createKnobStyle(book.ownedFr ?? undefined)} />
          </button>
        </div>

        {/* English Version Toggle */}
        <div style={toggleRowStyle}>
          <span style={toggleLabelStyle}>Version EN</span>
          <button
            onClick={() => !isToggling && onToggleEn(book)}
            disabled={isToggling}
            style={createToggleStyle(book.ownedEn ?? undefined)}
            aria-label={book.ownedEn ? 'Retirer version EN' : 'Ajouter version EN'}
            aria-pressed={book.ownedEn ?? false}
            role="switch"
          >
            <div style={createKnobStyle(book.ownedEn ?? undefined)} />
          </button>
        </div>
      </div>
    </div>
  )
}
