
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

async function createSupportUser() {
    try {
        console.log("Starting user creation script...");
        console.log("Current directory:", process.cwd());

        // Try multiple paths for .env
        const possiblePaths = [
            path.join(process.cwd(), '.env'),
            path.join(process.cwd(), '.env.local'),
            path.join(__dirname, '.env'),
            path.join(path.dirname(process.cwd()), '.env') // Parent dir?
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
                // Don't break immediately, maybe merge? Or just take the first valid one.
                // Usually local overrides.
                // Let's take the first one found for simplicity or merge if multiple.
                // For now, break if we found keys.
                if (envVars['VITE_SUPABASE_URL']) break;
            }
        }

        if (!loaded) {
            console.error("❌ No .env file found in checked paths.");
            // Print contents of current dir for debug
            console.log("Files:", fs.readdirSync(process.cwd()));
        }

        const supabaseUrl = envVars['VITE_SUPABASE_URL'];
        const serviceRoleKey = envVars['SUPABASE_SERVICE_ROLE_KEY'] || envVars['VITE_SUPABASE_SERVICE_ROLE_KEY'];

        if (!supabaseUrl || !serviceRoleKey) {
            console.error('❌ Missing Keys in .env');
            console.error('Looking for: VITE_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY');
            console.log('Found keys:', Object.keys(envVars));
            return;
        }

        console.log(`✅ Supabase URL found: ${supabaseUrl}`);
        console.log(`✅ Service Key found (length): ${serviceRoleKey.length}`);

        const supabase = createClient(supabaseUrl, serviceRoleKey);

        const email = 'suporte@profeplan.com.br';
        const password = '12348765';

        console.log(`Attempting to create user: ${email}...`);

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

        if (createError) {
            console.error('❌ Error creating user:', createError.message);
            // If user already exists, maybe update password/metadata?
            if (createError.message.includes("already registered")) {
                console.log("User exists. Attempting to update...");
                // search user logic if needed, but createUser is enough to fail.
                // We can try to list users to find ID and update.
            }
            return;
        }

        console.log('✅ User created successfully! ID:', user.user.id);

        // 2. Ensure Profile
        const { error: profileError } = await supabase
            .from('profiles')
            .upsert({
                id: user.user.id,
                email: email,
                role: 'admin',
                is_admin: true,
                full_name: 'Suporte ProfePlan',
                plan_tier: 'gold',
                credits: 9999
            });

        if (profileError) {
            console.error('❌ Error updating profile:', profileError.message);
        } else {
            console.log('✅ Profile configured as Admin Gold.');
        }

    } catch (err) {
        console.error('❌ Script crash:', err);
    }
}

createSupportUser();
