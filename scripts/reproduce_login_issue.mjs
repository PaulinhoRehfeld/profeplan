import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
dotenv.config();

const supabase = createClient(
    process.env.VITE_SUPABASE_URL,
    process.env.VITE_SUPABASE_ANON_KEY
);

async function testLogin() {
    const email = 'prehfeld@hotmail.com';
    const password = '12345678';
    
    console.log(`[Test] Attempting login for ${email} in Production...`);
    
    const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
    });

    if (error) {
        console.error('❌ Login Failed:', error.message);
        
        // Let's see if the user exists but has no confirmed email
        const { data: profile, error: profileErr } = await supabase
            .from('profiles')
            .select('email, role, is_admin')
            .eq('email', email)
            .maybeSingle();
            
        if (profileErr) {
            console.error('❌ Could not even fetch profile:', profileErr.message);
        } else if (profile) {
            console.log('✅ User Profile found in DB:', profile);
        } else {
            console.log('❌ User Profile NOT found in DB.');
        }
    } else {
        console.log('✅ Login SUCCESS for:', data.user.email);
        console.log('User ID:', data.user.id);
    }
}

testLogin();
