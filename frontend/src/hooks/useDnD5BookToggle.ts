import { useMutation, useQueryClient } from '@tanstack/react-query'
import { apiClient } from '@/lib/api/client'
import toast from 'react-hot-toast'

interface DnD5ToggleParams {
  bookId: string
  version: 'fr' | 'en'
  isOwned: boolean
}

async function toggleDnD5BookPossession(params: DnD5ToggleParams) {
  const { bookId, version, isOwned } = params

  const body = version === 'fr'
    ? { owned_fr: isOwned }
    : { owned_en: isOwned }

  const response = await apiClient.patch(`/api/v1/dnd5/books/${bookId}/ownership`, body)

  if (!response.ok) {
    throw new Error(`Failed to update book possession: ${response.statusText}`)
  }

  return await response.json()
}

export function useDnD5BookToggle() {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: toggleDnD5BookPossession,
    onSuccess: (_, variables) => {
      // Invalidate queries to refresh data
      queryClient.invalidateQueries({ queryKey: ['dnd5-books'] })
      queryClient.invalidateQueries({ queryKey: ['collections'] })

      // Show success toast
      const versionLabel = variables.version === 'fr' ? 'française' : 'anglaise'
      toast.success(
        variables.isOwned
          ? `Version ${versionLabel} ajoutée à votre collection !`
          : `Version ${versionLabel} retirée de votre collection`,
        {
          duration: 3000,
          position: 'bottom-right',
          icon: variables.isOwned ? '✓' : '✗',
        }
      )
    },
    onError: (error: any) => {
      console.error('Failed to update D&D 5e book possession:', error)

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
