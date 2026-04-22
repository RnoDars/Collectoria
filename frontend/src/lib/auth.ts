const AUTH_TOKEN_KEY = 'collectoria_auth_token'
const AUTH_EXPIRES_KEY = 'collectoria_auth_expires'

export interface AuthToken {
  token: string
  expiresAt: string
}

/**
 * Store authentication token and expiration date in localStorage
 */
export const setAuthToken = (token: string, expiresAt: string): void => {
  if (typeof window === 'undefined') return

  localStorage.setItem(AUTH_TOKEN_KEY, token)
  localStorage.setItem(AUTH_EXPIRES_KEY, expiresAt)
}

/**
 * Retrieve authentication token from localStorage
 * Returns null if token doesn't exist or is expired
 */
export const getAuthToken = (): string | null => {
  if (typeof window === 'undefined') return null

  const token = localStorage.getItem(AUTH_TOKEN_KEY)
  const expiresAt = localStorage.getItem(AUTH_EXPIRES_KEY)

  if (!token || !expiresAt) return null

  // Check if token is expired
  const expirationDate = new Date(expiresAt)
  const now = new Date()

  if (now >= expirationDate) {
    // Token expired, clean up
    removeAuthToken()
    return null
  }

  return token
}

/**
 * Remove authentication token from localStorage
 */
export const removeAuthToken = (): void => {
  if (typeof window === 'undefined') return

  localStorage.removeItem(AUTH_TOKEN_KEY)
  localStorage.removeItem(AUTH_EXPIRES_KEY)
}

/**
 * Check if user is authenticated (has valid non-expired token)
 */
export const isAuthenticated = (): boolean => {
  return getAuthToken() !== null
}

/**
 * Get token expiration date
 */
export const getTokenExpiration = (): Date | null => {
  if (typeof window === 'undefined') return null

  const expiresAt = localStorage.getItem(AUTH_EXPIRES_KEY)
  if (!expiresAt) return null

  return new Date(expiresAt)
}

/**
 * Decode JWT token and extract claims
 * Note: This does NOT validate the token signature, just decodes the payload
 */
export const decodeToken = (token: string): { user_id: string; email: string } | null => {
  try {
    const parts = token.split('.')
    if (parts.length !== 3) return null

    const payload = parts[1]
    const decoded = JSON.parse(atob(payload))

    return {
      user_id: decoded.user_id,
      email: decoded.email,
    }
  } catch (error) {
    console.error('Failed to decode JWT token:', error)
    return null
  }
}

/**
 * Get the email from the current auth token
 */
export const getUserEmail = (): string | null => {
  const token = getAuthToken()
  if (!token) return null

  const decoded = decodeToken(token)
  return decoded?.email || null
}
