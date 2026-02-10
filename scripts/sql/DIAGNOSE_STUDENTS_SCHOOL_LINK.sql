-- DIAGNÓSTICO: Alunos com current_school_id NULL
-- Executar no Supabase SQL Editor

-- 1) Contar alunos invisíveis (sem escola)
SELECT count(*) as alunos_invisiveis FROM students WHERE current_school_id IS NULL;

-- 2) Se houver nulos, obter primeira escola cadastrada
SELECT id, name FROM schools ORDER BY created_at ASC LIMIT 1;

-- 3) Listar escolas existentes (para referência)
SELECT id, name FROM schools LIMIT 10;

-- 4) Contar alunos por status de school_id
SELECT 
  CASE WHEN current_school_id IS NULL THEN 'SEM ESCOLA' ELSE 'COM ESCOLA' END as status,
  count(*) as total
FROM students
GROUP BY status;
