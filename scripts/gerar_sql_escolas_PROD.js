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

// Gera o arquivo SQL PARA ESTRUTURA PROD (id, name, city, sre)
const sqlPath = path.join(__dirname, '..', 'supabase', 'migrations', '20260124_import_schools_mg_PROD.sql');
let sql = `-- ============================================================================
-- MIGRATION: Importação de Escolas de Minas Gerais (PRODUÇÃO)
-- Date: 2024-01-24
-- Estrutura PROD: id=TEXT (código INEP), name=TEXT, city=TEXT, sre=TEXT
-- Total: ${escolasFiltradas.length} escolas
-- ============================================================================

BEGIN;

`;

let lote = [];
const tamanhoLote = 500;
let totalProcessado = 0;

for (const escola of escolasFiltradas) {
    // Para PROD: usa 'id' direto (não inep_code)
    const values = `(
        ${escapeSql(escola.id)},
        ${escapeSql(escola.nome)},
        ${escapeSql(escola.cidade)},
        ${escapeSql(escola.sre)}
    )`;

    lote.push(values);

    if (lote.length >= tamanhoLote) {
        // PROD usa 'id' como primary key (TEXT)
        sql += `INSERT INTO schools (id, name, city, sre)\nVALUES\n`;
        sql += lote.join(',\n');
        sql += '\nON CONFLICT (id) DO UPDATE SET\n';
        sql += '    name = EXCLUDED.name,\n';
        sql += '    city = EXCLUDED.city,\n';
        sql += '    sre = EXCLUDED.sre;\n\n';

        totalProcessado += lote.length;
        console.log(`✅ Gerados: ${totalProcessado} / ${escolasFiltradas.length}`);
        lote = [];
    }
}

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

SELECT id, name, city, sre FROM schools LIMIT 10;
`;

fs.writeFileSync(sqlPath, sql, 'utf8');

console.log(`\n🎉 SQL para PROD gerado!`);
console.log(`📁 ${sqlPath}`);
console.log(`🔧 Ajustado para estrutura PROD: id (TEXT) ao invés de inep_code`);
