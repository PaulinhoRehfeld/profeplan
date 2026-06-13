const { Client } = require('pg');

async function testConnection(url) {
  const client = new Client({ connectionString: url });
  try {
    await client.connect();
    const res = await client.query('SELECT current_user, version()');
    console.log(`[SUCCESS] Connected to ${url.split('@')[1]}`);
    console.log(`User: ${res.rows[0].current_user}`);
    console.log(`Version: ${res.rows[0].version}`);
    await client.end();
  } catch (err) {
    console.error(`[ERROR] Failed to connect to ${url.split('@')[1]}`);
    console.error(err.message);
  }
}

async function main() {
  const oldDbUrl = process.argv[2];
  const newDbUrl = process.argv[3];
  
  if (oldDbUrl) {
    console.log('Testing Old DB...');
    await testConnection(oldDbUrl);
  }
  
  if (newDbUrl) {
    console.log('Testing New DB...');
    await testConnection(newDbUrl);
  }
}

main();
