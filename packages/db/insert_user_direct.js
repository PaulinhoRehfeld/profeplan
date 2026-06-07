const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

const envPath = path.resolve(__dirname, '.env');
console.log('Reading DB env from:', envPath);
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf8');
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
const userId = 'd1111111-1111-4111-d111-111111111111'; // Static UUID for simplicity

async function main() {
  const url = process.env.DIRECT_URL || connectionString;
  console.log('Connecting to database...');
  const client = new Client({ connectionString: url });
  await client.connect();

  try {
    await client.query('BEGIN');

    // 1. Cleanup existing user
    console.log('Cleaning up existing user...');
    await client.query('DELETE FROM "TermPlan" WHERE "ownerId" = $1', [userId]);
    await client.query('DELETE FROM "Membership" WHERE "userId" = $1', [userId]);
    await client.query('DELETE FROM "User" WHERE id = $1', [userId]);
    await client.query('DELETE FROM "User" WHERE email = $1', [email]);
    await client.query('DELETE FROM auth.users WHERE email = $1', [email]);
    await client.query('DELETE FROM auth.users WHERE id = $1', [userId]);

    // 2. Insert into auth.users using crypt for password hashing
    console.log('Inserting into auth.users...');
    // Enable pgcrypto just in case
    await client.query('CREATE EXTENSION IF NOT EXISTS pgcrypto');

    const insertAuthUserSql = `
      INSERT INTO auth.users (
        id,
        instance_id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        created_at,
        updated_at,
        raw_app_meta_data,
        raw_user_meta_data,
        is_super_admin,
        is_sso_user,
        is_anonymous
      ) VALUES (
        $1,
        '00000000-0000-0000-0000-000000000000',
        'authenticated',
        'authenticated',
        $2,
        crypt($3, gen_salt('bf', 10)),
        NOW(),
        NOW(),
        NOW(),
        '{"provider": "email", "providers": ["email"]}'::jsonb,
        $4::jsonb,
        false,
        false,
        false
      )
    `;
    const userMetadata = JSON.stringify({ full_name: fullName });
    await client.query(insertAuthUserSql, [userId, email, password, userMetadata]);
    console.log('Successfully inserted into auth.users.');

    // 3. Create public User
    console.log('Creating User in public schema...');
    await client.query(
      'INSERT INTO "User" (id, email, "fullName", "createdAt", "updatedAt") VALUES ($1, $2, $3, NOW(), NOW())',
      [userId, email, fullName]
    );

    // 4. Get or create Organization
    let orgId = '';
    const orgCheck = await client.query('SELECT id FROM "Organization" WHERE slug = $1', [orgSlug]);
    if (orgCheck.rows.length > 0) {
      orgId = orgCheck.rows[0].id;
      console.log(`Using existing organization escola-modelo with ID: ${orgId}`);
    } else {
      orgId = 'b9999999-9999-4999-b999-999999999999';
      console.log(`Creating Organization ${orgName}...`);
      await client.query(
        'INSERT INTO "Organization" (id, name, slug, "createdAt", "updatedAt") VALUES ($1, $2, $3, NOW(), NOW())',
        [orgId, orgName, orgSlug]
      );
    }

    // 5. Create Membership
    const memId = 'c7777777-7777-4777-c777-777777777777';
    console.log('Creating Membership...');
    await client.query(
      'INSERT INTO "Membership" (id, "userId", "organizationId", role, "createdAt") VALUES ($1, $2, $3, \'OWNER\', NOW())',
      [memId, userId, orgId]
    );

    await client.query('COMMIT');
    console.log('\nDirect database seed successfully completed!');
    console.log(`User: ${email}`);
    console.log(`Password: ${password}`);
    console.log(`Organization: Escola Modelo (escola-modelo)`);
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error during direct database seed:', err);
  } finally {
    await client.end();
  }
}

main().catch(console.error);
