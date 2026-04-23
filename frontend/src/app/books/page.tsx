'use client'

import { useState, useEffect } from 'react'
import { useBooks } from '@/hooks/useBooks'
import { useBookToggle } from '@/hooks/useBookToggle'
import { BookFilters } from '@/lib/api/books'
import Link from 'next/link'
import BookCard from '@/components/books/BookCard'

// ─── Skeleton Loading ─────────────────────────────────────────────────────────

function BookSkeleton() {
  return (
    <div
      style={{
        background: 'var(--surface-container-lowest)',
        borderRadius: '12px',
        padding: '1.25rem',
        height: '220px',
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

// ─── Main Page Component ──────────────────────────────────────────────────────

type OwnedFilter = 'all' | 'true' | 'false'
type SeriesFilter = 'all' | 'principal' | 'hors-serie'

export default function BooksPage() {
  const [search, setSearch] = useState('')
  const [author, setAuthor] = useState('')
  const [bookType, setBookType] = useState('')
  const [series, setSeries] = useState<SeriesFilter>('all')
  const [owned, setOwned] = useState<OwnedFilter>('all')
  const [page, setPage] = useState(1)
  const [togglingBookId, setTogglingBookId] = useState<string>()

  // Debounce search input
  const [debouncedSearch, setDebouncedSearch] = useState('')
  useEffect(() => {
    const timer = setTimeout(() => setDebouncedSearch(search), 300)
    return () => clearTimeout(timer)
  }, [search])

  const filters: BookFilters = {
    page,
    limit: 50,
    ...(debouncedSearch && { search: debouncedSearch }),
    ...(author && { author }),
    ...(bookType && { bookType }),
    ...(series !== 'all' && { series: series as 'principal' | 'hors-serie' }),
    ...(owned !== 'all' && { isOwned: owned === 'true' }),
  }

  const { data, isLoading, isError, error } = useBooks(filters)
  const { toggleBook, isLoading: isToggling } = useBookToggle()

  const books = data?.books ?? []
  const pagination = data?.pagination ?? { total: 0, page: 1, limit: 50, totalPages: 1 }

  // Calculate stats
  const totalBooks = pagination.total
  const ownedBooks = books.filter((b) => b.isOwned).length
  const totalOwned = data?.pagination.total ?? 0 // This would need a separate query for accurate count

  // Reset page when filters change
  useEffect(() => {
    setPage(1)
  }, [debouncedSearch, author, bookType, series, owned])

  const handleToggle = (bookId: string, isOwned: boolean) => {
    setTogglingBookId(bookId)
    toggleBook(
      { bookId, isOwned },
      { onSettled: () => setTogglingBookId(undefined) }
    )
  }

  // ─── Styles ───────────────────────────────────────────────────────────────

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
    flex: '0 1 180px',
    minWidth: '160px',
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

  const paginationStyle: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.75rem',
    marginTop: '2rem',
  }

  const paginationButtonStyle = (disabled: boolean): React.CSSProperties => ({
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem',
    fontWeight: '600',
    padding: '0.625rem 1.25rem',
    borderRadius: '10px',
    border: 'none',
    background: disabled ? 'var(--surface-container-high)' : '#667eea',
    color: disabled ? 'var(--on-surface-variant)' : '#ffffff',
    cursor: disabled ? 'not-allowed' : 'pointer',
    opacity: disabled ? 0.5 : 1,
    transition: 'all 0.2s',
  })

  const pageInfoStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem',
    color: 'var(--on-surface-variant)',
  }

  // ─── Render ───────────────────────────────────────────────────────────────

  return (
    <div style={pageStyle}>
      <div style={containerStyle}>
        {/* Header */}
        <header style={headerStyle}>
          <Link href="/" style={backLinkStyle}>
            ← Retour au dashboard
          </Link>
          <h1 style={headingStyle}>Collection Royaumes Oubliés</h1>
          <div style={statsStyle}>
            <div style={statItemStyle}>
              <span>Total:</span>
              <strong>94 livres</strong>
            </div>
            {!isLoading && (
              <>
                <div style={statItemStyle}>
                  <span>Affichés:</span>
                  <strong>{totalBooks} livre{totalBooks > 1 ? 's' : ''}</strong>
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
            value={author}
            onChange={(e) => setAuthor(e.target.value)}
            style={selectStyle}
            aria-label="Filtrer par auteur"
          >
            <option value="">Tous les auteurs</option>
            <option value="Troy Denning">Troy Denning</option>
            <option value="R.A. Salvatore">R.A. Salvatore</option>
            <option value="Ed Greenwood">Ed Greenwood</option>
            <option value="Elaine Cunningham">Elaine Cunningham</option>
            <option value="James Lowder">James Lowder</option>
            <option value="Douglas Niles">Douglas Niles</option>
            <option value="Christie Golden">Christie Golden</option>
            <option value="Richard Awlinson">Richard Awlinson</option>
            <option value="Richard Lee Byers">Richard Lee Byers</option>
            <option value="Jean Rabe">Jean Rabe</option>
          </select>

          <select
            value={bookType}
            onChange={(e) => setBookType(e.target.value)}
            style={selectStyle}
            aria-label="Filtrer par type"
          >
            <option value="">Tous les types</option>
            <option value="roman">Roman</option>
            <option value="recueil de romans">Recueil de romans</option>
          </select>

          <div style={toggleGroupStyle} role="group" aria-label="Filtre série">
            <button
              onClick={() => setSeries('all')}
              style={toggleBtnStyle(series === 'all')}
              aria-pressed={series === 'all'}
            >
              Tous
            </button>
            <button
              onClick={() => setSeries('principal')}
              style={toggleBtnStyle(series === 'principal')}
              aria-pressed={series === 'principal'}
            >
              Principal
            </button>
            <button
              onClick={() => setSeries('hors-serie')}
              style={toggleBtnStyle(series === 'hors-serie')}
              aria-pressed={series === 'hors-serie'}
            >
              Hors-série
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
              onClick={() => setOwned('true')}
              style={toggleBtnStyle(owned === 'true')}
              aria-pressed={owned === 'true'}
            >
              Possédés
            </button>
            <button
              onClick={() => setOwned('false')}
              style={toggleBtnStyle(owned === 'false')}
              aria-pressed={owned === 'false'}
            >
              Manquants
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
                    <BookCard
                      key={book.id}
                      book={book}
                      onToggle={handleToggle}
                      isTogglingId={togglingBookId}
                    />
                  ))}
            </div>

            {/* Pagination */}
            {!isLoading && books.length > 0 && (
              <div style={paginationStyle}>
                <button
                  onClick={() => setPage((p) => Math.max(1, p - 1))}
                  disabled={page === 1}
                  style={paginationButtonStyle(page === 1)}
                  aria-label="Page précédente"
                >
                  ← Précédent
                </button>

                <span style={pageInfoStyle}>
                  Page {pagination.page} sur {pagination.totalPages}
                </span>

                <button
                  onClick={() => setPage((p) => Math.min(pagination.totalPages, p + 1))}
                  disabled={page >= pagination.totalPages}
                  style={paginationButtonStyle(page >= pagination.totalPages)}
                  aria-label="Page suivante"
                >
                  Suivant →
                </button>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  )
}
