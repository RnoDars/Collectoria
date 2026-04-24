'use client'

import { useState } from 'react'
import Link from 'next/link'
import CollectionsGrid from '@/components/homepage/CollectionsGrid'
import { useCollections } from '@/hooks/useCollections'

export default function TestPage() {
  const [inputValue, setInputValue] = useState('')
  const [displayValue, setDisplayValue] = useState('')
  const [history, setHistory] = useState<string[]>([])
  const { data: collectionsData, isLoading: collectionsLoading, error: collectionsError } = useCollections()

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
      padding: '2rem',
      background: '#f8f9fa',
    }}>
      <div style={{
        maxWidth: '800px',
        margin: '0 auto',
      }}>
        {/* Header */}
        <div style={{
          marginBottom: '3rem',
          textAlign: 'center',
        }}>
          <h1 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '2.5rem',
            fontWeight: '800',
            marginBottom: '0.5rem',
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            backgroundClip: 'text',
          }}>
            Page de Test - Collectoria
          </h1>
          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.95rem',
            color: '#43474e',
          }}>
            Page de test unifiée pour le développement et les tests d'intégration
          </p>
        </div>

        {/* Section 1: Status Backend */}
        <section style={{
          marginBottom: '3rem',
          background: '#ffffff',
          borderRadius: '12px',
          padding: '2rem',
          boxShadow: '0 4px 16px rgba(0,0,0,0.08)',
        }}>
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.5rem',
            fontWeight: '700',
            color: '#191c1d',
            marginBottom: '1.5rem',
          }}>
            Connexion Backend
          </h2>

          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            padding: '1rem',
            background: '#f8f9fa',
            borderRadius: '8px',
          }}>
            <div style={{
              width: '12px',
              height: '12px',
              borderRadius: '50%',
              background: collectionsLoading ? '#f59e0b' : collectionsError ? '#ef4444' : '#10b981',
              boxShadow: collectionsLoading ? '0 0 8px rgba(245, 158, 11, 0.5)' : collectionsError ? '0 0 8px rgba(239, 68, 68, 0.5)' : '0 0 8px rgba(16, 185, 129, 0.5)',
            }} />
            <div style={{ flex: 1 }}>
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
                {collectionsLoading ? 'Loading...' : collectionsError ? 'Connection failed' : 'Connected successfully'}
              </div>
            </div>
          </div>

          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.875rem',
            color: '#43474e',
            marginTop: '1rem',
          }}>
            API Endpoint: <code style={{
              background: '#e8e9ea',
              padding: '2px 6px',
              borderRadius: '4px',
              fontFamily: 'monospace',
              fontSize: '0.75rem',
            }}>http://localhost:8080/api/v1/collections</code>
          </p>
        </section>

        {/* Section 2: Backend Integration Tests */}
        <section style={{
          marginBottom: '3rem',
          background: '#ffffff',
          borderRadius: '12px',
          padding: '2rem',
          boxShadow: '0 4px 16px rgba(0,0,0,0.08)',
        }}>
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.5rem',
            fontWeight: '700',
            color: '#191c1d',
            marginBottom: '1rem',
          }}>
            Tests d'Integration Backend
          </h2>
          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.875rem',
            color: '#43474e',
            marginBottom: '1.5rem',
          }}>
            Test de la récupération des collections depuis l'API
          </p>
          <CollectionsGrid
            collections={collectionsData}
            isLoading={collectionsLoading}
            error={collectionsError as Error | null}
          />
        </section>

        {/* Section 3: UI Interactive Tests */}
        <section style={{
          marginBottom: '3rem',
          background: '#ffffff',
          borderRadius: '12px',
          padding: '2rem',
          boxShadow: '0 4px 16px rgba(0,0,0,0.08)',
        }}>
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.5rem',
            fontWeight: '700',
            color: '#191c1d',
            marginBottom: '1rem',
          }}>
            Tests UI Interactifs
          </h2>
          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: '0.875rem',
            color: '#43474e',
            marginBottom: '1.5rem',
          }}>
            Tests de formulaires, états React et interactions utilisateur
          </p>

          {/* Formulaire */}
          <form onSubmit={handleSubmit} style={{ marginBottom: '2rem' }}>
            <div style={{ marginBottom: '1rem' }}>
              <label
                htmlFor="testInput"
                style={{
                  display: 'block',
                  marginBottom: '0.5rem',
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: '600',
                  color: '#191c1d',
                  fontSize: '0.875rem',
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
                  fontFamily: 'Inter, sans-serif',
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
                fontFamily: 'Inter, sans-serif',
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
              <p style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.85rem',
                opacity: 0.9,
                marginBottom: '0.5rem',
              }}>
                Vous avez écrit :
              </p>
              <p style={{
                fontFamily: 'Manrope, sans-serif',
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
            }}>
              <div style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                marginBottom: '1rem',
              }}>
                <h3 style={{
                  fontFamily: 'Manrope, sans-serif',
                  fontSize: '1.1rem',
                  fontWeight: '600',
                  color: '#191c1d',
                }}>
                  Historique ({history.length})
                </h3>
                <button
                  onClick={clearHistory}
                  style={{
                    padding: '0.4rem 0.8rem',
                    fontFamily: 'Inter, sans-serif',
                    background: 'white',
                    border: '1px solid #ddd',
                    borderRadius: '6px',
                    fontSize: '0.85rem',
                    cursor: 'pointer',
                    color: '#43474e',
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
                      fontFamily: 'Inter, sans-serif',
                    }}>
                      {index + 1}
                    </span>
                    <span style={{
                      fontFamily: 'Inter, sans-serif',
                      color: '#191c1d',
                      flex: 1,
                    }}>{item}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}

          {/* Status UI Tests */}
          <div style={{
            padding: '1.5rem',
            background: '#e8f5e9',
            borderRadius: '12px',
            border: '2px solid #4caf50',
            marginTop: '2rem',
          }}>
            <div style={{ display: 'flex', gap: '0.75rem', alignItems: 'flex-start' }}>
              <span style={{ fontSize: '1.5rem' }}>✅</span>
              <div>
                <h4 style={{
                  fontFamily: 'Manrope, sans-serif',
                  color: '#2e7d32',
                  fontWeight: '600',
                  marginBottom: '0.5rem',
                }}>
                  Tests UI OK
                </h4>
                <ul style={{
                  fontFamily: 'Inter, sans-serif',
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
        </section>

        {/* Section 4: Debug Info */}
        <section style={{
          marginBottom: '3rem',
          background: '#ffffff',
          borderRadius: '12px',
          padding: '2rem',
          boxShadow: '0 4px 16px rgba(0,0,0,0.08)',
        }}>
          <h2 style={{
            fontFamily: 'Manrope, sans-serif',
            fontSize: '1.5rem',
            fontWeight: '700',
            color: '#191c1d',
            marginBottom: '1rem',
          }}>
            Debug Info
          </h2>
          <details>
            <summary style={{
              cursor: 'pointer',
              fontFamily: 'Inter, sans-serif',
              fontWeight: '600',
              color: '#43474e',
              fontSize: '0.875rem',
            }}>
              Afficher les données techniques
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
                collectionsData,
                collectionsLoading,
                collectionsError: collectionsError ? {
                  message: collectionsError.message,
                  name: collectionsError.name,
                } : null,
                apiUrl: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080',
                environment: {
                  nodeEnv: process.env.NODE_ENV,
                  nextVersion: '15.1.6',
                },
              }, null, 2)}
            </pre>
          </details>
        </section>

        {/* Navigation */}
        <div style={{
          textAlign: 'center',
        }}>
          <Link
            href="/"
            style={{
              display: 'inline-block',
              padding: '0.75rem 1.5rem',
              fontFamily: 'Inter, sans-serif',
              background: '#f0f0f0',
              color: '#43474e',
              borderRadius: '8px',
              fontWeight: '600',
              textDecoration: 'none',
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
            Retour à l'accueil
          </Link>
        </div>
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
