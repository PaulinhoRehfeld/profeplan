-- ==============================================================================
-- REVERT SCHOOL MANAGEMENT & RESET DATABASE
-- ==============================================================================

-- 1. Drop Tables (Order matters due to foreign keys)

-- Drop PDI Records (dependant on students/schools)
DROP TABLE IF EXISTS public.pdi_records;

-- Drop School Students (Master list)
DROP TABLE IF EXISTS public.school_students;

-- Drop Students (Class-based students)
DROP TABLE IF EXISTS public.students;

-- Drop Classes (Turmas)
DROP TABLE IF EXISTS public.classes;


-- 2. Remove Columns from Profiles
-- We need to check if they exist before dropping to avoid errors, 
-- but straightforward ALTER TABLE DROP COLUMN IF EXISTS is standard.

ALTER TABLE public.profiles 
DROP COLUMN IF EXISTS school_id CASCADE;

ALTER TABLE public.profiles 
DROP COLUMN IF EXISTS role CASCADE;

-- 3. Cleanup any other related artifacts (Functions, Policies)
-- Policies are dropped automatically when tables are dropped.
-- If there were specific RPC functions created for these features, they should be dropped too.

-- Example: If there was a dashboard stats function
DROP FUNCTION IF EXISTS get_school_dashboard_stats;

