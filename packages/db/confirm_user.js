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

const email = 'professor@profeplan.com';

async function main() {
  const url = process.env.DIRECT_URL || connectionString;
  console.log('Connecting to database...');
  const client = new Client({ connectionString: url });
  await client.connect();

  try {
    console.log(`Checking auth.users table for ${email}...`);
    const checkRes = await client.query(
      'SELECT id, email, email_confirmed_at FROM auth.users WHERE email = $1',
      [email]
    );
    if (checkRes.rows.length === 0) {
      console.log(`User ${email} not found in auth.users.`);
      process.exit(1);
    }

    console.log('User found:', checkRes.rows[0]);

    console.log(`Updating auth.users to confirm email for ${email}...`);
    const updateRes = await client.query(
      'UPDATE auth.users SET email_confirmed_at = NOW(), updated_at = NOW() WHERE email = $1',
      [email]
    );
    console.log('Update query executed successfully. Row count affected:', updateRes.rowCount);

    const doubleCheck = await client.query(
      'SELECT id, email, email_confirmed_at FROM auth.users WHERE email = $1',
      [email]
    );
    console.log('Double check result:', doubleCheck.rows[0]);
  } catch (err) {
    console.error('Error updating auth database:', err);
  } finally {
    await client.end();
  }
}

main().catch(console.error);
