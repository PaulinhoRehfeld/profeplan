# CONTINUITY CHECKPOINT 017 — Lote 3B.3 CurriculumRepository pronto para revisão

Data: 7 de agosto de 2026.

## Status

**A fatia `Lote 3B.3 — Supabase CurriculumRepository adapter` foi implementada e validada em ambiente descartável. O Pull Request nº 15 permanece em draft, sem merge automático. O GAP-3B-01 está tecnicamente coberto pela alteração da porta e pelos testes de desambiguação, mas permanece aberto até revisão e integração humana deste PR. Nenhuma story recebe `Done` integral e o Lote 3B.4 não está autorizado.**

## Repositório e Pull Request

Repositório:

`PaulinhoRehfeld/profeplan`

Branch:

`feat/knowledge-factory-supabase-curriculum-adapter`

Pull Request:

`#15 — feat(knowledge-factory): add Supabase curriculum repository adapter`

Base validada:

`aeada3ef1aa5916cad7adf86def56f97dafaa22b`

Head técnico validado antes desta atualização documental:

`c4863532447c7d0de2f507d0284d8c0c4bb28b33`

## Alteração da porta

A assinatura ambígua:

`findActivePackageByState(state)`

foi removida e substituída por:

`findActivePackageByStateAndStage(state, stage)`

Consequências confirmadas:

- `EducationStage` é exigido explicitamente;
- não existe alias, overload ou fallback para o método antigo;
- nenhum consumidor produtivo do método antigo foi encontrado;
- `@profeplan/types` e `KNOWLEDGE_FACTORY_CONTRACT_VERSION` não foram alterados;
- a porta está alinhada à unicidade física `(state, stage) WHERE status = 'active'`.

## Escopo implementado

- `SupabaseCurriculumRepository` atribuível a `CurriculumRepository`;
- client SYSTEM recebido por injeção;
- `findPackageById(id)` em `kf_curriculum_packages`;
- `findActivePackageByStateAndStage(state, stage)` com filtros obrigatórios de Estado, etapa e status ativo;
- hidratação de `sourceVersionIds` por leitura separada em `kf_curriculum_package_sources`;
- falha integral quando a hidratação retorna erro ou shape inválido, sem pacote parcial;
- ordenação de `sourceVersionIds` por `source_version_id` ascendente;
- `findNodeById(id)` em `kf_curriculum_nodes`;
- `listNodesByPackage(packageId)` com filtro obrigatório e ordenação por `code`, `version` e `id`, todos ascendentes;
- mappers explícitos SQL → `CurriculumPackage` e `CurriculumNode`;
- validação de enums, campos obrigatórios, arrays, opcionais e timestamps;
- listas explícitas de colunas, sem `SELECT *`;
- erros provider-neutral;
- observabilidade mínima injetada, allowlisted e sanitizada;
- testes contratuais, unitários e de integração com fixtures exclusivamente sintéticas.

## GAP-3B-01

As condições técnicas aprovadas foram comprovadas:

1. a ADR-048 está integrada à `main` por meio do PR nº 14;
2. a porta exige Estado e etapa;
3. o adapter read-only está implementado;
4. testes unitários e de integração comprovam a desambiguação.

A quinta e última condição ainda depende de decisão humana:

5. revisão e integração do PR nº 15.

Portanto, o GAP-3B-01 não é declarado encerrado neste checkpoint. Ele poderá ser encerrado somente após o merge humano deste PR e a verificação pós-integração.

## Validação concluída

### Local

- testes de domínio e contrato: **21/21 verdes**;
- teste contratual novo da porta curricular: **1/1 verde**;
- testes unitários acumulados do pacote Supabase: **70/70 verdes**;
- testes novos do adapter curricular: **22/22 verdes**;
- testes preexistentes de AuditRepository e KnowledgeSourceRepository: **48/48 verdes**;
- typecheck dos pacotes alterados: **verde**;
- Prettier e ESLint dos arquivos alterados: **verdes**;
- filtros oficiais de Prettier, ESLint, typecheck e build do CI: **verdes**;
- suíte completa de testes do monorepo: **verde**;
- `git diff --check`: **verde**;
- verificação estática: sem `any` generalizado, `createClient`, `process.env`, import de `api/`, INSERT, UPSERT, UPDATE ou DELETE no código curricular.

O ambiente local utilizou Node 24 e pnpm 11.5.2. A validação oficial abaixo confirmou o conteúdo em Node 22 e pnpm 11.5.2.

### GitHub Actions

CI geral:

- workflow: `CI Pipeline`;
- run: `31233513061`;
- número: `229`;
- head: `c4863532447c7d0de2f507d0284d8c0c4bb28b33`;
- resultado: **SUCCESS**;
- passaram: instalação, Prettier, ESLint, typecheck, build e testes.

DB CI:

- workflow: `Knowledge Factory DB CI`;
- run: `31233513065`;
- número: `13`;
- head: `c4863532447c7d0de2f507d0284d8c0c4bb28b33`;
- resultado: **SUCCESS**;
- passaram: criação do Supabase descartável, schema, constraints, RLS, rollback, reaplicação, integração TypeScript, DB lint, evidência e destruição do ambiente;
- artifact: `knowledge-factory-db-validation-31233513065`;
- artifact ID: `9014649331`;
- digest: `sha256:3c7cdcf717ae8432509a45bf3398eecb9e92f678fa0881781d8e5790a55040cc`.

Integração acumulada dos adapters:

- testes: **6/6 verdes**;
- AuditRepository: **2/2 verdes**;
- KnowledgeSourceRepository: **2/2 verdes**;
- CurriculumRepository: **2/2 verdes**;
- pacotes MG ativos distintos para Ensino Fundamental II e Ensino Médio: comprovados;
- consulta por `(MG, ensino_medio)` sem vazamento do pacote de `fundamental_ii`: comprovada;
- pacote inexistente retorna `null`: comprovado;
- `sourceVersionIds` isolados e ordenados: comprovados;
- nós de outro pacote não vazam: comprovado;
- `findNodeById` e `listNodesByPackage` mapeiam corretamente: comprovado;
- nenhum dado real ou conexão hospedada: confirmado.

### Vercel

- deployment do head técnico: **Ready**;
- nenhuma falha funcional relacionada ao adapter;
- nenhuma configuração foi alterada.

## Segurança e fronteira de produção

- nenhum secret real foi versionado;
- somente chave local descartável, capturada e mascarada durante o workflow;
- nenhum project ref de produção;
- nenhuma URL hospedada real;
- nenhum usuário ou dado real;
- nenhuma migration, RPC ou mudança de RLS;
- nenhuma escrita curricular;
- nenhuma leitura de `kf_curriculum_links`;
- nenhum wiring de API ou runtime de produção;
- `service_role` de produção não foi usado;
- o Supabase descartável foi destruído ao final;
- nenhuma alteração foi realizada no Supabase de produção ou na Vercel.

## GAPs preservados

- GAP-3B-01 — tecnicamente coberto, mas aberto até merge humano e verificação pós-integração;
- GAP-3B-02 — componente + versão exige atomicidade real;
- GAP-3B-03 — OPP + evento exige atomicidade e requester context;
- GAP-3B-04 — lifecycle de fonte não coberto integralmente pela porta;
- GAP-3B-05 — tabela física de auditoria mais rica que `DomainEvent`.

Nenhum outro GAP foi declarado resolvido por este PR.

## Stories

O adapter fornece infraestrutura parcial para:

- US-006.1 — pacote curricular;
- US-006.2 — vínculos curriculares por meio da leitura de nós.

Essas stories não recebem `Done` integral. Não há currículo real, ingestão, curadoria, leitura de links ou uso por agente.

## O que não foi implementado

- escrita, ativação, aposentadoria ou bloqueio de pacotes;
- gravação de fontes de pacote, nós ou links;
- leitura de `kf_curriculum_links`;
- migration, RPC ou mudança de RLS;
- currículo real de Minas Gerais ou Rio Grande do Sul;
- PNLD;
- API ou frontend;
- retrieval, embeddings, pgvector ou reranking;
- agentes, Sócrates 2 executável, Gráfica, Nexus ou EPIC-018;
- `PedagogicalComponentRepository` ou Lote 3B.4;
- `ProductionOrderRepository` ou Lote 3B.5;
- produção.

## Próximo gate humano

O Pull Request nº 15 pode seguir para revisão humana depois que os checks do commit deste checkpoint também estiverem verdes.

As opções autorizáveis serão:

1. solicitar ajustes;
2. aprovar e integrar o PR por squash merge;
3. rejeitar ou adiar a integração.

Não realizar merge automático. Não iniciar o Lote 3B.4 por continuidade implícita.

## Próximo momento de fork

**Este checkpoint marca o próximo momento oficial de fork.**

A próxima conversa deverá começar pela leitura deste `CONTINUITY-CHECKPOINT-017.md`, pela revisão humana do Pull Request nº 15 e pela decisão explícita sobre sua integração. O Lote 3B.4 permanece bloqueado até nova definição documental e autorização humana após o encerramento formal do 3B.3.
