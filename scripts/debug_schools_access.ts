
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';

// Load .env from project root
dotenv.config({ path: path.resolve(__dirname, '../.env') });


const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('Missing VITE_SUPABASE_URL or VITE_SUPABASE_ANON_KEY in .env');
    process.exit(1);
}

// const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey); // disabled

async function checkSchools() {
    console.log('--- CHECKING SCHOOLS ACCESS (ANON) ---');

    console.log('\n--- ATTEMPTING FETCH WITH ANON KEY ---');

    const supabaseAnon = createClient(supabaseUrl, supabaseKey);

    // 1. Try to fetch with the columns we need
    const { data: anonData, error: anonError } = await supabaseAnon
        .from('schools')
        .select('id, name, city, sre')
        .limit(5);

    console.log('[Anon Client] Fetch result:', anonError ? `Error: ${anonError.message} (Code: ${anonError.code}, Details: ${anonError.details})` : `Success, ${anonData?.length} rows`);
    if (anonError) {
        console.log("Anon Detail:", anonError);
    } else {
        console.log("Sample Data:", anonData);
    }
}

checkSchools().catch(console.error);
