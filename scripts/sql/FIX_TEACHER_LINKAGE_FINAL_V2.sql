-- ==============================================================================
-- FINAL FIX: TEACHER-SCHOOL LINKAGE & ROLE CONSISTENCY
-- ==============================================================================

BEGIN;

-- 1. CONSOLIDATE ROLES
-- Ensure the role check constraint allows 'manager'
ALTER TABLE public.profiles 
DROP CONSTRAINT IF EXISTS profiles_role_check;

ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_role_check 
CHECK (role IN ('teacher', 'manager', 'admin', 'school_manager', 'school_admin'));

-- Update all 'school_manager' to 'manager' for consistency with types.ts
UPDATE public.profiles SET role = 'manager' WHERE role = 'school_manager';
UPDATE public.authorized_users SET role = 'manager' WHERE role = 'school_manager';

-- 2. ENSURE RLS FOR COLLEAGUES (Allow Managers to see Teachers)
-- The "School Colleagues Read" policy should handle this, but let's make it explicit and robust.
DROP POLICY IF EXISTS "School Colleagues Read" ON public.profiles;
CREATE POLICY "School Colleagues Read" ON public.profiles
FOR SELECT TO authenticated
USING (
    (school_id IS NOT NULL AND school_id = public.get_auth_school_id())
    OR
    (public.is_admin() = true)
);

-- 3. FIX PENDING_TEACHERS POLICIES (Use correct role)
DROP POLICY IF EXISTS "pending_teachers_select" ON public.pending_teachers;
CREATE POLICY "pending_teachers_select" ON public.pending_teachers
FOR SELECT TO authenticated
USING (
    public.is_admin() = true
    OR
    (public.get_auth_role() = 'manager' AND public.get_auth_school_id() = pending_teachers.school_id)
);

DROP POLICY IF EXISTS "pending_teachers_insert" ON public.pending_teachers;
CREATE POLICY "pending_teachers_insert" ON public.pending_teachers
FOR INSERT TO authenticated
WITH CHECK (
    public.is_admin() = true
    OR
    (public.get_auth_role() = 'manager' AND public.get_auth_school_id() = pending_teachers.school_id)
);

-- 4. FIX APPROVE_TEACHER RPC (Robust case-insensitive)
CREATE OR REPLACE FUNCTION public.approve_teacher(
    p_pending_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_email TEXT;
    v_school_id TEXT;
    v_profile_id UUID;
BEGIN
    -- 1. Get Pending Info
    SELECT email_institucional, school_id 
    INTO v_email, v_school_id
    FROM public.pending_teachers 
    WHERE id = p_pending_id;

    IF v_email IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Convite não encontrado.');
    END IF;

    -- 2. Find Profile (Case Insensitive)
    SELECT id INTO v_profile_id
    FROM public.profiles 
    WHERE LOWER(email) = LOWER(v_email);

    IF v_profile_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Usuário ainda não criou conta no sistema (Perfil não encontrado com o e-mail ' || v_email || ').');
    END IF;

    -- 3. Link Profile
    UPDATE public.profiles
    SET 
        school_id = v_school_id,
        role = 'teacher',
        is_admin = false
    WHERE id = v_profile_id;

    -- 4. Mark Pending as Matched
    UPDATE public.pending_teachers 
    SET status = 'matched', 
        matched_profile_id = v_profile_id,
        matched_at = NOW()
    WHERE id = p_pending_id;

    RETURN jsonb_build_object(
        'success', true, 
        'message', 'Professor aprovado e vinculado com sucesso!'
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

COMMIT;
