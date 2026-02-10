-- ==============================================================================
-- FIX RECURSÃO INFINITA: PROFILES e POLICIES
-- ==============================================================================
-- O erro ocorre porque a política de segurança da tabela 'profiles' tenta ler a própria
-- tabela 'profiles' para saber a escola do usuário, criando um loop infinito.
-- A solução é criar uma função "blindada" (SECURITY DEFINER) que lê os dados ignorando o RLS.

-- 1. Criar função auxiliar segura (Bypass RLS)
CREATE OR REPLACE FUNCTION public.get_auth_school_id()
RETURNS TEXT
LANGUAGE sql
SECURITY DEFINER -- Importante: Roda com permissões do criador, não do usuário (evita RLS)
AS $$
  SELECT school_id::text FROM public.profiles WHERE id = auth.uid();
$$;

GRANT EXECUTE ON FUNCTION public.get_auth_school_id() TO authenticated;

-- 2. Corrigir Política de Visualização de Perfis (Profiles)
DROP POLICY IF EXISTS "School Colleagues View" ON public.profiles;

CREATE POLICY "School Colleagues View" ON public.profiles 
FOR SELECT USING (
    school_id = public.get_auth_school_id() -- Usa a função segura em vez de subquery direta
);

-- 3. Atualizar também a política de Pending Teachers para usar a função otimizada
-- (Isso previne erros futuros e deixa mais rápido)
DROP POLICY IF EXISTS "pending_teachers_insert_managers" ON public.pending_teachers;

CREATE POLICY "pending_teachers_insert_managers" ON public.pending_teachers
FOR INSERT TO authenticated
WITH CHECK (
    (
      -- Managers: Must match school (usando função segura)
      (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager' 
      AND 
      public.get_auth_school_id() = pending_teachers.school_id::text
    )
    OR
    (
      -- Admins: Access all
      (SELECT is_admin FROM profiles WHERE id = auth.uid()) = true
    )
);

-- Reaplicar as outras (SELECT, UPDATE, DELETE) de pending_teachers com a mesma lógica seria ideal,
-- mas o erro principal é no INSERT e no PROFILES. Vamos focar neles.
