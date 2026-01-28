-- FIX: Ensure profiles.school_id is TEXT (to match INEP codes)
-- Previously it might have been UUID, causing errors when saving "12345678"

-- 1. Drop existing constraint if it exists (name might vary, so we try common ones)
ALTER TABLE public.profiles 
DROP CONSTRAINT IF EXISTS profiles_school_id_fkey;

-- 2. Alter column type to TEXT (using simple cast if data exists)
ALTER TABLE public.profiles 
ALTER COLUMN school_id TYPE TEXT USING school_id::text;

-- 3. Re-add Foreign Key to schools(id)
-- Ensure schools.id is also unique/primary (it should be)
ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_school_id_fkey 
FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE SET NULL;

-- 4. Verification
SELECT 
    'Profile Column Fixed (TEXT)' as status,
    data_type 
FROM information_schema.columns 
WHERE table_name = 'profiles' AND column_name = 'school_id';
