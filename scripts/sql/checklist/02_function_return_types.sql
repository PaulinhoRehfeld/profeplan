-- Function return types
SELECT
    p.proname AS function_name,
    pg_get_function_result(p.oid) AS return_type,
    n.nspname AS schema_name
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
AND p.proname IN ('is_admin_safe', 'get_my_school_id_safe')
ORDER BY p.proname;
