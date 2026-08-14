# CONTINUITY CHECKPOINT 009 — Lote 3A rascunhado, validação SQL pendente

Data: 7 de agosto de 2026.

## Status

**Lote 3A implementado em PR rascunho, mas NÃO validado em ambiente Supabase/PostgreSQL executável. PR nº 7 NÃO está autorizado para merge. Produção permanece proibida.**

## Base

Repositório: `PaulinhoRehfeld/profeplan`

Branch: `feat/knowledge-factory-persistence-schema`

Pull Request: nº 7 — `feat(knowledge-factory): add persistence schema and RLS foundation`

## Inspeção pré-SQL concluída

- migrations de `supabase/migrations/` revisadas;
- nenhuma tabela/função/trigger/policy `kf_*` preexistente encontrada;
- `curriculum_rag` permanece legado e intocado;
- histórico de recursão RLS em `profiles` identificado;
- helper isolado `kf_is_platform_admin()` adotado, sem alterar helpers legados;
- duas raízes históricas de SQL identificadas (`supabase/` e `infra/supabase/`), mantendo `supabase/migrations/` como canônica para Knowledge Factory conforme ADR-033;
- CI atual não executa migrations Supabase nem testes SQL/RLS;
- ambiente desta sessão não possui Supabase CLI, Docker ou `psql`.

## Implementação rascunhada

### Migration

`supabase/migrations/202608071120_knowledge_factory_schema.sql`

Contém exclusivamente:

- as 15 tabelas `public.kf_*` aprovadas;
- checks alinhados aos contratos 1.1.0;
- FKs explícitas;
- coerência física da cadeia source → source_version → source_segment;
- coerência de `current_version_id` com a versão do próprio componente por FK composta e diferida;
- links curriculares limitados ao pacote pai;
- índice único parcial para um pacote ativo por `(state, stage)`;
- bloqueio físico de `RS` ativo no MVP;
- índices determinísticos permitidos;
- RLS deny-by-default;
- helper `kf_is_platform_admin()`;
- políticas de leitura administrativa para `admin`;
- OPP própria por `requester_id = auth.uid()`;
- insert direto de OPP somente no status `requested`;
- eventos append-only protegidos por trigger;
- nenhuma coluna vector/FTS/cache/materialized view.

### Testes SQL sintéticos

- `supabase/tests/knowledge_factory_schema.sql`;
- `supabase/tests/knowledge_factory_rls.sql`;
- `supabase/tests/knowledge_factory_rollback.sql`.

Os testes cobrem, em desenho:

- existência das 15 tabelas;
- ausência de vector;
- checks/status/versões;
- FKs órfãs;
- unicidade;
- pacote curricular ativo único;
- RS não ativo;
- `current_version_id` cruzado entre componentes;
- coerência de evidência;
- append-only;
- anon sem acesso;
- teacher sem corpus/auditoria;
- teacher A versus B em OPP/eventos;
- requester adulterado;
- school_admin sem privilégio global;
- admin com leitura administrativa e sem escrita direta;
- rollback guardado contra destruição se existir qualquer dado `kf_*`.

## Ajuste de branch realizado

Foi detectada uma migration duplicada de tentativa anterior (`20260807_knowledge_factory_schema.sql`) e um arquivo de auditoria redundante. Ambos foram removidos da branch. Existe agora somente uma migration canônica e uma única nota de inspeção.

## CI geral

O CI do monorepo foi acionado pelo PR e passou instalação, Prettier, ESLint, typecheck, build e testes do código existente.

Importante: esse CI NÃO executa os arquivos SQL do Lote 3A. Portanto, CI verde não satisfaz o gate de banco.

## Gate bloqueante atual

Antes de marcar o PR nº 7 como pronto ou solicitar merge, é obrigatório executar em ambiente não produtivo/descartável:

1. baseline compatível com o schema Supabase real;
2. migration 3A;
3. `knowledge_factory_schema.sql`;
4. `knowledge_factory_rls.sql` com usuários sintéticos;
5. rollback guardado;
6. confirmação de remoção exclusiva de objetos `kf_*`;
7. reaplicação da migration;
8. repetição dos testes de schema/RLS;
9. registro das evidências e correções eventualmente necessárias.

## Como destravar

É necessário disponibilizar um ambiente Supabase/PostgreSQL NÃO PRODUTIVO capaz de executar a migration.

Opções aceitáveis:

- Supabase local/descartável com CLI + Docker;
- projeto Supabase de homologação exclusivo e vazio/descartável;
- ambiente Codex/CI explicitamente preparado para Supabase local, mediante novo gate humano para qualquer alteração de workflow.

Não fornecer service role, senha de banco ou credencial de produção em chat ou em arquivos versionados.

## Produção

Continua proibida.

Mesmo após futura aprovação e merge do PR nº 7, a aplicação em produção exige autorização humana separada conforme ADR-038 e os documentos do Lote 3.

## Lote 3B

Continua bloqueado.

Nenhum adapter Supabase deve ser criado antes do fechamento validado do Lote 3A.

## Fork

Ainda não há novo fork obrigatório neste checkpoint. O próximo marco de continuidade ocorrerá após a validação real em ambiente não produtivo e a decisão humana sobre o PR nº 7.
