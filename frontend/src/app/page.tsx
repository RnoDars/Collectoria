'use client'

import CollectionsGrid from '@/components/homepage/CollectionsGrid'
import RecentActivityWidget from '@/components/homepage/RecentActivityWidget'
import { useCollections } from '@/hooks/useCollections'
import { useActivities } from '@/hooks/useActivities'

export default function Home() {
  const { data: collections, isLoading: collectionsLoading, error: collectionsError } = useCollections()
  const { data: activities, isLoading: activitiesLoading, error: activitiesError } = useActivities(5)

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

        {/* Recent Activity */}
        <section>
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.25rem',
            fontWeight: '700',
            color: 'var(--on-surface)',
            margin: '0 0 1.25rem',
          }}>
            Activité Récente
          </h2>
          <RecentActivityWidget
            feed={activities}
            isLoading={activitiesLoading}
            error={activitiesError as Error | null}
          />
        </section>

      </div>
    </main>
  )
}
