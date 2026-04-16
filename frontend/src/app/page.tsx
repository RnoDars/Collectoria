'use client'

import Link from 'next/link'

export default function Home() {
  return (
    <main style={{
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '2rem',
    }}>
      <div style={{
        background: 'white',
        borderRadius: '16px',
        padding: '3rem',
        maxWidth: '600px',
        width: '100%',
        boxShadow: '0 20px 60px rgba(0,0,0,0.3)',
      }}>
        <h1 style={{
          fontSize: '2.5rem',
          fontWeight: 'bold',
          marginBottom: '1rem',
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          backgroundClip: 'text',
        }}>
          Collectoria
        </h1>

        <p style={{
          fontSize: '1.1rem',
          color: '#666',
          marginBottom: '2rem',
        }}>
          Bienvenue sur votre gestionnaire de collections personnel
        </p>

        <div style={{
          display: 'grid',
          gap: '1rem',
          marginBottom: '2rem',
        }}>
          <Link
            href="/test-backend"
            style={{
              padding: '1rem 1.5rem',
              background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              color: 'white',
              borderRadius: '8px',
              fontWeight: '600',
              textAlign: 'center',
              transition: 'transform 0.2s',
            }}
            onMouseEnter={(e) => e.currentTarget.style.transform = 'scale(1.05)'}
            onMouseLeave={(e) => e.currentTarget.style.transform = 'scale(1)'}
          >
            🚀 Test Backend Integration (HeroCard)
          </Link>

          <Link
            href="/test"
            style={{
              padding: '1rem 1.5rem',
              background: '#e8e9ea',
              color: '#667eea',
              borderRadius: '8px',
              fontWeight: '600',
              textAlign: 'center',
              transition: 'all 0.2s',
              border: '2px solid #e1e3e4',
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.background = '#e1e3e4'
              e.currentTarget.style.transform = 'scale(1.02)'
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.background = '#e8e9ea'
              e.currentTarget.style.transform = 'scale(1)'
            }}
          >
            🧪 Page de Test Interactive
          </Link>

          <Link
            href="/test"
            style={{
              padding: '1rem 1.5rem',
              background: '#f0f0f0',
              color: '#666',
              borderRadius: '8px',
              fontWeight: '600',
              textAlign: 'center',
              transition: 'all 0.2s',
              border: '2px solid #e0e0e0',
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.background = '#e0e0e0'
              e.currentTarget.style.transform = 'scale(1.02)'
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.background = '#f0f0f0'
              e.currentTarget.style.transform = 'scale(1)'
            }}
          >
            📚 Mes Collections (En construction)
          </Link>

          <Link
            href="/test"
            style={{
              padding: '1rem 1.5rem',
              background: '#f0f0f0',
              color: '#666',
              borderRadius: '8px',
              fontWeight: '600',
              textAlign: 'center',
              transition: 'all 0.2s',
              border: '2px solid #e0e0e0',
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.background = '#e0e0e0'
              e.currentTarget.style.transform = 'scale(1.02)'
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.background = '#f0f0f0'
              e.currentTarget.style.transform = 'scale(1)'
            }}
          >
            🎯 Statistiques (En construction)
          </Link>
        </div>

        <div style={{
          padding: '1rem',
          background: '#f8f9fa',
          borderRadius: '8px',
          fontSize: '0.9rem',
          color: '#666',
        }}>
          <strong>ℹ️ Test de Déploiement Local</strong>
          <p style={{ marginTop: '0.5rem' }}>
            Cette page teste le bon fonctionnement de Next.js.
            Les liens grisés mènent vers la page de test interactive.
          </p>
        </div>
      </div>

      <p style={{
        marginTop: '2rem',
        color: 'white',
        fontSize: '0.9rem',
        opacity: 0.8,
      }}>
        Collectoria v0.1.0 - MVP en développement
      </p>
    </main>
  )
}
