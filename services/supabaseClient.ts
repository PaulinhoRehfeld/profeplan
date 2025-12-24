import { createClient } from '@supabase/supabase-js';

// Agora buscamos a URL e a CHAVE de forma dinâmica
const supabaseUrl = 
  process.env.REACT_APP_SUPABASE_URL || 
  (import.meta as any).env?.VITE_SUPABASE_URL || 
  'https://uatejrgmbzgoeayfascf.supabase.co'; // Fallback para o seu novo projeto

const supabaseAnonKey = 
  process.env.SUPABASE_ANON_KEY || 
  process.env.REACT_APP_SUPABASE_ANON_KEY || 
  (import.meta as any).env?.VITE_SUPABASE_ANON_KEY || 
  '';

if (!supabaseAnonKey) {
  console.warn("PROFEPLAN: Chave Anon não detectada.");
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);