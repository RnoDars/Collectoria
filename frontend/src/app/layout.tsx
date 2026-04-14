import type { Metadata } from 'next'
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
      <body>{children}</body>
    </html>
  )
}
