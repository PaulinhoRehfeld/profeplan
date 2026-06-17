-- Atualizar admins hardcoded para status correto
UPDATE profiles
SET
  role = 'admin',
  is_admin = true,
  tier = 'GOLD',
  credits = 9999,
  is_unlimited = true
WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');

-- Verificar o resultado
SELECT email, role, tier, is_admin, credits, is_unlimited
FROM profiles
WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');
