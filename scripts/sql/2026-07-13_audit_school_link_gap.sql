-- ==============================================================================
-- PROFEPLAN — Auditoria + backfill do gap de vínculo escola↔professor (2026-07-13)
-- ==============================================================================
-- Contexto: 2026-07-13_school_link_fixes.sql já corrigiu o caso "professor tem
-- turma com school_id preenchido, mas profiles.active_school_id ficou NULL"
-- (backfill via classes). Este script cobre o OUTRO padrão descoberto na mesma
-- investigação: reconcileTeacherByInep() criava a linha em teacher_schools mas
-- o UPDATE de active_school_id falhava em silêncio sob RLS e retornava
-- {success:true} mesmo assim — então existem professores com vínculo real em
-- teacher_schools cujo profiles.active_school_id nunca foi preenchido.
--
-- SEÇÃO 1 é só leitura (rode primeiro pra ver o tamanho do problema).
-- SEÇÃO 2 é o backfill (mesmo padrão já validado no script anterior).
-- SEÇÃO 3 é verificação pós-backfill.
-- Idempotente — seguro rodar de novo.
-- ==============================================================================


-- ==============================================================================
-- SEÇÃO 1 — Diagnóstico (SOMENTE LEITURA)
-- ==============================================================================

-- 1.1 Visão geral: quantos professores em cada situação
SELECT
  COUNT(*) FILTER (WHERE p.role = 'teacher') AS total_professores,
  COUNT(*) FILTER (WHERE p.role = 'teacher' AND p.active_school_id IS NOT NULL) AS com_active_school_id,
  COUNT(*) FILTER (
    WHERE p.role = 'teacher' AND p.active_school_id IS NULL
      AND EXISTS (SELECT 1 FROM public.teacher_schools ts WHERE ts.teacher_id = p.id)
  ) AS tem_teacher_schools_mas_sem_active_school_id, -- backfillável na Seção 2
  COUNT(*) FILTER (
    WHERE p.role = 'teacher' AND p.active_school_id IS NULL
      AND EXISTS (SELECT 1 FROM public.classes c WHERE c.user_id = p.id AND c.school_id IS NOT NULL)
  ) AS tem_turma_com_school_id_mas_sem_active_school_id, -- deveria ser 0 (já rodado antes)
  COUNT(*) FILTER (
    WHERE p.role = 'teacher' AND p.active_school_id IS NULL
      AND NOT EXISTS (SELECT 1 FROM public.teacher_schools ts WHERE ts.teacher_id = p.id)
      AND NOT EXISTS (SELECT 1 FROM public.classes c WHERE c.user_id = p.id AND c.school_id IS NOT NULL)
  ) AS sem_nenhuma_evidencia_de_escola -- provavelmente só não onboardaram ainda, não é bug
FROM public.profiles p;

-- 1.2 active_school_id apontando pra uma escola que não existe na tabela schools
-- (referência órfã — school_id foi setado mas a escola nunca existiu ou foi removida)
SELECT p.id, p.email, p.active_school_id
FROM public.profiles p
WHERE p.role = 'teacher'
  AND p.active_school_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM public.schools s WHERE s.id = p.active_school_id);

-- 1.3 Lista nominal dos professores backfilláveis pela Seção 2 (pra conferir antes)
SELECT p.id, p.email, p.active_school_id AS active_school_id_atual, ts.school_id AS school_id_via_teacher_schools
FROM public.profiles p
JOIN LATERAL (
  SELECT ts.school_id
  FROM public.teacher_schools ts
  WHERE ts.teacher_id = p.id
  ORDER BY (ts.ended_at IS NULL) DESC, ts.started_at DESC
  LIMIT 1
) ts ON true
WHERE p.role = 'teacher'
  AND p.active_school_id IS NULL;


-- ==============================================================================
-- SEÇÃO 2 — Backfill (mesmo padrão de 2026-07-13_school_link_fixes.sql)
-- Preenche active_school_id a partir do vínculo mais recente em teacher_schools
-- (prioriza vínculo ainda ativo — ended_at IS NULL — e depois o mais recente).
-- ==============================================================================

WITH escola_via_vinculo AS (
  SELECT DISTINCT ON (ts.teacher_id)
    ts.teacher_id,
    ts.school_id
  FROM public.teacher_schools ts
  ORDER BY ts.teacher_id, (ts.ended_at IS NULL) DESC, ts.started_at DESC
)
UPDATE public.profiles p
SET
  active_school_id = e.school_id,
  school_id        = COALESCE(p.school_id, e.school_id),
  updated_at        = NOW()
FROM escola_via_vinculo e
WHERE p.id = e.teacher_id
  AND p.role = 'teacher'
  AND p.active_school_id IS NULL;


-- ==============================================================================
-- SEÇÃO 3 — Verificação (SOMENTE LEITURA)
-- ==============================================================================

DO $$
DECLARE
  ainda_sem_vinculo int;
BEGIN
  SELECT COUNT(*) INTO ainda_sem_vinculo
  FROM public.profiles p
  WHERE p.role = 'teacher'
    AND p.active_school_id IS NULL
    AND EXISTS (SELECT 1 FROM public.teacher_schools ts WHERE ts.teacher_id = p.id);

  RAISE NOTICE '============================================';
  RAISE NOTICE '✅ VERIFICAÇÃO — auditoria de vínculo escola↔professor:';
  RAISE NOTICE '   Professores com teacher_schools mas ainda sem active_school_id (deveria ser 0): %', ainda_sem_vinculo;
  RAISE NOTICE '============================================';
END;
$$;
