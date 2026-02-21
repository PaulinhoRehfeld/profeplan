-- ==============================================================================
-- MIGRATION: Sistema de Pré-Cadastro de Professores
-- Date: 2024-01-24
-- Purpose: Permitir que escolas cadastrem professores antecipadamente usando
--          email institucional e MASP. Sistema faz match automático quando
--          professor se registra.
-- ==============================================================================

-- 1. Criar tabela para professores pendentes (pré-cadastrados)
-- Nota: school_id não tem FK constraint, validação é feita na UI
CREATE TABLE IF NOT EXISTS public.pending_teachers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_id TEXT NOT NULL,  -- Código INEP, sem FK por incompatibilidade de tipos
    email_institucional TEXT NOT NULL,
    masp TEXT NOT NULL,
    full_name TEXT NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'matched', 'expired')),
    matched_profile_id UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    matched_at TIMESTAMPTZ,
    created_by UUID REFERENCES auth.users(id),
    UNIQUE(email_institucional, masp)
);

-- 2. Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_pending_teachers_email ON public.pending_teachers(email_institucional);
CREATE INDEX IF NOT EXISTS idx_pending_teachers_masp ON public.pending_teachers(masp);
CREATE INDEX IF NOT EXISTS idx_pending_teachers_school ON public.pending_teachers(school_id);
CREATE INDEX IF NOT EXISTS idx_pending_teachers_status ON public.pending_teachers(status);

-- 3. Adicionar coluna MASP no profiles se não existir
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'profiles' AND column_name = 'masp'
    ) THEN
        ALTER TABLE public.profiles ADD COLUMN masp TEXT;
        CREATE INDEX IF NOT EXISTS idx_profiles_masp ON public.profiles(masp);
    END IF;
END $$;

-- 4. Função para fazer match automático de professores
CREATE OR REPLACE FUNCTION public.match_teacher_to_school()
RETURNS TRIGGER AS $$
DECLARE
    pending_record RECORD;
BEGIN
    -- Verificar se email e MASP foram fornecidos
    IF NEW.email IS NOT NULL AND NEW.masp IS NOT NULL THEN
        -- Buscar registro pendente que bata com email E masp
        SELECT * INTO pending_record
        FROM public.pending_teachers
        WHERE LOWER(email_institucional) = LOWER(NEW.email)
          AND masp = NEW.masp
          AND status = 'pending'
        LIMIT 1;

        IF pending_record IS NOT NULL THEN
            -- Atualizar o profile com os dados da escola
            NEW.school_id := pending_record.school_id;
            NEW.role := 'teacher';
            NEW.full_name := COALESCE(NEW.full_name, pending_record.full_name);
            
            -- Marcar o registro pendente como matched
            UPDATE public.pending_teachers
            SET status = 'matched',
                matched_profile_id = NEW.id,
                matched_at = NOW()
            WHERE id = pending_record.id;
            
            RAISE NOTICE 'Professor vinculado automaticamente à escola: %', pending_record.school_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Criar triggers para match automático

-- Trigger para novos profiles (INSERT)
DROP TRIGGER IF EXISTS trigger_match_teacher_on_insert ON public.profiles;
CREATE TRIGGER trigger_match_teacher_on_insert
BEFORE INSERT ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.match_teacher_to_school();

-- Trigger para updates de profiles (quando professor adiciona MASP depois)
DROP TRIGGER IF EXISTS trigger_match_teacher_on_update ON public.profiles;
CREATE TRIGGER trigger_match_teacher_on_update
BEFORE UPDATE ON public.profiles
FOR EACH ROW
WHEN (OLD.masp IS DISTINCT FROM NEW.masp OR OLD.email IS DISTINCT FROM NEW.email)
EXECUTE FUNCTION public.match_teacher_to_school();

-- 6. RLS Policies para pending_teachers

ALTER TABLE public.pending_teachers ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT (gestores podem ver professores pendentes da sua escola)
DROP POLICY IF EXISTS "pending_teachers_select_managers" ON public.pending_teachers;
CREATE POLICY "pending_teachers_select_managers"
ON public.pending_teachers
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND profiles.school_id::TEXT = pending_teachers.school_id::TEXT
    )
);

-- Policy: INSERT (gestores podem criar professores pendentes)
DROP POLICY IF EXISTS "pending_teachers_insert_managers" ON public.pending_teachers;
CREATE POLICY "pending_teachers_insert_managers"
ON public.pending_teachers
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND profiles.school_id::TEXT = pending_teachers.school_id::TEXT
    )
);

-- Policy: UPDATE (gestores podem atualizar professores pendentes)
DROP POLICY IF EXISTS "pending_teachers_update_managers" ON public.pending_teachers;
CREATE POLICY "pending_teachers_update_managers"
ON public.pending_teachers
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND profiles.school_id::TEXT = pending_teachers.school_id::TEXT
    )
);

-- Policy: DELETE (gestores podem excluir professores pendentes)
DROP POLICY IF EXISTS "pending_teachers_delete_managers" ON public.pending_teachers;
CREATE POLICY "pending_teachers_delete_managers"
ON public.pending_teachers
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND profiles.school_id::TEXT = pending_teachers.school_id::TEXT
    )
);

-- 7. Verificação
SELECT 
    'Migration completed' as status,
    EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'pending_teachers') as pending_teachers_exists,
    EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'masp') as masp_column_exists,
    EXISTS(SELECT 1 FROM pg_proc WHERE proname = 'match_teacher_to_school') as match_function_exists;
