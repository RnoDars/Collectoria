import { useQuery } from '@tanstack/react-query'
import { fetchRecentActivities } from '@/lib/api/collections'

export function useActivities(limit = 10) {
  return useQuery({
    queryKey: ['activities', limit],
    queryFn: () => fetchRecentActivities(limit),
    staleTime: 60 * 1000, // 1 minute
    retry: 3,
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
  })
}
