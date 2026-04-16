import { useQuery } from '@tanstack/react-query'
import { fetchCollectionSummary } from '@/lib/api/collections'

export function useCollectionSummary() {
  return useQuery({
    queryKey: ['collections', 'summary'],
    queryFn: fetchCollectionSummary,
    staleTime: 5 * 60 * 1000, // 5 minutes
    retry: 3,
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
  })
}
