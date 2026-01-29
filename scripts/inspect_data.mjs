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

async function inspectData() {
    console.log('--- Inspecting Schools Schema/Data ---');
    // Get one school to check ID format
    const { data: schools } = await supabase.from('schools').select('*').limit(1);
    if (schools && schools.length > 0) {
        console.log('Sample School:', schools[0]);
        console.log('School ID Type:', typeof schools[0].id);
    } else {
        console.log('No schools found ???');
    }

    console.log('\n--- Inspecting User Profile (Teacher) ---');
    // Find the teacher profile to see what school_id they have
    const { data: profiles } = await supabase
        .from('profiles')
        .select('id, email, school_id, role')
        .eq('role', 'teacher')
        .not('school_id', 'is', null)
        .limit(1);

    if (profiles && profiles.length > 0) {
        console.log('Sample Teacher Profile:', profiles[0]);
        console.log('Teacher School ID Type:', typeof profiles[0].school_id);
    }

    console.log('\n--- Inspecting ALL Students ---');
    // correct table 'students'
    const { data: students, error } = await supabase
        .from('students')
        .select('id, name, current_school_id, created_at')
        .order('created_at', { ascending: false })
        .limit(5);

    if (error) console.error('Error fetching students:', error);
    console.log('Recent 5 Students in DB:', students);

    if (students && students.length > 0) {
        console.log('Student School ID Type:', typeof students[0].current_school_id);
    }
}

inspectData();
