import { getAuthToken, removeAuthToken } from '../auth'

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080'

export interface ApiError {
  message: string
  status: number
  details?: Record<string, any>
}

/**
 * Enhanced fetch client with automatic JWT token injection
 * and 401 handling (redirect to login)
 */
export const apiClient = {
  async fetch(endpoint: string, options: RequestInit = {}): Promise<Response> {
    const token = getAuthToken()

    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    }

    // Merge existing headers
    if (options.headers) {
      const existingHeaders = options.headers as Record<string, string>
      Object.assign(headers, existingHeaders)
    }

    // Add Authorization header if token exists
    if (token) {
      headers['Authorization'] = `Bearer ${token}`
    }

    const url = endpoint.startsWith('http') ? endpoint : `${API_BASE_URL}${endpoint}`

    const response = await fetch(url, {
      ...options,
      headers,
    })

    // Handle 401 Unauthorized - token expired or invalid
    if (response.status === 401) {
      removeAuthToken()

      // Only redirect if we're in the browser and not already on login page
      if (typeof window !== 'undefined' && !window.location.pathname.includes('/login')) {
        window.location.href = '/login'
      }
    }

    return response
  },

  async get(endpoint: string): Promise<Response> {
    return this.fetch(endpoint, { method: 'GET' })
  },

  async post(endpoint: string, body?: any): Promise<Response> {
    return this.fetch(endpoint, {
      method: 'POST',
      body: body ? JSON.stringify(body) : undefined,
    })
  },

  async patch(endpoint: string, body?: any): Promise<Response> {
    return this.fetch(endpoint, {
      method: 'PATCH',
      body: body ? JSON.stringify(body) : undefined,
    })
  },

  async delete(endpoint: string): Promise<Response> {
    return this.fetch(endpoint, { method: 'DELETE' })
  },
}

/**
 * Parse API error from response
 */
export async function parseApiError(response: Response): Promise<ApiError> {
  try {
    const data = await response.json()
    return {
      message: data.error || data.message || 'Une erreur est survenue',
      status: response.status,
      details: data,
    }
  } catch {
    return {
      message: response.statusText || 'Une erreur est survenue',
      status: response.status,
    }
  }
}
