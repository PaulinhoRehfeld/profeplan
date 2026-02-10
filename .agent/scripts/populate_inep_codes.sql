-- =====================================================
-- MIGRATION: Popular INEP - VERSÃO SEGURA
-- UPDATEs com nome completo e cidade para evitar conflitos
-- =====================================================

-- 1. Capelinha - Antônio Lago (buscar nome mais específico)
UPDATE schools SET inep_code = '023299', city = 'CAPELINHA' 
WHERE name ILIKE '%professor antônio lago%' 
AND city ILIKE '%capelinha%'
AND inep_code IS NULL;

-- 2. Contagem - Domingos Pimenta (nome específico para evitar "Domingos Pimenta de Figueiredo")
UPDATE schools SET inep_code = '205893', city = 'CONTAGEM' 
WHERE name = 'EE DOMINGOS PIMENTA DE SOUZA'
AND inep_code IS NULL;

-- 3. Águas Vermelhas - Coronel José Venâncio
UPDATE schools SET inep_code = '184381', city = 'ÁGUAS VERMELHAS' 
WHERE name ILIKE '%coronel josé venâncio%'
AND city ILIKE '%águas vermelhas%'
AND inep_code IS NULL;

-- 4. Águas Vermelhas - Itamarati
UPDATE schools SET inep_code = '184462', city = 'ÁGUAS VERMELHAS' 
WHERE name ILIKE '%itamarati%'
AND city ILIKE '%águas vermelhas%'
AND inep_code IS NULL;

-- 5. Águas Vermelhas - Machado Mineiro
UPDATE schools SET inep_code = '184403', city = 'ÁGUAS VERMELHAS' 
WHERE name ILIKE '%machado mineiro%'
AND city ILIKE '%águas vermelhas%'
AND inep_code IS NULL;

-- 6. Águas Vermelhas - Joaquim Fernandes Abade
UPDATE schools SET inep_code = '184420', city = 'ÁGUAS VERMELHAS' 
WHERE name ILIKE '%joaquim fernandes abade%'
AND city ILIKE '%águas vermelhas%'
AND inep_code IS NULL;

-- 7. Almenara - CESEC Querubim (nome completo!)
UPDATE schools SET inep_code = '184578', city = 'ALMENARA' 
WHERE name = 'CESEC QUERUBIM FRÓES OTONI'
AND inep_code IS NULL;

-- 8. Almenara - Conde Afonso Celso
UPDATE schools SET inep_code = '184527', city = 'ALMENARA' 
WHERE name ILIKE '%conde afonso celso%'
AND city ILIKE '%almenara%'
AND inep_code IS NULL;

-- 9. Almenara - Pedra Grande
UPDATE schools SET inep_code = '184608', city = 'ALMENARA' 
WHERE name ILIKE '%pedra grande%'
AND city ILIKE '%almenara%'
AND inep_code IS NULL;

-- 10. Almenara - Joel Mares
UPDATE schools SET inep_code = '246336', city = 'ALMENARA' 
WHERE name ILIKE '%joel mares%'
AND city ILIKE '%almenara%'
AND inep_code IS NULL;

-- 11. Almenara - Joviano Naves
UPDATE schools SET inep_code = '184551', city = 'ALMENARA' 
WHERE name ILIKE '%joviano naves%'
AND city ILIKE '%almenara%'
AND inep_code IS NULL;

-- 12. Almenara - Laudelina Dias
UPDATE schools SET inep_code = '184543', city = 'ALMENARA' 
WHERE name ILIKE '%laudelina dias%'
AND city ILIKE '%almenara%'
AND inep_code IS NULL;

-- 13. Almenara - Tancredo Neves
UPDATE schools SET inep_code = '184519', city = 'ALMENARA' 
WHERE name ILIKE '%tancredo neves%' 
AND city ILIKE '%almenara%'
AND inep_code IS NULL;

-- 14. Bandeira - João dos Santos Amaral
UPDATE schools SET inep_code = '184632', city = 'BANDEIRA' 
WHERE name ILIKE '%joão dos santos amaral%'
AND city ILIKE '%bandeira%'
AND inep_code IS NULL;

-- 15. Cachoeira de Pajeú - Barão do Rio Branco
UPDATE schools SET inep_code = '184616', city = 'CACHOEIRA DE PAJEÚ' 
WHERE name ILIKE '%barão do rio branco%' 
AND city ILIKE '%pajeú%'
AND inep_code IS NULL;

-- =====================================================
-- VERIFICAÇÃO: Escolas Atualizadas
-- =====================================================

SELECT 
    name,
    inep_code,
    city,
    LENGTH(inep_code) as tam
FROM schools
WHERE inep_code IN (
    '023299', '205893', '184381', '184462', '184403', 
    '184420', '184578', '184527', '184608', '246336',
    '184551', '184543', '184519', '184632', '184616'
)
ORDER BY city, name;

-- Total atualizado
SELECT COUNT(*) as total_com_inep FROM schools WHERE inep_code IS NOT NULL;
