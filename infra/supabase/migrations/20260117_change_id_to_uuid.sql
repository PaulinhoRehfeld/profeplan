-- O Langchain gera UUIDs automaticamente para os documentos.
-- A tabela atual tem 'id' como bigint (número), o que causa o erro.
-- Este comando converte a tabela para usar UUIDs.

-- 1. Habilita a extensão de UUID se não estiver ativa
create extension if not exists "pgcrypto";

-- 2. Altera a coluna id para UUID apenas se a tabela existir
-- (guard necessário para evitar falha ao rodar migrations do zero)
DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'curriculos_mg'
  ) THEN
    ALTER TABLE curriculos_mg
    ALTER COLUMN id TYPE uuid USING gen_random_uuid();

    ALTER TABLE curriculos_mg
    ALTER COLUMN id SET DEFAULT gen_random_uuid();
  END IF;
END $$;
