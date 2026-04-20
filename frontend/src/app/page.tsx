'use client'

import HeroCard from '@/components/homepage/HeroCard'
import CollectionsGrid from '@/components/homepage/CollectionsGrid'
import { useCollectionSummary } from '@/hooks/useCollectionSummary'
import { useCollections } from '@/hooks/useCollections'

export default function Home() {
  const { data: summary, isLoading: summaryLoading, error: summaryError, refetch } = useCollectionSummary()
  const { data: collections, isLoading: collectionsLoading, error: collectionsError } = useCollections()

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
        <section>
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.25rem',
            fontWeight: '700',
            color: 'var(--on-surface)',
            margin: 0,
            marginBottom: '1.25rem',
          }}>
            Mes Collections
          </h2>
          <CollectionsGrid
            collections={collections}
            isLoading={collectionsLoading}
            error={collectionsError as Error | null}
          />
        </section>

      </div>
    </main>
  )
}
