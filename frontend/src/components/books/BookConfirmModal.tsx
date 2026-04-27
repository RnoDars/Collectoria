'use client'

import { useEffect, useRef } from 'react'
import { ForgottenRealmsNovel } from '@/lib/api/forgottenrealms'

export interface BookConfirmModalProps {
  book: ForgottenRealmsNovel
  newState: boolean
  isOpen: boolean
  onConfirm: () => void
  onCancel: () => void
}

export default function BookConfirmModal({
  book,
  newState,
  isOpen,
  onConfirm,
  onCancel,
}: BookConfirmModalProps) {
  const modalRef = useRef<HTMLDivElement>(null)
  const titleId = 'book-modal-title'

  // Handle Escape key
  useEffect(() => {
    if (!isOpen) return

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        onCancel()
      }
    }

    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [isOpen, onCancel])

  // Focus trap
  useEffect(() => {
    if (!isOpen || !modalRef.current) return

    const focusableElements = modalRef.current.querySelectorAll<HTMLElement>(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )

    const firstElement = focusableElements[0]
    const lastElement = focusableElements[focusableElements.length - 1]

    const handleTab = (e: KeyboardEvent) => {
      if (e.key !== 'Tab') return

      if (e.shiftKey) {
        if (document.activeElement === firstElement) {
          e.preventDefault()
          lastElement?.focus()
        }
      } else {
        if (document.activeElement === lastElement) {
          e.preventDefault()
          firstElement?.focus()
        }
      }
    }

    // Focus first button on open
    firstElement?.focus()

    document.addEventListener('keydown', handleTab)
    return () => document.removeEventListener('keydown', handleTab)
  }, [isOpen])

  // Lock body scroll when modal is open
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }

    return () => {
      document.body.style.overflow = ''
    }
  }, [isOpen])

  if (!isOpen) return null

  const handleBackdropClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget) {
      onCancel()
    }
  }

  const message = newState
    ? 'Voulez-vous ajouter ce livre à votre collection ?'
    : 'Voulez-vous retirer ce livre de votre collection ?'

  const displayTitle = book.title
  const displayAuthor = book.author

  // ─── Styles ───────────────────────────────────────────────────────────────────

  const backdropStyle: React.CSSProperties = {
    position: 'fixed',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    background: 'rgba(25, 28, 29, 0.6)',
    backdropFilter: 'blur(4px)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 1000,
    animation: 'fadeIn 0.2s ease-out',
  }

  const modalStyle: React.CSSProperties = {
    background: 'var(--surface-container-lowest)',
    borderRadius: '16px',
    maxWidth: '480px',
    width: '90%',
    boxShadow: '0 12px 32px rgba(25, 28, 29, 0.15)',
    animation: 'slideUp 0.3s ease-out',
  }

  const headerStyle: React.CSSProperties = {
    padding: '1.5rem',
    background: 'var(--surface-container-low)',
    borderRadius: '16px 16px 0 0',
  }

  const titleStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '700',
    fontSize: '1.25rem',
    color: 'var(--on-surface)',
    margin: 0,
  }

  const contentStyle: React.CSSProperties = {
    padding: '1.5rem',
  }

  const bookInfoContainerStyle: React.CSSProperties = {
    display: 'flex',
    alignItems: 'flex-start',
    gap: '0.75rem',
    marginBottom: '1.25rem',
    padding: '1rem',
    background: 'var(--surface-container-low)',
    borderRadius: '12px',
  }

  const iconStyle: React.CSSProperties = {
    fontSize: '1.5rem',
    lineHeight: 1,
    flexShrink: 0,
  }

  const bookDetailsStyle: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    gap: '0.25rem',
  }

  const titleTextStyle: React.CSSProperties = {
    fontFamily: 'Manrope, sans-serif',
    fontWeight: '700',
    fontSize: '1rem',
    color: 'var(--on-surface)',
    lineHeight: '1.4',
  }

  const authorStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem',
    color: 'var(--on-surface-variant)',
    lineHeight: '1.4',
  }

  const messageStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.9375rem',
    color: 'var(--on-surface)',
    lineHeight: '1.6',
    marginBottom: '1.5rem',
  }

  const actionsStyle: React.CSSProperties = {
    display: 'flex',
    gap: '0.75rem',
    justifyContent: 'flex-end',
  }

  const buttonBaseStyle: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.9375rem',
    fontWeight: '600',
    padding: '0.75rem 1.5rem',
    borderRadius: '12px',
    border: 'none',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
  }

  const cancelButtonStyle: React.CSSProperties = {
    ...buttonBaseStyle,
    background: 'var(--surface-container-high)',
    color: 'var(--on-surface)',
  }

  const confirmButtonStyle: React.CSSProperties = {
    ...buttonBaseStyle,
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: '#ffffff',
    boxShadow: '0 4px 12px rgba(102, 126, 234, 0.3)',
  }

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes slideUp {
          from {
            opacity: 0;
            transform: translateY(20px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        button:hover {
          filter: brightness(0.95);
        }
        button:active {
          transform: scale(0.98);
        }
      `}</style>

      <div
        data-testid="modal-backdrop"
        style={backdropStyle}
        onClick={handleBackdropClick}
      >
        <div
          ref={modalRef}
          role="dialog"
          aria-modal="true"
          aria-labelledby={titleId}
          style={modalStyle}
          onClick={(e) => e.stopPropagation()}
        >
          {/* Header */}
          <div style={headerStyle}>
            <h2 id={titleId} style={titleStyle}>
              Confirmer l&apos;action
            </h2>
          </div>

          {/* Content */}
          <div style={contentStyle}>
            {/* Book Info */}
            <div style={bookInfoContainerStyle}>
              <span style={iconStyle}>📚</span>
              <div style={bookDetailsStyle}>
                {displayTitle && <div style={titleTextStyle}>{displayTitle}</div>}
                {displayAuthor && <div style={authorStyle}>{displayAuthor}</div>}
              </div>
            </div>

            {/* Message */}
            <p style={messageStyle}>{message}</p>

            {/* Actions */}
            <div style={actionsStyle}>
              <button
                onClick={onCancel}
                style={cancelButtonStyle}
                aria-label="Annuler l'ajout du livre"
              >
                Annuler
              </button>
              <button
                onClick={onConfirm}
                style={confirmButtonStyle}
                aria-label="Confirmer l'action sur le livre"
              >
                ✓ Confirmer
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}
