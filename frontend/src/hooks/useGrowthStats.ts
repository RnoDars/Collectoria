import { useQuery } from '@tanstack/react-query'
import { fetchGrowthStats } from '@/lib/api/collections'

export function useGrowthStats(period = '6m', granularity = 'month') {
  return useQuery({
    queryKey: ['growth-stats', period, granularity],
    queryFn: () => fetchGrowthStats(period, granularity),
    staleTime: 30 * 60 * 1000, // 30 minutes
    retry: 3,
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
  })
}
