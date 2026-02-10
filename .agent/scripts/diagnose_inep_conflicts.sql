-- =====================================================
-- DIAGNÓSTICO: Verificar Colisões de INEP
-- =====================================================

-- Ver quais escolas correspondem aos nomes que estamos buscando
SELECT 
    name,
    inep_code,
    city
FROM schools
WHERE name ILIKE '%querubim%'
   OR name ILIKE '%antonio lago%'
   OR name ILIKE '%domingos pimenta%'
ORDER BY name;

-- Ver se os INEPs que queremos usar já existem
SELECT 
    inep_code,
    name,
    city,
    COUNT(*) as duplicates
FROM schools
WHERE inep_code IN (
    '023299', '205893', '184381', '184462', '184403', 
    '184420', '184578', '184527', '184608', '246336',
    '184551', '184543', '184519', '184632', '184616'
)
GROUP BY inep_code, name, city
ORDER BY inep_code;

-- Ver escolas duplicadas por nome
SELECT 
    name,
    COUNT(*) as total
FROM schools
WHERE name ILIKE '%querubim%'
   OR name ILIKE '%antonio lago%'
   OR name ILIKE '%domingos pimenta%'
GROUP BY name
HAVING COUNT(*) > 1;
