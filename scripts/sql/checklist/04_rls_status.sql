-- RLS status for all tables
SELECT
    c.relname AS table_name,
    c.relrowsecurity AS rls_enabled
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
AND c.relname IN (
    'schools', 'classes', 'students', 'pending_teachers', 'pdi_documents',
    'profiles', 'pdi_records', 'school_students', 'enem_questions'
)
ORDER BY c.relname;
