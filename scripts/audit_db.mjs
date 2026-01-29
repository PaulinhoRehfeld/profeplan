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

async function audit() {
    console.log('--- AUDITING DATABASE SCHEMA ---');

    // 1. Check what 'school_students' matches in tables
    console.log('\nChecking information_schema.tables for "school_students"...');
    const { data: tables, error: tableError } = await supabase
        .from('information_schema.tables') // This might fail if REST access to system tables is blocked
        .select('table_name, table_type')
        .eq('table_schema', 'public')
        .ilike('table_name', '%school_students%');

    if (tableError) {
        console.log('Cannot query information_schema via REST. Trying standard query to tables...');
        // Fallback: Try to Select from it to see if it works
        const { error: selectError } = await supabase.from('school_students').select('id').limit(1);
        if (selectError) console.log('Checking school_students directly:', selectError.message);
        else console.log('school_students exists and is queryable.');
    } else {
        console.log('Tables matching:', tables);
    }

    // 2. Check for Views manually if tables failed (often views are in separate endpoints or same)
    // 3. Check Policies (System Catalog) - often not accessible via REST
    console.log('\nCannot list policies directly via client without admin key.');
    console.log('However, we know there is a policy named: "School Manager can manage students"');
    console.log('And we know the error says it is on table "school_students".');

    // 4. Check columns of school_students
    console.log('\nChecking columns of "school_students"...');
    const { data: cols } = await supabase.from('school_students').select('*').limit(1);
    if (cols && cols.length > 0) {
        console.log('Columns found:', Object.keys(cols[0]));
    } else {
        console.log('No data found in school_students to infer columns.');
    }

    // 5. Check if 'school_students' is a VIEW
    // If we can't query info schema, we assume based on user error "table school_students".
    // Note: Postgres error usually says "relation" or "view" if it's a view, but "table" could be generic.
}

audit();
