-- ==============================================================================
-- FIX: CORRIGIR PAPEL DE GESTOR (Estava salvando como TEACHER)
-- ==============================================================================

-- 1. Corrige na tabela 'authorized_users' (Login)
-- Se o email for o do paulinho ou do gestor, vira 'school_manager'
UPDATE authorized_users
SET role = 'school_manager'
WHERE email IN ('paulinho.rehfeld@gmail.com', 'gestor.antoniolago@educacao.mg.gov.br');

-- 2. Corrige na tabela 'profiles' (Perfil)
-- Se o email for ese, altera para role correto e dá upgrade no plano
UPDATE profiles
SET 
  role = 'school_manager',
  tier = 'GOLD',
  is_unlimited = true,
  credits = 999
WHERE email IN ('paulinho.rehfeld@gmail.com', 'gestor.antoniolago@educacao.mg.gov.br');

-- 3. Garantir consistency case (tudo minúsculo para roles no banco)
UPDATE authorized_users SET role = LOWER(role);
