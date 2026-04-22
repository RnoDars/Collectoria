'use client'

import { useState, useEffect, FormEvent } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/hooks/useAuth'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [emailError, setEmailError] = useState('')
  const [passwordError, setPasswordError] = useState('')

  const { login, isLoading, isAuthenticated } = useAuth()
  const router = useRouter()

  // Redirect if already authenticated
  useEffect(() => {
    if (isAuthenticated()) {
      router.push('/')
    }
  }, [isAuthenticated, router])

  const validateEmail = (value: string): boolean => {
    if (!value) {
      setEmailError('Email requis')
      return false
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(value)) {
      setEmailError('Format d\'email invalide')
      return false
    }

    setEmailError('')
    return true
  }

  const validatePassword = (value: string): boolean => {
    if (!value) {
      setPasswordError('Mot de passe requis')
      return false
    }

    setPasswordError('')
    return true
  }

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault()

    // Validate all fields
    const isEmailValid = validateEmail(email)
    const isPasswordValid = validatePassword(password)

    if (!isEmailValid || !isPasswordValid) {
      return
    }

    try {
      await login(email, password)
    } catch (error) {
      // Error handling is done in useAuth hook via toast
    }
  }

  return (
    <div style={{
      minHeight: 'calc(100vh - 56px)',
      background: 'linear-gradient(135deg, rgba(102, 126, 234, 0.03) 0%, rgba(118, 75, 162, 0.03) 100%)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '2rem',
    }}>
      <div style={{
        width: '100%',
        maxWidth: '400px',
        background: 'var(--surface-container-low)',
        borderRadius: '24px',
        padding: '3rem 2rem',
        boxShadow: '0px 8px 32px rgba(25, 28, 29, 0.08)',
      }}>
        {/* Logo */}
        <div style={{
          textAlign: 'center',
          marginBottom: '2rem',
        }}>
          <h1 style={{
            fontFamily: 'Manrope, sans-serif',
            fontWeight: '800',
            fontSize: '1.5rem',
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            backgroundClip: 'text',
            margin: 0,
          }}>
            Collectoria
          </h1>
        </div>

        {/* Title */}
        <h2 style={{
          fontFamily: 'Manrope, sans-serif',
          fontWeight: '600',
          fontSize: '1.25rem',
          color: 'var(--on-surface)',
          textAlign: 'center',
          marginBottom: '2rem',
        }}>
          Bienvenue sur Collectoria
        </h2>

        {/* Form */}
        <form onSubmit={handleSubmit}>
          {/* Email Field */}
          <div style={{ marginBottom: '1.5rem' }}>
            <label
              htmlFor="email"
              style={{
                display: 'block',
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.875rem',
                fontWeight: '500',
                color: 'var(--on-surface)',
                marginBottom: '0.5rem',
              }}
            >
              Email
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => {
                setEmail(e.target.value)
                if (emailError) validateEmail(e.target.value)
              }}
              onBlur={(e) => validateEmail(e.target.value)}
              disabled={isLoading}
              style={{
                width: '100%',
                padding: '0.75rem',
                fontFamily: 'Inter, sans-serif',
                fontSize: '1rem',
                color: 'var(--on-surface)',
                background: 'var(--surface-container-highest)',
                border: emailError ? '1px solid #ef4444' : '1px solid transparent',
                borderRadius: '12px',
                outline: 'none',
                transition: 'all 0.15s',
              }}
              autoComplete="email"
            />
            {emailError && (
              <p style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.75rem',
                color: '#ef4444',
                marginTop: '0.25rem',
              }}>
                {emailError}
              </p>
            )}
          </div>

          {/* Password Field */}
          <div style={{ marginBottom: '1.5rem' }}>
            <label
              htmlFor="password"
              style={{
                display: 'block',
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.875rem',
                fontWeight: '500',
                color: 'var(--on-surface)',
                marginBottom: '0.5rem',
              }}
            >
              Mot de passe
            </label>
            <div style={{ position: 'relative' }}>
              <input
                id="password"
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => {
                  setPassword(e.target.value)
                  if (passwordError) validatePassword(e.target.value)
                }}
                onBlur={(e) => validatePassword(e.target.value)}
                disabled={isLoading}
                style={{
                  width: '100%',
                  padding: '0.75rem',
                  paddingRight: '3rem',
                  fontFamily: 'Inter, sans-serif',
                  fontSize: '1rem',
                  color: 'var(--on-surface)',
                  background: 'var(--surface-container-highest)',
                  border: passwordError ? '1px solid #ef4444' : '1px solid transparent',
                  borderRadius: '12px',
                  outline: 'none',
                  transition: 'all 0.15s',
                }}
                autoComplete="current-password"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                disabled={isLoading}
                style={{
                  position: 'absolute',
                  right: '0.75rem',
                  top: '50%',
                  transform: 'translateY(-50%)',
                  background: 'none',
                  border: 'none',
                  cursor: 'pointer',
                  fontSize: '1.25rem',
                  color: 'var(--on-surface-variant)',
                }}
                aria-label={showPassword ? 'Masquer le mot de passe' : 'Afficher le mot de passe'}
              >
                {showPassword ? '🙈' : '👁'}
              </button>
            </div>
            {passwordError && (
              <p style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: '0.75rem',
                color: '#ef4444',
                marginTop: '0.25rem',
              }}>
                {passwordError}
              </p>
            )}
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={isLoading}
            style={{
              width: '100%',
              padding: '0.875rem',
              fontFamily: 'Inter, sans-serif',
              fontSize: '1rem',
              fontWeight: '600',
              color: 'white',
              background: isLoading
                ? 'var(--on-surface-variant)'
                : 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              border: 'none',
              borderRadius: '12px',
              cursor: isLoading ? 'not-allowed' : 'pointer',
              transition: 'all 0.15s',
              opacity: isLoading ? 0.6 : 1,
            }}
          >
            {isLoading ? 'Connexion...' : 'Se connecter'}
          </button>
        </form>

        {/* Future link to register */}
        <p style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: '0.875rem',
          color: 'var(--on-surface-variant)',
          textAlign: 'center',
          marginTop: '1.5rem',
        }}>
          Pas encore de compte ? <span style={{ color: '#667eea', fontWeight: '500' }}>Bientôt disponible</span>
        </p>
      </div>
    </div>
  )
}
