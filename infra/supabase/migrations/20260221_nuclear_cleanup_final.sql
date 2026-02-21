-- ==============================================================================
-- EMERGENCY CLEANUP V8: SMART NUCLEAR RESET (EXTENDED)
-- Date: 2026-02-21
-- Description: Total wipe with all discovered tables including deleted_students.
-- ==============================================================================

BEGIN;

-- 1. Identify rows to keep (Admin)
CREATE TEMP TABLE IF NOT EXISTS users_to_keep AS
SELECT id FROM auth.users 
WHERE email IN ('prehfeld@hotmail.com');

-- 2. SMART TRUNCATE (Only existing tables)
DO $$ 
DECLARE
    t_name text;
    tables_to_clear text[] := ARRAY[
        'feedbacks', 'user_feedback_preferences', 'ai_preference_logs', 
        'user_memories', 'pdi_logs', 'pdi_teacher_evaluations', 
        'pdi_cycles', 'pdi_records', 'pdi_documents', 
        'pdi_lesson_adaptations', 'students', 'classes', 
        'term_plans', 'generated_contents', 'referrals', 
        'pending_teachers', 'simulation_analytics', 
        'school_students', 'lessons', 'student_archive',
        'deleted_students' -- Newly discovered blocker
    ];
BEGIN
    FOREACH t_name IN ARRAY tables_to_clear
    LOOP
        IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = t_name) THEN
            EXECUTE 'TRUNCATE TABLE public.' || quote_ident(t_name) || ' CASCADE';
        END IF;
    END LOOP;
END $$;

-- 3. Delete Profiles for everyone except admin
DELETE FROM public.profiles WHERE id NOT IN (SELECT id FROM users_to_keep);

-- 4. Delete Auth Users for everyone except admin
DELETE FROM auth.users WHERE id NOT IN (SELECT id FROM users_to_keep);

-- 5. Restore/Ensure Admin Profile Integrity
INSERT INTO public.profiles (id, email, role, is_admin, tier, is_unlimited, credits)
SELECT id, email, 'admin', true, 'GOLD', true, 9999
FROM auth.users
WHERE email = 'prehfeld@hotmail.com'
ON CONFLICT (id) DO UPDATE SET
    role = 'admin',
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999;

COMMIT;

-- Statistics for Verification
SELECT 
    (SELECT count(*) FROM auth.users) as remaining_auth_users,
    (SELECT count(*) FROM public.profiles) as remaining_public_profiles;

DROP TABLE IF EXISTS users_to_keep;
