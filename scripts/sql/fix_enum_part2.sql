-- ==============================================================================
-- PART 2: SYNC ADMIN (RUN THIS SECOND)
-- ==============================================================================
-- Now that 'admin' is a valid user_role, we can insert the profile.

INSERT INTO public.profiles (id, email, role, tier, credits, is_unlimited, is_admin, allowed_features)
SELECT 
    id, 
    email,
    'admin'::user_role, 
    'GOLD', 
    9999, 
    true, 
    true, 
    ARRAY['all']
FROM public.authorized_users
WHERE email = 'prehfeld@hotmail.com'
ON CONFLICT (id) DO UPDATE 
SET 
    role = 'admin'::user_role,
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999;
