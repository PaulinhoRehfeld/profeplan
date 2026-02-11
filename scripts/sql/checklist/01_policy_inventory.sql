-- Policy inventory (names, cmd, qual, with_check)
SELECT
    tablename,
    policyname,
    cmd,
    roles,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN (
    'schools', 'classes', 'students', 'pending_teachers', 'pdi_documents',
    'profiles', 'pdi_records', 'school_students', 'enem_questions'
)
ORDER BY tablename, cmd, policyname;
