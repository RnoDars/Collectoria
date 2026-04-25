'use client'

import { useState, useEffect, useRef, useCallback } from 'react'
import { useCards } from '@/hooks/useCards'
import { useCardToggle } from '@/hooks/useCardToggle'
import { CardFilters, Card, SortBy, SortDir } from '@/lib/api/collections'
import Link from 'next/link'
import ConfirmToggleModal from '@/components/cards/ConfirmToggleModal'

// ─── Données statiques ────────────────────────────────────────────────────────

const SERIES_OPTIONS = [
  'Les Sorciers',
  'Sombres Séides',
  'Les Dragons',
  'L\'Oeil de Sauron',
  'Against the Shadow',
  'The White Hand',
  'The Balrog',
  'Promo',
]

const TYPE_OPTIONS = [
  'Héros / Personnage',
  'Héros / Personnage / Sorcier',
  'Héros / Personnage / Sorcier Déchu',
  'Héros / Ressource / Allié',
  'Héros / Ressource / Evènement',
  'Héros / Ressource / Faction',
  'Héros / Ressource / Objet',
  'Héros / Site',
  'Héros / Site / Abîme',
  'Héros / Site / Havre',
  'Héros / Sites',
  'Péril / Créature',
  'Péril / Evènement',
  'Personnage / Agent',
  'Région',
  'Ressource Héros / Evènement',
  'Séide / Personnage',
  'Séide / Personnage / Agent',
  'Séide / Personnage / Spectre',
  'Séide / Ressource / Allié',
  'Séide / Ressource / Evènement',
  'Séide / Ressource / Faction',
  'Séide / Ressource / Objet',
  'Séide / Site',
  'Stage / Ressource / Allié',
  'Stage / Ressource / Evènement',
  'Stage / Ressource / Faction',
  'Stage / Site',
]

const RARITY_OPTIONS = [
  { value: 'C', label: 'Commune' },
  { value: 'U', label: 'Peu commune' },
  { value: 'R', label: 'Rare' },
  { value: 'F', label: 'Fixe' },
  { value: 'Promo', label: 'Promo' },
]

type OwnedFilter = 'all' | 'true' | 'false'

// ─── Card Toggle Component ────────────────────────────────────────────────────

interface CardToggleProps {
  card: Card
  onToggle: (cardId: string, isOwned: boolean) => void
  isLoading?: boolean
}

function CardToggle({ card, onToggle, isLoading }: CardToggleProps) {
  const isOwned = card.isOwned

  const toggleStyle: React.CSSProperties = {
    position: 'relative',
    width: '48px',
    height: '26px',
    background: isOwned
      ? 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
      : 'var(--surface-container-highest)',
    borderRadius: '13px',
    border: 'none',
    cursor: isLoading ? 'not-allowed' : 'pointer',
    opacity: isLoading ? 0.6 : 1,
    transition: 'all 0.3s ease',
    boxShadow: isOwned
      ? '0 4px 12px rgba(102, 126, 234, 0.4)'
      : '0 2px 6px rgba(25, 28, 29, 0.1)',
  }

  const knobStyle: React.CSSProperties = {
    position: 'absolute',
    top: '3px',
    left: isOwned ? '25px' : '3px',
    width: '20px',
    height: '20px',
    background: '#ffffff',
    borderRadius: '50%',
    transition: 'left 0.3s ease',
    boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)',
  }

  return (
    <button
      onClick={() => !isLoading && onToggle(card.id, !isOwned)}
      disabled={isLoading}
      style={toggleStyle}
      aria-label={isOwned ? 'Retirer de la collection' : 'Ajouter à la collection'}
      aria-pressed={isOwned}
      role="switch"
    >
      <div style={knobStyle} />
    </button>
  )
}

// ─── Card Grid Item ───────────────────────────────────────────────────────────

interface CardItemProps {
  card: Card
  sortBy: SortBy
  onToggle: (cardId: string, isOwned: boolean) => void
  isTogglingId?: string
}

function CardItem({ card, sortBy, onToggle, isTogglingId }: CardItemProps) {
  const isToggling = isTogglingId === card.id

  const cardStyle: React.CSSProperties = {
    background: 'var(--surface-container-lowest)',
    borderRadius: '12px',
    padding: '1.25rem',
    display: 'flex',
    flexDirection: 'column',
    gap: '1rem',
    boxShadow: '0 4px 12px rgba(25, 28, 29, 0.06)',
    transition: 'all 0.2s',
  }

  const nameStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '700',
    fontSize: '1rem',
    color: 'var(--on-surface)',
    marginBottom: '0.25rem',
    lineHeight: '1.3',
  }

  const metaStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.8125rem',
    color: 'var(--on-surface-variant)',
    marginBottom: '0.125rem',
  }

  const rarityBadgeStyle: React.CSSProperties = {
    display: 'inline-block',
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '700',
    fontSize: '0.6875rem',
    letterSpacing: '0.04em',
    padding: '0.125rem 0.5rem',
    borderRadius: '6px',
    background: 'var(--surface-container-high)',
    color: 'var(--on-surface-variant)',
  }

  return (
    <div style={cardStyle}>
      <div style={{ flex: 1 }}>
        {sortBy === 'name_fr' ? (
          <>
            <div style={nameStyle}>{card.nameFr || card.nameEn}</div>
            {card.nameFr && card.nameEn && (
              <div style={{ ...metaStyle, marginBottom: '0.5rem', opacity: 0.8 }}>{card.nameEn}</div>
            )}
          </>
        ) : (
          <>
            <div style={nameStyle}>{card.nameEn}</div>
            {card.nameFr && (
              <div style={{ ...metaStyle, marginBottom: '0.5rem', opacity: 0.8 }}>{card.nameFr}</div>
            )}
          </>
        )}
        <div style={metaStyle}>
          <strong>Type:</strong> {card.cardType}
        </div>
        <div style={metaStyle}>
          <strong>Série:</strong> {card.series}
        </div>
        <div style={{ marginTop: '0.5rem' }}>
          <span style={rarityBadgeStyle}>{card.rarity}</span>
        </div>
      </div>

      <div style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingTop: '0.75rem',
        borderTop: '1px solid var(--surface-container-high)',
      }}>
        <span style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.8125rem',
          fontWeight: '600',
          color: card.isOwned ? '#667eea' : 'var(--on-surface-variant)',
        }}>
          {card.isOwned ? 'Possédée' : 'Non possédée'}
        </span>
        <CardToggle card={card} onToggle={onToggle} isLoading={isToggling} />
      </div>
    </div>
  )
}

// ─── Skeleton Loading ─────────────────────────────────────────────────────────

function CardSkeleton() {
  return (
    <div style={{
      background: 'var(--surface-container-lowest)',
      borderRadius: '12px',
      padding: '1.25rem',
      height: '200px',
    }}>
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
      <div className="skeleton" style={{ width: '60px', height: '1.5rem' }} />
    </div>
  )
}

// ─── Main Page Component ──────────────────────────────────────────────────────

export default function AddCardsPage() {
  const [search, setSearch] = useState('')
  const [series, setSeries] = useState('')
  const [type, setType] = useState('')
  const [rarity, setRarity] = useState('')
  const [owned, setOwned] = useState<OwnedFilter>('all')
  const [sortBy,  setSortBy]  = useState<SortBy>('name_fr')
  const [sortDir, setSortDir] = useState<SortDir>('asc')
  const [togglingCardId, setTogglingCardId] = useState<string>()
  const [confirmModal, setConfirmModal] = useState<{
    card: Card
    newState: boolean
  } | null>(null)

  // Debounce search input
  const [debouncedSearch, setDebouncedSearch] = useState('')
  useEffect(() => {
    const timer = setTimeout(() => setDebouncedSearch(search), 300)
    return () => clearTimeout(timer)
  }, [search])

  const filters: CardFilters = {
    ...(debouncedSearch && { search: debouncedSearch }),
    ...(series && { series }),
    ...(type && { type }),
    ...(rarity && { rarity }),
    ...(owned !== 'all' && { owned: owned as 'true' | 'false' }),
    sort_by:  sortBy,
    sort_dir: sortDir,
  }

  const {
    data,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
    isLoading,
    isError,
    error,
  } = useCards(filters)

  const { toggleCard, isLoading: isToggling } = useCardToggle()

  const allCards = data?.pages.flatMap((p) => p.cards) ?? []
  const total = data?.pages[0]?.total ?? 0

  // Infinite scroll sentinel
  const sentinelRef = useRef<HTMLDivElement | null>(null)

  const handleIntersection = useCallback(
    (entries: IntersectionObserverEntry[]) => {
      if (entries[0].isIntersecting && hasNextPage && !isFetchingNextPage) {
        fetchNextPage()
      }
    },
    [fetchNextPage, hasNextPage, isFetchingNextPage]
  )

  useEffect(() => {
    const el = sentinelRef.current
    if (!el) return
    const observer = new IntersectionObserver(handleIntersection, { threshold: 0.1 })
    observer.observe(el)
    return () => observer.disconnect()
  }, [handleIntersection])

  const handleToggle = (cardId: string, isOwned: boolean) => {
    const card = allCards.find(c => c.id === cardId)
    if (!card) return
    setConfirmModal({ card, newState: isOwned })
  }

  const handleConfirmToggle = () => {
    if (!confirmModal) return
    setTogglingCardId(confirmModal.card.id)
    toggleCard(
      { cardId: confirmModal.card.id, isOwned: confirmModal.newState },
      { onSettled: () => setTogglingCardId(undefined) }
    )
    setConfirmModal(null)
  }

  const handleCancelToggle = () => {
    setConfirmModal(null)
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

  const counterStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem',
    color: 'var(--on-surface-variant)',
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
    gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
    gap: '1.25rem',
    marginBottom: '2rem',
  }

  const ownedOptions: { value: OwnedFilter; label: string }[] = [
    { value: 'all', label: 'Toutes' },
    { value: 'true', label: 'Possédées' },
    { value: 'false', label: 'Non possédées' },
  ]

  // ─── Render ───────────────────────────────────────────────────────────────

  return (
    <>
      {confirmModal && (
        <ConfirmToggleModal
          card={confirmModal.card}
          newState={confirmModal.newState}
          isOpen={true}
          onConfirm={handleConfirmToggle}
          onCancel={handleCancelToggle}
        />
      )}

      <div style={pageStyle}>
        <div style={containerStyle}>
        {/* Header */}
        <header style={headerStyle}>
          <Link href="/" style={backLinkStyle}>
            ← Retour au dashboard
          </Link>
          <h1 style={headingStyle}>Gérer ma Collection</h1>
          <p style={counterStyle}>
            {isLoading
              ? 'Chargement...'
              : isError
              ? 'Erreur de chargement'
              : `${total.toLocaleString('fr-FR')} carte${total > 1 ? 's' : ''} disponible${total > 1 ? 's' : ''}`}
          </p>
        </header>

        {/* Filters */}
        <div style={filtersBarStyle}>
          <input
            type="search"
            placeholder="Rechercher une carte..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={inputStyle}
            aria-label="Rechercher une carte"
          />

          <select
            value={series}
            onChange={(e) => setSeries(e.target.value)}
            style={selectStyle}
            aria-label="Filtrer par série"
          >
            <option value="">Toutes les séries</option>
            {SERIES_OPTIONS.map((s) => (
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>

          <select
            value={type}
            onChange={(e) => setType(e.target.value)}
            style={selectStyle}
            aria-label="Filtrer par type"
          >
            <option value="">Tous les types</option>
            {TYPE_OPTIONS.map((t) => (
              <option key={t} value={t}>
                {t}
              </option>
            ))}
          </select>

          <select
            value={rarity}
            onChange={(e) => setRarity(e.target.value)}
            style={selectStyle}
            aria-label="Filtrer par rareté"
          >
            <option value="">Toutes raretés</option>
            {RARITY_OPTIONS.map(({ value, label }) => (
              <option key={value} value={value}>
                {label}
              </option>
            ))}
          </select>

          <div style={toggleGroupStyle} role="group" aria-label="Filtre possession">
            {ownedOptions.map(({ value, label }) => (
              <button
                key={value}
                onClick={() => setOwned(value)}
                style={toggleBtnStyle(owned === value)}
                aria-pressed={owned === value}
              >
                {label}
              </button>
            ))}
          </div>

          {/* Toggle langue de tri */}
          <div style={toggleGroupStyle} role="group" aria-label="Langue de tri">
            <button onClick={() => setSortBy('name_fr')} style={toggleBtnStyle(sortBy === 'name_fr')} aria-pressed={sortBy === 'name_fr'}>FR</button>
            <button onClick={() => setSortBy('name_en')} style={toggleBtnStyle(sortBy === 'name_en')} aria-pressed={sortBy === 'name_en'}>EN</button>
          </div>

          {/* Toggle ordre de tri */}
          <div style={toggleGroupStyle} role="group" aria-label="Ordre de tri">
            <button onClick={() => setSortDir('asc')}  style={toggleBtnStyle(sortDir === 'asc')}  aria-pressed={sortDir === 'asc'}>A→Z</button>
            <button onClick={() => setSortDir('desc')} style={toggleBtnStyle(sortDir === 'desc')} aria-pressed={sortDir === 'desc'}>Z→A</button>
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
              Impossible de charger les cartes
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

        {/* Cards Grid */}
        {!isError && (
          <>
            <div style={gridStyle}>
              {isLoading
                ? Array.from({ length: 12 }).map((_, i) => <CardSkeleton key={i} />)
                : allCards.length === 0
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
                      Aucune carte trouvée
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
                : allCards.map((card) => (
                    <CardItem
                      key={card.id}
                      card={card}
                      sortBy={sortBy}
                      onToggle={handleToggle}
                      isTogglingId={togglingCardId}
                    />
                  ))}

              {/* Loading more cards */}
              {isFetchingNextPage &&
                Array.from({ length: 8 }).map((_, i) => <CardSkeleton key={`loading-${i}`} />)}
            </div>

            {/* Infinite scroll sentinel */}
            <div ref={sentinelRef} style={{ height: '1px' }} aria-hidden />

            {/* End of list message */}
            {!hasNextPage && !isLoading && allCards.length > 0 && (
              <p
                style={{
                  textAlign: 'center',
                  fontFamily: 'Inter, sans-serif',
                  fontSize: '0.8125rem',
                  color: 'var(--on-surface-variant)',
                  marginTop: '1.5rem',
                  opacity: 0.7,
                }}
              >
                Toutes les cartes sont affichées.
              </p>
            )}
          </>
        )}
      </div>
    </div>
    </>
  )
}
