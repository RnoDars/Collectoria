import { useMutation, useQueryClient } from '@tanstack/react-query'
import { toggleNovelPossession } from '@/lib/api/forgottenrealms'
import toast from 'react-hot-toast'

export function useForgottenRealmsNovelToggle() {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: ({ novelId, isOwned }: { novelId: string; isOwned: boolean }) =>
      toggleNovelPossession(novelId, isOwned),
    onSuccess: (updatedNovel) => {
      // Invalidate queries to refresh data
      queryClient.invalidateQueries({ queryKey: ['forgottenrealms-novels'] })
      queryClient.invalidateQueries({ queryKey: ['collections'] })

      // Show success toast
      toast.success(
        updatedNovel.isOwned ? 'Roman ajouté à votre collection !' : 'Roman retiré de votre collection',
        {
          duration: 3000,
          position: 'bottom-right',
          icon: updatedNovel.isOwned ? '✓' : '✗',
        }
      )
    },
    onError: (error: any) => {
      console.error('Failed to update novel possession:', error)

      // More detailed error message
      const errorMessage = error?.message || 'Erreur lors de la mise à jour du roman'
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
    toggleNovel: mutation.mutate,
    isLoading: mutation.isPending,
  }
}
