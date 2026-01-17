-- SOLUÇÃO PARA O ERRO 42804
-- O erro ocorre porque existe um "valor padrão" (provavelmente uma sequência numérica)
-- associado à coluna ID que não pode ser convertido automaticamente para UUID.

-- 1. Primeiro, removemos o valor padrão antigo (a sequência)
ALTER TABLE curriculos_mg ALTER COLUMN id DROP DEFAULT;

-- 2. Agora podemos converter a coluna para UUID com segurança
-- 'USING gen_random_uuid()' preenche os IDs existentes com novos UUIDs
ALTER TABLE curriculos_mg 
ALTER COLUMN id TYPE uuid USING gen_random_uuid();

-- 3. Definimos o novo valor padrão para UUID
ALTER TABLE curriculos_mg 
ALTER COLUMN id SET DEFAULT gen_random_uuid();

-- 4. Confirmação
NOTIFY pgrst, 'reload schema';
