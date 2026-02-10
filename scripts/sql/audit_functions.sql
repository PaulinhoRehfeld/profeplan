-- Script to find functions that might have UUID variables for school_id
SELECT 
    p.proname as function_name,
    pg_get_functiondef(p.oid) as definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND (
      pg_get_functiondef(p.oid) ILIKE '%uuid%' 
      AND pg_get_functiondef(p.oid) ILIKE '%school_id%'
  );
