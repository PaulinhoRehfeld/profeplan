-- Verificar se os profiles existem
SELECT 
  email,
  role,
  tier,
  is_admin,
  credits
FROM profiles
ORDER BY email;

-- Contar total
SELECT COUNT(*) as total FROM profiles;

-- Se aparecer 0 ou poucos, execute novamente o script de sync:
INSERT INTO profiles (
  id, 
  email, 
  role, 
  tier, 
  credits, 
  is_unlimited, 
  is_admin, 
  allowed_features
)
SELECT 
  au.id,
  au.email,
  'teacher' as role,
  'SILVER' as tier,
  10 as credits,
  false as is_unlimited,
  false as is_admin,
  ARRAY['all']::text[] as allowed_features
FROM auth.users au
LEFT JOIN profiles p ON au.id = p.id
WHERE p.id IS NULL
  AND au.email IS NOT NULL
ON CONFLICT (id) DO NOTHING;
