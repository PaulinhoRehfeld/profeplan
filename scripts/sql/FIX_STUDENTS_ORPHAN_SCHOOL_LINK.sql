-- CORREÇÃO: Vincular alunos órfãos à escola padrão
-- Executar no Supabase SQL Editor (APENAS SE HOUVER NULOS)

SET search_path = public;

-- 1) Obter primeira escola (padrão)
WITH default_school AS (
  SELECT id FROM schools ORDER BY created_at ASC LIMIT 1
)

-- 2) Atualizar todos os alunos sem escola
UPDATE students s
SET current_school_id = (SELECT id FROM default_school)
WHERE s.current_school_id IS NULL;

-- 3) Verificação pós-correção
SELECT 
  CASE WHEN current_school_id IS NULL THEN 'SEM ESCOLA' ELSE 'COM ESCOLA' END as status,
  count(*) as total
FROM students
GROUP BY status;

-- 4) Resultado esperado: "COM ESCOLA" = total anterior, "SEM ESCOLA" = 0
