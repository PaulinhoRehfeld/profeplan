-- 1. Identificar o ID correto (que tem role 'admin') e o ID duplicado (que provavelmente é 'teacher/manager')
-- E DELETAR o incorreto.

BEGIN;

-- Deletar qualqeur perfil para este email que NÃO SEJA admin
DELETE FROM public.profiles 
WHERE email = 'prehfeld@hotmail.com' 
AND (role IS NULL OR role != 'admin')
AND is_admin = false;

-- Garantir que o perfil restante seja SUPREMO
UPDATE public.profiles
SET 
  role = 'admin',
  is_admin = true,
  tier = 'GOLD',
  is_unlimited = true,
  allowed_features = ARRAY['all']
WHERE email = 'prehfeld@hotmail.com';

COMMIT;

-- VERIFICAR O RESULTADO FINAL
SELECT id, email, role, is_admin FROM public.profiles WHERE email = 'prehfeld@hotmail.com';
