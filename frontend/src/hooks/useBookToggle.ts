import { useMutation, useQueryClient } from '@tanstack/react-query'
import { toggleBookPossession } from '@/lib/api/books'
import toast from 'react-hot-toast'

export function useBookToggle() {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: ({ bookId, isOwned }: { bookId: string; isOwned: boolean }) =>
      toggleBookPossession(bookId, isOwned),
    onSuccess: (updatedBook) => {
      // Invalidate queries to refresh data
      queryClient.invalidateQueries({ queryKey: ['books'] })
      queryClient.invalidateQueries({ queryKey: ['collections'] })

      // Show success toast
      toast.success(
        updatedBook.isOwned ? 'Livre ajouté à votre collection !' : 'Livre retiré de votre collection',
        {
          duration: 3000,
          position: 'bottom-right',
          icon: updatedBook.isOwned ? '✓' : '✗',
        }
      )
    },
    onError: (error: any) => {
      console.error('Failed to update book possession:', error)

      // More detailed error message
      const errorMessage = error?.message || 'Erreur lors de la mise à jour du livre'
      const isAuthError = error?.message?.includes('401') || error?.message?.includes('Unauthorized')

      toast.error(
        isAuthError ? 'Session expirée. Veuillez vous reconnecter.' : errorMessage,
        {
          duration: 4000,
          position: 'bottom-right',
        }
      )
    },
  })

  return {
    toggleBook: mutation.mutate,
    isLoading: mutation.isPending,
  }
}
