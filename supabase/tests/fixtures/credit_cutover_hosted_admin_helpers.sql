-- =============================================================================
-- ProfePlan — Lote 1.3C.6 hosted admin helper baseline
-- TEST ONLY. Never a production migration.
--
-- The real hosted database already has public.is_admin_safe(). The historical
-- 1.3C.3 synthetic baseline did not need it because governed admin_add_credits
-- uses its own explicit authorization. The 1.3C.6 legacy rollback restores the
-- hosted two-argument admin RPC, so the disposable preflight must model this
-- existing hosted dependency faithfully.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = auth.uid()
      AND (role = 'admin' OR is_admin = true)
  );
$$;

ALTER FUNCTION public.is_admin_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.is_admin_safe() TO authenticated;
