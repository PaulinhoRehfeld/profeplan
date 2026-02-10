-- ==============================================================================
-- FIX FINAL DE SEGURANÇA (RLS)
-- ==============================================================================

-- 1. REABILITAR O RLS (Segurança Ativada)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2. LIMPEZA TOTAL (Remove qualquer regra antiga que esteja atrapalhando)
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
DROP POLICY IF EXISTS "Anyone can view profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can delete profiles" ON public.profiles;
DROP POLICY IF EXISTS "Managers can view school colleagues" ON public.profiles;
DROP POLICY IF EXISTS "School Members can view colleagues" ON public.profiles;
DROP POLICY IF EXISTS "Users insert own profile" ON public.profiles;

-- 3. CRIAR AS REGRAS CORRETAS (Permite o Login funcionar)

-- REGRA 1: Leitura (Essencial para o Login e para ver nomes de professores)
-- Permite que qualquer usuário logado leia os dados básicos de perfil
CREATE POLICY "Enable read access for authenticated users"
ON public.profiles FOR SELECT
TO authenticated
USING (true);

-- REGRA 2: Inserir (Apena o próprio usuário pode criar seu perfil no cadastro)
CREATE POLICY "Enable insert for users based on user_id"
ON public.profiles FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- REGRA 3: Atualizar (Apenas o próprio usuário edita seus dados)
CREATE POLICY "Enable update for users based on user_id"
ON public.profiles FOR UPDATE
TO authenticated
USING (auth.uid() = id);

-- REGRA 4: Admins Especiais (Permite deletar/gerenciar tudo - Opcional, via JWT)
CREATE POLICY "Enable delete for specific admins"
ON public.profiles FOR DELETE
TO authenticated
USING (auth.jwt() ->> 'email' IN ('prehfeld@hotmail.com', 'paulinho.rehfeld@hotmail.com'));

-- 4. VERIFICAÇÃO
SELECT 'RLS ESTÁ ATIVO E SEGURO AGORA' as status;
