'use client';

import { createSupabaseBrowserClient } from '@profeplan/auth/supabase/client';
import { useRouter, useSearchParams } from 'next/navigation';
import { useState, type FormEvent } from 'react';

export function LoginForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError(null);
    setIsLoading(true);

    const formData = new FormData(event.currentTarget);
    const email = String(formData.get('email') ?? '');
    const password = String(formData.get('password') ?? '');
    const supabase = createSupabaseBrowserClient();

    const { error: signInError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (signInError) {
      const msg = signInError.message?.toLowerCase() ?? '';
      if (msg.includes('invalid login credentials') || signInError.status === 400) {
        setError('E-mail ou senha incorretos. Verifique suas credenciais.');
      } else if (msg.includes('email not confirmed')) {
        setError('E-mail não confirmado. Verifique sua caixa de entrada para ativar sua conta.');
      } else if (signInError.status === 429 || msg.includes('rate limit') || msg.includes('for security purposes')) {
        setError('Muitas tentativas. Aguarde alguns minutos e tente novamente.');
      } else {
        setError('Ocorreu um erro ao entrar. Tente novamente ou entre em contato com o suporte.');
        console.error('[LoginForm] Erro de auth:', signInError);
      }
      setIsLoading(false);
      return;
    }

    // Record login event for auditing on the server
    await fetch('/api/auth/event', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ event: 'login' }),
    }).catch((err) => {
      console.error('Failed to log login event:', err);
    });

    router.replace(searchParams.get('next') ?? '/dashboard');
    router.refresh();
  }

  return (
    <form className="stack" onSubmit={handleSubmit}>
      <div className="field">
        <label htmlFor="email">E-mail</label>
        <input id="email" name="email" required type="email" />
      </div>
      <div className="field">
        <label htmlFor="password">Senha</label>
        <input id="password" name="password" required type="password" />
      </div>
      {error ? <p className="error">{error}</p> : null}
      <button className="button" disabled={isLoading} type="submit">
        {isLoading ? 'Entrando...' : 'Entrar'}
      </button>
    </form>
  );
}
