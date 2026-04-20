'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'

const NAV_LINKS = [
  { href: '/', label: 'Accueil' },
  { href: '/cards', label: 'Cartes' },
  { href: '/test-backend', label: 'Test Backend' },
  { href: '/test', label: 'Test UI' },
]

export default function TopNav() {
  const pathname = usePathname()

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
      </div>
    </nav>
  )
}
