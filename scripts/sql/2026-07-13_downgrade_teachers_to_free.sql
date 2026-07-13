-- ==============================================================================
-- PROFEPLAN — Rebaixa contas de professores pra FREE (2026-07-13)
-- ==============================================================================
-- Contexto: desde 2026-02-21 uma trigger de "período promocional" dá tier=GOLD
-- + is_unlimited=true + 9999 créditos pra todo cadastro novo, sem passar pelo
-- Stripe (ver infra/supabase/migrations/20260624_consolidate_handle_new_user_trigger.sql
-- e 20260709_fix_production_profile_save.sql). Não existe no banco nenhuma
-- coluna que distinga "comprou de verdade" de "ganhou de graça no cadastro" —
-- decisão consciente do dono do produto: encerrar a promoção e rebaixar todo
-- mundo pra FREE, sem tentar separar quem pagou (não dá pra fazer isso só com
-- os dados do banco).
--
-- Escopo: role = 'teacher' (só professores, não gestores/admins).
-- Excluídos: is_admin = true E as 4 contas de admin/suporte hardcoded no
-- código (constants.ts + migrations de admin), mesmo que alguma esteja com
-- role='teacher' por engano.
--
-- Efeito: tier='FREE', is_unlimited=false, credits=10 (default de conta FREE
-- nova — sem isso a conta fica "FREE" só no nome mas continua com créditos
-- ilimitados na prática, já que 9999 é o valor herdado do GOLD promocional).
--
-- SEÇÃO 1 é só leitura — RODE PRIMEIRO e confira a contagem/lista antes da
-- Seção 2. SEÇÃO 2 é o UPDATE real. Idempotente (seguro rodar de novo).
-- ==============================================================================


-- ==============================================================================
-- SEÇÃO 1 — Diagnóstico (SOMENTE LEITURA) — rode e confira antes de seguir
-- ==============================================================================

-- 1.1 Quantas contas seriam afetadas, e a distribuição atual de tier
SELECT
  tier,
  COUNT(*) AS total,
  COUNT(*) FILTER (WHERE is_unlimited) AS com_is_unlimited,
  COUNT(*) FILTER (WHERE credits > 10) AS com_mais_de_10_creditos
FROM public.profiles
WHERE role = 'teacher'
  AND is_admin IS NOT TRUE
  AND email NOT IN (
    'prehfeld@hotmail.com',
    'suporte@profeplan.com.br',
    'paulinho.rehfeld@hotmail.com',
    'suporte@wrtech-ai.com'
  )
GROUP BY tier
ORDER BY total DESC;

-- 1.2 Lista nominal de quem seria rebaixado (conferir antes de rodar a Seção 2)
SELECT id, email, tier, is_unlimited, credits
FROM public.profiles
WHERE role = 'teacher'
  AND is_admin IS NOT TRUE
  AND email NOT IN (
    'prehfeld@hotmail.com',
    'suporte@profeplan.com.br',
    'paulinho.rehfeld@hotmail.com',
    'suporte@wrtech-ai.com'
  )
  AND (tier IS DISTINCT FROM 'FREE' OR is_unlimited IS TRUE OR credits > 10)
ORDER BY email;

-- 1.3 Contas explicitamente EXCLUÍDAS do rebaixamento (conferir que é só quem devia)
SELECT id, email, role, tier, is_admin
FROM public.profiles
WHERE role = 'teacher'
  AND (
    is_admin IS TRUE
    OR email IN (
      'prehfeld@hotmail.com',
      'suporte@profeplan.com.br',
      'paulinho.rehfeld@hotmail.com',
      'suporte@wrtech-ai.com'
    )
  );


-- ==============================================================================
-- SEÇÃO 2 — UPDATE real (só rode depois de conferir a Seção 1)
-- ==============================================================================

UPDATE public.profiles
SET
  tier = 'FREE',
  is_unlimited = false,
  credits = 10,
  updated_at = NOW()
WHERE role = 'teacher'
  AND is_admin IS NOT TRUE
  AND email NOT IN (
    'prehfeld@hotmail.com',
    'suporte@profeplan.com.br',
    'paulinho.rehfeld@hotmail.com',
    'suporte@wrtech-ai.com'
  );


-- ==============================================================================
-- SEÇÃO 3 — Verificação (SOMENTE LEITURA)
-- ==============================================================================

SELECT
  tier,
  COUNT(*) AS total
FROM public.profiles
WHERE role = 'teacher'
  AND is_admin IS NOT TRUE
  AND email NOT IN (
    'prehfeld@hotmail.com',
    'suporte@profeplan.com.br',
    'paulinho.rehfeld@hotmail.com',
    'suporte@wrtech-ai.com'
  )
GROUP BY tier
ORDER BY total DESC;
