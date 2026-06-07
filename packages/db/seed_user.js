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

const email = 'professor@profeplan.com';
const password = 'Password123!';
const fullName = 'Professor Teste';
const orgName = 'Escola Modelo';
const orgSlug = 'escola-modelo';

async function main() {
  // 1. SignUp/SignIn in Supabase
  console.log(`Connecting to Supabase at ${supabaseUrl}...`);
  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: { persistSession: false },
  });

  console.log(`Registering / Authenticating user ${email} in Supabase Auth...`);
  let authUserId = '';

  // Try to sign up first
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
    if (signUpRes.error.message.includes('already registered') || signUpRes.error.status === 400) {
      console.log('User already registered in Supabase. Attempting login to retrieve user id...');
      const signInRes = await supabase.auth.signInWithPassword({ email, password });
      if (signInRes.error) {
        console.error('Failed to login existing user in Supabase:', signInRes.error.message);
        process.exit(1);
      }
      authUserId = signInRes.data.user.id;
      console.log(`Successfully authenticated! User ID is: ${authUserId}`);
    } else {
      console.error('Failed to sign up user in Supabase:', signUpRes.error.message);
      process.exit(1);
    }
  } else {
    authUserId = signUpRes.data.user.id;
    console.log(`Successfully registered! User ID is: ${authUserId}`);
  }

  // 2. Connect to postgres and insert the User, Organization, and Membership records
  const url = process.env.DIRECT_URL || connectionString;
  console.log('Connecting to database...');
  const client = new Client({ connectionString: url });
  await client.connect();

  try {
    // Start transaction
    await client.query('BEGIN');

    // Check if user already exists in Postgres
    const userCheck = await client.query('SELECT id FROM "User" WHERE email = $1', [email]);
    let pgUserId = '';

    if (userCheck.rows.length > 0) {
      pgUserId = userCheck.rows[0].id;
      console.log(`User ${email} already exists in Postgres database with ID: ${pgUserId}`);
    } else {
      // Use the supabase auth user id as postgres user id, or default UUID
      pgUserId = authUserId || 'a8888888-8888-4888-a888-888888888888';
      console.log(`Inserting user ${email} into Postgres...`);
      await client.query(
        'INSERT INTO "User" (id, email, "fullName", "createdAt", "updatedAt") VALUES ($1, $2, $3, NOW(), NOW())',
        [pgUserId, email, fullName]
      );
    }

    // Check if organization exists
    const orgCheck = await client.query('SELECT id FROM "Organization" WHERE slug = $1', [orgSlug]);
    let pgOrgId = '';

    if (orgCheck.rows.length > 0) {
      pgOrgId = orgCheck.rows[0].id;
      console.log(`Organization ${orgSlug} already exists in Postgres with ID: ${pgOrgId}`);
    } else {
      pgOrgId = 'b9999999-9999-4999-b999-999999999999';
      console.log(`Inserting organization ${orgSlug} into Postgres...`);
      await client.query(
        'INSERT INTO "Organization" (id, name, slug, "createdAt", "updatedAt") VALUES ($1, $2, $3, NOW(), NOW())',
        [pgOrgId, orgName, orgSlug]
      );
    }

    // Check if membership exists
    const memCheck = await client.query(
      'SELECT id FROM "Membership" WHERE "userId" = $1 AND "organizationId" = $2',
      [pgUserId, pgOrgId]
    );

    if (memCheck.rows.length > 0) {
      console.log('Membership already exists in Postgres.');
    } else {
      const memId = 'c7777777-7777-4777-c777-777777777777';
      console.log('Inserting membership in Postgres...');
      await client.query(
        'INSERT INTO "Membership" (id, "userId", "organizationId", role, "createdAt") VALUES ($1, $2, $3, \'OWNER\', NOW())',
        [memId, pgUserId, pgOrgId]
      );
    }

    await client.query('COMMIT');
    console.log('\nSeed successfully completed!');
    console.log(`User: ${email}`);
    console.log(`Password: ${password}`);
    console.log(`Organization: ${orgName} (${orgSlug})`);
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error during database seed:', err);
  } finally {
    await client.end();
  }
}

main().catch(console.error);
