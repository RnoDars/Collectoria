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
        height: '72px', // Augmenté de 64px - Plus confortable
        background: 'rgba(255, 255, 255, 0.85)', // Semi-transparent
        backdropFilter: 'blur(16px)', // Glassmorphism
        WebkitBackdropFilter: 'blur(16px)', // Safari support
        boxShadow: '0 -6px 20px rgba(25, 28, 29, 0.10)', // Plus prononcée
        zIndex: 100,
        display: 'flex', // Ajouté pour cohérence
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
              gap: '4px', // Augmenté de 2px pour accommoder background
              fontFamily: 'Inter, sans-serif',
              fontSize: '0.6875rem', // 11px - Plus lisible
              fontWeight: active ? '600' : '500',
              color: active ? '#667eea' : '#5f6368', // Couleur inactive plus claire
              padding: active ? '8px 12px' : '8px 4px', // Padding accru pour état actif
              textDecoration: 'none',
              transition: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)', // Transition plus smooth
              flex: 1,
              textAlign: 'center',
              background: active ? 'rgba(102, 126, 234, 0.08)' : 'transparent', // Background pill
              borderRadius: '16px', // Forme pill
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
