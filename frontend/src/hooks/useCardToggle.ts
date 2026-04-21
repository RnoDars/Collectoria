import { useMutation, useQueryClient } from '@tanstack/react-query'
import { updateCardPossession } from '@/lib/api/collections'
import toast from 'react-hot-toast'

export function useCardToggle() {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: ({ cardId, isOwned }: { cardId: string; isOwned: boolean }) =>
      updateCardPossession(cardId, isOwned),
    onSuccess: (updatedCard) => {
      // Invalidate queries to refresh data
      queryClient.invalidateQueries({ queryKey: ['cards'] })
      queryClient.invalidateQueries({ queryKey: ['collectionSummary'] })

      // Show success toast
      toast.success(
        updatedCard.isOwned ? 'Carte ajoutée à votre collection !' : 'Carte retirée de votre collection',
        {
          duration: 3000,
          position: 'bottom-right',
          icon: updatedCard.isOwned ? '✓' : '✗',
        }
      )
    },
    onError: (error) => {
      console.error('Failed to update card possession:', error)
      toast.error('Erreur lors de la mise à jour de la carte', {
        duration: 4000,
        position: 'bottom-right',
      })
    },
  })

  return {
    toggleCard: mutation.mutate,
    isLoading: mutation.isPending,
  }
}
