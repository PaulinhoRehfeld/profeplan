const fs = require('fs');
const path = require('path');

// Lê o arquivo JSON com as escolas
const escolasPath = path.join(__dirname, '..', '..', 'importador-escolas', 'banco_escolas_pronto.json');
const todasEscolas = JSON.parse(fs.readFileSync(escolasPath, 'utf8'));

console.log(`📊 Total de escolas no arquivo: ${todasEscolas.length}`);

// FILTRO INTELIGENTE POR TIPO DE ESCOLA
const escolasFiltradas = todasEscolas.filter(escola => {
    const nome = escola.nome.toUpperCase();
    const termosRelevantes = ['EE ', 'CESEC', 'INSTITUTO', 'POLIVALENTE', 'EDUCANDÁRIO'];
    return termosRelevantes.some(termo => nome.includes(termo));
});

console.log(`✅ Escolas filtradas: ${escolasFiltradas.length}`);

// Função para escapar strings SQL
function escapeSql(str) {
    if (!str) return "NULL";
    return "'" + String(str).replace(/'/g, "''") + "'";
}

// Gera o arquivo SQL CORRIGIDO para estrutura real
const sqlPath = path.join(__dirname, '..', 'supabase', 'migrations', '20260124_import_schools_mg_fixed.sql');
let sql = `-- ============================================================================
-- MIGRATION: Importação de Escolas de Minas Gerais (CORRIGIDO)
-- Date: 2024-01-24
-- Estrutura: id=UUID (auto), inep_code=TEXT, name=TEXT, city=TEXT, sre=TEXT
-- Total: ${escolasFiltradas.length} escolas
-- ============================================================================

BEGIN;

`;

let lote = [];
const tamanhoLote = 500;
let totalProcessado = 0;

for (const escola of escolasFiltradas) {
    // Ajustado para estrutura real: inep_code ao invés de id
    const values = `(
        ${escapeSql(escola.id)},
        ${escapeSql(escola.nome)},
        ${escapeSql(escola.cidade)},
        ${escapeSql(escola.sre)}
    )`;

    lote.push(values);

    if (lote.length >= tamanhoLote) {
        // IMPORTANTE: Usando inep_code agora, não id
        sql += `INSERT INTO schools (inep_code, name, city, sre)\nVALUES\n`;
        sql += lote.join(',\n');
        sql += '\nON CONFLICT (inep_code) DO UPDATE SET\n';
        sql += '    name = EXCLUDED.name,\n';
        sql += '    city = EXCLUDED.city,\n';
        sql += '    sre = EXCLUDED.sre;\n\n';

        totalProcessado += lote.length;
        console.log(`✅ Gerados: ${totalProcessado} / ${escolasFiltradas.length}`);
        lote = [];
    }
}

if (lote.length > 0) {
    sql += `INSERT INTO schools (inep_code, name, city, sre)\nVALUES\n`;
    sql += lote.join(',\n');
    sql += '\nON CONFLICT (inep_code) DO UPDATE SET\n';
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

SELECT inep_code, name, city, sre FROM schools LIMIT 10;
`;

fs.writeFileSync(sqlPath, sql, 'utf8');

console.log(`\n🎉 SQL CORRIGIDO gerado!`);
console.log(`📁 ${sqlPath}`);
console.log(`🔧 Ajustado para: inep_code (TEXT) ao invés de id (UUID)`);
