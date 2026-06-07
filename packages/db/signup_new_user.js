const fs = require('fs');
const path = require('path');
const { Client } = require('pg');
const { createClient } = require('@supabase/supabase-js');

// Load environment variables
const dbEnvPath = path.resolve(__dirname, '.env');
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

const connectionString = process.env.DATABASE_URL;
const oldEmail = 'professor@gmail.com';
const newEmail = 'profeplan.teste@gmail.com';
const password = 'Password123!';
const fullName = 'Professor Teste';
const orgName = 'Escola Modelo';
const orgSlug = 'escola-modelo';

async function main() {
  const url = process.env.DIRECT_URL || connectionString;
  const client = new Client({ connectionString: url });
  await client.connect();

  try {
    // 1. Cleanup the manually inserted professor@gmail.com from public and auth schemas
    console.log('Cleaning up old manual user professor@gmail.com...');
    await client.query('BEGIN');
    const oldUserRes = await client.query('SELECT id FROM auth.users WHERE email = $1', [oldEmail]);
    if (oldUserRes.rows.length > 0) {
      const oldId = oldUserRes.rows[0].id;
      await client.query('DELETE FROM "TermPlan" WHERE "ownerId" = $1', [oldId]);
      await client.query('DELETE FROM "Membership" WHERE "userId" = $1', [oldId]);
      await client.query('DELETE FROM "User" WHERE id = $1', [oldId]);
      await client.query('DELETE FROM auth.users WHERE id = $1', [oldId]);
    }
    await client.query('DELETE FROM "User" WHERE email = $1', [oldEmail]);
    await client.query('DELETE FROM auth.users WHERE email = $1', [oldEmail]);
    await client.query('COMMIT');
    console.log('Old user cleaned up successfully.');
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error cleaning up old user:', err);
  }

  try {
    // 2. Cleanup new email just in case
    console.log(`Cleaning up new email ${newEmail} just in case...`);
    await client.query('BEGIN');
    const newUserRes = await client.query('SELECT id FROM auth.users WHERE email = $1', [newEmail]);
    if (newUserRes.rows.length > 0) {
      const newId = newUserRes.rows[0].id;
      await client.query('DELETE FROM "TermPlan" WHERE "ownerId" = $1', [newId]);
      await client.query('DELETE FROM "Membership" WHERE "userId" = $1', [newId]);
      await client.query('DELETE FROM "User" WHERE id = $1', [newId]);
      await client.query('DELETE FROM auth.users WHERE id = $1', [newId]);
    }
    await client.query('DELETE FROM "User" WHERE email = $1', [newEmail]);
    await client.query('DELETE FROM auth.users WHERE email = $1', [newEmail]);
    await client.query('COMMIT');
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error cleaning up new user:', err);
  }

  // 3. Official signUp via Supabase API
  console.log(`Registering ${newEmail} via Supabase API...`);
  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: { persistSession: false },
  });

  const signUpRes = await supabase.auth.signUp({
    email: newEmail,
    password,
    options: {
      data: {
        full_name: fullName,
      },
    },
  });

  if (signUpRes.error) {
    console.error('Failed to sign up new user in Supabase:', signUpRes.error.message);
    await client.end();
    process.exit(1);
  }

  const authUserId = signUpRes.data.user.id;
  console.log(`Successfully registered! Auth User ID: ${authUserId}`);

  // 4. Confirm Email in auth.users and insert public schema records
  try {
    console.log('Confirming email in auth.users...');
    await client.query(
      'UPDATE auth.users SET email_confirmed_at = NOW(), updated_at = NOW() WHERE id = $1',
      [authUserId]
    );

    console.log('Inserting public schema records...');
    await client.query('BEGIN');

    // Create User
    await client.query(
      'INSERT INTO "User" (id, email, "fullName", "createdAt", "updatedAt") VALUES ($1, $2, $3, NOW(), NOW())',
      [authUserId, newEmail, fullName]
    );

    // Get or create organization
    let orgId = '';
    const orgCheck = await client.query('SELECT id FROM "Organization" WHERE slug = $1', [orgSlug]);
    if (orgCheck.rows.length > 0) {
      orgId = orgCheck.rows[0].id;
    } else {
      orgId = 'b9999999-9999-4999-b999-999999999999';
      await client.query(
        'INSERT INTO "Organization" (id, name, slug, "createdAt", "updatedAt") VALUES ($1, $2, $3, NOW(), NOW())',
        [orgId, orgName, orgSlug]
      );
    }

    // Create Membership
    const memId = 'c7777777-7777-4777-c777-777777777777';
    await client.query(
      'INSERT INTO "Membership" (id, "userId", "organizationId", role, "createdAt") VALUES ($1, $2, $3, \'OWNER\', NOW())',
      [memId, authUserId, orgId]
    );

    await client.query('COMMIT');
    console.log('\nSeeding completed successfully!');
    console.log(`User: ${newEmail}`);
    console.log(`Password: ${password}`);
    console.log(`Organization: Escola Modelo (escola-modelo)`);
  } catch (err) {
    console.error('Error finishing seeding:', err);
  } finally {
    await client.end();
  }
}

main().catch(console.error);
