'use client'

import { Collection } from '@/lib/api/collections'
import { useState } from 'react'
import Image from 'next/image'
import { useRouter } from 'next/navigation'

interface CollectionCardProps {
  collection: Collection
}

export default function CollectionCard({ collection }: CollectionCardProps) {
  const [isHovered, setIsHovered] = useState(false)
  const router = useRouter()

  const percentage = Math.round(collection.completionPercentage)
  const isComplete = percentage === 100
  const isEmpty = percentage === 0

  const getCollectionRoute = (slug: string) => {
    switch (slug) {
      case 'royaumes-oublies':
        return '/books'
      case 'dnd5':
        return '/dnd5'
      default:
        return '/cards'
    }
  }

  const collectionImages: Record<string, string> = {
    meccg: '/meccg-logo.png',
    'royaumes-oublies': '/royaumes-oublies.png',
  }

  return (
    <div
      onClick={() => router.push(getCollectionRoute(collection.slug))}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      style={{
        background: '#ffffff',
        borderRadius: '24px',
        padding: '24px',
        position: 'relative',
        overflow: 'hidden',
        transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
        transform: isHovered ? 'scale(1.02)' : 'scale(1)',
        boxShadow: isHovered
          ? '0 20px 40px rgba(0, 0, 0, 0.08), 0 8px 16px rgba(0, 0, 0, 0.04)'
          : '0 4px 8px rgba(0, 0, 0, 0.02)',
        cursor: 'pointer',
      }}
    >
      {/* Hero Image Background */}
      <div style={{
        position: 'relative',
        width: '100%',
        height: '160px',
        borderRadius: '16px',
        background: '#eaebec',
        marginBottom: '16px',
        overflow: 'hidden',
      }}>
        {collectionImages[collection.slug] && (
          <Image
            src={collectionImages[collection.slug]}
            alt={collection.name}
            fill
            style={{ objectFit: 'contain', padding: '8px' }}
            sizes="(max-width: 768px) 100vw, 400px"
          />
        )}
        {/* Complete Badge */}
        {isComplete && (
          <div style={{
            position: 'absolute',
            top: '12px',
            right: '12px',
            background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
            color: '#ffffff',
            padding: '6px 12px',
            borderRadius: '12px',
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.75rem',
            fontWeight: '700',
            textTransform: 'uppercase',
            letterSpacing: '0.05em',
            boxShadow: '0 4px 12px rgba(16, 185, 129, 0.4)',
          }}>
            Complete
          </div>
        )}

        {/* Empty Badge */}
        {isEmpty && (
          <div style={{
            position: 'absolute',
            top: '12px',
            left: '12px',
            background: 'rgba(255, 255, 255, 0.9)',
            color: '#43474e',
            padding: '6px 12px',
            borderRadius: '12px',
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.75rem',
            fontWeight: '600',
            letterSpacing: '0.05em',
          }}>
            Not Started
          </div>
        )}
      </div>

      {/* Collection Name */}
      <h3 style={{
        fontFamily: 'Manrope, sans-serif',
        fontSize: '1.5rem',
        fontWeight: '700',
        color: '#191c1d',
        marginBottom: '8px',
        lineHeight: '1.2',
      }}>
        {collection.name}
      </h3>

      {/* Description */}
      <p style={{
        fontFamily: 'Inter, sans-serif',
        fontSize: '0.875rem',
        color: '#43474e',
        marginBottom: '16px',
        lineHeight: '1.5',
        minHeight: '42px', // 2 lines minimum for consistency
      }}>
        {collection.description}
      </p>

      {/* Progress Bar */}
      <div style={{
        width: '100%',
        height: '8px',
        background: '#e8e9ea',
        borderRadius: '9999px',
        overflow: 'hidden',
        marginBottom: '12px',
        position: 'relative',
      }}>
        <div style={{
          width: `${percentage}%`,
          height: '100%',
          background: 'linear-gradient(90deg, #667eea 0%, #764ba2 100%)',
          borderRadius: '9999px',
          position: 'relative',
          boxShadow: percentage > 0 ? '0 0 8px rgba(102, 126, 234, 0.5)' : 'none',
          transition: 'width 0.6s ease-in-out',
        }} />
      </div>

      {/* Stats */}
      <div style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
      }}>
        <div style={{
          display: 'flex',
          flexDirection: 'column',
          gap: '4px',
        }}>
          <div style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.875rem',
            fontWeight: '600',
            color: '#191c1d',
          }}>
            {collection.totalCardsOwned} / {collection.totalCardsAvailable} {(collection.slug === 'royaumes-oublies' || collection.slug === 'dnd5') ? 'livres' : 'cards'}
          </div>
          {(collection.totalCardsAvailable - collection.totalCardsOwned) > 0 && (
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: '0.75rem',
              color: '#43474e',
              display: 'flex',
              alignItems: 'center',
              gap: '4px',
            }}>
              <span style={{ fontSize: '0.875rem' }}>🎯</span>
              <span><strong style={{ color: '#191c1d' }}>{collection.totalCardsAvailable - collection.totalCardsOwned}</strong> to go</span>
            </div>
          )}
        </div>

        <div style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: '1.25rem',
          fontWeight: '700',
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          backgroundClip: 'text',
        }}>
          {percentage}%
        </div>
      </div>

      {/* Empty State Message */}
      {isEmpty && (
        <div style={{
          marginTop: '12px',
          padding: '12px',
          background: '#f8f9fa',
          borderRadius: '12px',
          textAlign: 'center',
        }}>
          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.75rem',
            color: '#43474e',
            fontStyle: 'italic',
          }}>
            Start your collection journey
          </p>
        </div>
      )}
    </div>
  )
}
