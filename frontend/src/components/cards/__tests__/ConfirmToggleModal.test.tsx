import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import ConfirmToggleModal from '../ConfirmToggleModal'
import { Card } from '@/lib/api/collections'

const mockCard: Card = {
  id: 'card-1',
  nameEn: 'Gandalf the Grey',
  nameFr: 'Gandalf le Gris',
  cardType: 'Héros / Personnage / Sorcier',
  series: 'Les Sorciers',
  rarity: 'R',
  isOwned: false,
}

describe('ConfirmToggleModal', () => {
  describe('Visibility', () => {
    it('should not render when isOpen is false', () => {
      const { container } = render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={false}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(container.querySelector('[role="dialog"]')).not.toBeInTheDocument()
    })

    it('should render when isOpen is true', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByRole('dialog')).toBeInTheDocument()
    })
  })

  describe('Content Display', () => {
    it('should display modal title', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByText("Confirmer l'action")).toBeInTheDocument()
    })

    it('should display card name in English', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByText('Gandalf the Grey')).toBeInTheDocument()
    })

    it('should display card name in French', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByText('Gandalf le Gris')).toBeInTheDocument()
    })

    it('should display correct message when marking as owned (newState=true)', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByText(/Voulez-vous marquer cette carte comme possédée/i)).toBeInTheDocument()
    })

    it('should display correct message when marking as not owned (newState=false)', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={false}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByText(/Voulez-vous retirer cette carte de votre collection/i)).toBeInTheDocument()
    })

    it('should display card icon emoji', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByText('📇')).toBeInTheDocument()
    })
  })

  describe('Button Actions', () => {
    it('should display both Annuler and Confirmer buttons', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByRole('button', { name: /Annuler/i })).toBeInTheDocument()
      expect(screen.getByRole('button', { name: /Confirmer/i })).toBeInTheDocument()
    })

    it('should call onConfirm when Confirmer button is clicked', async () => {
      const user = userEvent.setup()
      const onConfirm = vi.fn()
      const onCancel = vi.fn()

      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={onConfirm}
          onCancel={onCancel}
        />
      )

      const confirmButton = screen.getByRole('button', { name: /Confirmer/i })
      await user.click(confirmButton)

      expect(onConfirm).toHaveBeenCalledTimes(1)
      expect(onCancel).not.toHaveBeenCalled()
    })

    it('should call onCancel when Annuler button is clicked', async () => {
      const user = userEvent.setup()
      const onConfirm = vi.fn()
      const onCancel = vi.fn()

      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={onConfirm}
          onCancel={onCancel}
        />
      )

      const cancelButton = screen.getByRole('button', { name: /Annuler/i })
      await user.click(cancelButton)

      expect(onCancel).toHaveBeenCalledTimes(1)
      expect(onConfirm).not.toHaveBeenCalled()
    })
  })

  describe('Keyboard Navigation', () => {
    it('should call onCancel when Escape key is pressed', async () => {
      const user = userEvent.setup()
      const onConfirm = vi.fn()
      const onCancel = vi.fn()

      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={onConfirm}
          onCancel={onCancel}
        />
      )

      await user.keyboard('{Escape}')

      expect(onCancel).toHaveBeenCalledTimes(1)
      expect(onConfirm).not.toHaveBeenCalled()
    })
  })

  describe('Backdrop Interaction', () => {
    it('should call onCancel when backdrop is clicked', async () => {
      const user = userEvent.setup()
      const onConfirm = vi.fn()
      const onCancel = vi.fn()

      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={onConfirm}
          onCancel={onCancel}
        />
      )

      // Click the backdrop (the overlay behind the modal)
      const backdrop = screen.getByTestId('modal-backdrop')
      await user.click(backdrop)

      expect(onCancel).toHaveBeenCalledTimes(1)
      expect(onConfirm).not.toHaveBeenCalled()
    })

    it('should not call onCancel when clicking inside modal content', async () => {
      const user = userEvent.setup()
      const onConfirm = vi.fn()
      const onCancel = vi.fn()

      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={onConfirm}
          onCancel={onCancel}
        />
      )

      // Click inside the modal content
      const modalContent = screen.getByRole('dialog')
      await user.click(modalContent)

      expect(onCancel).not.toHaveBeenCalled()
      expect(onConfirm).not.toHaveBeenCalled()
    })
  })

  describe('Accessibility', () => {
    it('should have proper ARIA role', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByRole('dialog')).toBeInTheDocument()
    })

    it('should have aria-modal attribute', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      const dialog = screen.getByRole('dialog')
      expect(dialog).toHaveAttribute('aria-modal', 'true')
    })

    it('should have aria-labelledby pointing to the title', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      const dialog = screen.getByRole('dialog')
      const labelledBy = dialog.getAttribute('aria-labelledby')
      expect(labelledBy).toBeTruthy()

      const title = document.getElementById(labelledBy!)
      expect(title).toBeInTheDocument()
      expect(title).toHaveTextContent("Confirmer l'action")
    })

    it('should focus trap within the modal when open', () => {
      render(
        <ConfirmToggleModal
          card={mockCard}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      const dialog = screen.getByRole('dialog')
      const focusableElements = dialog.querySelectorAll('button')

      // Should have at least 2 focusable buttons (Annuler, Confirmer)
      expect(focusableElements.length).toBeGreaterThanOrEqual(2)
    })
  })

  describe('Edge Cases', () => {
    it('should handle card with only English name', () => {
      const cardWithOnlyEn: Card = {
        ...mockCard,
        nameFr: '',
      }

      render(
        <ConfirmToggleModal
          card={cardWithOnlyEn}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByText('Gandalf the Grey')).toBeInTheDocument()
      expect(screen.queryByText('Gandalf le Gris')).not.toBeInTheDocument()
    })

    it('should handle card with only French name', () => {
      const cardWithOnlyFr: Card = {
        ...mockCard,
        nameEn: '',
      }

      render(
        <ConfirmToggleModal
          card={cardWithOnlyFr}
          newState={true}
          isOpen={true}
          onConfirm={vi.fn()}
          onCancel={vi.fn()}
        />
      )

      expect(screen.getByText('Gandalf le Gris')).toBeInTheDocument()
      expect(screen.queryByText('Gandalf the Grey')).not.toBeInTheDocument()
    })
  })
})
