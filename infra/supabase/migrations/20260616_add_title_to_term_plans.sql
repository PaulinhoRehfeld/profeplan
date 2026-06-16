-- ================================================
-- Add 'title' column to term_plans
-- Date: 2026-06-16
-- Reason: Frontend saves title but column was missing from original schema
-- ================================================

ALTER TABLE term_plans
ADD COLUMN IF NOT EXISTS title TEXT;

-- Backfill existing rows with a computed title
UPDATE term_plans
SET title = period::TEXT || 'º ' || regime || ' - ' || subject
WHERE title IS NULL;
