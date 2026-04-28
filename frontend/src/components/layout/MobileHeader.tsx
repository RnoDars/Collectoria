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
        height: '60px', // Augmenté de 56px
        background: 'rgba(255, 255, 255, 0.85)', // Semi-transparent - Cohérence avec nav
        backdropFilter: 'blur(16px)', // Glassmorphism
        WebkitBackdropFilter: 'blur(16px)', // Safari support
        boxShadow: '0 2px 12px rgba(25, 28, 29, 0.08)', // Plus prononcée
        zIndex: 100,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingLeft: '20px', // Augmenté de 16px pour cohérence avec page padding
        paddingRight: '20px',
      }}
    >
      {/* Logo */}
      <div
        style={{
          fontFamily: 'Manrope, sans-serif',
          fontSize: '1.375rem', // 22px - Plus présent
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
