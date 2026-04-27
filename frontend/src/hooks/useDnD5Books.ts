import { useQuery } from '@tanstack/react-query'
import { fetchBooks, DnD5Filters } from '@/lib/api/dnd5'

export function useDnD5Books(filters: DnD5Filters = {}) {
  return useQuery({
    queryKey: ['dnd5-books', filters],
    queryFn: () => fetchBooks(filters),
    staleTime: 5 * 60 * 1000, // 5 minutes
    retry: 3,
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
  })
}
