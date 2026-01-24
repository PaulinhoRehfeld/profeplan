-- ============================================
-- SCRIPT: Verificar e Corrigir Usuários Faltantes
-- ============================================

-- Passo 1: Ver quantos usuários existem em auth.users
SELECT COUNT(*) as total_auth_users
FROM auth.users
WHERE email IS NOT NULL;

-- Passo 2: Ver quantos profiles existem
SELECT COUNT(*) as total_profiles
FROM profiles;

-- Passo 3: Ver usuários que NÃO têm profile
SELECT 
  au.id,
  au.email,
  au.created_at,
  'FALTA PROFILE' as status
FROM auth.users au
LEFT JOIN profiles p ON au.id = p.id
WHERE p.id IS NULL
  AND au.email IS NOT NULL
ORDER BY au.created_at DESC;

-- Passo 4: CRIAR PROFILES para os usuários faltantes
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

-- Passo 5: Verificar todos os profiles criados
SELECT 
  p.email,
  p.role,
  p.tier,
  p.credits,
  p.is_admin
FROM profiles p
ORDER BY p.email;

-- Passo 6 (OPCIONAL): Definir prehfeld@hotmail.com como ADMIN
UPDATE profiles 
SET 
  is_admin = true,
  tier = 'GOLD',
  credits = 999,
  is_unlimited = true
WHERE email = 'prehfeld@hotmail.com';
