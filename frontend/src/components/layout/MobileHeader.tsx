'use client'

export default function MobileHeader() {
  return (
    <header
      className="mobile-header"
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        width: '100%',
        height: '56px',
        background: 'var(--surface-container-lowest)',
        boxShadow: '0 2px 8px rgba(25, 28, 29, 0.06)',
        zIndex: 100,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingLeft: '16px',
        paddingRight: '16px',
      }}
    >
      {/* Logo */}
      <div
        style={{
          fontFamily: 'Manrope, sans-serif',
          fontSize: '1.25rem',
          fontWeight: 800,
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          backgroundClip: 'text',
        }}
      >
        Collectoria
      </div>

      {/* Future: Icône menu/recherche à droite */}
    </header>
  )
}
