
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

async function ensureProfile() {
    try {
        console.log("Starting Profile Fix (CJS)...");

        // ENV Loading Logic
        const possiblePaths = [path.join(process.cwd(), '.env'), path.join(process.cwd(), '.env.local')];
        let envVars = {};
        for (const p of possiblePaths) {
            if (fs.existsSync(p)) {
                const content = fs.readFileSync(p, 'utf8');
                content.split('\n').forEach(line => {
                    const parts = line.split('=');
                    if (parts.length >= 2) envVars[parts[0].trim()] = parts.slice(1).join('=').trim().replace(/^["']|["']$/g, '');
                });
                if (envVars['VITE_SUPABASE_URL']) break;
            }
        }

        const supabaseUrl = envVars['VITE_SUPABASE_URL'];
        const serviceRoleKey = envVars['SUPABASE_SERVICE_ROLE_KEY'] || envVars['VITE_SUPABASE_SERVICE_ROLE_KEY'];

        if (!supabaseUrl || !serviceRoleKey) {
            console.error('❌ Missing Keys in .env');
            return;
        }

        const supabase = createClient(supabaseUrl, serviceRoleKey);
        const email = 'suporte@profeplan.com.br';

        // 1. Get User ID
        // Note: admin.listUsers is the only way to search by email if strictly using Admin API without login.
        console.log(`Searching for user: ${email}...`);
        const { data: usersData, error: listError } = await supabase.auth.admin.listUsers();

        if (listError) {
            console.error("❌ List Users Error:", listError);
            return;
        }

        const user = usersData.users.find(u => u.email === email);

        if (!user) {
            console.error("❌ User not found in Auth! Run the create script again.");
            return;
        }

        console.log(`✅ Found User ID: ${user.id}`);

        // 2. Upsert Profile
        console.log("Upserting Profile...");
        const { data, error } = await supabase
            .from('profiles')
            .upsert({
                id: user.id,
                email: email,
                role: 'admin',
                is_admin: true,
                full_name: 'Suporte ProfePlan',
                plan_tier: 'gold',
                credits: 9999,
                updated_at: new Date().toISOString()
            })
            .select();

        if (error) {
            console.error("❌ Profile Upsert Error:", error);
        } else {
            console.log("✅ Profile Upserted Successfully:", data);
        }

    } catch (err) {
        console.error("❌ Script Error:", err);
    }
}

ensureProfile();
