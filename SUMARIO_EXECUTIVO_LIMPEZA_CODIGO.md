-- Diagnostic script (READ-ONLY) for Supabase/Postgres
-- Shows RLS status and policy definitions for critical tables
-- Run as a regular SQL query (no DDL changes)

SET search_path = public;

-- Timestamp
SELECT now() AS diagnostic_run_at;

-- 1) RLS enabled flags for critical tables
SELECT
  c.relname AS table_name,
  CASE WHEN c.relrowsecurity THEN 'ENABLED' ELSE 'DISABLED' END AS rls_enabled,
  CASE WHEN c.relforcerowsecurity THEN 'FORCED' ELSE 'NOT_FORCED' END AS force_row_security
FROM pg_class c
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname = 'public' AND c.relname IN ('profiles', 'pdi_documents', 'students', 'authorized_users')
ORDER BY c.relname;

-- 2) Policies on profiles, pdi_documents, students (name, command, using expression, with_check)
SELECT
  schemaname,
  tablename,
  policyname,
  cmd AS command,
  qual AS using_expression,
  with_check AS with_check_expression
FROM pg_policies
WHERE tablename IN ('profiles','pdi_documents','students')
ORDER BY tablename, policyname;

-- 3) Policies on authorized_users (relevant for recursion)
SELECT
  schemaname,
  tablename,
  policyname,
  cmd AS command,
  qual AS using_expression,
  with_check AS with_check_expression
FROM pg_policies
WHERE tablename = 'authorized_users'
ORDER BY policyname;

-- 4) Show possible SECURITY DEFINER helper functions used by some fixes
-- If present, return full function definition (source)
SELECT
  p.proname AS function_name,
  n.nspname AS schema_name,
  pg_get_functiondef(p.oid) AS definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public' AND p.proname IN ('get_my_school_id_safe','is_admin_safe');

-- 5) Show function ACLs for these functions (who has EXECUTE)
SELECT
  p.proname AS function_name,
  p.proacl AS acl
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public' AND p.proname IN ('get_my_school_id_safe','is_admin_safe');

-- 6) Helpful view: all policies (for quick manual search)
SELECT
  schemaname, tablename, policyname, cmd AS command, qual AS using_expression, with_check AS with_check_expression
FROM pg_policies
WHERE tablename IN ('profiles','authorized_users','pdi_documents','students')
ORDER BY tablename, policyname;