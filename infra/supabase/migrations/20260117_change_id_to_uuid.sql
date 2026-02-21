-- O Langchain gera UUIDs automaticamente para os documentos.
-- A tabela atual tem 'id' como bigint (número), o que causa o erro.
-- Este comando converte a tabela para usar UUIDs.

-- 1. Habilita a extensão de UUID se não estiver ativa
create extension if not exists "pgcrypto";

-- 2. Altera a coluna id para UUID
-- O 'USING' diz como converter os dados existentes (gerando novos uuids)
ALTER TABLE curriculos_mg 
ALTER COLUMN id TYPE uuid USING gen_random_uuid();

-- 3. Define o valor padrão para novos inserts como UUID aleatório
ALTER TABLE curriculos_mg 
ALTER COLUMN id SET DEFAULT gen_random_uuid();

-- 4. Atualiza a função de busca para retornar o tipo correto (se necessário)
-- DROP FUNCTION IF EXISTS match_curriculo_enem; -- Descomente se precisar recriar
-- (Recomendado recriar a função match_curriculo_enem posteriormente se ela tipar id como bigint explicitamente)
