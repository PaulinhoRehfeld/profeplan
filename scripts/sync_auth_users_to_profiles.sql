-- ============================================
-- SCRIPT: Sincronizar Usuários para Profiles
-- ============================================
-- Este script cria profiles para todos os usuários 
-- em auth.users que ainda não têm um registro em profiles
-- ============================================

-- Passo 1: Visualizar usuários que NÃO têm profile
SELECT 
  au.id,
  au.email,
  au.created_at,
  'SEM PROFILE' as status
FROM auth.users au
LEFT JOIN profiles p ON au.id = p.id
WHERE p.id IS NULL
  AND au.email IS NOT NULL
ORDER BY au.created_at DESC;

-- Passo 2: CRIAR PROFILES para todos os usuários sem profile
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

-- Passo 3: Verificar o resultado
SELECT 
  p.email,
  p.role,
  p.tier,
  p.credits,
  p.is_admin,
  'PROFILE CRIADO' as status
FROM profiles p
ORDER BY p.email
LIMIT 20;

-- Passo 4 (OPCIONAL): Se quiser tornar usuários específicos ADMIN
-- DESCOMENTE e ajuste os emails conforme necessário:

-- UPDATE profiles 
-- SET 
--   is_admin = true,
--   role = 'teacher',
--   tier = 'GOLD',
--   credits = 999,
--   is_unlimited = true
-- WHERE email IN (
--   'prehfeld@hotmail.com',
--   'suporte@profeplan.com.br'
-- );

-- ============================================
-- INFORMAÇÕES ADICIONAIS
-- ============================================
-- Após executar este script:
-- 1. Todos os usuários em auth.users terão profiles
-- 2. Novos usuários receberão: SILVER tier, 10 créditos
-- 3. AdminPanel mostrará todos os usuários
-- ============================================
