
import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('Missing Supabase credentials');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function inspectTable() {
    console.log('Inspecting enem_questions...');
    const { data, error } = await supabase
        .from('enem_questions')
        .select('*')
        .limit(1);

    if (error) {
        console.error('Error fetching enem_questions:', error);
    } else {
        console.log('Sample row from enem_questions:', JSON.stringify(data, null, 2));
    }

    console.log('Inspecting questoes_enem...');
    const { data: qeData, error: qeError } = await supabase
        .from('questoes_enem')
        .select('*')
        .limit(1);

    if (qeError) {
        console.error('Error fetching questoes_enem:', qeError);
    } else {
        console.log('Sample row from questoes_enem:', JSON.stringify(qeData, null, 2));
    }
}

inspectTable();
