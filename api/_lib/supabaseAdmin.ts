import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.SUPABASE_URL || '';
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error('[supabaseAdmin] SUPABASE_URL ou SUPABASE_SERVICE_ROLE_KEY ausentes nas variáveis de ambiente.');
}

// Cliente com service_role — NUNCA expor ao frontend.
// Usado apenas em serverless functions (Vercel, BFF).
export const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});
