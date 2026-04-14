'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function TestPage() {
  const [inputValue, setInputValue] = useState('')
  const [displayValue, setDisplayValue] = useState('')
  const [history, setHistory] = useState<string[]>([])

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (inputValue.trim()) {
      setDisplayValue(inputValue)
      setHistory(prev => [...prev, inputValue])
      setInputValue('')
    }
  }

  const clearHistory = () => {
    setHistory([])
    setDisplayValue('')
  }

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
        maxWidth: '700px',
        width: '100%',
        boxShadow: '0 20px 60px rgba(0,0,0,0.3)',
      }}>
        {/* Header */}
        <div style={{ marginBottom: '2rem' }}>
          <h1 style={{
            fontSize: '2rem',
            fontWeight: 'bold',
            marginBottom: '0.5rem',
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            backgroundClip: 'text',
          }}>
            🧪 Page de Test Interactive
          </h1>
          <p style={{ color: '#666', fontSize: '0.95rem' }}>
            Testez le bon fonctionnement du déploiement local
          </p>
        </div>

        {/* Formulaire */}
        <form onSubmit={handleSubmit} style={{ marginBottom: '2rem' }}>
          <div style={{ marginBottom: '1rem' }}>
            <label
              htmlFor="testInput"
              style={{
                display: 'block',
                marginBottom: '0.5rem',
                fontWeight: '600',
                color: '#333',
              }}
            >
              Entrez du texte :
            </label>
            <input
              id="testInput"
              type="text"
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              placeholder="Tapez quelque chose..."
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                fontSize: '1rem',
                border: '2px solid #e0e0e0',
                borderRadius: '8px',
                outline: 'none',
                transition: 'border-color 0.2s',
              }}
              onFocus={(e) => e.currentTarget.style.borderColor = '#667eea'}
              onBlur={(e) => e.currentTarget.style.borderColor = '#e0e0e0'}
            />
          </div>

          <button
            type="submit"
            style={{
              width: '100%',
              padding: '0.75rem 1.5rem',
              background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              color: 'white',
              border: 'none',
              borderRadius: '8px',
              fontSize: '1rem',
              fontWeight: '600',
              cursor: 'pointer',
              transition: 'transform 0.2s',
            }}
            onMouseEnter={(e) => e.currentTarget.style.transform = 'scale(1.02)'}
            onMouseLeave={(e) => e.currentTarget.style.transform = 'scale(1)'}
          >
            Afficher le texte
          </button>
        </form>

        {/* Affichage de la valeur actuelle */}
        {displayValue && (
          <div style={{
            padding: '1.5rem',
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            color: 'white',
            borderRadius: '12px',
            marginBottom: '2rem',
            animation: 'fadeIn 0.3s ease-in',
          }}>
            <p style={{ fontSize: '0.85rem', opacity: 0.9, marginBottom: '0.5rem' }}>
              Vous avez écrit :
            </p>
            <p style={{
              fontSize: '1.3rem',
              fontWeight: 'bold',
              wordBreak: 'break-word',
            }}>
              "{displayValue}"
            </p>
          </div>
        )}

        {/* Historique */}
        {history.length > 0 && (
          <div style={{
            padding: '1.5rem',
            background: '#f8f9fa',
            borderRadius: '12px',
            marginBottom: '2rem',
          }}>
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              marginBottom: '1rem',
            }}>
              <h3 style={{
                fontSize: '1.1rem',
                fontWeight: '600',
                color: '#333',
              }}>
                Historique ({history.length})
              </h3>
              <button
                onClick={clearHistory}
                style={{
                  padding: '0.4rem 0.8rem',
                  background: 'white',
                  border: '1px solid #ddd',
                  borderRadius: '6px',
                  fontSize: '0.85rem',
                  cursor: 'pointer',
                  color: '#666',
                }}
                onMouseEnter={(e) => e.currentTarget.style.background = '#f0f0f0'}
                onMouseLeave={(e) => e.currentTarget.style.background = 'white'}
              >
                Effacer
              </button>
            </div>
            <ul style={{ listStyle: 'none' }}>
              {history.map((item, index) => (
                <li
                  key={index}
                  style={{
                    padding: '0.75rem',
                    background: 'white',
                    borderRadius: '8px',
                    marginBottom: '0.5rem',
                    border: '1px solid #e0e0e0',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '0.75rem',
                  }}
                >
                  <span style={{
                    display: 'inline-flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    width: '24px',
                    height: '24px',
                    background: '#667eea',
                    color: 'white',
                    borderRadius: '50%',
                    fontSize: '0.75rem',
                    fontWeight: 'bold',
                  }}>
                    {index + 1}
                  </span>
                  <span style={{ color: '#333', flex: 1 }}>{item}</span>
                </li>
              ))}
            </ul>
          </div>
        )}

        {/* Info technique */}
        <div style={{
          padding: '1.5rem',
          background: '#e8f5e9',
          borderRadius: '12px',
          border: '2px solid #4caf50',
          marginBottom: '1.5rem',
        }}>
          <div style={{ display: 'flex', gap: '0.75rem', alignItems: 'flex-start' }}>
            <span style={{ fontSize: '1.5rem' }}>✅</span>
            <div>
              <h4 style={{ color: '#2e7d32', fontWeight: '600', marginBottom: '0.5rem' }}>
                Test Réussi !
              </h4>
              <ul style={{
                color: '#1b5e20',
                fontSize: '0.9rem',
                lineHeight: '1.6',
                listStyle: 'none',
              }}>
                <li>✓ Next.js fonctionne correctement</li>
                <li>✓ React State Management OK</li>
                <li>✓ Formulaires interactifs OK</li>
                <li>✓ Client-side rendering OK</li>
                <li>✓ CSS-in-JS OK</li>
              </ul>
            </div>
          </div>
        </div>

        {/* Bouton retour */}
        <Link
          href="/"
          style={{
            display: 'block',
            textAlign: 'center',
            padding: '0.75rem',
            background: '#f0f0f0',
            color: '#666',
            borderRadius: '8px',
            fontWeight: '600',
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
          ← Retour à l'accueil
        </Link>
      </div>

      {/* Footer */}
      <div style={{
        marginTop: '2rem',
        color: 'white',
        textAlign: 'center',
        fontSize: '0.9rem',
        opacity: 0.8,
      }}>
        <p>Page de test - Collectoria v0.1.0</p>
        <p style={{ fontSize: '0.8rem', marginTop: '0.5rem' }}>
          Cette page sert de destination pour tous les liens non implémentés
        </p>
      </div>

      {/* Animation CSS */}
      <style jsx>{`
        @keyframes fadeIn {
          from {
            opacity: 0;
            transform: translateY(-10px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
      `}</style>
    </main>
  )
}
