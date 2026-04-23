import { useQuery } from '@tanstack/react-query'
import { fetchBooks, BookFilters } from '@/lib/api/books'

export function useBooks(filters: BookFilters = {}) {
  return useQuery({
    queryKey: ['books', filters],
    queryFn: () => fetchBooks(filters),
    staleTime: 5 * 60 * 1000, // 5 minutes
    retry: 3,
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
  })
}
