import { createClient } from '@supabase/supabase-js';

/**
 * Inicialização do cliente Supabase.
 * Prioriza variáveis de ambiente (Vercel/Production) e usa o endpoint oficial como fallback.
 */
const supabaseUrl = process.env.SUPABASE_URL || 
                    process.env.REACT_APP_SUPABASE_URL || 
                    'https://dlpebpireghwddibcgqr.supabase.co';

// A Anon Key deve ser configurada nas variáveis de ambiente do seu projeto (Vercel).
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || 
                        process.env.REACT_APP_SUPABASE_ANON_KEY || 
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.placeholder';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);