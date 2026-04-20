'use client'

import { GrowthStats } from '@/lib/api/collections'

interface GrowthInsightWidgetProps {
  stats: GrowthStats | undefined
  isLoading: boolean
  error: Error | null
}

const TREND_LABEL: Record<string, string> = {
  increasing: 'En hausse',
  decreasing: 'En baisse',
  stable: 'Stable',
}

const TREND_COLOR: Record<string, string> = {
  increasing: '#10b981',
  decreasing: '#ef4444',
  stable: '#f59e0b',
}

export default function GrowthInsightWidget({ stats, isLoading, error }: GrowthInsightWidgetProps) {
  if (isLoading) {
    return (
      <div style={{
        background: 'var(--surface-container-lowest)',
        borderRadius: '24px',
        padding: '1.5rem',
        boxShadow: '0px 12px 32px rgba(25, 28, 29, 0.06)',
      }}>
        <div style={{ height: '1.25rem', width: '50%', background: 'var(--surface-container-low)', borderRadius: '8px', marginBottom: '1.5rem' }} />
        <div style={{ display: 'flex', gap: '6px', alignItems: 'flex-end', height: '80px' }}>
          {[...Array(6)].map((_, i) => (
            <div key={i} style={{
              flex: 1,
              height: `${30 + Math.random() * 50}%`,
              background: 'var(--surface-container-low)',
              borderRadius: '6px 6px 0 0',
            }} />
          ))}
        </div>
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
          Croissance
        </h3>
        <p style={{ fontFamily: 'Inter, sans-serif', fontSize: '0.875rem', color: '#ef4444', margin: 0 }}>
          Impossible de charger les statistiques.
        </p>
      </div>
    )
  }

  if (!stats || stats.dataPoints.length === 0) return null

  const maxCards = Math.max(...stats.dataPoints.map((dp) => dp.cardsAdded), 1)
  const trendColor = TREND_COLOR[stats.trend] || '#667eea'

  return (
    <div style={{
      background: 'var(--surface-container-lowest)',
      borderRadius: '24px',
      padding: '1.5rem',
      boxShadow: '0px 12px 32px rgba(25, 28, 29, 0.06)',
    }}>
      {/* Header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '1.25rem' }}>
        <h3 style={{
          fontFamily: 'Manrope, sans-serif',
          fontWeight: '700',
          fontSize: '1rem',
          color: 'var(--on-surface)',
          margin: 0,
        }}>
          Croissance
        </h3>
        <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
          <span style={{
            width: '8px',
            height: '8px',
            borderRadius: '50%',
            background: trendColor,
            display: 'inline-block',
          }} />
          <span style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.75rem',
            fontWeight: '600',
            color: trendColor,
          }}>
            {TREND_LABEL[stats.trend]}
          </span>
        </div>
      </div>

      {/* Bar chart */}
      <div style={{ display: 'flex', gap: '6px', alignItems: 'flex-end', height: '80px', marginBottom: '0.5rem' }}>
        {stats.dataPoints.map((dp) => {
          const height = dp.cardsAdded === 0 ? 4 : Math.max(8, (dp.cardsAdded / maxCards) * 80)
          const isLast = dp === stats.dataPoints[stats.dataPoints.length - 1]
          return (
            <div key={dp.period} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '4px' }}>
              <div style={{
                width: '100%',
                height: `${height}px`,
                background: isLast
                  ? 'linear-gradient(180deg, #667eea 0%, #764ba2 100%)'
                  : 'var(--surface-container-highest)',
                borderRadius: '4px 4px 0 0',
                transition: 'height 0.3s ease',
              }} />
            </div>
          )
        })}
      </div>

      {/* Labels */}
      <div style={{ display: 'flex', gap: '6px' }}>
        {stats.dataPoints.map((dp) => (
          <div key={dp.period} style={{
            flex: 1,
            textAlign: 'center',
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.625rem',
            color: 'var(--on-surface-variant)',
          }}>
            {dp.label}
          </div>
        ))}
      </div>

      {/* Growth rate */}
      <div style={{
        marginTop: '1rem',
        padding: '0.75rem',
        background: 'var(--surface-container-low)',
        borderRadius: '12px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
      }}>
        <span style={{ fontFamily: 'Inter, sans-serif', fontSize: '0.75rem', color: 'var(--on-surface-variant)' }}>
          Taux de croissance
        </span>
        <span style={{
          fontFamily: 'Manrope, sans-serif',
          fontSize: '0.875rem',
          fontWeight: '700',
          color: trendColor,
        }}>
          {stats.growthRatePercentage >= 0 ? '+' : ''}{stats.growthRatePercentage.toFixed(1)}%
        </span>
      </div>
    </div>
  )
}
