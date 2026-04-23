'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useAuth } from '@/hooks/useAuth'
import { getUserEmail } from '@/lib/auth'
import { useEffect, useState } from 'react'

const NAV_LINKS = [
  { href: '/', label: 'Accueil' },
  { href: '/cards', label: 'Cartes' },
  { href: '/books', label: 'Livres' },
  { href: '/test-backend', label: 'Test Backend' },
  { href: '/test', label: 'Test UI' },
]

export default function TopNav() {
  const pathname = usePathname()
  const { isAuthenticated, logout } = useAuth()
  const [userEmail, setUserEmail] = useState<string | null>(null)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  useEffect(() => {
    if (!mounted) return
    if (isAuthenticated()) {
      setUserEmail(getUserEmail())
    } else {
      setUserEmail(null)
    }
  }, [pathname, mounted])

  return (
    <nav style={{
      background: 'var(--surface-container-lowest)',
      boxShadow: '0px 4px 16px rgba(25, 28, 29, 0.06)',
      position: 'sticky',
      top: 0,
      zIndex: 100,
    }}>
      <div style={{
        maxWidth: '860px',
        margin: '0 auto',
        padding: '0 1.5rem',
        display: 'flex',
        alignItems: 'center',
        gap: '2rem',
        height: '56px',
      }}>
        <span style={{
          fontFamily: 'Manrope, sans-serif',
          fontWeight: '800',
          fontSize: '1rem',
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          backgroundClip: 'text',
        }}>
          Collectoria
        </span>

        <div style={{ display: 'flex', gap: '0.25rem', flex: 1 }}>
          {NAV_LINKS.map(({ href, label }) => {
            const active = pathname === href
            return (
              <Link
                key={href}
                href={href}
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: '0.875rem',
                  fontWeight: active ? '600' : '500',
                  color: active ? '#667eea' : 'var(--on-surface-variant)',
                  padding: '0.375rem 0.75rem',
                  borderRadius: '8px',
                  background: active ? 'rgba(102, 126, 234, 0.08)' : 'transparent',
                  textDecoration: 'none',
                  transition: 'all 0.15s',
                }}
              >
                {label}
              </Link>
            )
          })}
        </div>

        {/* Auth Actions */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          {mounted && isAuthenticated() ? (
            <>
              {/* User Email */}
              {userEmail && (
                <span style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: '0.875rem',
                  fontWeight: '500',
                  color: 'var(--on-surface)',
                }}>
                  {userEmail}
                </span>
              )}

              {/* Logout Button */}
              <button
                onClick={logout}
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: '0.875rem',
                  fontWeight: '500',
                  color: 'var(--on-surface-variant)',
                  padding: '0.375rem 0.75rem',
                  borderRadius: '8px',
                  background: 'transparent',
                  border: '1px solid var(--outline-variant)',
                  cursor: 'pointer',
                  transition: 'all 0.15s',
                }}
              >
                Se déconnecter
              </button>
            </>
          ) : (
            <Link
              href="/login"
              style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.875rem',
                fontWeight: '600',
                color: 'white',
                padding: '0.375rem 0.875rem',
                borderRadius: '8px',
                background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                textDecoration: 'none',
                transition: 'all 0.15s',
              }}
            >
              Se connecter
            </Link>
          )}
        </div>
      </div>
    </nav>
  )
}
