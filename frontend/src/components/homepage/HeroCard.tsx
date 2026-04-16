'use client'

import { CollectionSummary } from '@/lib/api/collections'

interface HeroCardProps {
  summary?: CollectionSummary
  isLoading?: boolean
  error?: Error | null
  onRetry?: () => void
}

export default function HeroCard({ summary, isLoading, error, onRetry }: HeroCardProps) {
  // Loading State
  if (isLoading) {
    return <HeroCardSkeleton />
  }

  // Error State
  if (error) {
    return (
      <div style={{
        background: '#ffffff',
        borderRadius: '16px',
        padding: '32px',
        textAlign: 'center',
      }}>
        <div style={{
          fontSize: '48px',
          marginBottom: '16px',
        }}>⚠️</div>
        <h3 style={{
          fontFamily: 'Manrope, sans-serif',
          fontSize: '1.5rem',
          fontWeight: '600',
          color: '#191c1d',
          marginBottom: '8px',
        }}>
          Unable to load collection data
        </h3>
        <p style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          color: '#43474e',
          marginBottom: '24px',
        }}>
          {error.message || 'Something went wrong. Please try again.'}
        </p>
        {onRetry && (
          <button
            onClick={onRetry}
            style={{
              background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              color: '#ffffff',
              border: 'none',
              borderRadius: '24px',
              padding: '12px 32px',
              fontFamily: 'Inter, sans-serif',
              fontSize: '0.875rem',
              fontWeight: '600',
              cursor: 'pointer',
              transition: 'transform 0.2s',
            }}
            onMouseEnter={(e) => e.currentTarget.style.transform = 'scale(1.05)'}
            onMouseLeave={(e) => e.currentTarget.style.transform = 'scale(1)'}
          >
            Retry
          </button>
        )}
      </div>
    )
  }

  // Empty State (no data)
  if (!summary) {
    return (
      <div style={{
        background: '#ffffff',
        borderRadius: '16px',
        padding: '32px',
        textAlign: 'center',
      }}>
        <p style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          color: '#43474e',
        }}>
          No collection data available.
        </p>
      </div>
    )
  }

  // Success State
  const percentage = Math.round(summary.completionPercentage)
  const cardsToGo = summary.totalCardsAvailable - summary.totalCardsOwned

  return (
    <div style={{
      background: '#ffffff',
      borderRadius: '16px',
      padding: '32px',
      position: 'relative',
    }}>
      {/* Label */}
      <div style={{
        fontFamily: 'Inter, sans-serif',
        fontSize: '0.75rem',
        fontWeight: '600',
        color: '#43474e',
        textTransform: 'uppercase',
        letterSpacing: '0.05em',
        marginBottom: '16px',
      }}>
        Dashboard Overview
      </div>

      {/* Title */}
      <h2 style={{
        fontFamily: 'Manrope, sans-serif',
        fontSize: '1.875rem',
        fontWeight: '700',
        color: '#191c1d',
        marginBottom: '8px',
      }}>
        Total Collection Progress
      </h2>

      {/* Percentage Display */}
      <div style={{
        fontFamily: 'Manrope, sans-serif',
        fontSize: '4rem',
        fontWeight: '800',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        WebkitBackgroundClip: 'text',
        WebkitTextFillColor: 'transparent',
        backgroundClip: 'text',
        marginBottom: '8px',
        lineHeight: '1',
      }}>
        {percentage}%
      </div>

      <div style={{
        fontFamily: 'Inter, sans-serif',
        fontSize: '0.875rem',
        fontWeight: '500',
        color: '#43474e',
        marginBottom: '24px',
      }}>
        completed
      </div>

      {/* Progress Bar */}
      <div style={{
        width: '100%',
        height: '12px',
        background: '#e1e3e4',
        borderRadius: '8px',
        overflow: 'hidden',
        marginBottom: '24px',
        position: 'relative',
      }}>
        <div style={{
          width: `${percentage}%`,
          height: '100%',
          background: 'linear-gradient(90deg, #667eea 0%, #764ba2 100%)',
          borderRadius: '8px',
          position: 'relative',
          boxShadow: '0 0 12px rgba(102, 126, 234, 0.5)',
          transition: 'width 0.6s ease-in-out',
        }} />
      </div>

      {/* Stats */}
      <div style={{
        display: 'flex',
        gap: '24px',
        marginBottom: '32px',
      }}>
        <div style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          color: '#43474e',
        }}>
          <span style={{ fontSize: '1.25rem', marginRight: '8px' }}>💎</span>
          <strong style={{ color: '#191c1d' }}>{summary.totalCardsOwned}</strong> / {summary.totalCardsAvailable} Cards Owned
        </div>
        {cardsToGo > 0 && (
          <div style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.875rem',
            color: '#43474e',
          }}>
            <span style={{ fontSize: '1.25rem', marginRight: '8px' }}>🎯</span>
            <strong style={{ color: '#191c1d' }}>{cardsToGo}</strong> to go
          </div>
        )}
      </div>

      {/* Action Buttons */}
      <div style={{
        display: 'flex',
        gap: '12px',
        flexWrap: 'wrap',
      }}>
        <button style={{
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          color: '#ffffff',
          border: 'none',
          borderRadius: '24px',
          padding: '12px 24px',
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          fontWeight: '600',
          cursor: 'pointer',
          transition: 'transform 0.2s',
        }}
        onMouseEnter={(e) => e.currentTarget.style.transform = 'scale(1.05)'}
        onMouseLeave={(e) => e.currentTarget.style.transform = 'scale(1)'}
        >
          Add Card
        </button>

        <button style={{
          background: '#e8e9ea',
          color: '#667eea',
          border: 'none',
          borderRadius: '24px',
          padding: '12px 24px',
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          fontWeight: '600',
          cursor: 'pointer',
          transition: 'all 0.2s',
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.background = '#e1e3e4'
          e.currentTarget.style.transform = 'scale(1.05)'
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.background = '#e8e9ea'
          e.currentTarget.style.transform = 'scale(1)'
        }}
        >
          View Wishlist
        </button>

        <button style={{
          background: '#e8e9ea',
          color: '#667eea',
          border: 'none',
          borderRadius: '24px',
          padding: '12px 24px',
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          fontWeight: '600',
          cursor: 'pointer',
          transition: 'all 0.2s',
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.background = '#e1e3e4'
          e.currentTarget.style.transform = 'scale(1.05)'
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.background = '#e8e9ea'
          e.currentTarget.style.transform = 'scale(1)'
        }}
        >
          Import
        </button>
      </div>
    </div>
  )
}

// Skeleton Loader Component
function HeroCardSkeleton() {
  return (
    <div style={{
      background: '#ffffff',
      borderRadius: '16px',
      padding: '32px',
      position: 'relative',
    }}>
      {/* Shimmer effect */}
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

      {/* Label skeleton */}
      <div className="skeleton" style={{
        width: '120px',
        height: '12px',
        borderRadius: '4px',
        marginBottom: '16px',
      }} />

      {/* Title skeleton */}
      <div className="skeleton" style={{
        width: '60%',
        height: '32px',
        borderRadius: '8px',
        marginBottom: '24px',
      }} />

      {/* Percentage skeleton */}
      <div className="skeleton" style={{
        width: '150px',
        height: '64px',
        borderRadius: '8px',
        marginBottom: '8px',
      }} />

      {/* "completed" label skeleton */}
      <div className="skeleton" style={{
        width: '80px',
        height: '14px',
        borderRadius: '4px',
        marginBottom: '24px',
      }} />

      {/* Progress bar skeleton */}
      <div style={{
        width: '100%',
        height: '12px',
        background: '#e1e3e4',
        borderRadius: '8px',
        marginBottom: '24px',
      }} />

      {/* Stats skeleton */}
      <div style={{
        display: 'flex',
        gap: '24px',
        marginBottom: '32px',
      }}>
        <div className="skeleton" style={{
          width: '180px',
          height: '16px',
          borderRadius: '4px',
        }} />
        <div className="skeleton" style={{
          width: '100px',
          height: '16px',
          borderRadius: '4px',
        }} />
      </div>

      {/* Buttons skeleton */}
      <div style={{
        display: 'flex',
        gap: '12px',
      }}>
        <div className="skeleton" style={{
          width: '100px',
          height: '40px',
          borderRadius: '24px',
        }} />
        <div className="skeleton" style={{
          width: '120px',
          height: '40px',
          borderRadius: '24px',
        }} />
        <div className="skeleton" style={{
          width: '80px',
          height: '40px',
          borderRadius: '24px',
        }} />
      </div>
    </div>
  )
}
