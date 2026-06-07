const fs = require('fs');
const path = require('path');
const { Client } = require('pg');
const { createClient } = require('@supabase/supabase-js');

// Load environment variables from packages/db/.env
const dbEnvPath = path.resolve(__dirname, '.env');
console.log('Reading DB env from:', dbEnvPath);
if (fs.existsSync(dbEnvPath)) {
  const envContent = fs.readFileSync(dbEnvPath, 'utf8');
  envContent.split('\n').forEach((line) => {
    const match = line.match(/^\s*([\w.\-]+)\s*=\s*(.*)?\s*$/);
    if (match) {
      const key = match[1];
      let value = match[2] || '';
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      process.env[key] = value;
    }
  });
}

// Load environment variables from apps/web/.env.local for Supabase
const webEnvPath = path.resolve(__dirname, '../../apps/web/.env.local');
console.log('Reading Web env from:', webEnvPath);
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
  console.error('Supabase configuration not found in apps/web/.env.local!');
  process.exit(1);
}

const connectionString = process.env.DATABASE_URL;
if (!connectionString) {
  console.error('DATABASE_URL is not set!');
  process.exit(1);
}

const email = 'professor@gmail.com';
const password = 'Password123!';
const fullName = 'Professor Teste';
const orgName = 'Escola Modelo';
const orgSlug = 'escola-modelo';

async function main() {
  const url = process.env.DIRECT_URL || connectionString;
  console.log('Connecting to database for cleanup...');
  const client = new Client({ connectionString: url });
  await client.connect();

  let existingAuthUserId = '';
  try {
    await client.query('BEGIN');

    // Get existing auth user ID if any
    const authUserRes = await client.query('SELECT id FROM auth.users WHERE email = $1', [email]);
    if (authUserRes.rows.length > 0) {
      existingAuthUserId = authUserRes.rows[0].id;
      console.log(`Found existing auth user ${email} with ID: ${existingAuthUserId}`);
    }

    // Delete from public tables first (due to foreign key constraints, though user isn't directly cascaded)
    console.log('Deleting from public tables...');
    if (existingAuthUserId) {
      await client.query('DELETE FROM "TermPlan" WHERE "ownerId" = $1', [existingAuthUserId]);
      await client.query('DELETE FROM "Membership" WHERE "userId" = $1', [existingAuthUserId]);
      await client.query('DELETE FROM "User" WHERE id = $1', [existingAuthUserId]);
    }
    await client.query('DELETE FROM "User" WHERE email = $1', [email]);

    // Delete from auth.users
    console.log('Deleting from auth.users...');
    await client.query('DELETE FROM auth.users WHERE email = $1', [email]);

    await client.query('COMMIT');
    console.log('Cleanup completed successfully.');
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error during cleanup:', err);
    process.exit(1);
  }

  // Create client and sign up user
  console.log(`Connecting to Supabase at ${supabaseUrl}...`);
  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: { persistSession: false },
  });

  console.log(`Registering user ${email} in Supabase Auth...`);
  const signUpRes = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        full_name: fullName,
      },
    },
  });

  if (signUpRes.error) {
    console.error('Failed to sign up user in Supabase:', signUpRes.error.message);
    process.exit(1);
  }

  const authUserId = signUpRes.data.user.id;
  console.log(`Successfully registered in Supabase! Auth User ID is: ${authUserId}`);

  // Confirm email and seed database
  try {
    console.log('Directly confirming email in database...');
    await client.query(
      'UPDATE auth.users SET email_confirmed_at = NOW(), updated_at = NOW() WHERE id = $1',
      [authUserId]
    );
    console.log('User email confirmed in auth.users.');

    await client.query('BEGIN');

    // Create user in public table using authUserId as ID
    console.log('Creating User in public table...');
    await client.query(
      'INSERT INTO "User" (id, email, "fullName", "createdAt", "updatedAt") VALUES ($1, $2, $3, NOW(), NOW())',
      [authUserId, email, fullName]
    );

    // Get or create organization
    let orgId = '';
    const orgCheck = await client.query('SELECT id FROM "Organization" WHERE slug = $1', [orgSlug]);
    if (orgCheck.rows.length > 0) {
      orgId = orgCheck.rows[0].id;
      console.log(`Using existing organization escola-modelo with ID: ${orgId}`);
    } else {
      orgId = 'b9999999-9999-4999-b999-999999999999';
      console.log(`Creating Organization ${orgName} in public table...`);
      await client.query(
        'INSERT INTO "Organization" (id, name, slug, "createdAt", "updatedAt") VALUES ($1, $2, $3, NOW(), NOW())',
        [orgId, orgName, orgSlug]
      );
    }

    // Create membership
    const memId = 'c7777777-7777-4777-c777-777777777777';
    console.log('Creating Membership in public table...');
    await client.query(
      'INSERT INTO "Membership" (id, "userId", "organizationId", role, "createdAt") VALUES ($1, $2, $3, \'OWNER\', NOW())',
      [memId, authUserId, orgId]
    );

    await client.query('COMMIT');
    console.log('\nReset and seed successfully completed!');
    console.log(`User: ${email}`);
    console.log(`Password: ${password}`);
    console.log(`Organization: Escola Modelo (escola-modelo)`);
  } catch (err) {
    console.error('Error during database seeding:', err);
  } finally {
    await client.end();
  }
}

main().catch(console.error);
