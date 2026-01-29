-- ==============================================================================
-- FIX: PROFILES VISIBILITY (RLS)
-- Solves "Teachers (0)" issue by ensuring managers can see their school's profiles
-- ==============================================================================

-- 1. Create Helper Functions (SECURITY DEFINER to bypass RLS and avoid recursion)
CREATE OR REPLACE FUNCTION public.get_my_school_id_safe()
RETURNS TEXT
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
    SELECT school_id FROM public.profiles WHERE id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() AND is_admin = true
    );
$$;

-- 2. Drop existing restrictive policies
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "Profiles Viewable by Everyone" ON public.profiles;
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;

-- 3. Create NEW Robust Policies

-- VIEW: Everyone sees their own. Managers/Admins see their school's profiles. Admins see all.
CREATE POLICY "profiles_select_policy" ON public.profiles
FOR SELECT USING (
    -- 1. I am the user
    auth.uid() = id
    OR
    -- 2. I am an Admin (Global)
    public.is_admin_safe()
    OR
    -- 3. I am a Manager of the SAME school as the target profile
    (
        public.get_my_school_id_safe() IS NOT NULL 
        AND 
        public.get_my_school_id_safe() = school_id
    )
);

-- UPDATE: Users update own. Admins update all. Managers update their school's profiles.
CREATE POLICY "profiles_update_policy" ON public.profiles
FOR UPDATE USING (
    auth.uid() = id
    OR
    public.is_admin_safe()
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL 
        AND 
        public.get_my_school_id_safe() = school_id
    )
);

-- INSERT: Public registration (usually handled by auth trigger, but good to have)
CREATE POLICY "profiles_insert_policy" ON public.profiles
FOR INSERT WITH CHECK (
    auth.uid() = id
);

-- 4. Enable RLS (Just in case)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 5. Grant permissions
GRANT EXECUTE ON FUNCTION public.get_my_school_id_safe() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin_safe() TO authenticated;
