const fs = require('fs');
const path = require('path');

// Lê o arquivo JSON com as escolas
const escolasPath = path.join(__dirname, '..', '..', 'importador-escolas', 'banco_escolas_pronto.json');
const escolas = JSON.parse(fs.readFileSync(escolasPath, 'utf8'));

console.log(`📊 Processando ${escolas.length} escolas...`);

// Função para escapar strings SQL (evitar SQL injection)
function escapeSql(str) {
    if (!str) return "NULL";
    return "'" + String(str).replace(/'/g, "''") + "'";
}

// Gera o arquivo SQL
const sqlPath = path.join(__dirname, '..', 'supabase', 'migrations', '20260124_import_schools_mg.sql');
let sql = `-- ============================================================================
-- MIGRATION: Importação de Escolas de Minas Gerais
-- Date: 2024-01-24
-- Source: Catálogo INEP/Censo Escolar
-- Total: ${escolas.length} escolas
-- ============================================================================

-- Limpar tabela antes de importar (CUIDADO: remove dados existentes)
-- TRUNCATE TABLE schools CASCADE;

-- Importação em lotes
BEGIN;

`;

let lote = [];
const tamanhoLote = 500; // Insere 500 de cada vez
let totalProcessado = 0;

for (const escola of escolas) {
    // Prepara os valores
    const values = `(
        ${escapeSql(escola.id)},
        ${escapeSql(escola.nome)},
        ${escapeSql(escola.cidade)},
        ${escapeSql(escola.sre)}
    )`;

    lote.push(values);

    // Quando o lote encher, gera o INSERT
    if (lote.length >= tamanhoLote) {
        sql += `INSERT INTO schools (id, name, city, sre)\nVALUES\n`;
        sql += lote.join(',\n');
        sql += '\nON CONFLICT (id) DO UPDATE SET\n';
        sql += '    name = EXCLUDED.name,\n';
        sql += '    city = EXCLUDED.city,\n';
        sql += '    sre = EXCLUDED.sre;\n\n';

        totalProcessado += lote.length;
        console.log(`✅ Gerados: ${totalProcessado} / ${escolas.length}`);
        lote = [];
    }
}

// Insere o restante
if (lote.length > 0) {
    sql += `INSERT INTO schools (id, name, city, sre)\nVALUES\n`;
    sql += lote.join(',\n');
    sql += '\nON CONFLICT (id) DO UPDATE SET\n';
    sql += '    name = EXCLUDED.name,\n';
    sql += '    city = EXCLUDED.city,\n';
    sql += '    sre = EXCLUDED.sre;\n\n';
}

sql += `COMMIT;

-- Verificação
SELECT 
    COUNT(*) as total_escolas,
    COUNT(DISTINCT city) as total_cidades,
    COUNT(DISTINCT sre) as total_sres
FROM schools;

-- Exemplos de escolas importadas
SELECT * FROM schools LIMIT 10;
`;

// Salva o arquivo SQL
fs.writeFileSync(sqlPath, sql, 'utf8');

console.log(`\n🎉 Arquivo SQL gerado com sucesso!`);
console.log(`📁 Local: ${sqlPath}`);
console.log(`📊 Total: ${escolas.length} escolas`);
console.log(`\n✅ Execute este arquivo no SQL Editor do Supabase`);
