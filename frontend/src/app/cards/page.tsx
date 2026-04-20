'use client'

import { useState, useEffect, useRef, useCallback } from 'react'
import { useCards } from '@/hooks/useCards'
import { CardFilters } from '@/lib/api/collections'

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

// ─── Helpers ──────────────────────────────────────────────────────────────────

// ─── Skeleton ─────────────────────────────────────────────────────────────────

function SkeletonRow() {
  return (
    <tr>
      {[120, 120, 80, 140, 60, 60].map((w, i) => (
        <td key={i} style={{ padding: '0.75rem 1rem' }}>
          <div
            style={{
              height: '0.875rem',
              width: `${w}px`,
              borderRadius: '6px',
              background: 'var(--surface-container-highest)',
              animation: 'pulse 1.4s ease-in-out infinite',
            }}
          />
        </td>
      ))}
    </tr>
  )
}

// ─── Page principale ──────────────────────────────────────────────────────────

export default function CardsPage() {
  const [search, setSearch]   = useState('')
  const [series, setSeries]   = useState('')
  const [type, setType]       = useState('')
  const [rarity, setRarity]   = useState('')
  const [owned, setOwned]     = useState<OwnedFilter>('all')

  // Debounce du champ search (300 ms)
  const [debouncedSearch, setDebouncedSearch] = useState('')
  useEffect(() => {
    const id = setTimeout(() => setDebouncedSearch(search), 300)
    return () => clearTimeout(id)
  }, [search])

  const filters: CardFilters = {
    ...(debouncedSearch && { search: debouncedSearch }),
    ...(series          && { series }),
    ...(type            && { type }),
    ...(rarity          && { rarity }),
    ...(owned !== 'all' && { owned: owned as 'true' | 'false' }),
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

  // Aplatir toutes les pages en un tableau
  const allCards = data?.pages.flatMap((p) => p.cards) ?? []
  const total    = data?.pages[0]?.total ?? 0

  // Sentinel IntersectionObserver
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

  // ─── Styles inline (Ethos V1) ────────────────────────────────────────────

  const pageStyle: React.CSSProperties = {
    minHeight: '100vh',
    background: 'var(--surface)',
    padding: '2rem 1.5rem 4rem',
  }

  const containerStyle: React.CSSProperties = {
    maxWidth: '1100px',
    margin: '0 auto',
  }

  const headingStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '800',
    fontSize: '1.75rem',
    color: 'var(--on-surface)',
    marginBottom: '0.25rem',
  }

  const counterStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem',
    color: 'var(--on-surface-variant)',
    marginBottom: '1.5rem',
  }

  const filtersBarStyle: React.CSSProperties = {
    display: 'flex',
    flexWrap: 'wrap',
    gap: '0.75rem',
    marginBottom: '1.5rem',
    padding: '1rem 1.25rem',
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
    padding: '0.5rem 0.875rem',
    outline: 'none',
    minWidth: '180px',
    flex: '1 1 180px',
    boxShadow: '0px 2px 8px rgba(25, 28, 29, 0.06)',
  }

  const selectStyle: React.CSSProperties = {
    ...inputStyle,
    cursor: 'pointer',
    flex: '0 1 160px',
    minWidth: '140px',
  }

  const tableWrapStyle: React.CSSProperties = {
    background: 'var(--surface-container-lowest)',
    borderRadius: '16px',
    overflow: 'hidden',
    boxShadow: '0px 12px 32px rgba(25, 28, 29, 0.06)',
  }

  const tableStyle: React.CSSProperties = {
    width: '100%',
    borderCollapse: 'collapse',
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.8125rem',
    color: 'var(--on-surface)',
  }

  const thStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '700',
    fontSize: '0.75rem',
    textTransform: 'uppercase',
    letterSpacing: '0.06em',
    color: 'var(--on-surface-variant)',
    padding: '0.875rem 1rem',
    background: 'var(--surface-container-low)',
    textAlign: 'left',
    whiteSpace: 'nowrap',
  }

  const tdStyle: React.CSSProperties = {
    padding: '0.625rem 1rem',
    verticalAlign: 'middle',
  }

  const rowEvenStyle: React.CSSProperties = {
    background: 'var(--surface-container-lowest)',
  }

  const rowOddStyle: React.CSSProperties = {
    background: 'var(--surface-container-low)',
  }

  // ─── Toggle owned ────────────────────────────────────────────────────────

  const ownedOptions: { value: OwnedFilter; label: string }[] = [
    { value: 'all',   label: 'Toutes' },
    { value: 'true',  label: 'Possédées' },
    { value: 'false', label: 'Non possédées' },
  ]

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
      padding: '0.5rem 0.875rem',
      cursor: 'pointer',
      transition: 'all 0.15s',
      whiteSpace: 'nowrap',
    }
  }

  // ─── Rendu ───────────────────────────────────────────────────────────────

  return (
    <div style={pageStyle}>
      <style>{`
        @keyframes pulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.4; }
        }
        select option { background: var(--surface-container-lowest, #fff); }
      `}</style>

      <div style={containerStyle}>

        {/* En-tête */}
        <h1 style={headingStyle}>Cartes</h1>
        <p style={counterStyle}>
          {isLoading
            ? 'Chargement…'
            : isError
            ? 'Erreur de chargement'
            : `${total.toLocaleString('fr-FR')} carte${total > 1 ? 's' : ''}`}
        </p>

        {/* Barre de filtres */}
        <div style={filtersBarStyle}>
          <input
            type="search"
            placeholder="Rechercher…"
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
              <option key={s} value={s}>{s}</option>
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
              <option key={t} value={t}>{t}</option>
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
              <option key={value} value={value}>{label}</option>
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
        </div>

        {/* État d'erreur */}
        {isError && (
          <div style={{
            padding: '2rem',
            borderRadius: '16px',
            background: 'var(--surface-container-low)',
            textAlign: 'center',
          }}>
            <p style={{
              fontFamily: 'Manrope, sans-serif',
              fontWeight: '700',
              fontSize: '1.125rem',
              color: 'var(--on-surface)',
              marginBottom: '0.5rem',
            }}>
              Impossible de charger les cartes
            </p>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: '0.875rem',
              color: 'var(--on-surface-variant)',
            }}>
              {(error as Error)?.message ?? 'Une erreur inattendue est survenue.'}
            </p>
          </div>
        )}

        {/* Tableau */}
        {!isError && (
          <div style={tableWrapStyle}>
            <table style={tableStyle}>
              <thead>
                <tr>
                  <th style={thStyle}>Nom FR</th>
                  <th style={thStyle}>Nom EN</th>
                  <th style={thStyle}>Type</th>
                  <th style={thStyle}>Série</th>
                  <th style={thStyle}>Rareté</th>
                  <th style={{ ...thStyle, textAlign: 'center' }}>Possédée</th>
                </tr>
              </thead>
              <tbody>
                {isLoading
                  ? Array.from({ length: 10 }).map((_, i) => <SkeletonRow key={i} />)
                  : allCards.length === 0
                  ? (
                    <tr>
                      <td colSpan={6} style={{ padding: '3rem', textAlign: 'center' }}>
                        <p style={{
                          fontFamily: 'Manrope, sans-serif',
                          fontWeight: '700',
                          fontSize: '1.125rem',
                          color: 'var(--on-surface)',
                          marginBottom: '0.375rem',
                        }}>
                          Aucune carte trouvée
                        </p>
                        <p style={{
                          fontFamily: 'Inter, sans-serif',
                          fontSize: '0.875rem',
                          color: 'var(--on-surface-variant)',
                        }}>
                          Essayez de modifier vos filtres.
                        </p>
                      </td>
                    </tr>
                  )
                  : allCards.map((card, idx) => (
                    <tr key={card.id} style={idx % 2 === 0 ? rowEvenStyle : rowOddStyle}>
                      <td style={tdStyle}>{card.nameFr || '—'}</td>
                      <td style={{ ...tdStyle, color: 'var(--on-surface-variant)' }}>
                        {card.nameEn || '—'}
                      </td>
                      <td style={tdStyle}>{card.cardType}</td>
                      <td style={{ ...tdStyle, color: 'var(--on-surface-variant)' }}>
                        {card.series}
                      </td>
                      <td style={tdStyle}>
                        <span style={{
                          display: 'inline-block',
                          fontFamily: 'Manrope, sans-serif',
                          fontWeight: '700',
                          fontSize: '0.6875rem',
                          letterSpacing: '0.04em',
                          padding: '0.125rem 0.5rem',
                          borderRadius: '6px',
                          background: 'var(--surface-container-highest)',
                          color: 'var(--on-surface-variant)',
                        }}>
                          {card.rarity}
                        </span>
                      </td>
                      <td style={{ ...tdStyle, textAlign: 'center' }}>
                        {card.isOwned
                          ? <span style={{ color: '#667eea', fontWeight: '700' }} aria-label="Possédée">✓</span>
                          : <span style={{ color: 'var(--on-surface-variant)', opacity: 0.4 }} aria-label="Non possédée">✗</span>
                        }
                      </td>
                    </tr>
                  ))
                }

                {/* Skeleton des pages suivantes */}
                {isFetchingNextPage &&
                  Array.from({ length: 5 }).map((_, i) => <SkeletonRow key={`next-${i}`} />)
                }
              </tbody>
            </table>
          </div>
        )}

        {/* Sentinel scroll infini */}
        <div ref={sentinelRef} style={{ height: '1px', marginTop: '2rem' }} aria-hidden />

        {/* Message fin de liste */}
        {!hasNextPage && !isLoading && allCards.length > 0 && (
          <p style={{
            textAlign: 'center',
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.8125rem',
            color: 'var(--on-surface-variant)',
            marginTop: '1.5rem',
            opacity: 0.7,
          }}>
            Toutes les cartes sont affichées.
          </p>
        )}

      </div>
    </div>
  )
}
