'use client'

import { ActivityFeed } from '@/lib/api/collections'

interface RecentActivityWidgetProps {
  feed: ActivityFeed | undefined
  isLoading: boolean
  error: Error | null
}

const ICON_MAP: Record<string, string> = {
  'plus-circle': '＋',
  'trophy': '🏆',
  'download': '⬇',
}

const TYPE_COLOR: Record<string, string> = {
  card_added: '#667eea',
  milestone_reached: '#f59e0b',
  import_completed: '#10b981',
}

function formatRelativeTime(timestamp: string): string {
  const diff = Date.now() - new Date(timestamp).getTime()
  const hours = Math.floor(diff / 3600000)
  if (hours < 1) return 'À l\'instant'
  if (hours < 24) return `Il y a ${hours}h`
  const days = Math.floor(hours / 24)
  return `Il y a ${days}j`
}

export default function RecentActivityWidget({ feed, isLoading, error }: RecentActivityWidgetProps) {
  if (isLoading) {
    return (
      <div style={{
        background: 'var(--surface-container-lowest)',
        borderRadius: '24px',
        padding: '1.5rem',
        boxShadow: '0px 12px 32px rgba(25, 28, 29, 0.06)',
      }}>
        <div style={{ height: '1.25rem', width: '40%', background: 'var(--surface-container-low)', borderRadius: '8px', marginBottom: '1.5rem' }} />
        {[...Array(4)].map((_, i) => (
          <div key={i} style={{ display: 'flex', gap: '12px', marginBottom: '1rem', alignItems: 'center' }}>
            <div style={{ width: '36px', height: '36px', borderRadius: '50%', background: 'var(--surface-container-low)', flexShrink: 0 }} />
            <div style={{ flex: 1 }}>
              <div style={{ height: '0.875rem', background: 'var(--surface-container-low)', borderRadius: '6px', marginBottom: '6px', width: '70%' }} />
              <div style={{ height: '0.75rem', background: 'var(--surface-container-low)', borderRadius: '6px', width: '40%' }} />
            </div>
          </div>
        ))}
      </div>
    )
  }

  if (error) {
    return (
      <div style={{
        background: 'var(--surface-container-lowest)',
        borderRadius: '24px',
        padding: '1.5rem',
        boxShadow: '0px 12px 32px rgba(25, 28, 29, 0.06)',
      }}>
        <h3 style={{ fontFamily: 'Manrope, sans-serif', fontWeight: '700', fontSize: '1rem', color: 'var(--on-surface)', margin: '0 0 0.5rem' }}>
          Activité récente
        </h3>
        <p style={{ fontFamily: 'Inter, sans-serif', fontSize: '0.875rem', color: '#ef4444', margin: 0 }}>
          Impossible de charger l'activité.
        </p>
      </div>
    )
  }

  if (!feed || feed.activities.length === 0) {
    return (
      <div style={{
        background: 'var(--surface-container-lowest)',
        borderRadius: '24px',
        padding: '1.5rem',
        boxShadow: '0px 12px 32px rgba(25, 28, 29, 0.06)',
      }}>
        <h3 style={{ fontFamily: 'Manrope, sans-serif', fontWeight: '700', fontSize: '1rem', color: 'var(--on-surface)', margin: '0 0 1rem' }}>
          Activité récente
        </h3>
        <p style={{ fontFamily: 'Inter, sans-serif', fontSize: '0.875rem', color: 'var(--on-surface-variant)', margin: 0 }}>
          Aucune activité pour le moment.
        </p>
      </div>
    )
  }

  return (
    <div style={{
      background: 'var(--surface-container-lowest)',
      borderRadius: '24px',
      padding: '1.5rem',
      boxShadow: '0px 12px 32px rgba(25, 28, 29, 0.06)',
    }}>
      <h3 style={{
        fontFamily: 'Manrope, sans-serif',
        fontWeight: '700',
        fontSize: '1rem',
        color: 'var(--on-surface)',
        margin: '0 0 1.25rem',
      }}>
        Activité récente
      </h3>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
        {feed.activities.map((activity) => (
          <div key={activity.id} style={{ display: 'flex', gap: '12px', alignItems: 'flex-start' }}>
            <div style={{
              width: '36px',
              height: '36px',
              borderRadius: '50%',
              background: `${TYPE_COLOR[activity.type] || '#667eea'}18`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '1rem',
              flexShrink: 0,
              color: TYPE_COLOR[activity.type] || '#667eea',
            }}>
              {ICON_MAP[activity.icon] || '•'}
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <p style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.875rem',
                fontWeight: '600',
                color: 'var(--on-surface)',
                margin: '0 0 2px',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
                whiteSpace: 'nowrap',
              }}>
                {activity.title}
              </p>
              <p style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.75rem',
                color: 'var(--on-surface-variant)',
                margin: 0,
              }}>
                {formatRelativeTime(activity.timestamp)}
                {activity.relatedCollectionName && ` · ${activity.relatedCollectionName}`}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
