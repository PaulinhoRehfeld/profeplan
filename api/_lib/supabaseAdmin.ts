import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.SUPABASE_URL || '';
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error('[supabaseAdmin] CRITICAL: SUPABASE_URL ou SUPABASE_SERVICE_ROLE_KEY ausentes nas variáveis de ambiente.');
}

// createClient lança exceção se a URL for string vazia — usamos placeholder para evitar
// crash no módulo. Chamadas reais falharão com erro da API, capturado pelo try-catch.
export const supabaseAdmin = createClient(
  SUPABASE_URL || 'https://placeholder.supabase.co',
  SUPABASE_SERVICE_ROLE_KEY || 'placeholder-key',
  { auth: { autoRefreshToken: false, persistSession: false } }
);
