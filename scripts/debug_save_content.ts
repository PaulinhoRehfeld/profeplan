
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';

// Load env vars
dotenv.config({ path: path.resolve(__dirname, '../.env') });

const supabaseUrl = process.env.VITE_SUPABASE_URL || '';
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Missing Supabase credentials');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testSave() {
    console.log('Testing Supabase INSERT on generated_contents...');

    // Note: For this to truly test RLS, we need a session. 
    // But we can check if it fails with a generic error even without being "authenticated" 
    // if the policy is strictly "TO authenticated".

    const testData = {
        user_id: '00000000-0000-0000-0000-000000000000', // Dummy UUID
        type: 'plano',
        folder: 'PLANOS DE AULA',
        title: 'TESTE DE SISTEMA ' + new Date().toISOString(),
        content: 'Conteúdo de teste para verificar permissões.'
    };

    const { data, error } = await supabase
        .from('generated_contents')
        .insert([testData])
        .select();

    if (error) {
        console.error('❌ Insert Failed:', error.message);
        console.error('Error Code:', error.code);
        console.error('Hint:', error.hint);
    } else {
        console.log('✅ Insert Succeeded (Wait, this shouldn\'t happen if RLS is on and we are not logged in!):', data);
    }

    // Also test READ
    const { data: readData, error: readError } = await supabase
        .from('generated_contents')
        .select('*')
        .limit(1);

    if (readError) {
        console.error('❌ Read Failed:', readError.message);
    } else {
        console.log('✅ Read Succeeded:', readData?.length || 0, 'rows found.');
    }
}

testSave();
