import { apiClient, parseApiError } from './client'

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080'

export interface LoginCredentials {
  email: string
  password: string
}

export interface LoginResponse {
  token: string
  expiresAt: string
}

/**
 * Login user with email and password
 * Returns JWT token and expiration date
 */
export async function login(credentials: LoginCredentials): Promise<LoginResponse> {
  const response = await fetch(`${API_BASE_URL}/api/v1/auth/login`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(credentials),
  })

  if (!response.ok) {
    const error = await parseApiError(response)
    throw new Error(error.message)
  }

  const data = await response.json()

  return {
    token: data.token,
    expiresAt: data.expires_at,
  }
}
