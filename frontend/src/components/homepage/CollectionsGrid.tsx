'use client'

import { Collection } from '@/lib/api/collections'
import CollectionCard from './CollectionCard'
import { useDnD5Books } from '@/hooks/useDnD5Books'

interface CollectionsGridProps {
  collections?: Collection[]
  isLoading?: boolean
  error?: Error | null
}

export default function CollectionsGrid({ collections, isLoading, error }: CollectionsGridProps) {
  // Fetch D&D 5e books data
  const { data: dnd5Data } = useDnD5Books({ limit: 500 })
  const dnd5Books = dnd5Data?.books ?? []
  const dnd5Owned = dnd5Books.filter(b => b.ownedFr || b.ownedEn).length

  // Loading State
  if (isLoading) {
    return <CollectionsGridSkeleton />
  }

  // Error State
  if (error) {
    return (
      <div style={{
        background: '#ffffff',
        borderRadius: '24px',
        padding: '48px 32px',
        textAlign: 'center',
      }}>
        <div style={{
          fontSize: '64px',
          marginBottom: '16px',
        }}>⚠️</div>
        <h3 style={{
          fontFamily: 'Manrope, sans-serif',
          fontSize: '1.5rem',
          fontWeight: '600',
          color: '#191c1d',
          marginBottom: '8px',
        }}>
          Unable to load collections
        </h3>
        <p style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          color: '#43474e',
        }}>
          {error.message || 'Something went wrong. Please try again later.'}
        </p>
      </div>
    )
  }

  // Empty State
  if (!collections || collections.length === 0) {
    return (
      <div style={{
        background: '#ffffff',
        borderRadius: '24px',
        padding: '48px 32px',
        textAlign: 'center',
      }}>
        <div style={{
          fontSize: '64px',
          marginBottom: '16px',
        }}>📦</div>
        <h3 style={{
          fontFamily: 'Manrope, sans-serif',
          fontSize: '1.5rem',
          fontWeight: '600',
          color: '#191c1d',
          marginBottom: '8px',
        }}>
          No collections yet
        </h3>
        <p style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          color: '#43474e',
        }}>
          Start by creating your first collection.
        </p>
      </div>
    )
  }

  // Success State - Grid Layout
  // Add static Books collection (until backend returns it)
  const booksCollection: Collection = {
    id: 'books-royaumes-oublies',
    name: 'Royaumes Oubliés',
    slug: 'royaumes-oublies',
    description: 'Collection de romans Forgotten Realms',
    totalCardsOwned: 41,
    totalCardsAvailable: 94,
    completionPercentage: 43.6,
    heroImageUrl: '',
    lastUpdated: null,
  }

  // Add D&D 5e collection
  const dnd5Collection: Collection = {
    id: 'dnd5',
    name: 'D&D 5e',
    slug: 'dnd5',
    description: 'Livres officiels Dungeons & Dragons 5e',
    totalCardsOwned: dnd5Owned,
    totalCardsAvailable: 53,
    completionPercentage: dnd5Books.length > 0 ? Math.round((dnd5Owned / 53) * 100 * 10) / 10 : 0,
    heroImageUrl: '',
    lastUpdated: null,
  }

  const allCollections = collections ? [...collections, booksCollection, dnd5Collection] : [booksCollection, dnd5Collection]

  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))',
      gap: '24px',
    }}>
      {allCollections.map((collection) => (
        <CollectionCard key={collection.id} collection={collection} />
      ))}
    </div>
  )
}

// Skeleton Loader Component
function CollectionsGridSkeleton() {
  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))',
      gap: '24px',
    }}>
      {/* Shimmer animation */}
      <style>{`
        @keyframes shimmer {
          0% {
            background-position: -1000px 0;
          }
          100% {
            background-position: 1000px 0;
          }
        }
        .skeleton {
          animation: shimmer 2s infinite linear;
          background: linear-gradient(
            90deg,
            #f3f4f5 0%,
            #e8e9ea 20%,
            #f3f4f5 40%,
            #f3f4f5 100%
          );
          background-size: 1000px 100%;
        }
      `}</style>

      {/* Skeleton Card 1 */}
      <div style={{
        background: '#ffffff',
        borderRadius: '24px',
        padding: '24px',
      }}>
        {/* Hero Image Skeleton */}
        <div className="skeleton" style={{
          width: '100%',
          height: '160px',
          borderRadius: '16px',
          marginBottom: '16px',
        }} />

        {/* Title Skeleton */}
        <div className="skeleton" style={{
          width: '70%',
          height: '28px',
          borderRadius: '8px',
          marginBottom: '8px',
        }} />

        {/* Description Skeleton */}
        <div style={{ marginBottom: '16px' }}>
          <div className="skeleton" style={{
            width: '100%',
            height: '14px',
            borderRadius: '4px',
            marginBottom: '6px',
          }} />
          <div className="skeleton" style={{
            width: '85%',
            height: '14px',
            borderRadius: '4px',
          }} />
        </div>

        {/* Progress Bar Skeleton */}
        <div style={{
          width: '100%',
          height: '8px',
          background: '#e8e9ea',
          borderRadius: '9999px',
          marginBottom: '12px',
        }} />

        {/* Stats Skeleton */}
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
        }}>
          <div className="skeleton" style={{
            width: '100px',
            height: '16px',
            borderRadius: '4px',
          }} />
          <div className="skeleton" style={{
            width: '50px',
            height: '20px',
            borderRadius: '4px',
          }} />
        </div>
      </div>

      {/* Skeleton Card 2 */}
      <div style={{
        background: '#ffffff',
        borderRadius: '24px',
        padding: '24px',
      }}>
        {/* Hero Image Skeleton */}
        <div className="skeleton" style={{
          width: '100%',
          height: '160px',
          borderRadius: '16px',
          marginBottom: '16px',
        }} />

        {/* Title Skeleton */}
        <div className="skeleton" style={{
          width: '60%',
          height: '28px',
          borderRadius: '8px',
          marginBottom: '8px',
        }} />

        {/* Description Skeleton */}
        <div style={{ marginBottom: '16px' }}>
          <div className="skeleton" style={{
            width: '100%',
            height: '14px',
            borderRadius: '4px',
            marginBottom: '6px',
          }} />
          <div className="skeleton" style={{
            width: '90%',
            height: '14px',
            borderRadius: '4px',
          }} />
        </div>

        {/* Progress Bar Skeleton */}
        <div style={{
          width: '100%',
          height: '8px',
          background: '#e8e9ea',
          borderRadius: '9999px',
          marginBottom: '12px',
        }} />

        {/* Stats Skeleton */}
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
        }}>
          <div className="skeleton" style={{
            width: '100px',
            height: '16px',
            borderRadius: '4px',
          }} />
          <div className="skeleton" style={{
            width: '50px',
            height: '20px',
            borderRadius: '4px',
          }} />
        </div>
      </div>
    </div>
  )
}
