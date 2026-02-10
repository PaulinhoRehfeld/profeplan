-- =====================================================
-- DIAGNÓSTICO: Escolas com INEP null
-- =====================================================

-- Ver escolas com "WALDOMIRO" ou "DOMINGOS"
SELECT 
    name,
    inep_code,
    city
FROM schools
WHERE name ILIKE '%waldomiro%'
   OR name ILIKE '%domingos%'
ORDER BY name;

-- Total de escolas SEM inep
SELECT COUNT(*) as total_sem_inep
FROM schools
WHERE inep_code IS NULL;

-- Total de escolas COM inep
SELECT COUNT(*) as total_com_inep
FROM schools
WHERE inep_code IS NOT NULL;
