-- ==============================================================================
-- SCRIPT DE RECUPERAÇÃO FINAL
-- ==============================================================================
-- Recupera TODOS os alunos que estão sem escola no banco de dados.
-- Vincula eles à escola 'EE PROFESSOR ANTÔNIO LAGO' (23299).

UPDATE public.students
SET current_school_id = '23299'
WHERE current_school_id IS NULL;

-- Verifica o resultado
SELECT count(*) as total_alunos_na_escola 
FROM public.students 
WHERE current_school_id = '23299';
