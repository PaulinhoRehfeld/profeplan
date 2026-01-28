-- FIX: Add missing 'city' column to profiles table
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS city TEXT;

-- Verify if school_id is compatible with INEP codes (Text)
-- If it was created as UUID by mistake, we might need to fix it, but let's check 'city' first.
-- This script explicitly fixes the error: "Could not find the 'city' column"

SELECT 
    'Column Added' as status,
    EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'city') as city_exists;
