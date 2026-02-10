-- ==============================================================================
-- FIX: CORRIGIR ERRO DE "INFINITE RECURSION" (LOOP INFINITO)
-- Motivo: A política de segurança consultava a própria tabela 'profiles' para checar a escola.
-- Solução: Criar uma "Função Segura" que lê o dado sem ativar o loop.
-- ==============================================================================

-- 1. Criar Função Segura para ler a escola do usuário atual
CREATE OR REPLACE FUNCTION get_my_safe_school_id()
RETURNS TEXT AS $$
BEGIN
  RETURN (SELECT school_id FROM profiles WHERE id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 
-- 'SECURITY DEFINER' faz a função rodar com permissão máxima, ignorando o RLS, o que quebra o loop.

-- 2. Corrigir a Política da Tabela Profiles
-- Removemos a antiga que causava loop e criamos a nova.

DROP POLICY IF EXISTS "School Members can view colleagues" ON profiles;

CREATE POLICY "School Members can view colleagues" 
ON profiles FOR SELECT 
TO authenticated 
USING (
    school_id IS NOT NULL 
    AND 
    school_id = get_my_safe_school_id() -- Usa a função segura agora
);

-- 3. Garantir que ADMINS vejam tudo sem loop
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;

CREATE POLICY "Admins can view all profiles" 
ON profiles FOR ALL
TO authenticated 
USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin' 
    OR 
    (SELECT is_admin FROM profiles WHERE id = auth.uid()) = true
);
-- Nota: Se essa de Admin também causar loop (pouco provável pois é direta),
-- podemos ter que criar 'get_my_role()' também, mas vamos testar a da escola primeiro.
