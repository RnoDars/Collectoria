import { describe, it, expect, beforeEach, vi } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import LoginPage from '../page'
import * as authHook from '@/hooks/useAuth'
import { useRouter } from 'next/navigation'

// Mock next/navigation
vi.mock('next/navigation', () => ({
  useRouter: vi.fn(),
}))

// Mock useAuth hook
vi.mock('@/hooks/useAuth', () => ({
  useAuth: vi.fn(),
}))

describe('LoginPage', () => {
  const mockPush = vi.fn()
  const mockLogin = vi.fn()
  const mockLogout = vi.fn()
  const mockIsAuthenticated = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
    localStorage.clear()

    // Default mock implementations
    vi.mocked(useRouter).mockReturnValue({
      push: mockPush,
      back: vi.fn(),
      forward: vi.fn(),
      refresh: vi.fn(),
      replace: vi.fn(),
      prefetch: vi.fn(),
    } as any)

    vi.mocked(authHook.useAuth).mockReturnValue({
      login: mockLogin,
      logout: mockLogout,
      isAuthenticated: mockIsAuthenticated,
      isLoading: false,
      error: null,
    })

    mockIsAuthenticated.mockReturnValue(false)
  })

  describe('Rendering', () => {
    it('should render login form', () => {
      render(<LoginPage />)

      expect(screen.getByText('Bienvenue sur Collectoria')).toBeInTheDocument()
      expect(screen.getByRole('textbox', { name: /email/i })).toBeInTheDocument()
      expect(screen.getByLabelText('Mot de passe')).toBeInTheDocument()
      expect(screen.getByRole('button', { name: /se connecter/i })).toBeInTheDocument()
    })

    it('should render logo', () => {
      render(<LoginPage />)

      expect(screen.getByText('Collectoria')).toBeInTheDocument()
    })

    it('should render future register link', () => {
      render(<LoginPage />)

      expect(screen.getByText(/pas encore de compte/i)).toBeInTheDocument()
      expect(screen.getByText(/bientôt disponible/i)).toBeInTheDocument()
    })
  })

  describe('Email Validation', () => {
    it('should show error for empty email on blur', async () => {
      const user = userEvent.setup()
      render(<LoginPage />)

      const emailInput = screen.getByRole('textbox', { name: /email/i })
      await user.click(emailInput)
      await user.tab()

      await waitFor(() => {
        expect(screen.getByText(/email requis/i)).toBeInTheDocument()
      })
    })

    it('should show error for invalid email format', async () => {
      const user = userEvent.setup()
      render(<LoginPage />)

      const emailInput = screen.getByRole('textbox', { name: /email/i })
      await user.type(emailInput, 'invalid-email')
      await user.tab()

      await waitFor(() => {
        expect(screen.getByText(/format d'email invalide/i)).toBeInTheDocument()
      })
    })

    it('should clear error when valid email is entered', async () => {
      const user = userEvent.setup()
      render(<LoginPage />)

      const emailInput = screen.getByRole('textbox', { name: /email/i })

      // Enter invalid email
      await user.type(emailInput, 'invalid')
      await user.tab()
      await waitFor(() => {
        expect(screen.getByText(/format d'email invalide/i)).toBeInTheDocument()
      })

      // Fix email
      await user.clear(emailInput)
      await user.type(emailInput, 'test@example.com')
      await user.tab()

      await waitFor(() => {
        expect(screen.queryByText(/format d'email invalide/i)).not.toBeInTheDocument()
      })
    })
  })

  describe('Password Validation', () => {
    it('should show error for empty password on blur', async () => {
      const user = userEvent.setup()
      render(<LoginPage />)

      const passwordInput = screen.getByLabelText('Mot de passe')
      await user.click(passwordInput)
      await user.tab()

      await waitFor(() => {
        expect(screen.getByText(/mot de passe requis/i)).toBeInTheDocument()
      })
    })

    it('should toggle password visibility', async () => {
      const user = userEvent.setup()
      render(<LoginPage />)

      const passwordInput = screen.getByLabelText('Mot de passe') as HTMLInputElement
      const toggleButton = screen.getByLabelText(/afficher le mot de passe/i)

      expect(passwordInput.type).toBe('password')

      await user.click(toggleButton)
      expect(passwordInput.type).toBe('text')

      await user.click(toggleButton)
      expect(passwordInput.type).toBe('password')
    })
  })

  describe('Form Submission', () => {
    it('should not submit with invalid email', async () => {
      const user = userEvent.setup()
      render(<LoginPage />)

      const emailInput = screen.getByRole('textbox', { name: /email/i })
      const passwordInput = screen.getByLabelText('Mot de passe')
      const submitButton = screen.getByRole('button', { name: /se connecter/i })

      await user.type(emailInput, 'invalid-email')
      await user.type(passwordInput, 'password123')
      await user.click(submitButton)

      await waitFor(() => {
        expect(mockLogin).not.toHaveBeenCalled()
        expect(screen.getByText(/format d'email invalide/i)).toBeInTheDocument()
      })
    })

    it('should not submit with empty password', async () => {
      const user = userEvent.setup()
      render(<LoginPage />)

      const emailInput = screen.getByRole('textbox', { name: /email/i })
      const submitButton = screen.getByRole('button', { name: /se connecter/i })

      await user.type(emailInput, 'test@example.com')
      await user.click(submitButton)

      await waitFor(() => {
        expect(mockLogin).not.toHaveBeenCalled()
        expect(screen.getByText(/mot de passe requis/i)).toBeInTheDocument()
      })
    })

    it('should call login with valid credentials', async () => {
      const user = userEvent.setup()
      mockLogin.mockResolvedValue(undefined)

      render(<LoginPage />)

      const emailInput = screen.getByRole('textbox', { name: /email/i })
      const passwordInput = screen.getByLabelText('Mot de passe')
      const submitButton = screen.getByRole('button', { name: /se connecter/i })

      await user.type(emailInput, 'test@example.com')
      await user.type(passwordInput, 'password123')
      await user.click(submitButton)

      await waitFor(() => {
        expect(mockLogin).toHaveBeenCalledWith('test@example.com', 'password123')
      })
    })
  })

  describe('Loading State', () => {
    it('should show loading state during login', () => {
      vi.mocked(authHook.useAuth).mockReturnValue({
        login: mockLogin,
        logout: mockLogout,
        isAuthenticated: mockIsAuthenticated,
        isLoading: true,
        error: null,
      })

      render(<LoginPage />)

      expect(screen.getByRole('button', { name: /connexion.../i })).toBeInTheDocument()
      expect(screen.getByRole('button', { name: /connexion.../i })).toBeDisabled()
    })

    it('should disable inputs during loading', () => {
      vi.mocked(authHook.useAuth).mockReturnValue({
        login: mockLogin,
        logout: mockLogout,
        isAuthenticated: mockIsAuthenticated,
        isLoading: true,
        error: null,
      })

      render(<LoginPage />)

      expect(screen.getByRole('textbox', { name: /email/i })).toBeDisabled()
      expect(screen.getByLabelText('Mot de passe')).toBeDisabled()
    })
  })

  describe('Redirect Behavior', () => {
    it('should redirect to home if already authenticated', () => {
      mockIsAuthenticated.mockReturnValue(true)

      render(<LoginPage />)

      expect(mockPush).toHaveBeenCalledWith('/')
    })

    it('should not redirect if not authenticated', () => {
      mockIsAuthenticated.mockReturnValue(false)

      render(<LoginPage />)

      expect(mockPush).not.toHaveBeenCalled()
    })
  })
})
