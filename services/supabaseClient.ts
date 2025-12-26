import { createClient } from '@supabase/supabase-js';

/**
 * Supabase Client Initialization
 * 
 * Prioritizes environment variables following Vercel's standard (NEXT_PUBLIC_)
 * to ensure seamless integration with the deployment platform while maintaining
 * fallback support for development and initial setup.
 */

const getEnv = (key: string): string | undefined => {
  if (typeof process !== 'undefined' && process.env) {
    const value = process.env[key];
    // Valida se o valor existe, não é a string literal "undefined" (comum em alguns builds)
    // e se não é apenas espaço em branco.
    if (value && value !== 'undefined' && value.trim() !== '') {
      return value;
    }
  }
  return undefined;
};

// Priority: NEXT_PUBLIC_SUPABASE_URL > SUPABASE_URL > Hardcoded Fallback
const supabaseUrl = 
  getEnv('NEXT_PUBLIC_SUPABASE_URL') || 
  getEnv('SUPABASE_URL') || 
  'https://uatejrgmbzgoeayfascf.supabase.co';

// Priority: NEXT_PUBLIC_SUPABASE_ANON_KEY > SUPABASE_ANON_KEY > Hardcoded Fallback
const supabaseAnonKey = 
  getEnv('NEXT_PUBLIC_SUPABASE_ANON_KEY') || 
  getEnv('SUPABASE_ANON_KEY') || 
  'sb_publishable_B3kDSe1fX5KILgPHlBIOBQ_LNkoJjvC';

// Initialize the client. This will throw if supabaseUrl is missing or invalid.
export const supabase = createClient(supabaseUrl, supabaseAnonKey);