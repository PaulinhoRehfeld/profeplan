-- CLEANUP SCRIPT FOR TEST PHASE
-- Deletes all user-generated content to reset the environment.

BEGIN;

-- 1. Term Plans (where lessons are stored)
TRUNCATE TABLE term_plans CASCADE;

-- 2. Generated Contents (Drive files)
TRUNCATE TABLE generated_contents CASCADE;

-- 3. Assessments (Table might not exist yet, uncomment if needed)
-- TRUNCATE TABLE assessments CASCADE;

-- 4. User Usage/History (Optional, keeps account valid but resets usage tracking if needed)
-- TRUNCATE TABLE user_daily_usage CASCADE; 

COMMIT;
