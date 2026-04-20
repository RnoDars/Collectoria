import { useInfiniteQuery } from '@tanstack/react-query'
import { fetchCards, CardFilters } from '@/lib/api/collections'

export function useCards(filters: CardFilters = {}) {
  return useInfiniteQuery({
    queryKey: ['cards', filters],
    queryFn: ({ pageParam }) => fetchCards(filters, pageParam as number),
    initialPageParam: 1,
    getNextPageParam: (lastPage) =>
      lastPage.hasMore ? lastPage.page + 1 : undefined,
    staleTime: 2 * 60 * 1000, // 2 minutes
    retry: 3,
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
  })
}
