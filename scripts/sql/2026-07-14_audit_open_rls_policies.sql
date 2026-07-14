-- ==============================================================================
-- PROFEPLAN — Auditoria de policies RLS efetivamente abertas (2026-07-14)
-- ==============================================================================
-- Contexto: term_plans tinha uma policy "USING (true) WITH CHECK (true)" pra
-- todos os comandos e todos os roles — RLS ligada, mas sem checar nada de
-- verdade (achado ao investigar por que Planejamento nunca reproduzia o
-- mesmo bug de "sessão expirada" que Minhas Turmas). Esta query lista
-- QUALQUER policy em QUALQUER tabela pública que tenha esse mesmo padrão
-- (using_expr ou with_check_expr literalmente 'true'), pra não descobrir as
-- outras uma de cada vez.
-- Somente leitura.
-- ==============================================================================

SELECT
  n.nspname AS schema,
  c.relname AS table_name,
  p.polname AS policy_name,
  p.polcmd AS command,
  p.polpermissive AS permissive,
  p.polroles::regrole[]::text[] AS roles,
  pg_get_expr(p.polqual, p.polrelid) AS using_expr,
  pg_get_expr(p.polwithcheck, p.polrelid) AS with_check_expr
FROM pg_policy p
JOIN pg_class c ON c.oid = p.polrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND (
    pg_get_expr(p.polqual, p.polrelid) = 'true'
    OR pg_get_expr(p.polwithcheck, p.polrelid) = 'true'
  )
ORDER BY c.relname, p.polname;
