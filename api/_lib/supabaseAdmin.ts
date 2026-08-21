import { createClient } from '@supabase/supabase-js';
import { resolveSupabaseAdminKey } from './supabaseCredentials';

const SUPABASE_URL = process.env.SUPABASE_URL?.trim() || '';
const SUPABASE_ADMIN_KEY = resolveSupabaseAdminKey();

if (!SUPABASE_URL || !SUPABASE_ADMIN_KEY) {
  console.error(
    '[supabaseAdmin] CRITICAL: SUPABASE_URL e uma credencial administrativa Supabase são obrigatórias.'
  );
}

// createClient lança exceção se a URL for string vazia — usamos placeholder para evitar
// crash no módulo. Chamadas reais falharão com erro da API, capturado pelo try-catch.
export const supabaseAdmin = createClient(
  SUPABASE_URL || 'https://placeholder.supabase.co',
  SUPABASE_ADMIN_KEY || 'placeholder-key',
  { auth: { autoRefreshToken: false, persistSession: false } }
);
