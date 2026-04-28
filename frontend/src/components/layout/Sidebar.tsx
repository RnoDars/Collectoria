'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'

const NAV_LINKS = [
  { href: '/', label: 'Accueil', icon: '🏠' },
  { href: '/cards', label: 'MECCG', icon: '🎴' },
  { href: '/books', label: 'Royaumes Oubliés', icon: '📚' },
  { href: '/dnd5', label: 'D&D 5e', icon: '🎲' },
]

export default function Sidebar() {
  const pathname = usePathname()

  return (
    <aside className="sidebar-desktop" style={{
      position: 'fixed',
      left: 0,
      top: 0,
      height: '100vh',
      width: '240px',
      background: 'var(--surface-container-lowest)',
      boxShadow: '4px 0 16px rgba(25, 28, 29, 0.06)',
      padding: '24px 16px',
      display: 'flex',
      flexDirection: 'column',
      gap: '8px',
      zIndex: 100,
    }}>
      {/* Logo Section */}
      <div style={{
        marginBottom: '32px',
        paddingLeft: '12px',
      }}>
        <span style={{
          fontFamily: 'Manrope, sans-serif',
          fontWeight: '800',
          fontSize: '1.25rem',
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          backgroundClip: 'text',
        }}>
          Collectoria
        </span>
      </div>

      {/* Navigation Links */}
      <nav style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '4px',
      }}>
        {NAV_LINKS.map(({ href, label, icon }) => {
          const active = pathname === href
          return (
            <Link
              key={href}
              href={href}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.875rem',
                fontWeight: active ? '600' : '500',
                color: active ? '#667eea' : 'var(--on-surface-variant)',
                padding: '12px 16px',
                borderRadius: '16px',
                background: active ? 'rgba(102, 126, 234, 0.08)' : 'transparent',
                textDecoration: 'none',
                transition: 'all 0.15s ease-in-out',
              }}
              onMouseEnter={(e) => {
                if (!active) {
                  e.currentTarget.style.background = 'var(--surface-container-low)'
                }
              }}
              onMouseLeave={(e) => {
                if (!active) {
                  e.currentTarget.style.background = 'transparent'
                }
              }}
            >
              <span style={{
                fontSize: '1.25rem',
                lineHeight: 1,
              }}>
                {icon}
              </span>
              <span>{label}</span>
            </Link>
          )
        })}
      </nav>
    </aside>
  )
}
