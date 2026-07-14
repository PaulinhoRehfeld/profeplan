-- ==============================================================================
-- PROFEPLAN — Insere a escola referenciada pelas turmas já existentes (2026-07-14)
-- ==============================================================================
-- Contexto: a tabela public.schools está vazia em produção (0 linhas — decisão
-- de arquitetura: abandonamos o pré-povoamento com as ~4.014 escolas de MG,
-- ver docs/handoff mais recente). A partir de agora, escolas são criadas sob
-- demanda (find-or-create) quando um professor informa uma que ainda não
-- existe. Este script só popula UM caso específico: as 2 turmas e o perfil de
-- paulo.rehfeld@educacao.mg.gov.br já referenciam school_id='23299', que
-- precisa existir pra essas turmas aparecerem vinculadas.
-- Idempotente — seguro rodar de novo.
-- ==============================================================================

INSERT INTO public.schools (id, inep_code, name, city, sre)
VALUES ('23299', '23299', 'EE PROFESSOR ANTÔNIO LAGO', 'CAPELINHA', 'SRE DIAMANTINA')
ON CONFLICT (id) DO NOTHING;

-- Verificação:
SELECT id, inep_code, name, city FROM public.schools WHERE id = '23299';
