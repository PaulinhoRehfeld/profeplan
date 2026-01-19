-- Function to get a manifest of all ingested curriculum files
-- This allows the UI to show "What the AI knows"
CREATE OR REPLACE FUNCTION get_ingested_files_manifest()
RETURNS TABLE (
  source_file text,
  disciplina text,
  ano_escolar text,
  total_chunks bigint
) 
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    (metadata->>'source')::text as source_file,
    (metadata->>'disciplina')::text as disciplina,
    (metadata->>'ano_escolar')::text as ano_escolar,
    COUNT(*) as total_chunks
  FROM curriculos_mg
  GROUP BY 
    metadata->>'source',
    metadata->>'disciplina',
    metadata->>'ano_escolar'
  ORDER BY 
    metadata->>'ano_escolar',
    metadata->>'disciplina';
END;
$$;
