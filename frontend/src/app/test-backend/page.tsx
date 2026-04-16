'use client'

import Link from 'next/link'
import HeroCard from '@/components/homepage/HeroCard'
import { useCollectionSummary } from '@/hooks/useCollectionSummary'

export default function TestBackendPage() {
  const { data, isLoading, error, refetch } = useCollectionSummary()

  return (
    <main style={{
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '2rem',
      background: '#f8f9fa',
    }}>
      <div style={{
        maxWidth: '800px',
        width: '100%',
      }}>
        {/* Header */}
        <div style={{
          marginBottom: '2rem',
        }}>
          <h1 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '2rem',
            fontWeight: '700',
            color: '#191c1d',
            marginBottom: '0.5rem',
          }}>
            Test Backend Integration
          </h1>
          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.875rem',
            color: '#43474e',
          }}>
            Testing connection to backend API at <code style={{
              background: '#e8e9ea',
              padding: '2px 6px',
              borderRadius: '4px',
              fontFamily: 'monospace',
            }}>http://localhost:8080/api/v1/collections/summary</code>
          </p>
        </div>

        {/* HeroCard Component */}
        <HeroCard
          summary={data}
          isLoading={isLoading}
          error={error as Error | null}
          onRetry={() => refetch()}
        />

        {/* Navigation */}
        <div style={{
          marginTop: '2rem',
          textAlign: 'center',
        }}>
          <Link href="/" style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.875rem',
            color: '#667eea',
            textDecoration: 'none',
            fontWeight: '600',
          }}>
            ← Retour à l'accueil
          </Link>
        </div>

        {/* Status Indicator */}
        <div style={{
          marginTop: '2rem',
          padding: '1rem',
          background: '#ffffff',
          borderRadius: '8px',
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
        }}>
          <div style={{
            width: '12px',
            height: '12px',
            borderRadius: '50%',
            background: isLoading ? '#f59e0b' : error ? '#ef4444' : '#10b981',
            boxShadow: isLoading ? '0 0 8px rgba(245, 158, 11, 0.5)' : error ? '0 0 8px rgba(239, 68, 68, 0.5)' : '0 0 8px rgba(16, 185, 129, 0.5)',
          }} />
          <div>
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: '0.75rem',
              fontWeight: '600',
              color: '#191c1d',
              textTransform: 'uppercase',
              letterSpacing: '0.05em',
            }}>
              Backend Status
            </div>
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: '0.875rem',
              color: '#43474e',
            }}>
              {isLoading ? 'Loading...' : error ? 'Connection failed' : 'Connected successfully'}
            </div>
          </div>
        </div>

        {/* Debug Info */}
        <details style={{
          marginTop: '2rem',
          padding: '1rem',
          background: '#ffffff',
          borderRadius: '8px',
        }}>
          <summary style={{
            cursor: 'pointer',
            fontFamily: 'Inter, sans-serif',
            fontWeight: '600',
            color: '#191c1d',
            fontSize: '0.875rem',
          }}>
            🔍 Debug Info
          </summary>
          <pre style={{
            marginTop: '1rem',
            fontSize: '0.75rem',
            overflow: 'auto',
            background: '#f8f9fa',
            padding: '1rem',
            borderRadius: '8px',
            fontFamily: 'monospace',
            color: '#43474e',
          }}>
            {JSON.stringify({
              data,
              isLoading,
              error: error ? {
                message: error.message,
                name: error.name,
              } : null,
              apiUrl: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080',
            }, null, 2)}
          </pre>
        </details>

        {/* Instructions */}
        <div style={{
          marginTop: '2rem',
          padding: '1.5rem',
          background: '#ffffff',
          borderRadius: '8px',
          border: '1px solid #e8e9ea',
        }}>
          <h3 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1rem',
            fontWeight: '600',
            color: '#191c1d',
            marginBottom: '1rem',
          }}>
            📋 Testing Instructions
          </h3>
          <ol style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.875rem',
            color: '#43474e',
            lineHeight: '1.6',
            paddingLeft: '1.5rem',
            margin: 0,
          }}>
            <li style={{ marginBottom: '0.5rem' }}>
              Make sure the backend is running on <code style={{
                background: '#f8f9fa',
                padding: '2px 6px',
                borderRadius: '4px',
                fontFamily: 'monospace',
                fontSize: '0.75rem',
              }}>http://localhost:8080</code>
            </li>
            <li style={{ marginBottom: '0.5rem' }}>
              Check the Backend Status indicator above (should be green)
            </li>
            <li style={{ marginBottom: '0.5rem' }}>
              The HeroCard should display: <strong>24/40 cards = 60% completion</strong>
            </li>
            <li style={{ marginBottom: '0.5rem' }}>
              If you see an error, click the "Retry" button to try again
            </li>
            <li>
              Open the Debug Info to see the raw API response
            </li>
          </ol>
        </div>
      </div>
    </main>
  )
}
