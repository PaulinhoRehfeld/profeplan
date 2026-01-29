-- ==============================================================================
-- FIX: PROFILES RLS 400 ERROR (Infinite Recursion)
-- Recreates functions and policies with explicit OWNER TO postgres for true RLS bypass
-- ==============================================================================

-- 1. DROP EVERYTHING RELATED TO PROFILES RLS
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
DROP POLICY IF EXISTS "Profiles Viewable by Everyone" ON public.profiles; -- legacy cleanup
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles; -- legacy cleanup

-- 2. RECREATE HELPER FUNCTIONS (Strict Mode)

-- Helper: Am I Admin?
CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- Directly check bypassing RLS
    RETURN EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() AND is_admin = true
    );
END;
$$;
-- CRITICAL: Ensure it runs as superuser
ALTER FUNCTION public.is_admin_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.is_admin_safe() TO authenticated;


-- Helper: Get My School ID
CREATE OR REPLACE FUNCTION public.get_my_school_id_safe()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_school_id TEXT;
BEGIN
    SELECT school_id INTO v_school_id
    FROM public.profiles 
    WHERE id = auth.uid();
    
    RETURN v_school_id;
END;
$$;
-- CRITICAL: Ensure it runs as superuser
ALTER FUNCTION public.get_my_school_id_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_my_school_id_safe() TO authenticated;


-- 3. RECREATE POLICIES (Non-Recursive)

-- SELECT: Who can see profiles?
CREATE POLICY "profiles_select_policy" ON public.profiles
FOR SELECT USING (
    -- 1. I am viewing myself
    auth.uid() = id
    OR
    -- 2. I am an Admin (Global Bypass)
    public.is_admin_safe() = true
    OR
    -- 3. I am a School Manager viewing my school's profiles
    (
        public.get_my_school_id_safe() IS NOT NULL 
        AND 
        public.get_my_school_id_safe() = school_id
    )
);

-- UPDATE: Who can edit profiles?
CREATE POLICY "profiles_update_policy" ON public.profiles
FOR UPDATE USING (
    -- 1. I am editing myself (limited fields usually, but RLS on row is generic)
    auth.uid() = id
    OR
    -- 2. Admin
    public.is_admin_safe() = true
    OR
    -- 3. Manager editing their school's users
    (
        public.get_my_school_id_safe() IS NOT NULL 
        AND 
        public.get_my_school_id_safe() = school_id
    )
);

-- INSERT: Self registration
CREATE POLICY "profiles_insert_policy" ON public.profiles
FOR INSERT WITH CHECK (
    auth.uid() = id
);

-- 4. FORCE RLS REFRESH
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
