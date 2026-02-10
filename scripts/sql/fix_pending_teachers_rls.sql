-- ==============================================================================
-- FIX: PENDING TEACHERS RLS FOR ADMIN IMPERSONATION
-- ==============================================================================

BEGIN;

-- 1. Drop existing restrictive policies
DROP POLICY IF EXISTS "pending_teachers_select_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_insert_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_update_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_delete_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "Managers can view pending teachers" ON public.pending_teachers;
DROP POLICY IF EXISTS "Managers can insert pending teachers" ON public.pending_teachers;
DROP POLICY IF EXISTS "Managers can update pending teachers" ON public.pending_teachers;
DROP POLICY IF EXISTS "Managers can delete pending teachers" ON public.pending_teachers;


-- 2. Create new flexible policies

-- SELECT: Admins view ALL, Managers view OWN school
CREATE POLICY "pending_teachers_select_policy"
ON public.pending_teachers
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (
            -- Admin has global access
            role = 'admin' 
            OR is_admin = true
            -- Managers restricted to their school
            OR (
                (role = 'manager' OR role = 'school_manager') 
                AND profiles.school_id::TEXT = pending_teachers.school_id::TEXT
            )
        )
    )
);

-- INSERT: Admins insert ANY, Managers insert OWN school
CREATE POLICY "pending_teachers_insert_policy"
ON public.pending_teachers
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (
            -- Admin has global access
            role = 'admin' 
            OR is_admin = true
            -- Managers restricted to their school
            OR (
                (role = 'manager' OR role = 'school_manager') 
                AND profiles.school_id::TEXT = pending_teachers.school_id::TEXT
            )
        )
    )
);

-- UPDATE: Admins update ANY, Managers update OWN school
CREATE POLICY "pending_teachers_update_policy"
ON public.pending_teachers
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (
            role = 'admin' 
            OR is_admin = true
            OR (
                (role = 'manager' OR role = 'school_manager') 
                AND profiles.school_id::TEXT = pending_teachers.school_id::TEXT
            )
        )
    )
);

-- DELETE: Admins delete ANY, Managers delete OWN school
CREATE POLICY "pending_teachers_delete_policy"
ON public.pending_teachers
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (
            role = 'admin' 
            OR is_admin = true
            OR (
                (role = 'manager' OR role = 'school_manager') 
                AND profiles.school_id::TEXT = pending_teachers.school_id::TEXT
            )
        )
    )
);

COMMIT;
