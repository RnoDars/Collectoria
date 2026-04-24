'use client'

import { useEffect, useRef } from 'react'
import { Book } from '@/lib/api/books'

export interface BookConfirmModalProps {
  book: Book
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

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm animate-fadeIn"
      onClick={handleBackdropClick}
      role="dialog"
      aria-modal="true"
      aria-labelledby={titleId}
    >
      <div
        ref={modalRef}
        className="bg-[var(--surface-1)] rounded-3xl p-8 max-w-md w-full mx-4 shadow-2xl animate-scaleIn"
        style={{
          animation: 'scaleIn 0.2s ease-out',
        }}
      >
        {/* Header */}
        <div className="mb-6">
          <h2
            id={titleId}
            className="text-2xl font-semibold mb-2"
            style={{ fontFamily: 'Manrope, sans-serif' }}
          >
            Confirmer l'action
          </h2>
          <p className="text-[var(--text-secondary)]" style={{ fontFamily: 'Inter, sans-serif' }}>
            {message}
          </p>
        </div>

        {/* Book Info */}
        <div
          className="bg-[var(--surface-0)] rounded-2xl p-6 mb-6"
          style={{
            border: 'none',
          }}
        >
          <div className="mb-2">
            <div
              className="text-sm text-[var(--text-tertiary)] mb-1"
              style={{ fontFamily: 'Inter, sans-serif' }}
            >
              Titre
            </div>
            <div
              className="font-medium text-[var(--text-primary)]"
              style={{ fontFamily: 'Manrope, sans-serif' }}
            >
              {displayTitle}
            </div>
          </div>

          {displayAuthor && (
            <div>
              <div
                className="text-sm text-[var(--text-tertiary)] mb-1"
                style={{ fontFamily: 'Inter, sans-serif' }}
              >
                Auteur
              </div>
              <div
                className="text-[var(--text-secondary)]"
                style={{ fontFamily: 'Inter, sans-serif' }}
              >
                {displayAuthor}
              </div>
            </div>
          )}
        </div>

        {/* Actions */}
        <div className="flex gap-3">
          <button
            onClick={onCancel}
            className="flex-1 px-6 py-3 rounded-xl font-medium transition-all hover:bg-[var(--surface-2)]"
            style={{
              fontFamily: 'Inter, sans-serif',
              border: 'none',
              backgroundColor: 'var(--surface-2)',
            }}
          >
            Annuler
          </button>
          <button
            onClick={onConfirm}
            className="flex-1 px-6 py-3 rounded-xl font-medium text-white transition-all hover:opacity-90"
            style={{
              fontFamily: 'Inter, sans-serif',
              border: 'none',
              background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              boxShadow: '0 4px 12px rgba(102, 126, 234, 0.3)',
            }}
          >
            Confirmer
          </button>
        </div>
      </div>

      <style jsx>{`
        @keyframes fadeIn {
          from {
            opacity: 0;
          }
          to {
            opacity: 1;
          }
        }

        @keyframes scaleIn {
          from {
            opacity: 0;
            transform: scale(0.95);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }

        .animate-fadeIn {
          animation: fadeIn 0.2s ease-out;
        }

        .animate-scaleIn {
          animation: scaleIn 0.2s ease-out;
        }
      `}</style>
    </div>
  )
}
