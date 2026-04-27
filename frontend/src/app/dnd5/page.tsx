'use client'

import { useState, useEffect } from 'react'
import { useDnD5Books } from '@/hooks/useDnD5Books'
import { useDnD5BookToggle } from '@/hooks/useDnD5BookToggle'
import { DnD5Filters, DnD5Book } from '@/lib/api/dnd5'
import Link from 'next/link'
import DnD5BookCard from '@/components/books/DnD5BookCard'
import DnD5BookConfirmModal from '@/components/books/DnD5BookConfirmModal'

// Skeleton Loading
function BookSkeleton() {
  return (
    <div
      style={{
        background: 'var(--surface-container-lowest)',
        borderRadius: '12px',
        padding: '1.25rem',
        height: '280px',
      }}
    >
      <style>{`
        @keyframes pulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.4; }
        }
        .skeleton {
          animation: pulse 1.4s ease-in-out infinite;
          background: var(--surface-container-highest);
          borderRadius: 6px;
        }
      `}</style>
      <div className="skeleton" style={{ width: '80%', height: '1rem', marginBottom: '0.75rem' }} />
      <div className="skeleton" style={{ width: '60%', height: '0.75rem', marginBottom: '0.5rem' }} />
      <div className="skeleton" style={{ width: '70%', height: '0.75rem', marginBottom: '0.5rem' }} />
      <div className="skeleton" style={{ width: '40%', height: '0.75rem', marginBottom: '1rem' }} />
      <div className="skeleton" style={{ width: '80px', height: '1.5rem' }} />
    </div>
  )
}

// Main Page Component
type OwnedFilter = 'all' | 'fr' | 'en' | 'none'

export default function DnD5Page() {
  const [search, setSearch] = useState('')
  const [bookType, setBookType] = useState('')
  const [owned, setOwned] = useState<OwnedFilter>('all')
  const [language, setLanguage] = useState<'fr' | 'en'>('fr')
  const [togglingBookId, setTogglingBookId] = useState<string>()

  // Modal state
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [pendingBook, setPendingBook] = useState<DnD5Book | null>(null)
  const [pendingVersion, setPendingVersion] = useState<'fr' | 'en'>('fr')
  const [pendingState, setPendingState] = useState<boolean>(false)

  // Debounce search input
  const [debouncedSearch, setDebouncedSearch] = useState('')
  useEffect(() => {
    const timer = setTimeout(() => setDebouncedSearch(search), 300)
    return () => clearTimeout(timer)
  }, [search])

  const filters: DnD5Filters = {
    limit: 500,
    ...(debouncedSearch && { search: debouncedSearch }),
    ...(bookType && { bookType }),
  }

  const { data, isLoading, isError, error } = useDnD5Books(filters)
  const { toggleBook, isLoading: isToggling } = useDnD5BookToggle()

  let books = data?.books ?? []
  const pagination = data?.pagination ?? { total: 0, page: 1, limit: 50, totalPages: 1 }

  // Apply language filter first (client-side)
  if (language === 'fr') {
    books = books.filter((book) => book.nameFr !== null)
  }

  // Apply owned filter client-side
  if (owned !== 'all') {
    books = books.filter((book) => {
      if (owned === 'fr') return book.ownedFr === true
      if (owned === 'en') return book.ownedEn === true
      if (owned === 'none') return !book.ownedFr && !book.ownedEn
      return true
    })
  }

  // Calculate stats
  const totalBooks = books.length
  const ownedFrBooks = books.filter((b) => b.ownedFr).length
  const ownedEnBooks = books.filter((b) => b.ownedEn).length

  const handleToggleFr = (book: DnD5Book) => {
    if (!book.nameFr) return // Cannot toggle FR if not translated
    setPendingBook(book)
    setPendingVersion('fr')
    setPendingState(!book.ownedFr)
    setIsModalOpen(true)
  }

  const handleToggleEn = (book: DnD5Book) => {
    setPendingBook(book)
    setPendingVersion('en')
    setPendingState(!book.ownedEn)
    setIsModalOpen(true)
  }

  const handleConfirmToggle = () => {
    if (!pendingBook) return

    setTogglingBookId(pendingBook.id)
    toggleBook(
      {
        bookId: pendingBook.id,
        version: pendingVersion,
        isOwned: pendingState,
      },
      {
        onSettled: () => {
          setTogglingBookId(undefined)
          setIsModalOpen(false)
          setPendingBook(null)
        }
      }
    )
  }

  const handleCancelToggle = () => {
    setIsModalOpen(false)
    setPendingBook(null)
  }

  // Styles
  const pageStyle: React.CSSProperties = {
    minHeight: '100vh',
    background: 'var(--surface)',
    padding: '2rem 1.5rem 4rem',
  }

  const containerStyle: React.CSSProperties = {
    maxWidth: '1200px',
    margin: '0 auto',
  }

  const headerStyle: React.CSSProperties = {
    marginBottom: '2rem',
  }

  const backLinkStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem',
    color: '#667eea',
    textDecoration: 'none',
    display: 'inline-flex',
    alignItems: 'center',
    gap: '0.5rem',
    marginBottom: '0.75rem',
    fontWeight: '600',
  }

  const headingStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '800',
    fontSize: '1.875rem',
    color: 'var(--on-surface)',
    marginBottom: '0.5rem',
  }

  const statsStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem',
    color: 'var(--on-surface-variant)',
    display: 'flex',
    gap: '1.5rem',
    flexWrap: 'wrap',
  }

  const statItemStyle: React.CSSProperties = {
    display: 'flex',
    gap: '0.5rem',
  }

  const filtersBarStyle: React.CSSProperties = {
    display: 'flex',
    flexWrap: 'wrap',
    gap: '0.75rem',
    marginBottom: '2rem',
    padding: '1.25rem',
    background: 'var(--surface-container-low)',
    borderRadius: '16px',
  }

  const inputStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem',
    color: 'var(--on-surface)',
    background: 'var(--surface-container-lowest)',
    border: 'none',
    borderRadius: '10px',
    padding: '0.625rem 0.875rem',
    outline: 'none',
    minWidth: '200px',
    flex: '1 1 200px',
    boxShadow: '0px 2px 8px rgba(25, 28, 29, 0.06)',
  }

  const selectStyle: React.CSSProperties = {
    ...inputStyle,
    cursor: 'pointer',
    flex: '0 1 200px',
    minWidth: '180px',
  }

  const toggleGroupStyle: React.CSSProperties = {
    display: 'flex',
    background: 'var(--surface-container-lowest)',
    borderRadius: '10px',
    boxShadow: '0px 2px 8px rgba(25, 28, 29, 0.06)',
    overflow: 'hidden',
  }

  function toggleBtnStyle(active: boolean): React.CSSProperties {
    return {
      fontFamily: 'Inter, sans-serif',
      fontSize: '0.8125rem',
      fontWeight: active ? '600' : '500',
      color: active ? '#667eea' : 'var(--on-surface-variant)',
      background: active ? 'rgba(102, 126, 234, 0.1)' : 'transparent',
      border: 'none',
      padding: '0.625rem 1rem',
      cursor: 'pointer',
      transition: 'all 0.15s',
      whiteSpace: 'nowrap',
    }
  }

  const gridStyle: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))',
    gap: '1.25rem',
    marginBottom: '2rem',
  }

  return (
    <div style={pageStyle}>
      <div style={containerStyle}>
        {/* Header */}
        <header style={headerStyle}>
          <Link href="/" style={backLinkStyle}>
            ← Retour au dashboard
          </Link>
          <h1 style={headingStyle}>Collection D&D 5e</h1>
          <div style={statsStyle}>
            <div style={statItemStyle}>
              <span>Total:</span>
              <strong>53 livres</strong>
            </div>
            {!isLoading && (
              <>
                <div style={statItemStyle}>
                  <span>Affichés:</span>
                  <strong>{totalBooks} livre{totalBooks > 1 ? 's' : ''}</strong>
                </div>
                <div style={statItemStyle}>
                  <span>Version FR:</span>
                  <strong>{ownedFrBooks}</strong>
                </div>
                <div style={statItemStyle}>
                  <span>Version EN:</span>
                  <strong>{ownedEnBooks}</strong>
                </div>
              </>
            )}
          </div>
        </header>

        {/* Filters */}
        <div style={filtersBarStyle}>
          <input
            type="search"
            placeholder="Rechercher un livre..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={inputStyle}
            aria-label="Rechercher un livre"
          />

          <select
            value={bookType}
            onChange={(e) => setBookType(e.target.value)}
            style={selectStyle}
            aria-label="Filtrer par type"
          >
            <option value="">Tous les types</option>
            <option value="Core Rules">Core Rules</option>
            <option value="Starter Set">Starter Set</option>
            <option value="Supplément de règles">Supplément de règles</option>
            <option value="Setting">Setting</option>
            <option value="Campagnes">Campagnes</option>
            <option value="Recueil d'aventures">Recueil d&apos;aventures</option>
          </select>

          <div style={toggleGroupStyle} role="group" aria-label="Langue">
            <button
              onClick={() => setLanguage('fr')}
              style={toggleBtnStyle(language === 'fr')}
              aria-pressed={language === 'fr'}
            >
              🇫🇷 Français
            </button>
            <button
              onClick={() => setLanguage('en')}
              style={toggleBtnStyle(language === 'en')}
              aria-pressed={language === 'en'}
            >
              🇬🇧 Anglais
            </button>
          </div>

          <div style={toggleGroupStyle} role="group" aria-label="Filtre possession">
            <button
              onClick={() => setOwned('all')}
              style={toggleBtnStyle(owned === 'all')}
              aria-pressed={owned === 'all'}
            >
              Tous
            </button>
            <button
              onClick={() => setOwned('fr')}
              style={toggleBtnStyle(owned === 'fr')}
              aria-pressed={owned === 'fr'}
            >
              Version FR
            </button>
            <button
              onClick={() => setOwned('en')}
              style={toggleBtnStyle(owned === 'en')}
              aria-pressed={owned === 'en'}
            >
              Version EN
            </button>
            <button
              onClick={() => setOwned('none')}
              style={toggleBtnStyle(owned === 'none')}
              aria-pressed={owned === 'none'}
            >
              Non possédé
            </button>
          </div>
        </div>

        {/* Error State */}
        {isError && (
          <div
            style={{
              padding: '2rem',
              borderRadius: '16px',
              background: 'var(--surface-container-low)',
              textAlign: 'center',
            }}
          >
            <p
              style={{
                fontFamily: 'Manrope, sans-serif',
                fontWeight: '700',
                fontSize: '1.125rem',
                color: 'var(--on-surface)',
                marginBottom: '0.5rem',
              }}
            >
              Impossible de charger les livres
            </p>
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.875rem',
                color: 'var(--on-surface-variant)',
              }}
            >
              {(error as Error)?.message ?? 'Une erreur inattendue est survenue.'}
            </p>
          </div>
        )}

        {/* Books Grid */}
        {!isError && (
          <>
            <div style={gridStyle}>
              {isLoading
                ? Array.from({ length: 12 }).map((_, i) => <BookSkeleton key={i} />)
                : books.length === 0
                ? (
                  <div
                    style={{
                      gridColumn: '1 / -1',
                      padding: '3rem',
                      textAlign: 'center',
                      background: 'var(--surface-container-lowest)',
                      borderRadius: '16px',
                    }}
                  >
                    <p
                      style={{
                        fontFamily: 'Manrope, sans-serif',
                        fontWeight: '700',
                        fontSize: '1.125rem',
                        color: 'var(--on-surface)',
                        marginBottom: '0.5rem',
                      }}
                    >
                      Aucun livre trouvé
                    </p>
                    <p
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontSize: '0.875rem',
                        color: 'var(--on-surface-variant)',
                      }}
                    >
                      Essayez de modifier vos filtres.
                    </p>
                  </div>
                )
                : books.map((book) => (
                    <DnD5BookCard
                      key={book.id}
                      book={book}
                      language={language}
                      onToggleFr={handleToggleFr}
                      onToggleEn={handleToggleEn}
                      isTogglingId={togglingBookId}
                    />
                  ))}
            </div>
          </>
        )}
      </div>

      {/* Confirmation Modal */}
      {pendingBook && (
        <DnD5BookConfirmModal
          book={pendingBook}
          version={pendingVersion}
          newState={pendingState}
          isOpen={isModalOpen}
          onConfirm={handleConfirmToggle}
          onCancel={handleCancelToggle}
        />
      )}
    </div>
  )
}
