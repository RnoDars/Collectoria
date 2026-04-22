'use client'

import { useMutation } from '@tanstack/react-query'
import { useRouter } from 'next/navigation'
import { login as apiLogin, type LoginCredentials } from '@/lib/api/auth'
import { setAuthToken, removeAuthToken, isAuthenticated as checkAuth } from '@/lib/auth'
import toast from 'react-hot-toast'

export const useAuth = () => {
  const router = useRouter()

  const loginMutation = useMutation({
    mutationFn: async (credentials: LoginCredentials) => {
      return await apiLogin(credentials)
    },
    onSuccess: (data) => {
      setAuthToken(data.token, data.expiresAt)
      toast.success('Connexion réussie')
      router.push('/')
    },
    onError: (error: Error) => {
      const message = error.message.toLowerCase().includes('401') || error.message.toLowerCase().includes('unauthorized')
        ? 'Email ou mot de passe incorrect'
        : 'Erreur de connexion, veuillez réessayer'

      toast.error(message)
    },
  })

  const login = async (email: string, password: string) => {
    return loginMutation.mutateAsync({ email, password })
  }

  const logout = () => {
    removeAuthToken()
    toast.success('Déconnexion réussie')
    router.push('/login')
  }

  const isAuthenticated = () => {
    return checkAuth()
  }

  return {
    login,
    logout,
    isAuthenticated,
    isLoading: loginMutation.isPending,
    error: loginMutation.error,
  }
}
