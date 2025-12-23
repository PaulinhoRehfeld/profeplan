import { createClient } from '@supabase/supabase-js';

/**
 * Inicialização do cliente Supabase.
 * Para resolver o erro 'supabaseUrl is required', inserimos a URL fornecida como fallback.
 * Prioriza variáveis de ambiente (Vercel/Production) e usa o endpoint oficial como segurança.
 */
const supabaseUrl = process.env.SUPABASE_URL || 
                    process.env.REACT_APP_SUPABASE_URL || 
                    'https://dlpebpireghwddibcgqr.supabase.co';

// A Anon Key também é obrigatória para a inicialização. 
// Certifique-se de configurar SUPABASE_ANON_KEY nas variáveis de ambiente do seu projeto.
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || 
                        process.env.REACT_APP_SUPABASE_ANON_KEY || 
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.placeholder';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
