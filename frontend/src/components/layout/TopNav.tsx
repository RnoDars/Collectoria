'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useAuth } from '@/hooks/useAuth'
import { getUserEmail } from '@/lib/auth'
import { useEffect, useState } from 'react'

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
        maxWidth: '100%',
        padding: '0 2rem',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        height: '56px',
      }}>
        {/* Logo - Visible uniquement pour cohérence, mais la sidebar a aussi le logo */}
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
                  border: '1px solid rgba(25, 28, 29, 0.12)',
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
