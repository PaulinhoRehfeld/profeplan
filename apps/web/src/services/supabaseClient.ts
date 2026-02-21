import { createClient } from '@supabase/supabase-js';

/**
 * Supabase Client Initialization
 * 
 * Prioritizes environment variables following Vercel's standard (NEXT_PUBLIC_)
 * to ensure seamless integration with the deployment platform while maintaining
 * fallback support for development and initial setup.
 */

// 1. Environment Detection with robust fallbacks
const isDev = import.meta.env?.DEV || false;

const getEnv = (key: string): string | undefined => {
  // Vite standard: import.meta.env
  if (import.meta.env && import.meta.env[key]) {
    return import.meta.env[key];
  }

  // Node fallback (SSR/Scripts)
  if (typeof process !== 'undefined' && process.env) {
    const value = process.env[key];
    if (value && value !== 'undefined' && value.trim() !== '') {
      return value;
    }
  }

  return undefined;
};

// Priority: VITE_ > NEXT_PUBLIC_ > Hardcoded Fallback
const supabaseUrl = getEnv('VITE_SUPABASE_URL') || getEnv('NEXT_PUBLIC_SUPABASE_URL') || getEnv('SUPABASE_URL') || '';
const supabaseAnonKey = getEnv('VITE_SUPABASE_ANON_KEY') || getEnv('NEXT_PUBLIC_SUPABASE_ANON_KEY') || getEnv('SUPABASE_ANON_KEY') || '';

// 2. Runtime Integrity Check
if (!supabaseUrl || !supabaseAnonKey) {
  console.error('[Supabase] ❌ CRITICAL: Missing configuration keys!', {
    hasUrl: !!supabaseUrl,
    hasKey: !!supabaseAnonKey,
    mode: isDev ? 'DEVELOPMENT' : 'PRODUCTION'
  });
} else if (isDev) {
  console.log('[Supabase] 🚀 Client connected to:', supabaseUrl.substring(0, 15) + '...');
}

// Initialize the client. This will throw if supabaseUrl is missing or invalid.
export const supabase = createClient(supabaseUrl, supabaseAnonKey);