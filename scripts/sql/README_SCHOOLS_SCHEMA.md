# Schema da tabela `schools` — fonte de verdade

Havia 3 definições `CREATE TABLE schools` conflitantes espalhadas pelo repo
(achado em 2026-07-13, durante o trabalho de unificação da busca de
escolas). Este arquivo existe pra não se repetir a confusão.

## Estrutura real de produção

```
schools.id        TEXT  -- código INEP, 6 dígitos, SEM prefixo estadual "31"
                         -- (ex: '023299', nunca '31023299')
schools.name       TEXT
schools.city       TEXT
schools.sre        TEXT
schools.inep_code  TEXT  -- redundante, guarda o mesmo valor de id
schools.created_at TIMESTAMPTZ
```

Confirmado por:
- `infra/supabase/migrations/20260124_ensure_schools_structure.sql` —
  migração idempotente que cria/ajusta essa estrutura. **Fonte de verdade
  da estrutura.**
- `infra/supabase/migrations/20260124_import_schools_mg_PROD.sql` — import
  real dos dados (4.014 escolas estaduais/CESEC/institutos que oferecem
  Fundamental 2 e/ou Ensino Médio — filtro intencional, não é um gap de
  dados; ver `20260124_import_schools_mg_filtered.sql`).
- `apps/web/src/utils/inepUtils.ts` (`normalizeInepCode()`) — normaliza pra
  esse formato de 6 dígitos.

## Arquivos obsoletos/incompatíveis (arquivados)

`scripts/sql/_archive_obsoleto/step1_school_manager_model.sql` e
`seed_schools_v2.sql` — protótipo abandonado de um modelo "school manager"
nunca adotado, com `id UUID` + `inep_code` separado + coluna
`municipality` (em vez de `city`). O primeiro faz
`DROP TABLE IF EXISTS public.schools CASCADE` — rodar isso contra produção
apaga a tabela e tudo que referencia ela por FK (`teacher_schools`,
`school_students`, `pdi_records`, `term_plans`). **Não rodar.**

## Outros arquivos relacionados a `schools`

- `scripts/sql/master_schema_dev.sql` — schema completo pra bootstrap de um
  ambiente de DEV do zero (não é usado em produção). A estrutura de
  `schools` aqui é compatível com produção (`id TEXT`). Uso: só em
  ambiente novo/local.
- Diversos scripts pontuais em `scripts/sql/` (`fix_school_id_*.sql`,
  `restore_schools_security.sql`, `stabilize_school_schema.sql`, etc.) —
  histórico de correções ad-hoc já aplicadas em algum momento, não
  removidos por cautela (ver `INVENTARIO_CODIGO_MORTO.md` na raiz do
  repo, que já mapeia essa dívida em mais detalhe e recomenda não deletar
  sem revisão em lote).
