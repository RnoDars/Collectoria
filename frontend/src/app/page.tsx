'use client'

import CollectionsGrid from '@/components/homepage/CollectionsGrid'
import RecentActivityWidget from '@/components/homepage/RecentActivityWidget'
import { useCollections } from '@/hooks/useCollections'
import { useActivities } from '@/hooks/useActivities'
import ProtectedRoute from '@/components/auth/ProtectedRoute'

export default function Home() {
  const { data: collections, isLoading: collectionsLoading, error: collectionsError } = useCollections()
  const { data: activities, isLoading: activitiesLoading, error: activitiesError } = useActivities(5)

  return (
    <ProtectedRoute>
    <main style={{
      minHeight: '100vh',
      background: 'var(--surface)',
      padding: '1.5rem 1.25rem', // 24px 20px - Plus d'espace pour contenu
    }}>
      <div style={{
        maxWidth: '860px',
        margin: '0 auto',
      }}>

        {/* Collections Grid */}
        <section style={{ marginBottom: '1.75rem' }}> {/* 28px - Sections plus connectées */}
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.125rem', // 18px - Moins dominant
            fontWeight: '700',
            color: 'var(--on-surface)',
            margin: '0 0 1rem', // 0 0 16px
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
            fontSize: '1.125rem', // 18px - Moins dominant
            fontWeight: '700',
            color: 'var(--on-surface)',
            margin: '0 0 1rem', // 0 0 16px
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
    </ProtectedRoute>
  )
}
