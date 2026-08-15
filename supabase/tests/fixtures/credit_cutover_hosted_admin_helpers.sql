-- =============================================================================
-- ProfePlan — Lote 1.3C.6 hosted admin helper baseline marker
-- TEST ONLY. Never a production migration.
--
-- The real hosted database already has public.is_admin_safe(). Do not create
-- this hosted dependency during `supabase start`: doing so makes bootstrap
-- diagnostics opaque if the local stack rejects the helper while migrations
-- are being applied. The rollback rehearsal installs the exact hosted helper
-- explicitly, after the disposable stack is healthy, immediately before the
-- legacy rollback behavior is exercised.
-- =============================================================================

SELECT 'credit_cutover_hosted_admin_helpers_deferred_to_rehearsal' AS fixture_marker;
