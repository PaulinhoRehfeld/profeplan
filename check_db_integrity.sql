-- ==============================================================================
-- SCRIPT DE DIAGNÓSTICO DE DADOS
-- ==============================================================================

-- 1. Verificar seu perfil e qual escola você está vinculado
SELECT id, email, role, school_id 
FROM public.profiles 
WHERE email = 'prehfeld@hotmail.com'; -- Substitua pelo seu email se diferente

-- 2. Verificar os últimos 10 alunos cadastrados (e qual escola eles têm)
SELECT id, name, current_school_id, created_at 
FROM public.students 
ORDER BY created_at DESC 
LIMIT 10;

-- 3. Verificar se ainda existem alunos "órfãos" (sem escola)
SELECT count(*) as alunos_sem_escola 
FROM public.students 
WHERE current_school_id IS NULL;
