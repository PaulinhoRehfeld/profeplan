const fs = require('fs');
const path = require('path');

// Lê o arquivo JSON com as escolas
const escolasPath = path.join(__dirname, '..', '..', 'importador-escolas', 'banco_escolas_pronto.json');
const todasEscolas = JSON.parse(fs.readFileSync(escolasPath, 'utf8'));

console.log(`📊 Total de escolas no arquivo: ${todasEscolas.length}`);

// FILTRO INTELIGENTE POR TIPO DE ESCOLA
// Como os dados de etapas não estão preenchidos, vamos filtrar por tipo:
//
// INCLUIR:
// - EE (Escola Estadual) → geralmente tem Fundamental 2 e Médio
// - CESEC (Centro Estadual de Educação Continuada) → EJA Médio
// - INSTITUTO ESTADUAL → geralmente técnico/profissionalizante
//
// EXCLUIR:
// - Escolas só de Fundamental 1 (menos comum em estaduais)
// - Infantil (não há estadual de infantil em MG)

const escolasFiltradas = todasEscolas.filter(escola => {
    const nome = escola.nome.toUpperCase();

    // Lista de termos que indicam escola relevante
    const termosRelevantes = [
        'EE ',           // Escola Estadual
        'CESEC',         // Centro de Educação Continuada
        'INSTITUTO',     // Instituto (geralmente técnico)
        'POLIVALENTE',   // Escola Polivalente
        'EDUCANDÁRIO',   // Educandário Estadual
    ];

    // Verifica se o nome contém algum termo relevante
    const isRelevante = termosRelevantes.some(termo => nome.includes(termo));

    return isRelevante;
});

console.log(`✅ Escolas filtradas: ${escolasFiltradas.length}`);
console.log(`📉 Redução: ${todasEscolas.length - escolasFiltradas.length} escolas removidas`);

// Estatísticas por tipo
const ee = escolasFiltradas.filter(e => e.nome.toUpperCase().includes('EE ')).length;
const cesec = escolasFiltradas.filter(e => e.nome.toUpperCase().includes('CESEC')).length;
const instituto = escolasFiltradas.filter(e => e.nome.toUpperCase().includes('INSTITUTO')).length;

console.log(`\n📚 Estatísticas por tipo:`);
console.log(`   - Escolas Estaduais (EE): ${ee}`);
console.log(`   - CESEC (Educação Continuada): ${cesec}`);
console.log(`   - Institutos: ${instituto}`);

// Função para escapar strings SQL
function escapeSql(str) {
    if (!str) return "NULL";
    return "'" + String(str).replace(/'/g, "''") + "'";
}

// Gera o arquivo SQL FILTRADO
const sqlPath = path.join(__dirname, '..', 'supabase', 'migrations', '20260124_import_schools_mg_filtered.sql');
let sql = `-- ============================================================================
-- MIGRATION: Importação de Escolas de Minas Gerais (FILTRADAS)
-- Date: 2024-01-24
-- Source: Catálogo INEP/Censo Escolar
-- Filtro: Escolas Estaduais (EE), CESEC e Institutos
-- Justificativa: Escolas estaduais de MG oferecem Ensino Fundamental 2 e Médio
-- Total Original: ${todasEscolas.length} escolas
-- Total Filtrado: ${escolasFiltradas.length} escolas (~${Math.round(escolasFiltradas.length / todasEscolas.length * 100)}%)
-- ============================================================================

-- IMPORTANTE: Este arquivo contém apenas escolas relevantes para o ProfePlan
-- (Escolas Estaduais, CESEC e Institutos que atendem Fund. 2 e/ou Médio)

-- Limpar tabela antes de importar (CUIDADO: remove dados existentes)
-- TRUNCATE TABLE schools CASCADE;

-- Importação em lotes
BEGIN;

`;

let lote = [];
const tamanhoLote = 500;
let totalProcessado = 0;

for (const escola of escolasFiltradas) {
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
        console.log(`✅ Gerados: ${totalProcessado} / ${escolasFiltradas.length}`);
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
    COUNT(*) as total_escolas_filtradas,
    COUNT(DISTINCT city) as total_cidades,
    COUNT(DISTINCT sre) as total_sres
FROM schools;

-- Estatísticas por tipo de escola
SELECT 
    CASE 
        WHEN name LIKE 'EE %' THEN 'Escola Estadual'
        WHEN name LIKE '%CESEC%' THEN 'CESEC'
        WHEN name LIKE '%INSTITUTO%' THEN 'Instituto'
        ELSE 'Outros'
    END as tipo_escola,
    COUNT(*) as quantidade
FROM schools
GROUP BY tipo_escola
ORDER BY quantidade DESC;

-- Exemplos de escolas importadas
SELECT id, name, city, sre FROM schools LIMIT 10;

-- OBSERVAÇÃO:
-- Este arquivo importou apenas escolas estaduais de MG que oferecem:
-- - Ensino Fundamental Anos Finais (Fund. 2)
-- - Ensino Médio 
-- - Educação de Jovens e Adultos (EJA)
-- - Ensino Técnico/Profissionalizante
-- Total: ${escolasFiltradas.length} de ${todasEscolas.length} escolas (${Math.round(escolasFiltradas.length / todasEscolas.length * 100)}%)
`;

// Salva o arquivo SQL filtrado
fs.writeFileSync(sqlPath, sql, 'utf8');

console.log(`\n🎉 Arquivo SQL FILTRADO gerado com sucesso!`);
console.log(`📁 Local: ${sqlPath}`);
console.log(`📊 Total: ${escolasFiltradas.length} escolas (${Math.round(escolasFiltradas.length / todasEscolas.length * 100)}% do total)`);
console.log(`\n✅ Este arquivo contém apenas escolas relevantes para o ProfePlan`);
console.log(`✅ Execute este arquivo no SQL Editor do Supabase`);
