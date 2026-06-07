const fs = require('fs');
const path = require('path');
const { createClient } = require('@supabase/supabase-js');

// Load env variables
const webEnvPath = path.resolve(__dirname, '../../apps/web/.env.local');
let supabaseUrl = '';
let supabaseAnonKey = '';
if (fs.existsSync(webEnvPath)) {
  const envContent = fs.readFileSync(webEnvPath, 'utf8');
  envContent.split('\n').forEach((line) => {
    const match = line.match(/^\s*([\w.\-]+)\s*=\s*(.*)?\s*$/);
    if (match) {
      const key = match[1];
      let value = match[2] || '';
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      if (key === 'NEXT_PUBLIC_SUPABASE_URL') supabaseUrl = value;
      if (key === 'NEXT_PUBLIC_SUPABASE_ANON_KEY') supabaseAnonKey = value;
    }
  });
}

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Supabase config not found.');
  process.exit(1);
}

const email = 'profeplan.teste@gmail.com';
const password = 'Password123!';

async function main() {
  console.log(`Connecting to Supabase at ${supabaseUrl}...`);
  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: { persistSession: false },
  });

  console.log(`Testing login for ${email}...`);
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    console.error('Login failed with error:');
    console.error(error);
  } else {
    console.log('Login succeeded! User ID:', data.user.id);
  }
}

main().catch(console.error);
