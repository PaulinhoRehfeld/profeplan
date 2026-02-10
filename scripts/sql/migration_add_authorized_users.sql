-- ==============================================================================
-- MIGRATION: CRIAR TABELA authorized_users (Faltou no Master)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS authorized_users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT NOT NULL,
    access_key TEXT NOT NULL, -- Senha temporária ou chave de acesso
    role TEXT DEFAULT 'teacher',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS
ALTER TABLE authorized_users ENABLE ROW LEVEL SECURITY;

-- Política: Apenas Admins podem ver/gerenciar esta tabela
-- (Necessário para o AdminPanel listar e criar usuários)
CREATE POLICY "Admins manage authorized_users" 
ON authorized_users FOR ALL 
TO authenticated 
USING (
    exists (
        select 1 from profiles 
        where id = auth.uid() 
        and (role = 'admin' OR is_admin = true)
    )
);

-- Permissão pública de leitura/verificação no login?
-- Se o Login screen verificar se o usuário está autorizado antes de criar conta.
-- Geralmente é uma function segura, mas se for via client, precisa de select.
-- Por segurança, manter restrito a admin. O login usa RPC 'verify_access_key'?
-- Se não tiver RPC, o login direto na tabela falharia.
-- Vou adicionar uma policy para leitura pública SE tiver access_key? Não, inseguro.
-- Vamos assumir que só o AdminPanel usa isso para "Convidar".
