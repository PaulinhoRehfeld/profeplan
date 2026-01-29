-- ==============================================================================
-- FIX RLS: PENDING TEACHERS (ADMIN ACCESS)
-- ==============================================================================
-- O problema era que a regra de segurança exigia que o usuário tivesse o MESMO school_id
-- que o professor sendo criado. Mas Admins têm school_id NULL (pois acessam todas).
-- Esta correção permite que Admins gerenciem qualquer escola.

ALTER TABLE public.pending_teachers ENABLE ROW LEVEL SECURITY;

-- 1. SELECT
DROP POLICY IF EXISTS "pending_teachers_select_managers" ON public.pending_teachers;
CREATE POLICY "pending_teachers_select_managers" ON public.pending_teachers
FOR SELECT TO authenticated
USING (
    ( -- Managers: Must match school
      (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager' 
      AND 
      (SELECT school_id::text FROM profiles WHERE id = auth.uid()) = pending_teachers.school_id::text
    )
    OR
    ( -- Admins: Access all
      (SELECT is_admin FROM profiles WHERE id = auth.uid()) = true
    )
    OR
    ( -- Teachers: Can see their own pending/matched status? (Optional, keeping strict for now)
      false 
    )
);

-- 2. INSERT
DROP POLICY IF EXISTS "pending_teachers_insert_managers" ON public.pending_teachers;
CREATE POLICY "pending_teachers_insert_managers" ON public.pending_teachers
FOR INSERT TO authenticated
WITH CHECK (
    (
      (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager' 
      AND 
      (SELECT school_id::text FROM profiles WHERE id = auth.uid()) = pending_teachers.school_id::text
    )
    OR
    (
      (SELECT is_admin FROM profiles WHERE id = auth.uid()) = true
    )
);

-- 3. UPDATE
DROP POLICY IF EXISTS "pending_teachers_update_managers" ON public.pending_teachers;
CREATE POLICY "pending_teachers_update_managers" ON public.pending_teachers
FOR UPDATE TO authenticated
USING (
    (
      (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager' 
      AND 
      (SELECT school_id::text FROM profiles WHERE id = auth.uid()) = pending_teachers.school_id::text
    )
    OR
    (
      (SELECT is_admin FROM profiles WHERE id = auth.uid()) = true
    )
);

-- 4. DELETE
DROP POLICY IF EXISTS "pending_teachers_delete_managers" ON public.pending_teachers;
CREATE POLICY "pending_teachers_delete_managers" ON public.pending_teachers
FOR DELETE TO authenticated
USING (
    (
      (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager' 
      AND 
      (SELECT school_id::text FROM profiles WHERE id = auth.uid()) = pending_teachers.school_id::text
    )
    OR
    (
      (SELECT is_admin FROM profiles WHERE id = auth.uid()) = true
    )
);
