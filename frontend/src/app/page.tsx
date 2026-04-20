'use client'

import HeroCard from '@/components/homepage/HeroCard'
import CollectionsGrid from '@/components/homepage/CollectionsGrid'
import RecentActivityWidget from '@/components/homepage/RecentActivityWidget'
import GrowthInsightWidget from '@/components/homepage/GrowthInsightWidget'
import { useCollectionSummary } from '@/hooks/useCollectionSummary'
import { useCollections } from '@/hooks/useCollections'
import { useActivities } from '@/hooks/useActivities'
import { useGrowthStats } from '@/hooks/useGrowthStats'

export default function Home() {
  const { data: summary, isLoading: summaryLoading, error: summaryError, refetch } = useCollectionSummary()
  const { data: collections, isLoading: collectionsLoading, error: collectionsError } = useCollections()
  const { data: activities, isLoading: activitiesLoading, error: activitiesError } = useActivities(5)
  const { data: growthStats, isLoading: growthLoading, error: growthError } = useGrowthStats()

  return (
    <main style={{
      minHeight: '100vh',
      background: 'var(--surface)',
      padding: '2rem 1.5rem',
    }}>
      <div style={{
        maxWidth: '860px',
        margin: '0 auto',
      }}>

        {/* HeroCard */}
        <section style={{ marginBottom: '2.5rem' }}>
          <HeroCard
            summary={summary}
            isLoading={summaryLoading}
            error={summaryError as Error | null}
            onRetry={() => refetch()}
          />
        </section>

        {/* Collections Grid */}
        <section style={{ marginBottom: '2.5rem' }}>
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.25rem',
            fontWeight: '700',
            color: 'var(--on-surface)',
            margin: '0 0 1.25rem',
          }}>
            Mes Collections
          </h2>
          <CollectionsGrid
            collections={collections}
            isLoading={collectionsLoading}
            error={collectionsError as Error | null}
          />
        </section>

        {/* Dashboard Widgets */}
        <section>
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.25rem',
            fontWeight: '700',
            color: 'var(--on-surface)',
            margin: '0 0 1.25rem',
          }}>
            Tableau de bord
          </h2>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
            gap: '1.5rem',
          }}>
            <RecentActivityWidget
              feed={activities}
              isLoading={activitiesLoading}
              error={activitiesError as Error | null}
            />
            <GrowthInsightWidget
              stats={growthStats}
              isLoading={growthLoading}
              error={growthError as Error | null}
            />
          </div>
        </section>

      </div>
    </main>
  )
}
