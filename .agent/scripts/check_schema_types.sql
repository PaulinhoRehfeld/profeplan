-- =====================================================
-- VERIFICAÇÃO URGENTE: Tipos das Colunas ID
-- =====================================================
-- Execute ESTE script primeiro para confirmar os tipos

SELECT 
    table_name,
    column_name,
    data_type,
    udt_name
FROM information_schema.columns
WHERE table_name IN ('schools', 'profiles')
  AND column_name IN ('id', 'school_id')
ORDER BY table_name, column_name;

-- =====================================================
-- RESULTADO ESPERADO:
-- profiles.id → uuid
-- profiles.school_id → ??? (text ou uuid)
-- schools.id → ??? (text ou uuid)
-- =====================================================
