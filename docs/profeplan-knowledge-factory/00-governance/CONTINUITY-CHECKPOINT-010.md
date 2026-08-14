# CONTINUITY CHECKPOINT 010 — Lote 3A validado em Supabase descartável

Data: 7 de agosto de 2026.

## Status

**Lote 3A implementado e validado em ambiente Supabase local/descartável no GitHub Actions. PR nº 7 pode seguir para revisão humana. NÃO realizar merge automático. Produção permanece proibida e exige gate separado.**

## Base

Repositório: `PaulinhoRehfeld/profeplan`

Branch: `feat/knowledge-factory-persistence-schema`

Pull Request: nº 7 — `feat(knowledge-factory): add persistence schema and RLS foundation`

Branch head validado: `30ee0701284e229779a2bff12074f2e3bcccf143`

Merge-ref efêmero usado pelo workflow do PR: `163b2ac0bedfdf076c652d5504057cb69d5aa614`

## Ambiente de validação

Foi criado um workflow exclusivo e não produtivo:

`.github/workflows/knowledge-factory-db-ci.yml`

Características:

- GitHub Actions `ubuntu-latest`;
- Supabase CLI fixada em `2.109.1` para reprodutibilidade;
- Docker `28.0.4` no runner da execução registrada;
- PostgreSQL client `16.14`;
- nenhum `SUPABASE_ACCESS_TOKEN`;
- nenhum project ref hospedado;
- nenhuma senha/service role de produção;
- projeto Supabase temporário inicializado dentro do runner;
- stack destruída com `supabase stop --no-backup` ao final.

## Baseline sintética

Arquivo:

`supabase/tests/fixtures/knowledge_factory_minimal_baseline.sql`

A baseline contém exclusivamente a dependência legada necessária ao Lote 3A:

- `public.profiles` com shape compatível com os campos usados pela Knowledge Factory;
- FK para `auth.users` fornecida pelo Supabase local;
- roles de perfil relevantes (`teacher`, `manager`, `school_manager`, `school_admin`, `admin`);
- RLS habilitada;
- nenhum dado real.

A baseline NÃO é migration de produção e não é copiada para o diretório canônico do repositório. No workflow ela é copiada apenas para o workdir descartável antes da migration 3A.

## Execução Supabase registrada

Workflow: `Knowledge Factory DB CI`

Run ID: `31193046933`

Resultado: **SUCCESS**

Artefato de evidência:

`knowledge-factory-db-validation-31193046933`

Artifact ID: `8999681019`

Digest:

`sha256:3a513159e163eacf7b1e6962e39e88795ef27ebf255051eaa596b76eb04a1154`

Período registrado no log:

- início UTC: `2026-08-07T15:32:00Z`;
- fim UTC: `2026-08-07T15:33:42Z`.

## Sequência executada com sucesso

1. checkout do PR;
2. instalação da Supabase CLI;
3. instalação do cliente PostgreSQL;
4. criação do projeto Supabase descartável;
5. aplicação da baseline sintética;
6. aplicação da migration `202608071120_knowledge_factory_schema.sql`;
7. primeira execução de `knowledge_factory_schema.sql`;
8. primeira execução de `knowledge_factory_rls.sql`;
9. execução de `knowledge_factory_rollback.sql`;
10. confirmação `OK:rollback_isolated`;
11. reaplicação da migration 3A;
12. segunda execução de `knowledge_factory_schema.sql`;
13. segunda execução de `knowledge_factory_rls.sql`;
14. `supabase db lint --local --level error`;
15. resultado do lint: `No schema errors found`;
16. upload do artefato de evidência;
17. destruição do ambiente descartável sem backup.

## Schema e constraints comprovados

Os testes executados comprovam no ambiente descartável:

- existência das 15 tabelas `public.kf_*`;
- nenhuma coluna `vector`;
- nenhum IVFFlat/HNSW;
- nenhuma dependência física de `curriculum_rag`;
- estados inválidos rejeitados;
- versões vazias rejeitadas;
- FKs órfãs rejeitadas;
- versões duplicadas rejeitadas;
- pacote `active` único por `(state, stage)`;
- RS não pode ficar `active` no MVP;
- `current_version_id` não pode apontar para versão de outro componente;
- cadeia de evidência source/version/segment coerente;
- links curriculares limitados ao pacote correto;
- nenhuma trigger `kf_*` instalada em tabela legada.

## RLS comprovada

A matriz sintética executada usa identidades distintas e comprovou:

- `anon` sem acesso direto;
- professor autenticado sem leitura do corpus global;
- professor sem leitura de segmentos brutos;
- professor sem leitura de componentes globais;
- professor sem leitura de auditoria;
- professor A lê somente OPP A;
- professor A não lê OPP B;
- professor B não lê OPP A;
- eventos de OPP seguem ownership da OPP pai;
- `requester_id` adulterado é rejeitado;
- professor não atualiza status de OPP diretamente;
- professor não insere eventos arbitrários;
- professor não insere permission events;
- `school_admin` não se torna administrador global;
- `admin` pode fazer leitura administrativa aprovada;
- `admin` não recebe escrita direta de corpus neste lote.

## Append-only comprovado

UPDATE e DELETE foram rejeitados, inclusive quando executados pelo executor privilegiado de teste, para:

- `kf_source_permission_events`;
- `kf_production_order_events`;
- `kf_audit_events`.

O mecanismo físico é trigger de proteção, além dos grants/RLS restritivos.

## Rollback comprovado

O rollback foi executado após testes transacionais e:

- recusaria execução destrutiva caso qualquer tabela `kf_*` possuísse registros;
- removeu policies, triggers, tabelas e funções exclusivas `kf_*`;
- preservou `public.profiles` da baseline;
- confirmou `OK:rollback_isolated`;
- permitiu reaplicação integral da migration;
- permitiu repetir schema e RLS com sucesso após a reaplicação.

## CI geral do monorepo

Workflow: `CI Pipeline`

Run ID: `31193045637`

Resultado: **SUCCESS**

Passaram:

- instalação;
- Prettier;
- ESLint;
- TypeScript typecheck;
- build;
- testes do monorepo.

O workflow de banco agora complementa o CI geral; ele não substitui os testes de aplicação.

## Diff do Lote 3A

Continua aditivo.

Novos artefatos autorizados incluem:

- migration 3A;
- testes SQL sintéticos;
- baseline mínima exclusivamente de teste;
- workflow de validação Supabase descartável;
- documentação/checkpoints.

Não foram alterados:

- `curriculum_rag`;
- profiles de produção;
- students;
- classes;
- PDI;
- billing/créditos;
- migrations legadas;
- `@profeplan/types`;
- `@profeplan/knowledge-factory`;
- API;
- frontend;
- agentes;
- IA/retrieval/vetores.

## Gate do PR nº 7

Os gates técnicos previstos antes de classificar o PR como pronto para revisão foram satisfeitos no ambiente não produtivo/descartável.

Portanto:

- o PR nº 7 pode sair de draft para revisão humana;
- merge automático continua proibido;
- Lote 3B continua proibido até merge e novo gate explícito.

## Gate de produção continua separado

A validação local NÃO autoriza aplicação da migration no Supabase de produção.

Antes de produção continuam obrigatórios:

1. identificar formalmente o projeto alvo;
2. capturar snapshot/schema atual do banco alvo;
3. analisar divergência entre banco alvo e migrations versionadas;
4. confirmar backup/pre-flight;
5. confirmar ausência de objetos `kf_*` no alvo;
6. definir executor e janela;
7. definir comandos exatos de aplicação;
8. definir resposta/rollback para falha;
9. obter autorização humana explícita específica para produção.

Nenhuma credencial de produção deve ser colocada em chat ou arquivo versionado.

## Nexus

Integração com Nexus permanece deliberadamente adiada. O foco continua nas funções internas do ProfePlan e na Knowledge Factory.

## Lote 3B

Não iniciar.

O Lote 3B somente poderá ser autorizado após:

- decisão humana sobre merge do PR nº 7;
- merge efetivo na `main`;
- novo checkpoint da `main` pós-merge;
- autorização explícita para adapters Supabase.

## Próximo momento de fork

O próximo momento recomendado de fork/continuidade é **imediatamente após o merge humano do PR nº 7 na `main`**.

Nesse ponto deve ser criado um novo checkpoint confirmando o commit de merge/squash e somente então decidir se o trabalho seguirá para:

- preparação do Lote 3B; ou
- pre-flight separado de produção.

Até esse fork, não iniciar 3B e não aplicar nada em produção.
