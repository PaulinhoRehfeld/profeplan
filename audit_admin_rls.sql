-- ==============================================================================
-- AUDIT: ADMIN & RLS GLOBAL ACCESS
-- Checking if policies exist that grant "Review Everything" to admins
-- ==============================================================================

SELECT 
    schemaname, 
    tablename, 
    policyname, 
    permissive, 
    roles, 
    cmd, 
    qual, 
    with_check 
FROM pg_policies 
WHERE tablename IN ('schools', 'classes', 'students')
ORDER BY tablename;

-- Check explicitly if is_admin_safe() or similar check is used in the text definition
