import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
dotenv.config();

// Try to read env vars directly or fallback to placeholders if running via ts-node directly might be tricky without setup
// I will rely on the user running this with environment variables loaded or hardcoding them purely for this debug step if needed.
// Actually, I can read the file .env.local if it exists.
// For now, I'll attempt to use the existing client if I can import it, but it's a react app file.
// Better to simple create a standalone script.

const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.VITE_SUPABASE_ANON_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error('Please set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY env vars.');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function debug_db() {
  console.log("Fetching from 'questions'...");
  const { data: qData, error: qError } = await supabase.from('questions').select('*').limit(1);
  if (qError) console.error("Error 'questions':", qError);
  else console.log("'questions' sample:", JSON.stringify(qData, null, 2));

  console.log("Fetching from 'enem_questions'...");
  const { data: eData, error: eError } = await supabase.from('enem_questions').select('*').limit(1);
  if (eError) console.error("Error 'enem_questions':", eError);
  else console.log("'enem_questions' sample:", JSON.stringify(eData, null, 2));
}

debug_db();
