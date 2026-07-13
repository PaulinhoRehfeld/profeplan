-- ==============================================================================
-- PROFEPLAN — Correção do vínculo escola↔professor (2026-07-13)
-- ==============================================================================
-- Contexto: professores ficavam com profiles.active_school_id = NULL para
-- sempre, mesmo escolhendo escola na tela /select-school ou tendo turmas reais
-- cadastradas — a escolha na tela só gravava em localStorage/estado React,
-- nunca no banco. O único caminho que gravava active_school_id era o professor
-- digitar manualmente o código INEP em Configurações (reconcileTeacherByInep),
-- um fluxo opcional e fácil de nunca disparar.
--
-- Como executar: cole este arquivo inteiro no SQL Editor do Supabase Studio do
-- projeto de produção e rode de uma vez. Idempotente (seguro rodar de novo).
-- ==============================================================================


-- ==============================================================================
-- SEÇÃO 1 — RPC set_my_active_school(p_school_id)
-- Usada por useActiveSchool.ts (tela /select-school) e teacherSchoolService.ts
-- (reconcileTeacherByInep) para persistir a escola ativa de verdade no banco,
-- em vez de só localStorage. SECURITY DEFINER + auth.uid() evita o problema de
-- Ghost ID (userId local desatualizado ≠ auth.uid() real).
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.set_my_active_school(p_school_id text)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid uuid := auth.uid();
  v_result public.profiles;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Não autenticado';
  END IF;

  UPDATE public.profiles SET
    active_school_id = p_school_id,
    school_id        = p_school_id, -- mantém o campo legado em sincronia
                                     -- (lido por get_my_school_id_safe() e por
                                     -- getUserProfile() para resolver school_name)
    updated_at       = NOW()
  WHERE id = v_uid
  RETURNING * INTO v_result;

  IF v_result IS NULL THEN
    RAISE EXCEPTION 'Perfil não encontrado para o usuário autenticado (id=%)', v_uid;
  END IF;

  RETURN v_result;
END;
$$;

ALTER FUNCTION public.set_my_active_school(text) OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.set_my_active_school(text) TO authenticated;
COMMENT ON FUNCTION public.set_my_active_school(text) IS
  'Define a escola ativa do usuário autenticado (profiles.active_school_id e '
  'profiles.school_id). Usada pela tela de seleção de escola e pela '
  'reconciliação por INEP.';


-- ==============================================================================
-- SEÇÃO 2 — Backfill: deriva active_school_id a partir das turmas existentes
-- Para professores que já têm turmas com school_id preenchido mas o perfil
-- ainda está com active_school_id NULL (o caso relatado: turmas sincronizam,
-- mas "Fetching classes for school: null" continua aparecendo).
-- ==============================================================================

WITH turma_escola_recente AS (
  SELECT DISTINCT ON (c.user_id)
    c.user_id,
    c.school_id
  FROM public.classes c
  WHERE c.school_id IS NOT NULL
  ORDER BY c.user_id, c.created_at DESC
)
UPDATE public.profiles p
SET
  active_school_id = t.school_id,
  school_id        = COALESCE(p.school_id, t.school_id),
  updated_at        = NOW()
FROM turma_escola_recente t
WHERE p.id = t.user_id
  AND p.active_school_id IS NULL;

-- Garante que exista um vínculo em teacher_schools correspondente (evita que
-- availableSchools fique vazio na tela /select-school para quem foi
-- reconciliado acima só via classes, sem nunca ter passado pelo fluxo de INEP).
INSERT INTO public.teacher_schools (teacher_id, school_id, role, started_at)
SELECT DISTINCT p.id, p.active_school_id, 'teacher', NOW()
FROM public.profiles p
WHERE p.active_school_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.teacher_schools ts
    WHERE ts.teacher_id = p.id
      AND ts.school_id = p.active_school_id
      AND ts.ended_at IS NULL
  );


-- ==============================================================================
-- SEÇÃO 3 — Verificação (só leitura)
-- ==============================================================================

DO $$
DECLARE
  rpc_exists boolean;
  backfilled_count int;
  still_null_with_classes int;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM pg_proc pr
    JOIN pg_namespace n ON pr.pronamespace = n.oid
    WHERE n.nspname = 'public' AND pr.proname = 'set_my_active_school'
  ) INTO rpc_exists;

  SELECT COUNT(*) INTO backfilled_count
  FROM public.profiles
  WHERE active_school_id IS NOT NULL;

  SELECT COUNT(DISTINCT c.user_id) INTO still_null_with_classes
  FROM public.classes c
  JOIN public.profiles p ON p.id = c.user_id
  WHERE p.active_school_id IS NULL
    AND c.school_id IS NOT NULL;

  RAISE NOTICE '============================================';
  RAISE NOTICE '✅ VERIFICAÇÃO — vínculo escola↔professor:';
  RAISE NOTICE '   RPC set_my_active_school: %', CASE WHEN rpc_exists THEN '✅ Presente' ELSE '❌ Ausente' END;
  RAISE NOTICE '   Perfis com active_school_id preenchido: %', backfilled_count;
  RAISE NOTICE '   Professores com turmas mas SEM active_school_id (deveria ser 0): %', still_null_with_classes;
  RAISE NOTICE '============================================';
END;
$$;

-- Consulta específica para conferir o professor relatado no bug:
-- SELECT id, email, school_id, active_school_id FROM public.profiles
--  WHERE email = 'paulo.rehfeld@educacao.mg.gov.br';
