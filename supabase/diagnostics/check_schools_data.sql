-- Script de diagnóstico para a tabela schools
-- Execute este script no SQL Editor do Supabase para diagnosticar o problema

-- 1. Ver quantas escolas existem
SELECT COUNT(*) as total_schools FROM schools;

-- 2. Ver todas as escolas (ordenadas alfabeticamente)
SELECT id, name, city, sre
FROM schools
ORDER BY name
LIMIT 100;

-- 3. Buscar duplicatas (mesmo nome)
SELECT name, COUNT(*) as count
FROM schools
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY count DESC
LIMIT 50;

-- 4. Procurar as escolas específicas mencionadas
SELECT * FROM schools
WHERE name ILIKE '%antonio%lago%'
   OR name ILIKE '%domingos%pimenta%';

-- 5. Ver nomes que parecem incompletos/genéricos
SELECT DISTINCT name, COUNT(*) as occurrences
FROM schools
WHERE name LIKE 'EE DE ENSINO%'
GROUP BY name
ORDER BY occurrences DESC, name
LIMIT 50;

-- 6. Ver estatísticas de qualidade de dados
SELECT 
    COUNT(*) as total,
    COUNT(DISTINCT name) as unique_names,
    COUNT(*) - COUNT(DISTINCT name) as duplicate_count,
    COUNT(CASE WHEN city IS NULL THEN 1 END) as missing_city,
    COUNT(CASE WHEN sre IS NULL THEN 1 END) as missing_sre
FROM schools;

-- 7. OPCIONAL: Se quiser limpar duplicatas e manter apenas uma de cada nome
-- CUIDADO: NÃO EXECUTE AINDA! Teste primeiro com SELECT
-- Esta query mostra QUAIS seriam deletados:
SELECT id, name, city, sre
FROM schools
WHERE id NOT IN (
    SELECT MIN(id)
    FROM schools
    GROUP BY name
)
ORDER BY name
LIMIT 100;

-- 8. Verificar integridade de chaves estrangeiras
SELECT 
    (SELECT COUNT(*) FROM profiles WHERE school_id IS NOT NULL AND school_id NOT IN (SELECT id FROM schools)) as orphan_profiles,
    (SELECT COUNT(*) FROM school_students WHERE school_id NOT IN (SELECT id FROM schools)) as orphan_students;

