import { createClient } from '@supabase/supabase-js';

/**
 * Supabase Client Configuration
 * 
 * Prioritiza variáveis de ambiente injetadas pelo Vercel (SUPABASE_URL, SUPABASE_ANON_KEY)
 * e prefixes comuns de frameworks (NEXT_PUBLIC_, VITE_) para garantir compatibilidade
 * máxima entre ambientes de desenvolvimento e produção.
 */

const getEnv = (keys: string[]): string | undefined => {
  if (typeof process === 'undefined' || !process.env) return undefined;
  
  for (const key of keys) {
    const value = process.env[key];
    if (value && value !== 'undefined' && value.trim() !== '') {
      return value;
    }
  }
  return undefined;
};

// Definição de chaves por ordem de prioridade (Integração Vercel > Public Keys)
const URL_KEYS = ['SUPABASE_URL', 'NEXT_PUBLIC_SUPABASE_URL', 'VITE_SUPABASE_URL'];
const KEY_KEYS = ['SUPABASE_ANON_KEY', 'NEXT_PUBLIC_SUPABASE_ANON_KEY', 'VITE_SUPABASE_ANON_KEY'];

// Fallbacks para o ambiente de demonstração específico do PROFEPLAN
const DEFAULT_URL = 'https://uatejrgmbzgoeayfascf.supabase.co';
const DEFAULT_KEY = 'sb_publishable_B3kDSe1fX5KILgPHlBIOBQ_LNkoJjvC';

const supabaseUrl = getEnv(URL_KEYS) || DEFAULT_URL;
const supabaseAnonKey = getEnv(KEY_KEYS) || DEFAULT_KEY;

// Validação em tempo de execução
if (!supabaseUrl.startsWith('https://')) {
  console.warn('PROFEPLAN Supabase Warning: URL de conexão inválida ou ausente.');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);