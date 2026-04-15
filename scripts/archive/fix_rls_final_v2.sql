-- 2. FIX: FORCE ROBUST POLICIES
-- Re-applying the fix with extra safety measures

-- Helper: Get School ID (Security Definer = Bypasses RLS)
CREATE OR REPLACE FUNCTION public.get_my_school_id_safe()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    RETURN (SELECT COALESCE(active_school_id, school_id)::TEXT FROM public.profiles WHERE id = auth.uid());
END;
$$;

-- Helper: Am I Admin? (Security Definer = Bypasses RLS)
CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() AND is_admin = true
    );
END;
$$;

-- Reset Permissions
ALTER FUNCTION public.get_my_school_id_safe() OWNER TO postgres;
ALTER FUNCTION public.is_admin_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_my_school_id_safe() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin_safe() TO authenticated;

-- Drop Policies
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;

-- Create Policies (Using CAST to ensure type matching)
CREATE POLICY "profiles_select_policy" ON public.profiles
FOR SELECT USING (
    -- 1. Self
    auth.uid() = id
    OR
    -- 2. Admin
    public.is_admin_safe()
    OR
    -- 3. School Manager
    (
        public.get_my_school_id_safe() IS NOT NULL 
        AND 
        public.get_my_school_id_safe() = school_id::TEXT
    )
);

CREATE POLICY "profiles_update_policy" ON public.profiles
FOR UPDATE USING (
    auth.uid() = id
    OR
    public.is_admin_safe()
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL 
        AND 
        public.get_my_school_id_safe() = school_id::TEXT
    )
);

-- Toggle RLS to ensure flush
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
