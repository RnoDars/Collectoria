import { describe, it, expect, beforeEach, vi } from 'vitest'
import {
  setAuthToken,
  getAuthToken,
  removeAuthToken,
  isAuthenticated,
  getTokenExpiration,
} from '../auth'

describe('Auth Utilities', () => {
  beforeEach(() => {
    // Clear localStorage before each test
    localStorage.clear()
  })

  describe('setAuthToken', () => {
    it('should store token and expiration in localStorage', () => {
      const token = 'test-jwt-token'
      const expiresAt = '2026-12-31T23:59:59Z'

      setAuthToken(token, expiresAt)

      expect(localStorage.getItem('collectoria_auth_token')).toBe(token)
      expect(localStorage.getItem('collectoria_auth_expires')).toBe(expiresAt)
    })
  })

  describe('getAuthToken', () => {
    it('should return token if valid and not expired', () => {
      const token = 'test-jwt-token'
      const futureDate = new Date()
      futureDate.setHours(futureDate.getHours() + 1)
      const expiresAt = futureDate.toISOString()

      setAuthToken(token, expiresAt)

      expect(getAuthToken()).toBe(token)
    })

    it('should return null if token does not exist', () => {
      expect(getAuthToken()).toBeNull()
    })

    it('should return null and remove token if expired', () => {
      const token = 'test-jwt-token'
      const pastDate = new Date()
      pastDate.setHours(pastDate.getHours() - 1)
      const expiresAt = pastDate.toISOString()

      setAuthToken(token, expiresAt)

      expect(getAuthToken()).toBeNull()
      expect(localStorage.getItem('collectoria_auth_token')).toBeNull()
      expect(localStorage.getItem('collectoria_auth_expires')).toBeNull()
    })

    it('should return null if expiration date is missing', () => {
      localStorage.setItem('collectoria_auth_token', 'test-token')

      expect(getAuthToken()).toBeNull()
    })

    it('should return null if token is missing', () => {
      const futureDate = new Date()
      futureDate.setHours(futureDate.getHours() + 1)
      localStorage.setItem('collectoria_auth_expires', futureDate.toISOString())

      expect(getAuthToken()).toBeNull()
    })
  })

  describe('removeAuthToken', () => {
    it('should remove token and expiration from localStorage', () => {
      const token = 'test-jwt-token'
      const expiresAt = '2026-12-31T23:59:59Z'

      setAuthToken(token, expiresAt)
      expect(localStorage.getItem('collectoria_auth_token')).toBe(token)

      removeAuthToken()

      expect(localStorage.getItem('collectoria_auth_token')).toBeNull()
      expect(localStorage.getItem('collectoria_auth_expires')).toBeNull()
    })

    it('should not throw error if no token exists', () => {
      expect(() => removeAuthToken()).not.toThrow()
    })
  })

  describe('isAuthenticated', () => {
    it('should return true if valid token exists', () => {
      const token = 'test-jwt-token'
      const futureDate = new Date()
      futureDate.setHours(futureDate.getHours() + 1)
      const expiresAt = futureDate.toISOString()

      setAuthToken(token, expiresAt)

      expect(isAuthenticated()).toBe(true)
    })

    it('should return false if no token exists', () => {
      expect(isAuthenticated()).toBe(false)
    })

    it('should return false if token is expired', () => {
      const token = 'test-jwt-token'
      const pastDate = new Date()
      pastDate.setHours(pastDate.getHours() - 1)
      const expiresAt = pastDate.toISOString()

      setAuthToken(token, expiresAt)

      expect(isAuthenticated()).toBe(false)
    })
  })

  describe('getTokenExpiration', () => {
    it('should return expiration date if exists', () => {
      const token = 'test-jwt-token'
      const expiresAt = '2026-12-31T23:59:59.000Z'

      setAuthToken(token, expiresAt)

      const expiration = getTokenExpiration()
      expect(expiration).toBeInstanceOf(Date)
      expect(expiration?.toISOString()).toBe(expiresAt)
    })

    it('should return null if no expiration exists', () => {
      expect(getTokenExpiration()).toBeNull()
    })
  })
})
