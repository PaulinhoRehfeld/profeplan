-- ==============================================================================
-- MIGRATION: HABILITAR LEITURA PÚBLICA (AUTHENTICATED) DE ESCOLAS
-- ==============================================================================

-- 1. Habilitar RLS em schools (se não estiver)
ALTER TABLE schools ENABLE ROW LEVEL SECURITY;

-- 2. Política: Qualquer usuário logado pode buscar escolas
-- Necessário para o SchoolSelector funcionar antes do vínculo
DROP POLICY IF EXISTS "Public view for authenticated users" ON schools;

CREATE POLICY "Public view for authenticated users" 
ON schools FOR SELECT 
TO authenticated 
USING ( true );

-- 3. Política: Apenas Admins podem criar/editar escolas (segurança)
DROP POLICY IF EXISTS "Admins can manage schools" ON schools;

CREATE POLICY "Admins can manage schools" 
ON schools FOR ALL 
TO authenticated 
USING (
    exists (
        select 1 from profiles
        where profiles.id = auth.uid()
        and (profiles.role = 'admin' OR profiles.is_admin = true)
    )
);
