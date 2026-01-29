import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.resolve(__dirname, '../.env') });

const supabase = createClient(
    process.env.VITE_SUPABASE_URL,
    process.env.VITE_SUPABASE_ANON_KEY
);

async function diagnose() {
    console.log('--- DIAGNOSTIC START ---');

    // 1. Test RPC get_cities
    console.log('\n1. Testing RPC get_cities...');
    const { data: cities, error: rpcError } = await supabase.rpc('get_cities');
    if (rpcError) {
        console.error('❌ RPC Failed:', rpcError.message);
    } else {
        console.log(`✅ RPC Success! Found ${cities ? cities.length : 0} cities.`);
        if (cities && cities.length > 0) {
            console.log('First 3 cities:', cities.slice(0, 3));
            console.log('Last 3 cities:', cities.slice(-3));
        }
    }

    // 2. Check User Profile (We'll assume the main user email from context or check 'prehfeld@hotmail.com')
    const targetEmail = 'prehfeld@hotmail.com'; // Adjust if known
    console.log(`\n2. Checking Profile for ${targetEmail}...`);

    const { data: profiles } = await supabase
        .from('profiles')
        .select('id, school_id, role, full_name')
        .eq('email', targetEmail);

    let userSchoolId = null;
    if (profiles && profiles.length > 0) {
        console.log('User Profile:', profiles[0]);
        userSchoolId = profiles[0].school_id;
    } else {
        console.log('User profile not found via script (RLS might hide it if not using Service Key, but fetching own should work if authenticated usually. Here we are anon+public polices? No, profiles normally constrained).');
        // Note: This script runs as Anon, so it might not see the profile unless RLS allows public read or we use service key (which we don't have easily here).
        // Let's rely on Step 3 generally.
    }

    // 3. Check Students
    console.log('\n3. Checking Students Count...');
    // We'll filter by the school_id if we found it, otherwise verify ALL recent students
    const { data: allStudents } = await supabase
        .from('students')
        .select('id, name, current_school_id, created_at')
        .order('created_at', { ascending: false })
        .limit(10);

    console.log('Recent 10 Students in DB (Anonymous check - might be empty due to RLS):');
    console.log(allStudents);

    // 4. Check specific school counts if we know the ID (23299)
    const knownSchoolId = '23299';
    console.log(`\n4. Checking Counts for School ID: ${knownSchoolId}...`);

    // Note: This query heavily depends on RLS allowing Anon access or permissive policies we set.
    // We set "Teachers View" and "Managers View". Anon might see nothing.
    // We previously dropped permissions? No we recreated them.
    // If this script returns empty, it confirms RLS is working (blocking anon).
    // But checking if specific rows exist might require a specific query or knowing if "Public Access" exists.
}

diagnose();
