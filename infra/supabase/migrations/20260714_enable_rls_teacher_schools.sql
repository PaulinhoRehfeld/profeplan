-- ==============================================================================
-- FIX: teacher_schools tinha policies criadas mas RLS nunca foi habilitada
-- Date: 2026-07-14
-- ==============================================================================
-- Achado pelo Database Linter do Supabase (Advisors): a tabela já tinha 5
-- policies corretas ("Teachers view own school links", "Managers add teachers
-- to their school", etc.) mas sem ALTER TABLE ... ENABLE ROW LEVEL SECURITY,
-- então nenhuma delas era de fato aplicada — qualquer requisição lia/escrevia
-- livremente. Só precisa ligar o RLS; as policies já existem e não são
-- alteradas aqui.
-- ==============================================================================

ALTER TABLE public.teacher_schools ENABLE ROW LEVEL SECURITY;

-- Verificação:
SELECT relrowsecurity, relforcerowsecurity FROM pg_class WHERE oid = 'public.teacher_schools'::regclass;
