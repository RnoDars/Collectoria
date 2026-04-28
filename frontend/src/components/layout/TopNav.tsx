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
      <div className="topnav-container" style={{
        maxWidth: '100%',
        padding: '0 2rem',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'flex-end',
        height: '56px',
      }}>
        {/* Auth Actions */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          {mounted && isAuthenticated() ? (
            <>
              {/* User Email */}
              {userEmail && (
                <span className="topnav-email" style={{
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
                <span className="topnav-button-text-full">Se déconnecter</span>
                <span className="topnav-button-text-short">Déco</span>
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
