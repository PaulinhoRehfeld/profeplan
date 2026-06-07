'use client';

import { createSupabaseBrowserClient } from '@profeplan/auth/supabase/client';
import { useRouter } from 'next/navigation';
import { useState } from 'react';

export function LogoutButton() {
  const router = useRouter();
  const [isLoggingOut, setIsLoggingOut] = useState(false);

  async function handleLogout() {
    setIsLoggingOut(true);

    // Record logout event for auditing on the server
    await fetch('/api/auth/event', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ event: 'logout' }),
    }).catch((err) => {
      console.error('Failed to log logout event:', err);
    });

    const supabase = createSupabaseBrowserClient();
    await supabase.auth.signOut();
    router.push('/login');
    router.refresh();
  }

  return (
    <button className="button button-danger" onClick={handleLogout} disabled={isLoggingOut}>
      {isLoggingOut ? 'Saindo...' : 'Sair da Conta'}
    </button>
  );
}
