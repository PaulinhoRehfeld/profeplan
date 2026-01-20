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

// Priority: VITE_ > NEXT_PUBLIC_ > SUPABASE_ > Hardcoded Fallback
const supabaseUrl =
  import.meta.env.VITE_SUPABASE_URL ||
  getEnv('NEXT_PUBLIC_SUPABASE_URL') ||
  getEnv('SUPABASE_URL') ||
  '';

// Priority: VITE_ > NEXT_PUBLIC_ > SUPABASE_ > Hardcoded Fallback
const supabaseAnonKey =
  import.meta.env.VITE_SUPABASE_ANON_KEY ||
  getEnv('NEXT_PUBLIC_SUPABASE_ANON_KEY') ||
  getEnv('SUPABASE_ANON_KEY') ||
  '';

// Initialize the client. This will throw if supabaseUrl is missing or invalid.
export const supabase = createClient(supabaseUrl, supabaseAnonKey);