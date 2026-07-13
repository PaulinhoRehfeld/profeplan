-- ==============================================================================
-- PROFEPLAN — Vincula escola do professor paulo.rehfeld@educacao.mg.gov.br
-- (2026-07-13, complemento ao 2026-07-13_school_link_fixes.sql)
-- ==============================================================================
-- Descobertas ao investigar por que o backfill automático não resolveu:
--
-- 1) Nem o perfil nem as turmas existentes (1º EM REG 1, 1º EM REG 7) nunca
--    tiveram school_id preenchido — a cadeia estava quebrada desde o início,
--    não havia de onde derivar a escola automaticamente.
--
-- 2) A escola do professor (INEP federal 31023299 = "EE PROFESSOR ANTÔNIO
--    LAGO", Capelinha, SRE Diamantina — confirmado via
--    C:\Users\Admin\PROFEPLAN\ESCOLASMG\banco_escolas_mg_filtrado.json,
--    id "23299") não está entre as 4.014 escolas importadas na tabela
--    `schools`. Precisa ser inserida.
--
-- 3) BUG SISTÊMICO à parte (corrigido em apps/web/src/utils/inepUtils.ts):
--    a tabela `schools` armazena o código SEM o prefixo estadual "31" (ex:
--    id/inep_code = '374709', confirmado com dados reais de produção via
--    SRE Diamantina) — não "31374709" como o código anterior assumia. Por
--    isso este script insere/busca a escola pelo código de 6 dígitos
--    ('023299'), não pelo INEP federal de 8 dígitos que o professor informou.
--
-- Como executar: cole este arquivo inteiro no SQL Editor do Supabase Studio e
-- rode de uma vez. Seguro rodar de novo (idempotente).
-- ==============================================================================

DO $$
DECLARE
  v_teacher_id  uuid;
  v_school_id   text;
  v_school_code text := '023299'; -- INEP federal 31023299 sem o prefixo "31"
BEGIN
  -- 1. Resolve o professor
  SELECT id INTO v_teacher_id
  FROM public.profiles
  WHERE email = 'paulo.rehfeld@educacao.mg.gov.br';

  IF v_teacher_id IS NULL THEN
    RAISE EXCEPTION 'Professor não encontrado (email paulo.rehfeld@educacao.mg.gov.br)';
  END IF;

  -- 2. Garante que a escola existe na tabela schools (insere se faltar,
  --    dados vindos de ESCOLASMG/banco_escolas_mg_filtrado.json).
  --    Inclui id=inep_code explicitamente: dados reais de produção mostram
  --    id e inep_code sempre iguais (ex: '374709'/'374709'), não um UUID
  --    auto-gerado — então id provavelmente não tem default.
  INSERT INTO public.schools (id, inep_code, name, city, sre)
  VALUES (v_school_code, v_school_code, 'EE PROFESSOR ANTÔNIO LAGO', 'CAPELINHA', 'SRE DIAMANTINA')
  ON CONFLICT (inep_code) DO NOTHING;

  SELECT id INTO v_school_id
  FROM public.schools
  WHERE inep_code = v_school_code;

  IF v_school_id IS NULL THEN
    RAISE EXCEPTION 'Falha ao resolver/inserir a escola com código %', v_school_code;
  END IF;

  RAISE NOTICE 'Professor: % | Escola: EE PROFESSOR ANTÔNIO LAGO (id=%)', v_teacher_id, v_school_id;

  -- 3. Vincula o perfil à escola (active_school_id + school_id legado)
  UPDATE public.profiles
  SET active_school_id = v_school_id,
      school_id        = v_school_id,
      updated_at       = NOW()
  WHERE id = v_teacher_id;

  -- 4. Preenche school_id nas turmas existentes deste professor que estão órfãs
  UPDATE public.classes
  SET school_id = v_school_id
  WHERE user_id = v_teacher_id
    AND school_id IS NULL;

  -- 5. Garante o vínculo formal em teacher_schools (evita lista vazia em /select-school)
  INSERT INTO public.teacher_schools (teacher_id, school_id, role, started_at)
  SELECT v_teacher_id, v_school_id, 'teacher', NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM public.teacher_schools
    WHERE teacher_id = v_teacher_id
      AND school_id = v_school_id
      AND ended_at IS NULL
  );

  RAISE NOTICE '✅ Vínculo concluído para %', v_teacher_id;
END;
$$;

-- Verificação:
SELECT p.email, p.school_id, p.active_school_id, c.id AS turma_id, c.name, c.school_id AS turma_school_id
FROM public.profiles p
LEFT JOIN public.classes c ON c.user_id = p.id
WHERE p.email = 'paulo.rehfeld@educacao.mg.gov.br';
