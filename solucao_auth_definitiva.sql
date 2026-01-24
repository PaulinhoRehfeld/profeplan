-- ==============================================================================
-- SOLUÇÃO DEFINITIVA: Criar conta Supabase Auth para paulinho.rehfeld@gmail.com
-- ==============================================================================

-- PROBLEMA IDENTIFICADO:
-- O usuário existe em authorized_users e profiles, mas NÃO existe no Supabase Auth.
-- Isso faz o login VIP "funcionar" mas sem criar sessão válida.
-- Por isso todas as requisições subsequentes dão erro 406 (sem JWT válido).

-- SOLUÇÃO:
-- Precisamos criar o usuário no Supabase Auth manualmente.
-- Isso não pode ser feito via SQL diretamente (por segurança do Supabase).

-- ============================================================================
-- OPÇÃO 1: Via Dashboard do Supabase (RECOMENDADO)
-- ============================================================================

/*
1. Vá em: Authentication > Users > Add User
2. Preencha:
   - Email: paulinho.rehfeld@gmail.com
   - Password: 123456 (ou a senha que quiser)
   - Auto Confirm User: ✅ SIM (importante!)
   
3. Após criar, COPIE o UUID do usuário criado

4. ATUALIZE o ID em authorized_users e profiles para corresponder:
*/

-- Exemplo (substitua NEW_UUID_AQUI pelo ID copiado):
-- UPDATE authorized_users SET id = 'NEW_UUID_AQUI' WHERE email = 'paulinho.rehfeld@gmail.com';
-- UPDATE profiles SET id = 'NEW_UUID_AQUI' WHERE email = 'paulinho.rehfeld@gmail.com';

-- ============================================================================
-- OPÇÃO 2: Usar apenas Supabase Auth (sem authorized_users)
-- ============================================================================

-- Fazer o usuário fazer signup normal:
-- 1. Clicar em "Criar conta" no app
-- 2. Digitar: paulinho.rehfeld@gmail.com / 123456
-- 3. Isso vai criar no auth.users automaticamente
-- 4. E o LoginScreen.tsx já chama handleAuthSuccess que cria o profile

-- ============================================================================
-- VERIFICAÇÃO APÓS CORRIGIR
-- ============================================================================

-- Execute para confirmar que os IDs coincidem:
SELECT 
    'auth.users' as source,
    id::text as user_id,
    email
FROM auth.users
WHERE email = 'paulinho.rehfeld@gmail.com'

UNION ALL

SELECT 
    'authorized_users' as source,
    id::text as user_id,
    email
FROM authorized_users
WHERE email = 'paulinho.rehfeld@gmail.com'

UNION ALL

SELECT 
    'profiles' as source,
    id::text as user_id,
    email
FROM profiles
WHERE email = 'paulinho.rehfeld@gmail.com';

-- Deve mostrar 3 linhas com o MESMO user_id
