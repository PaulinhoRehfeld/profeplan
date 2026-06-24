import { createClient } from '@supabase/supabase-js';

const isDev = import.meta.env?.DEV || false;

const getEnv = (key: string): string | undefined => {
  if (import.meta.env && import.meta.env[key]) {
    return import.meta.env[key];
  }

  if (typeof process !== 'undefined' && process.env) {
    const value = process.env[key];
    if (value && value !== 'undefined' && value.trim() !== '') {
      return value;
    }
  }

  return undefined;
};

const supabaseUrl =
  getEnv('VITE_SUPABASE_URL') ||
  getEnv('NEXT_PUBLIC_SUPABASE_URL') ||
  getEnv('SUPABASE_URL') ||
  '';

const supabaseAnonKey =
  getEnv('VITE_SUPABASE_ANON_KEY') ||
  getEnv('NEXT_PUBLIC_SUPABASE_ANON_KEY') ||
  getEnv('SUPABASE_ANON_KEY') ||
  '';

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('[Supabase] Missing configuration keys.', {
    hasUrl: !!supabaseUrl,
    hasKey: !!supabaseAnonKey,
    mode: isDev ? 'DEVELOPMENT' : 'PRODUCTION',
  });
  throw new Error('Supabase configuration is missing. Define VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY.');
}

if (isDev) {
  console.log('[Supabase] Client connected to:', `${supabaseUrl.substring(0, 15)}...`);
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    // Mantém a sessão no localStorage e renova o token automaticamente em background.
    // O auto-refresh do cliente é seguro para concorrência (lock interno) — por isso
    // nenhum código deve chamar refreshSession() manualmente no caminho quente.
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
  },
});
