# CONTINUITY CHECKPOINT 015 — Lote 3B.2 KnowledgeSourceRepository pronto para revisão

Data: 7 de agosto de 2026.

## Status

**A fatia `Lote 3B.2 — Supabase KnowledgeSourceRepository adapter` foi implementada e validada em ambiente descartável. O Pull Request nº 13 permanece em draft, sem merge automático. O GAP-3B-04 permanece ativo, nenhuma story recebe `Done` integral e nenhuma próxima porta está autorizada.**

## Repositório e Pull Request

Repositório:

`PaulinhoRehfeld/profeplan`

Branch:

`feat/knowledge-factory-supabase-source-adapter`

Pull Request:

`#13 — feat(knowledge-factory): add Supabase knowledge source repository adapter`

Base validada:

`5d37e373f2306421cc05c3fb1ffbce0e98f80f05`

Head técnico validado antes desta atualização documental:

`031ad7472b9edec03c912612215e76252109b99f`

## Escopo implementado

- `SupabaseKnowledgeSourceRepository` atribuível a `KnowledgeSourceRepository`;
- client SYSTEM recebido por injeção;
- `findById(id)` em `kf_sources`, com filtro obrigatório e `maybeSingle`;
- `findVersion(sourceId, version)` em `kf_source_versions`, com os dois filtros obrigatórios;
- `listPermissionEvents(sourceId)` em `kf_source_permission_events`, com filtro por fonte e ordenação determinística por `occurred_at` e `id`;
- `save(source)` restrito a `kf_sources`, com conflito controlado exclusivamente por `id`;
- mappers explícitos SQL ↔ `KnowledgeSource`, `SourceVersion` e `SourcePermissionEvent`;
- validação de enums, campos obrigatórios, arrays, opcionais e timestamps;
- listas explícitas de colunas, sem `SELECT *`;
- taxonomia de erros provider-neutral já aprovada;
- observabilidade mínima injetada, allowlisted e sanitizada;
- testes unitários sem rede;
- testes de integração no Supabase descartável do Lote 3A;
- ampliação mínima dos scripts do pacote para executar todas as suítes de repository e integration;
- renomeação descritiva do passo de integração no workflow, sem alterar o ambiente descartável.

## GAP-3B-04 preservado

A implementação cobre exatamente os quatro métodos existentes na porta.

Não foram criados:

- `saveVersion`;
- `saveSegment`;
- `appendPermissionEvent`;
- escrita em `kf_source_versions` pelo adapter;
- escrita em `kf_source_segments` pelo adapter;
- escrita em `kf_source_permission_events` pelo adapter;
- fluxo de ingestão, versionamento completo ou lifecycle autoral paralelo.

O adapter não transforma `save(source)` em comando multi-tabela e não promete ingestão completa.

## Correção durante a validação

O primeiro DB CI do PR, run `31228606997`, número 10, comprovou schema, constraints, RLS, rollback, reaplicação e três dos quatro testes de integração, mas um assert comparava representações textuais equivalentes do mesmo `timestamptz` (`.000Z` e `+00:00`).

A correção ficou restrita ao teste de integração:

- timestamps persistidos passaram a ser comparados semanticamente por instante, conforme o padrão já aprovado no Lote 3B.1;
- nenhum mapper, adapter, schema, contrato ou comportamento de produção foi alterado;
- o run seguinte validou a correção integralmente.

## Validação concluída

### Local

- typecheck do pacote: **verde**;
- testes unitários acumulados: **48/48 verdes**;
- testes novos do adapter de fontes: **23/23 verdes**;
- testes existentes do AuditRepository: **25/25 verdes**;
- Prettier canônico do repositório: **verde**;
- `git diff --check`: **verde**;
- verificação estática: sem `any` generalizado, `createClient`, `process.env`, import de `api/`, INSERT, UPDATE ou DELETE no código-fonte do adapter de fontes.

### GitHub Actions

CI geral:

- workflow: `CI Pipeline`;
- run: `31228789202`;
- número: `222`;
- resultado: **SUCCESS**;
- passaram: instalação, Prettier, ESLint, typecheck, build e testes.

DB CI:

- workflow: `Knowledge Factory DB CI`;
- run: `31228789204`;
- número: `11`;
- resultado: **SUCCESS**;
- passaram: criação do Supabase descartável, schema, constraints, RLS, rollback, reaplicação, integração TypeScript, DB lint, evidência e destruição do ambiente.

Integração acumulada dos adapters:

- testes: **4/4 verdes**;
- AuditRepository: **2/2 verdes**;
- KnowledgeSourceRepository: **2/2 verdes**;
- criação, atualização e leitura de fontes sintéticas: comprovadas;
- ausência por ID e por versão retorna `null`: comprovada;
- leitura de versão por `(source_id, version)`: comprovada;
- histórico de permissão filtrado e ordenado: comprovado;
- isolamento entre fontes: comprovado;
- nenhum dado real ou conexão hospedada: confirmado.

### Vercel

- deployment do head técnico: **Ready**;
- nenhuma falha funcional relacionada ao adapter.

## Segurança e fronteira de produção

- nenhum secret real foi versionado;
- somente chave local descartável, capturada e mascarada durante o workflow;
- nenhum project ref de produção;
- nenhuma URL hospedada real;
- nenhum usuário ou dado real;
- nenhuma migration ou RPC nova;
- nenhum wiring de API ou runtime de produção;
- `service_role` de produção não foi usado;
- o ambiente local foi destruído ao final sem backup;
- nenhuma alteração foi realizada no Supabase de produção ou na Vercel.

## GAPs preservados

Continuam ativos:

- GAP-3B-01 — currículo ativo sem `stage` na porta;
- GAP-3B-02 — componente + versão exige atomicidade real;
- GAP-3B-03 — OPP + evento exige atomicidade e requester context;
- GAP-3B-04 — lifecycle de fonte não coberto integralmente pela porta;
- GAP-3B-05 — tabela física de auditoria mais rica que `DomainEvent`.

Nenhum GAP foi declarado resolvido por este PR.

## Stories

O adapter fornece infraestrutura de persistência para as capacidades relacionadas a:

- US-002.1 — procedência da fonte;
- US-002.2 — autorização/bloqueio.

Essas stories não recebem `Done` integral. O GAP-3B-04 mantém ingestão, versionamento e append de permissão fora desta fatia.

A US-013.2 continua parcial conforme o GAP-3B-05; o Lote 3B.2 não altera esse estado.

## O que não foi implementado

- mudança em `KnowledgeSourceRepository` ou `@profeplan/types`;
- `CurriculumRepository`;
- `PedagogicalComponentRepository`;
- `ProductionOrderRepository`;
- migration ou RPC;
- produção;
- API ou frontend;
- retrieval, embeddings, pgvector ou reranking;
- ingestão, PNLD ou currículo real;
- agentes, Sócrates 2, Gráfica, Nexus ou EPIC-018.

## Próximo gate humano

O Pull Request nº 13 pode seguir para revisão humana depois que os checks do commit deste checkpoint também estiverem verdes.

É proibido iniciar `Lote 3B.3 — CurriculumRepository`, alterar a porta curricular ou implementar qualquer outra porta sem nova aprovação humana explícita.

Não realizar merge automático.

## Próximo momento de fork

**Este checkpoint marca o próximo momento oficial de fork.**

A próxima conversa deverá começar pela leitura deste `CONTINUITY-CHECKPOINT-015.md`, pela revisão humana do Pull Request nº 13 e pela decisão explícita entre solicitar ajustes, aprovar/mergear o PR ou autorizar um ciclo futuro. Nenhuma próxima porta deve ser iniciada por continuidade implícita.
