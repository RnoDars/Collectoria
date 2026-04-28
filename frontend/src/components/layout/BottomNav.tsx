'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'

const NAV_LINKS = [
  { href: '/', label: 'Accueil', icon: '🏠' },
  { href: '/cards', label: 'MECCG', icon: '🎴' },
  { href: '/books', label: 'Royaumes', icon: '📚' },
  { href: '/dnd5', label: 'D&D 5e', icon: '🎲' },
]

export default function BottomNav() {
  const pathname = usePathname()

  return (
    <nav
      className="bottom-nav-mobile"
      style={{
        position: 'fixed',
        bottom: 0,
        left: 0,
        right: 0,
        height: '64px',
        background: 'var(--surface-container-lowest)',
        boxShadow: '0 -4px 16px rgba(25, 28, 29, 0.06)',
        zIndex: 100,
        justifyContent: 'space-around',
        alignItems: 'center',
      }}
    >
      {NAV_LINKS.map(({ href, label, icon }) => {
        const active = pathname === href
        return (
          <Link
            key={href}
            href={href}
            style={{
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '2px',
              fontFamily: 'Inter, sans-serif',
              fontSize: '0.625rem',
              fontWeight: active ? '600' : '500',
              color: active ? '#667eea' : 'var(--on-surface-variant)',
              padding: '8px 4px',
              textDecoration: 'none',
              transition: 'all 0.15s ease-in-out',
              flex: 1,
              textAlign: 'center',
            }}
          >
            <span style={{
              fontSize: '1.5rem',
              lineHeight: 1,
            }}>
              {icon}
            </span>
            <span>{label}</span>
          </Link>
        )
      })}
    </nav>
  )
}
