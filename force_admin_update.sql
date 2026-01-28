-- 1. Tenta atualizar pelo email (Case Insensitive para evitar erros)
UPDATE public.profiles 
SET role = 'admin', is_admin = true, tier = 'GOLD', is_unlimited = true 
WHERE lower(email) = lower('prehfeld@hotmail.com');

-- 2. Verificação (Mostra o estado atual da conta)
SELECT id, email, role, is_admin, tier 
FROM public.profiles 
WHERE lower(email) = lower('prehfeld@hotmail.com');

-- DICA: Se "Update 0" aparecer, o email pode estar diferente. 
-- Verifique seu ID nas Configurações do Sistema (role a tela até o fim).
-- E use o script abaixo substituindo o ID:
-- UPDATE public.profiles SET role = 'admin', is_admin = true WHERE id = 'SEU-UUID-AQUI';
