import type { Metadata } from 'next'
import { Providers } from './providers'
import TopNav from '@/components/layout/TopNav'
import { Toaster } from 'react-hot-toast'
import './globals.css'

export const metadata: Metadata = {
  title: 'Collectoria - Gestionnaire de Collections',
  description: 'Gérez vos collections de cartes, livres, jeux et figurines',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
      </head>
      <body>
        <Providers>
          <TopNav />
          {children}
          <Toaster position="bottom-right" />
        </Providers>
      </body>
    </html>
  )
}
