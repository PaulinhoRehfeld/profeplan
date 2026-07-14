-- ==============================================================================
-- FIX: 7 tabelas com RLS efetivamente aberta (falha de segurança)
-- Date: 2026-07-14
-- ==============================================================================
-- Mesma auditoria que achou term_plans (ver 20260714_fix_term_plans_open_rls.sql)
-- encontrou mais 7 tabelas com policies "USING (true)"/"Public Access" — RLS
-- ligada mas sem checar dono de verdade. Para as 3 mais simples (generated_
-- contents, lessons, user_learning_profile) o dono é sempre user_id, sem
-- nenhum caso de acesso compartilhado no código — policy direta.
--
-- Para authorized_users, profiles e as duas tabelas de PDI, uma policy ingênua
-- de "só a própria linha" JÁ FOI TENTADA antes neste projeto e QUEBROU
-- funcionalidades reais (Ghost ID em profiles, forçando a criação da RPC
-- get_my_profile(); PDI precisa ser visível por vários professores da mesma
-- escola, não só quem escreveu). Este script espelha os padrões já corretos e
-- comprovados em produção nas tabelas irmãs (pdi_documents, e a versão de
-- profiles de 20260129_final_robust_fix_profiles.sql) em vez de inventar um
-- novo modelo de acesso.
-- ==============================================================================

-- ------------------------------------------------------------------
-- 1. generated_contents — dono = user_id, sem acesso compartilhado
-- ------------------------------------------------------------------
ALTER TABLE public.generated_contents ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Access" ON public.generated_contents;

CREATE POLICY "generated_contents_select" ON public.generated_contents
  FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "generated_contents_insert" ON public.generated_contents
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "generated_contents_update" ON public.generated_contents
  FOR UPDATE TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "generated_contents_delete" ON public.generated_contents
  FOR DELETE TO authenticated USING (user_id = auth.uid());

-- ------------------------------------------------------------------
-- 2. lessons — dono = user_id (o schema original em teacher_memory.sql já
--    definia isso corretamente; foi relaxada em produção em algum momento)
-- ------------------------------------------------------------------
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Access" ON public.lessons;

CREATE POLICY "lessons_select" ON public.lessons
  FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "lessons_insert" ON public.lessons
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "lessons_update" ON public.lessons
  FOR UPDATE TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "lessons_delete" ON public.lessons
  FOR DELETE TO authenticated USING (user_id = auth.uid());

-- ------------------------------------------------------------------
-- 3. user_learning_profile — dono = user_id (também é a PK)
-- ------------------------------------------------------------------
ALTER TABLE public.user_learning_profile ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Access" ON public.user_learning_profile;

CREATE POLICY "user_learning_profile_select" ON public.user_learning_profile
  FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "user_learning_profile_insert" ON public.user_learning_profile
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "user_learning_profile_update" ON public.user_learning_profile
  FOR UPDATE TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "user_learning_profile_delete" ON public.user_learning_profile
  FOR DELETE TO authenticated USING (user_id = auth.uid());

-- ------------------------------------------------------------------
-- 4. authorized_users — NÃO é "1 linha = 1 dono" comum: é allowlist
--    administrada por admin (AdminPanel.tsx apaga linhas de outros usuários),
--    mas o próprio usuário também precisa poder UPDATE a própria linha (troca
--    de senha em SecurityTab.tsx, que filtra por email mas depende da RLS
--    permitir a linha onde id = auth.uid()). Sem FK id->auth.users, mas os
--    scripts de bootstrap sempre inseriram id = mesmo UUID de profiles.id.
-- ------------------------------------------------------------------
ALTER TABLE public.authorized_users ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Access" ON public.authorized_users;

CREATE POLICY "authorized_users_select" ON public.authorized_users
  FOR SELECT TO authenticated USING (public.is_admin() = true OR id = auth.uid());
CREATE POLICY "authorized_users_update" ON public.authorized_users
  FOR UPDATE TO authenticated
  USING (public.is_admin() = true OR id = auth.uid())
  WITH CHECK (public.is_admin() = true OR id = auth.uid());
CREATE POLICY "authorized_users_insert" ON public.authorized_users
  FOR INSERT TO authenticated WITH CHECK (public.is_admin() = true);
CREATE POLICY "authorized_users_delete" ON public.authorized_users
  FOR DELETE TO authenticated USING (public.is_admin() = true);

-- ------------------------------------------------------------------
-- 5. profiles — restaura a policy de 3 condições já usada e comprovada em
--    20260129_final_robust_fix_profiles.sql (auto-leitura OU colega da mesma
--    escola OU admin). "Só a própria linha" já foi tentado nesta tabela
--    especificamente e quebrou usuários Ghost ID + busca de gestor por MASP.
-- ------------------------------------------------------------------
DROP POLICY IF EXISTS "profiles_select_own_or_all" ON public.profiles;

CREATE POLICY "profiles_select_own_or_all" ON public.profiles
  FOR SELECT TO authenticated
  USING (
    public.is_admin() = true
    OR (school_id IS NOT NULL AND TRIM(school_id) = public.get_auth_school_id())
    OR (id = auth.uid())
  );

-- ------------------------------------------------------------------
-- 6 e 7. pdi_lesson_adaptations e pdi_teacher_entries — leitura por escola
--    (várias disciplinas/professores lançam entradas no mesmo PDI de aluno,
--    mesmo padrão já usado em pdi_documents_select via
--    get_my_school_id_safe()); escrita restrita a quem é dono da entrada
--    (teacher_id = auth.uid()) e pertence à escola do PDI.
-- ------------------------------------------------------------------
ALTER TABLE public.pdi_lesson_adaptations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON public.pdi_lesson_adaptations;

CREATE POLICY "pdi_lesson_adaptations_select" ON public.pdi_lesson_adaptations
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.pdi_documents pd
      WHERE pd.id = pdi_lesson_adaptations.pdi_document_id
        AND pd.school_id::text = public.get_my_school_id_safe()
    )
  );
CREATE POLICY "pdi_lesson_adaptations_insert" ON public.pdi_lesson_adaptations
  FOR INSERT TO authenticated
  WITH CHECK (
    teacher_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.pdi_documents pd
      WHERE pd.id = pdi_lesson_adaptations.pdi_document_id
        AND pd.school_id::text = public.get_my_school_id_safe()
    )
  );
CREATE POLICY "pdi_lesson_adaptations_update" ON public.pdi_lesson_adaptations
  FOR UPDATE TO authenticated
  USING (teacher_id = auth.uid()) WITH CHECK (teacher_id = auth.uid());
CREATE POLICY "pdi_lesson_adaptations_delete" ON public.pdi_lesson_adaptations
  FOR DELETE TO authenticated USING (teacher_id = auth.uid());

ALTER TABLE public.pdi_teacher_entries ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON public.pdi_teacher_entries;

CREATE POLICY "pdi_teacher_entries_select" ON public.pdi_teacher_entries
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.pdi_documents pd
      WHERE pd.id = pdi_teacher_entries.pdi_document_id
        AND pd.school_id::text = public.get_my_school_id_safe()
    )
  );
CREATE POLICY "pdi_teacher_entries_insert" ON public.pdi_teacher_entries
  FOR INSERT TO authenticated
  WITH CHECK (
    teacher_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.pdi_documents pd
      WHERE pd.id = pdi_teacher_entries.pdi_document_id
        AND pd.school_id::text = public.get_my_school_id_safe()
    )
  );
CREATE POLICY "pdi_teacher_entries_update" ON public.pdi_teacher_entries
  FOR UPDATE TO authenticated
  USING (teacher_id = auth.uid()) WITH CHECK (teacher_id = auth.uid());
CREATE POLICY "pdi_teacher_entries_delete" ON public.pdi_teacher_entries
  FOR DELETE TO authenticated USING (teacher_id = auth.uid());

-- Verificação:
SELECT c.relname AS table_name, p.polname, p.polcmd,
       pg_get_expr(p.polqual, p.polrelid) AS using_expr,
       pg_get_expr(p.polwithcheck, p.polrelid) AS with_check_expr
FROM pg_policy p
JOIN pg_class c ON c.oid = p.polrelid
WHERE c.relname IN (
  'generated_contents', 'lessons', 'user_learning_profile',
  'authorized_users', 'profiles', 'pdi_lesson_adaptations', 'pdi_teacher_entries'
)
ORDER BY c.relname, p.polname;
