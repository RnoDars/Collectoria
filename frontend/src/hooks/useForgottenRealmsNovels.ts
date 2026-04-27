import { useQuery } from '@tanstack/react-query'
import { fetchNovels, NovelFilters } from '@/lib/api/forgottenrealms'

export function useForgottenRealmsNovels(filters: NovelFilters = {}) {
  return useQuery({
    queryKey: ['forgottenrealms-novels', filters],
    queryFn: () => fetchNovels(filters),
    staleTime: 5 * 60 * 1000, // 5 minutes
    retry: 3,
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
  })
}
