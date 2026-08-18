\set ON_ERROR_STOP on

-- Superseded non-destructively during C.3.2 validation.
--
-- The active proof is:
--   supabase/tests/knowledge_factory_extraction_c3_2_control_plane.sql
--
-- This file remains only to preserve the branch history without a destructive
-- delete after the earlier draft test was replaced. It intentionally performs
-- no database mutation or assertion.

SELECT 'C.3.2 draft proof superseded by knowledge_factory_extraction_c3_2_control_plane.sql' AS status;
