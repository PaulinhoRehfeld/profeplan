-- ==============================================================================
-- MIGRATION: Allow Teachers to Create and Manage Their Own Classes
-- Date: 2026-03-11
-- Purpose: Fixes RLS violation (401/403) where only admins and managers could create classes
-- ==============================================================================

-- 1. Create policy for INSERT
DROP POLICY IF EXISTS "classes_insert_teacher" ON public.classes;
CREATE POLICY "classes_insert_teacher"
ON public.classes
FOR INSERT
TO authenticated
WITH CHECK (
    user_id = auth.uid()
);

-- 2. Create policy for UPDATE
DROP POLICY IF EXISTS "classes_update_teacher" ON public.classes;
CREATE POLICY "classes_update_teacher"
ON public.classes
FOR UPDATE
TO authenticated
USING (
    user_id = auth.uid()
);

-- 3. Create policy for DELETE
DROP POLICY IF EXISTS "classes_delete_teacher" ON public.classes;
CREATE POLICY "classes_delete_teacher"
ON public.classes
FOR DELETE
TO authenticated
USING (
    user_id = auth.uid()
);

-- 4. Create policy for SELECT (ensure teachers can always see their own classes regardless of school)
DROP POLICY IF EXISTS "classes_select_teacher" ON public.classes;
CREATE POLICY "classes_select_teacher"
ON public.classes
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid()
);
