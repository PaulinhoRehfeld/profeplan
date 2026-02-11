const fs = require('fs');
const path = require('path');

// Read the JSON file
const jsonPath = 'C:\\Users\\Admin\\PROFEPLAN\\ESCOLASMG\\banco_escolas_mg_filtrado.json';
const outputPath = path.join(__dirname, 'update_schools.sql');

console.log('Reading JSON file...');
const rawData = fs.readFileSync(jsonPath, 'utf8');
const schools = JSON.parse(rawData);

console.log(`Found ${schools.length} schools`);

// Generate SQL
let sql = `-- Update schools table with filtered data
-- Generated on ${new Date().toISOString()}
-- Total schools: ${schools.length}

-- Step 1: Truncate existing data (CAREFUL!)
TRUNCATE TABLE schools CASCADE;

-- Step 2: Insert filtered schools
`;

schools.forEach((school, index) => {
    const id = school.id.replace(/'/g, "''");
    const nome = school.nome.replace(/'/g, "''");
    const sre = school.sre ? school.sre.replace(/'/g, "''") : null;
    const cidade = school.cidade ? school.cidade.replace(/'/g, "''") : null;

    sql += `INSERT INTO schools (id, name, city, sre) VALUES ('${id}', '${nome}', ${cidade ? `'${cidade}'` : 'NULL'}, ${sre ? `'${sre}'` : 'NULL'});\n`;

    if ((index + 1) % 500 === 0) {
        console.log(`Processed ${index + 1}/${schools.length} schools...`);
    }
});

// Add statistics
sql += `\n-- Statistics
SELECT 
    COUNT(*) as total_schools,
    COUNT(DISTINCT city) as unique_cities,
    COUNT(DISTINCT sre) as unique_sres
FROM schools;
`;

// Write SQL file
fs.writeFileSync(outputPath, sql, 'utf8');
console.log(`\n✅ SQL file generated: ${outputPath}`);
console.log(`Total schools processed: ${schools.length}`);
console.log('\nNext steps:');
console.log('1. Review the generated SQL file');
console.log('2. Run it in Supabase SQL Editor');
console.log('3. Test the school selection in the app');
