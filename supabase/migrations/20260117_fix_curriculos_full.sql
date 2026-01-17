-- Garante que todas as colunas necessárias para o Langchain existam

-- 1. Cria a coluna 'content' (texto do chunk)
ALTER TABLE curriculos_mg ADD COLUMN IF NOT EXISTS content text;

-- 2. Cria a coluna 'metadata' (json com metadados)
ALTER TABLE curriculos_mg ADD COLUMN IF NOT EXISTS metadata jsonb;

-- 3. (Opcional) Se a coluna metadata existisse mas não fosse JSONB, isso a converteria
-- ALTER TABLE curriculos_mg ALTER COLUMN metadata TYPE jsonb USING metadata::jsonb;

-- 4. Recarrega o cache da API
NOTIFY pgrst, 'reload schema';
