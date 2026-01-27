
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';

// Load env vars
dotenv.config({ path: path.resolve(__dirname, '../.env') });

const supabaseUrl = process.env.VITE_SUPABASE_URL || '';
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Missing Supabase URL or Anon Key');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function checkContentAccess() {
    console.log(`Checking 'generated_contents' table access...`);
    console.log(`URL: ${supabaseUrl}`);

    // Try to select 1 row (as anon, should probably get 0 rows or error, but NOT 404)
    const { data, error, status, statusText } = await supabase
        .from('generated_contents')
        .select('id')
        .limit(1);

    console.log(`Status: ${status} ${statusText}`);

    if (error) {
        console.error('Error:', error);
    } else {
        console.log('Success (Query executed, even if empty):', data);
    }
}

checkContentAccess();
