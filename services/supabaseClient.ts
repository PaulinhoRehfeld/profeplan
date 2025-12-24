import { createClient } from '@supabase/supabase-js';

// Prioridade 1: Variáveis da integração Vercel (SUPABASE_URL)
// Prioridade 2: Variáveis manuais (REACT_APP_SUPABASE_URL)
// Prioridade 3: URL do seu NOVO projeto PROFEPLAN (uatejrgmbzgoeayfascf) como fallback final
const supabaseUrl = 
  process.env.SUPABASE_URL || 
  process.env.REACT_APP_SUPABASE_URL || 
  'https://uatejrgmbzgoeayfascf.supabase.co'; 

// Prioridade 1: Variáveis da integração Vercel (SUPABASE_ANON_KEY)
// Prioridade 2: Variáveis manuais (REACT_APP_SUPABASE_ANON_KEY)
// Prioridade 3: Sua chave real de fallback para garantir funcionalidade
const supabaseAnonKey = 
  process.env.SUPABASE_ANON_KEY || 
  process.env.REACT_APP_SUPABASE_ANON_KEY || 
  'sb_publishable_B3kDSe1fX5KILgPHlBIOBQ_LNkoJjvC'; // Sua chave real aqui!

export const supabase = createClient(supabaseUrl, supabaseAnonKey);