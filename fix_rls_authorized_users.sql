-- ==============================================================================
-- FIX RLS: PERMITIR QUE ADMINS CRIEM USUÁRIOS
-- ==============================================================================
-- O erro "new row violates row-level security policy" indica que falta permissão.

-- 1. Habilitar RLS (caso não esteja)
ALTER TABLE public.authorized_users ENABLE ROW LEVEL SECURITY;

-- 2. Remover policies antigas (se houver) para evitar duplicação/conflito
DROP POLICY IF EXISTS "Admins can manage authorized_users" ON public.authorized_users;

-- 3. Criar Policy Universal para Admins
-- Permite que usuários com role='admin' na tabela PROFILES façam tudo na AUTHORIZED_USERS.

CREATE POLICY "Admins can manage authorized_users"
ON public.authorized_users
FOR ALL -- SELECT, INSERT, UPDATE, DELETE
USING (
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE profiles.id = auth.uid() 
        AND (profiles.role = 'admin' OR profiles.is_admin = true)
    )
);

-- 4. [OPCIONAL] Permitir leitura pública (se necessário para login simplificado)
-- Se o login simplificado fizer SELECT direto do client sem estar logado, precisa disso.
-- Mas geralmente o login é via RPC (Function) que usa SECURITY DEFINER.
-- Vou deixar comentado por segurança, mas se o login falhar na LEITURA, descomente.
-- CREATE POLICY "Public can read authorized_users" ON public.authorized_users FOR SELECT USING (true);
