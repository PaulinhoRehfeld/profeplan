-- Investigar escolas de Capelinha
-- Vamos buscar por todas as formas possíveis

-- 1. Buscar por city = 'CAPELINHA'
SELECT id, name, city, sre
FROM schools
WHERE city ILIKE '%capelinha%'
ORDER BY name;

-- 2. Buscar por nome que contenha as escolas que você mencionou
SELECT id, name, city, sre
FROM schools
WHERE name ILIKE '%domingos%pimenta%'
   OR name ILIKE '%antonio%lago%'
   OR name ILIKE '%benito%rocha%'
   OR name ILIKE '%coronel%coelho%'
   OR name ILIKE '%cesec%capelinha%'
ORDER BY name;

-- 3. Buscar por SRE que pode indicar região de Capelinha
SELECT id, name, city, sre
FROM schools
WHERE sre ILIKE '%capelinha%'
ORDER BY name;

-- 4. Ver TODAS as escolas que têm city NULL mas podem ser de Capelinha
SELECT id, name, city, sre
FROM schools
WHERE (city IS NULL OR city = '')
  AND (
    name ILIKE '%capelinha%'
    OR sre ILIKE '%capelinha%'
    OR name ILIKE '%domingos%pimenta%'
    OR name ILIKE '%antonio%lago%'
  )
ORDER BY name;
