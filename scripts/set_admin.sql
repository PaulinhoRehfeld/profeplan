-- Atualizar prehfeld@hotmail.com para ADMIN
UPDATE profiles 
SET 
  is_admin = true,
  tier = 'GOLD',
  credits = 999,
  is_unlimited = true
WHERE email = 'prehfeld@hotmail.com';

-- Verificar o resultado
SELECT email, role, tier, is_admin, credits, is_unlimited
FROM profiles
WHERE email = 'prehfeld@hotmail.com';
