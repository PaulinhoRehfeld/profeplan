-- Column type checks
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN ('profiles', 'pdi_records', 'school_students')
AND column_name IN ('school_id', 'teacher_id')
ORDER BY table_name, column_name;
