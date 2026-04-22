'use client'

import { useEffect, ReactNode } from 'react'
import { useRouter } from 'next/navigation'
import { isAuthenticated } from '@/lib/auth'

interface ProtectedRouteProps {
  children: ReactNode
}

/**
 * Component to protect routes that require authentication
 * Redirects to /login if user is not authenticated
 */
export default function ProtectedRoute({ children }: ProtectedRouteProps) {
  const router = useRouter()

  useEffect(() => {
    if (!isAuthenticated()) {
      router.push('/login')
    }
  }, [router])

  // If not authenticated, don't render children (will redirect)
  if (!isAuthenticated()) {
    return null
  }

  return <>{children}</>
}
