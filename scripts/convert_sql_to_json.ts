
import fs from 'fs';
import path from 'path';

const sqlPath = path.resolve(__dirname, '../supabase/migrations/20260124_import_schools_mg_filtered.sql');
const jsonPath = path.resolve(__dirname, '../public/schools_data.json');

function convertSqlToJson() {
    console.log(`Reading SQL from: ${sqlPath}`);

    if (!fs.existsSync(sqlPath)) {
        console.error('SQL file not found!');
        process.exit(1);
    }

    const sqlContent = fs.readFileSync(sqlPath, 'utf-8');
    const schools: any[] = [];

    // Regex to match: ('id', 'name', 'city', 'sre')
    // The SQL format is: ('123', 'NAME', 'CITY', 'SRE')
    // Example: ( '184381', 'EE CORONEL JOSÉ VENÂNCIO DE SOUSA', 'ÁGUAS VERMELHAS', 'SRE ALMENARA' )
    // We need to be careful with quotes and newlines.

    // Improved Regex to capture the values inside parentheses
    const regex = /\(\s*'([^']+)'\s*,\s*'([^']+)'\s*,\s*'([^']+)'\s*,\s*'([^']+)'\s*\)/g;

    let match;
    let count = 0;

    while ((match = regex.exec(sqlContent)) !== null) {
        schools.push({
            id: match[1],
            name: match[2],
            city: match[3],
            sre: match[4]
        });
        count++;
    }

    console.log(`Extracted ${count} schools.`);

    if (count === 0) {
        console.error('No matches found! Regex might be incorrect or file format changed.');
        process.exit(1);
    }

    fs.writeFileSync(jsonPath, JSON.stringify(schools, null, 2), 'utf-8');
    console.log(`JSON saved to: ${jsonPath}`);
    console.log(`Size: ${(fs.statSync(jsonPath).size / 1024 / 1024).toFixed(2)} MB`);
}

convertSqlToJson();
