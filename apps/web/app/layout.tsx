import './globals.css';

import type { Metadata } from 'next';
import type { ReactNode } from 'react';
import { Inter } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-sans',
});

export const metadata: Metadata = {
  title: 'PROFEPLAN V2',
  description: 'PROFEPLAN V2 authentication foundation',
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="pt-BR" className={`${inter.variable}`}>
      <body>{children}</body>
    </html>
  );
}
