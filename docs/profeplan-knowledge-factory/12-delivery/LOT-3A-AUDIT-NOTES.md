# Lote 3A — Notas de auditoria pré-SQL

Status: auditoria concluída antes da criação da migration.

## Base confirmada

O commit aprovado `ee6ddf36d504635e7fcb74edbec79d2e4c072383` permanece ancestral da `main`. Durante esta execução um arquivo placeholder documental foi criado acidentalmente e removido imediatamente da `main`; não houve alteração de código, schema, migration ou banco. A branch do Lote 3A foi criada somente após a correção.

## Migrations inspecionadas integralmente

- `20260606_search_curriculum_rag.sql`
- `20260613_meus_documentos.sql`
- `20260613_pdi_global_alignment.sql`
- `20260614_rls_hardening.sql`
- `20260617_fix_admin_rls_rpc.sql`
- `20260617_fix_missing_profile.sql`
- `20260619_fix_classes_rls.sql`
- `20260620_add_admin_write_policies.sql`
- `20260620_fix_admin_select_and_rpc.sql`
- `20260620_fix_rls_recursion.sql`
- `20260623_search_curriculum_rag_textual.sql`

## Achados

1. Nenhuma tabela, função, trigger ou policy com prefixo `kf_` existia antes deste lote.
2. `curriculum_rag`, `teacher_documents`, `teacher_document_chunks`, `teacher_agents` e estruturas de PDI são legado e não serão alteradas.
3. Há histórico real de recursão RLS em `profiles`, resolvido por helpers `SECURITY DEFINER` com `search_path` fixo.
4. O Lote 3A não reutiliza helpers escolares (`get_my_school_id_safe`, `is_manager_or_admin_safe`) para governança global da Knowledge Factory.
5. Para leitura administrativa do corpus/auditoria, o desenho aprovado exige distinção de `admin`; será usada uma helper exclusiva `kf_is_platform_admin()` que consulta apenas `profiles.role = 'admin'`, sem conceder poder a `manager` ou `school_admin`.
6. O CI geral não executa migrations SQL nem testes Supabase; ele cobre Node/TypeScript, lint, build e testes de aplicação/pacotes.
7. Não existe `supabase/config.toml`, pgTAP ou fluxo de `supabase test db` versionado no repositório.
8. O ambiente desta execução não possui `supabase`, `psql`, Docker ou Podman instalados.

## Consequência operacional

A migration e os testes SQL podem ser produzidos e revisados neste PR, mas o PR não poderá ser classificado como pronto para merge até que a migration seja executada em ambiente Supabase/PostgreSQL descartável e a matriz RLS seja validada com pelo menos dois usuários fictícios.

## Estratégia de segurança

- corpus global: sem policy de professor;
- `anon`: nenhum privilégio `kf_*`;
- `authenticated`: somente privilégios necessários para policies explícitas; RLS continua sendo deny-by-default;
- `admin`: leitura administrativa somente, mediada por `kf_is_platform_admin()`;
- OPP: SELECT e INSERT da própria ordem; sem UPDATE/DELETE direto por usuário final;
- eventos de OPP: SELECT somente quando a OPP pai pertence ao usuário; sem INSERT/UPDATE/DELETE direto;
- append-only reforçado por trigger que rejeita UPDATE/DELETE;
- nenhuma função de retrieval, embedding ou acesso ao legado.
