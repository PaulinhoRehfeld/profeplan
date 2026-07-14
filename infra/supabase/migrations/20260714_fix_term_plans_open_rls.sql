-- ==============================================================================
-- FIX: term_plans tinha RLS efetivamente desligada (falha de segurança)
-- Date: 2026-07-14
-- ==============================================================================
-- Achado ao investigar por que "Minhas Turmas" falhava mas "Planejamento"
-- nunca falhava com o mesmo tipo de erro: a policy real de term_plans em
-- produção é "Enable all for authenticated users", USING (true) WITH CHECK
-- (true), pra TODOS os comandos (SELECT/INSERT/UPDATE/DELETE) e TODOS os
-- roles (nem exige estar autenticado) — não checa auth.uid() = user_id em
-- nada. Ou seja, term_plans "funcionava" não porque a sessão estivesse OK,
-- e sim porque a RLS não impedia nada: qualquer requisição, autenticada ou
-- não, podia ler/escrever qualquer term_plan de qualquer usuário.
--
-- ATENÇÃO: depois desta migration, term_plans passa a exigir auth.uid() =
-- user_id de verdade. Se o mesmo problema não identificado que afeta
-- `classes` (auth.uid() não resolvendo em certas chamadas) também afetar
-- term_plans, o sintoma "sessão expirada"/dado não sincronizado pode
-- aparecer em Planejamento também — até agora nunca apareceu ali só porque
-- a RLS nunca chegou a checar auth.uid(). Não é regressão desta migration,
-- é a exposição de um problema que já existia e estava mascarado.
-- ==============================================================================

ALTER TABLE public.term_plans ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Enable all for authenticated users" ON public.term_plans;

CREATE POLICY "term_plans_select_own"
ON public.term_plans
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "term_plans_insert_own"
ON public.term_plans
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY "term_plans_update_own"
ON public.term_plans
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "term_plans_delete_own"
ON public.term_plans
FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- Verificação:
SELECT polname, polcmd, pg_get_expr(polqual, polrelid) AS using_expr, pg_get_expr(polwithcheck, polrelid) AS with_check_expr
FROM pg_policy
WHERE polrelid = 'public.term_plans'::regclass;
