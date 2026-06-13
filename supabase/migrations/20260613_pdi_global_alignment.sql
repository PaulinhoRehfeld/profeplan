-- ==============================================================================
-- MIGRATION: Align PDI Documents globally and setup observations sync triggers
-- Date: 2026-06-13
-- Goal:
--   1) Correção de Foreign Key de pdi_documents para school_students(id) (Escopo Global)
--   2) Trigger de Sincronização de Observações Pedagógicas (Students <=> School Students)
-- ==============================================================================

-- 1. Cura e Migração dos dados órfãos/desalinhados em pdi_documents
-- Se o student_id atual aponta para a tabela local 'students', tentamos mover para o correspondente 'school_students'
UPDATE public.pdi_documents pd
SET student_id = s.school_student_id
FROM public.students s
WHERE pd.student_id = s.id
  AND s.school_student_id IS NOT NULL;

-- Remove qualquer PDI cujo student_id ainda não exista na tabela school_students (evitar violação de FK na migração)
DELETE FROM public.pdi_documents
WHERE student_id NOT IN (SELECT id FROM public.school_students);

-- 2. Alteração do vínculo de Foreign Key em pdi_documents para apontar para school_students(id)
ALTER TABLE public.pdi_documents
DROP CONSTRAINT IF EXISTS pdi_documents_student_id_fkey;

ALTER TABLE public.pdi_documents
ADD CONSTRAINT pdi_documents_student_id_fkey
FOREIGN KEY (student_id) REFERENCES public.school_students(id)
ON DELETE CASCADE;

-- 3. Trigger de Sincronização: students -> school_students
CREATE OR REPLACE FUNCTION public.sync_student_to_school_student()
RETURNS TRIGGER AS $$
DECLARE
    v_pdi_data JSONB;
BEGIN
    -- Prevenir loop recursivo infinito de triggers
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    IF NEW.school_student_id IS NOT NULL THEN
        -- Obter pdi_data atual ou inicializar como objeto vazio
        SELECT pdi_data INTO v_pdi_data FROM public.school_students WHERE id = NEW.school_student_id;
        v_pdi_data := COALESCE(v_pdi_data, '{}'::jsonb);

        -- Garantir a existência da seção clinical_health
        IF NOT (v_pdi_data ? 'clinical_health') THEN
            v_pdi_data := jsonb_set(v_pdi_data, '{clinical_health}', '{}'::jsonb);
        END IF;

        -- Sincronizar observações pedagógicas para a chave clinical_health.medical_updates
        v_pdi_data := jsonb_set(
            v_pdi_data,
            '{clinical_health, medical_updates}',
            to_jsonb(COALESCE(NEW.pedagogical_observations, ''))
        );

        -- Sincronizar deficiencies para a raiz do pdi_data
        v_pdi_data := jsonb_set(
            v_pdi_data,
            '{deficiencies}',
            to_jsonb(COALESCE(NEW.deficiencies, '{}'::text[]))
        );

        -- Atualizar a tabela global
        UPDATE public.school_students
        SET pdi_data = v_pdi_data
        WHERE id = NEW.school_student_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger disparado ao atualizar dados pedagógicos/inclusão em students
DROP TRIGGER IF EXISTS trigger_sync_student_to_school_student ON public.students;
CREATE TRIGGER trigger_sync_student_to_school_student
AFTER INSERT OR UPDATE OF pedagogical_observations, deficiencies ON public.students
FOR EACH ROW
EXECUTE FUNCTION public.sync_student_to_school_student();


-- 4. Trigger de Sincronização: school_students -> students
CREATE OR REPLACE FUNCTION public.sync_school_student_to_student()
RETURNS TRIGGER AS $$
DECLARE
    v_obs TEXT;
    v_deficiencies TEXT[];
BEGIN
    -- Prevenir loop recursivo infinito de triggers
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    -- Extrair observações pedagógicas de clinical_health.medical_updates
    v_obs := COALESCE(NEW.pdi_data->'clinical_health'->>'medical_updates', '');

    -- Extrair deficiencies
    IF NEW.pdi_data ? 'deficiencies' AND jsonb_typeof(NEW.pdi_data->'deficiencies') = 'array' THEN
        SELECT ARRAY(SELECT jsonb_array_elements_text(NEW.pdi_data->'deficiencies')) INTO v_deficiencies;
    ELSE
        v_deficiencies := '{}'::text[];
    END IF;

    -- Atualizar todos os registros correspondentes na tabela students
    UPDATE public.students
    SET
        pedagogical_observations = v_obs,
        deficiencies = v_deficiencies,
        needs_adaptation = (v_obs <> '' OR array_length(v_deficiencies, 1) > 0)
    WHERE school_student_id = NEW.id;

    -- Sincronizar a coluna legada observations caso ela exista
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'students'
          AND column_name = 'observations'
    ) THEN
        EXECUTE format('UPDATE public.students SET observations = %L WHERE school_student_id = %L', v_obs, NEW.id);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger disparado ao atualizar o PDI oficial (pdi_data) em school_students
DROP TRIGGER IF EXISTS trigger_sync_school_student_to_student ON public.school_students;
CREATE TRIGGER trigger_sync_school_student_to_student
AFTER UPDATE OF pdi_data ON public.school_students
FOR EACH ROW
EXECUTE FUNCTION public.sync_school_student_to_student();
