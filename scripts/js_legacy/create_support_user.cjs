
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

async function createSupportUser() {
    try {
        console.log("Starting user creation script (CJS)...");
        console.log("Current directory:", process.cwd());

        // Try multiple paths for .env
        const possiblePaths = [
            path.join(process.cwd(), '.env'),
            path.join(process.cwd(), '.env.local')
        ];

        let envVars = {};
        let loaded = false;

        for (const p of possiblePaths) {
            if (fs.existsSync(p)) {
                console.log(`Found .env at: ${p}`);
                const content = fs.readFileSync(p, 'utf8');
                content.split('\n').forEach(line => {
                    const parts = line.split('=');
                    if (parts.length >= 2) {
                        const key = parts[0].trim();
                        const val = parts.slice(1).join('=').trim().replace(/^["']|["']$/g, ''); // Remove quotes
                        if (key && val) envVars[key] = val;
                    }
                });
                loaded = true;
                if (envVars['VITE_SUPABASE_URL']) break;
            }
        }

        if (!loaded) {
            console.error("❌ No .env file found.");
            process.exit(1);
        }

        const supabaseUrl = envVars['VITE_SUPABASE_URL'];
        const serviceRoleKey = envVars['SUPABASE_SERVICE_ROLE_KEY'] || envVars['VITE_SUPABASE_SERVICE_ROLE_KEY'];

        if (!supabaseUrl || !serviceRoleKey) {
            console.error('❌ Missing Keys in .env');
            process.exit(1);
        }

        console.log(`✅ Supabase URL: ${supabaseUrl}`);

        const supabase = createClient(supabaseUrl, serviceRoleKey);

        const email = 'suporte@profeplan.com.br';
        const password = '12348765';

        console.log(`Creating user: ${email}...`);

        // 1. Create User via Admin API
        const { data: user, error: createError } = await supabase.auth.admin.createUser({
            email: email,
            password: password,
            email_confirm: true,
            user_metadata: {
                full_name: 'Suporte ProfePlan',
                role: 'admin',
                is_admin: true
            }
        });

        let userId = user?.user?.id;

        if (createError) {
            console.error('⚠️ Create Error:', createError.message);
            // If exists, try to find ID?
            // Usually we can't find ID by email easily with Service Role unless we ListUsers
            if (createError.message.includes("already registered")) {
                console.log("User exists. Trying to list users to find ID...");
                const { data: usersData } = await supabase.auth.admin.listUsers();
                const found = usersData.users.find(u => u.email === email);
                if (found) {
                    userId = found.id;
                    console.log("Found existing user ID:", userId);
                    // Update password if needed?
                    await supabase.auth.admin.updateUserById(userId, { password: password });
                    console.log("Password updated.");
                }
            }
        }

        if (!userId) {
            console.error("❌ Could not get User ID.");
            return;
        }

        console.log('✅ User ID:', userId);

        // 2. Ensure Profile
        const { error: profileError } = await supabase
            .from('profiles')
            .upsert({
                id: userId,
                email: email,
                role: 'admin',
                is_admin: true,
                full_name: 'Suporte ProfePlan',
                plan_tier: 'gold',
                credits: 9999
            });

        if (profileError) {
            console.error('❌ Profile Error:', profileError.message);
        } else {
            console.log('✅ Profile SUCCESS.');
        }

    } catch (err) {
        console.error('❌ Crash:', err);
    }
}

createSupportUser();
