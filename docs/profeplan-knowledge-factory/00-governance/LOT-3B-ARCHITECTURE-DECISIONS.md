# Lote 3B — Decisões arquiteturais aprovadas

Data: 7 de agosto de 2026.

## Status

**Aprovado integralmente por decisão humana em 7 de agosto de 2026.**

A aprovação destas decisões autoriza somente a preparação do primeiro PR de código do Lote 3B dentro do escopo explicitamente aprovado. Não autoriza produção, migration nova, ampliação das portas bloqueadas, retrieval, agentes, PNLD real, currículo real, Gráfica, Nexus ou EPIC-018.

Estado atualizado em 11 de agosto de 2026: os Lotes 3B.1, 3B.2, 3B.3 e 3B.4 foram integrados;
GAP-3B-01, GAP-3B-02 e GAP-3B-06 foram encerrados. O texto histórico de autorização do primeiro PR
permanece preservado.

## ADR-040 — Pacote concreto isolado para adapters Supabase

**Status:** aprovado

Criar:

`packages/knowledge-factory-supabase/`

Workspace:

`@profeplan/knowledge-factory-supabase`

O pacote implementará portas do domínio e mapeará contratos ↔ Supabase, sem regras pedagógicas, HTTP, env ou credenciais.

## ADR-041 — SupabaseClient por injeção e separação SYSTEM/REQUESTER

**Status:** aprovado

Adapters recebem `SupabaseClient` já configurado. O pacote não chama `createClient()`, não lê `process.env`, não importa `api/_lib/supabaseAdmin.ts` e não armazena secrets.

Contextos:

- SYSTEM: client server-side privilegiado para corpus global/auditoria;
- REQUESTER: client autenticado sob identidade do usuário para operações privadas sujeitas a RLS, especialmente OPP.

`service_role` não será o padrão para simular professor.

## ADR-042 — `api/` permanece composition root server-side do runtime atual

**Status:** aprovado

Enquanto o deploy atual permanecer Vite/Vercel:

- `api/` será a composition root server-side para wiring futuro;
- `packages/*` jamais importarão `api/*`;
- o Lote 3B não migra backend nem cria API da Knowledge Factory.

## ADR-043 — Atomicidade multi-tabela somente por transação real/RPC específica

**Status:** aprovado

Chamadas Supabase independentes não serão tratadas como uma transação.

Operações indivisíveis, como componente + versão e OPP + evento, ficam bloqueadas até função PostgreSQL/RPC transacional ou fronteira atômica equivalente, versionada, testada e aprovada.

Não criar Unit of Work genérico fictício.

## ADR-044 — Erros de persistência provider-neutral

**Status:** aprovado

Taxonomia estável inicial:

- `NOT_FOUND`;
- `CONFLICT`;
- `CONSTRAINT_VIOLATION`;
- `UNAUTHORIZED`;
- `FORBIDDEN`;
- `UNAVAILABLE`;
- `INVALID_RESPONSE`;
- `UNKNOWN`.

Métodos `find*` que admitem ausência retornam `null`; indisponibilidade nunca vira `null` silencioso.

Mapeamento mínimo:

| Provider                                | Erro estável           |
| --------------------------------------- | ---------------------- |
| `23505`                                 | `CONFLICT`             |
| `23503`, `23514`, `23502`               | `CONSTRAINT_VIOLATION` |
| `42501` / permission denied             | `FORBIDDEN`            |
| identidade ausente em requester context | `UNAUTHORIZED`         |
| rede/timeout                            | `UNAVAILABLE`          |
| shape incompatível                      | `INVALID_RESPONSE`     |
| desconhecido                            | `UNKNOWN`              |

SQLSTATE, PostgREST error bruto, query, URL, headers, token e payload integral não atravessam para domínio/API/UX.

Retry genérico não será implementado no primeiro PR. Escritas append-only não serão repetidas automaticamente sem idempotência aprovada.

## ADR-045 — Observabilidade injetada e sanitizada

**Status:** aprovado

Adapters não dependerão diretamente de `@profeplan/logger` no primeiro PR.

Receberão interface mínima de telemetria por injeção. Campos permitidos:

- operation;
- adapter;
- durationMs;
- outcome;
- aggregateType/aggregateId quando aplicável;
- correlationId quando disponível;
- rowCount quando não sensível;
- errorCode sanitizado.

Nunca registrar:

- service role;
- JWT/access token;
- Authorization header;
- senha;
- `extracted_text`;
- texto integral de fonte/componente/OPP;
- metadata arbitrária integral;
- query SQL completa.

`kf_audit_events` e telemetria operacional são responsabilidades diferentes. O AuditRepository não gera recursivamente audit event ao registrar sua própria telemetria.

## ADR-046 — Testes do 3B reutilizam Supabase descartável do Lote 3A

**Status:** aprovado

Cada adapter terá:

1. testes unitários sem rede;
2. integração contra o stack descartável do `Knowledge Factory DB CI`;
3. testes de isolamento/RLS quando usar REQUESTER context.

Nenhum teste usa project ref, token, service role ou dado de produção.

## ADR-047 — Implementação incremental por porta; AuditRepository primeiro

**Status:** aprovado

Ordem inicial:

1. AuditRepository;
2. KnowledgeSourceRepository;
3. CurriculumRepository após corrigir lookup com `stage`;
4. PedagogicalComponentRepository em leitura antes de escrita transacional;
5. ProductionOrderRepository após requester client e RPC de transição.

O primeiro PR implementará somente `AuditRepository` e será tratado como prova da infraestrutura de adapter, não como conclusão integral da auditoria funcional.

## Gaps associados — aceitos como restrições do Lote 3B

A aprovação humana reconhece formalmente estes gaps e suas medidas de contenção. Nenhum deles é considerado resolvido apenas pela aprovação documental.

### GAP-3B-01 — currículo ativo

`CurriculumRepository.findActivePackageByState(state)` é ambíguo porque o banco admite um ativo por `(state, stage)`.

**Status atualizado:** encerrado após correção do contrato, testes de desambiguação e integração humana do PR nº 15.

### GAP-3B-02 — componente + versão

Criação completa exige atomicidade real.

**Status atualizado:** encerrado após integração das RPCs transacionais no PR nº 21 e do adapter
de comandos no PR nº 22, com atomicidade, rollback, replay e concorrência verdes no Supabase
descartável.

### GAP-3B-03 — OPP + evento

Transição persistida exige atomicidade real e requester context definido.

**Status atualizado:** encerrado após integração dos quatro sublotes do Lote 3B.5 pelos PRs nº 25 a
28 e formalização pós-merge no Checkpoint 031. RPCs atômicas, requester isolation, transição
server-only, idempotência e concorrência permanecem controles obrigatórios.

### GAP-3B-04 — lifecycle de fonte

A porta de fontes não cobre criação de versão, segmento ou evento de permissão.

Adapter não inventará operações de ingestão.

**Status atualizado:** ativo e contido para a saída da Fase B no Checkpoint 032. Ingestão,
versionamento, segmentação e eventos de permissão reais permanecem bloqueados. A primeira frente
documental futura da Fase C deverá definir a governança operacional desse lifecycle em lote
próprio, sem autorização implícita de código.

### GAP-3B-05 — auditoria física mais rica que a porta

`AuditRepository` devolve `DomainEvent`, enquanto `kf_audit_events` também possui `actor_id`, `actor_role`, `correlation_id`, `outcome` e `reason`.

O primeiro adapter deverá mapear somente o contrato existente. Contexto adicional poderá ser persistido por dependência/contexto injetado quando aprovado, mas não será prometido em `listByAggregate()`.

US-013.2 permanece apenas em fatia parcial até eventual extensão contratual explícita.

**Status atualizado:** ativo e contido no Checkpoint 032. A extensão futura exige contrato
versionado, minimização/LGPD, regras de acesso, mapeamento completo e testes de round-trip. Não
bloqueia a preparação de matéria-prima, mas impede qualquer alegação de auditoria enriquecida.

### GAP-3B-06 — escrita de versão não representa evidências e vínculos integralmente

`PedagogicalComponentVersion` contém `sourceEvidenceIds` e `curriculumNodeIds`, mas a porta não oferece criação de `EvidenceOrigin` nem define se `saveVersion()` insere, atualiza ou substitui os vínculos.

**Status atualizado:** encerrado. O contrato `2.0.0` substituiu os métodos `save*` por comandos
explícitos que transportam `EvidenceOrigin` completo e vínculos versionados. O adapter integrado
pelo PR nº 22 usa somente as RPCs correspondentes, sem side-channel ou sincronização destrutiva.

### GAP-3B-07 — fatia física da OPP menor que o contrato normativo

O contrato e o schema atuais não persistem integralmente contexto, inclusão, atores, sequência,
correlação, tentativas, componentes utilizados, validações e entrega previstos no contrato
normativo da OPP.

O gap não bloqueia a fatia mínima do `ProductionOrderRepository`, mas impede declarar a OPP
funcional completa ou as Stories US-010.1/US-010.2 integralmente concluídas.

**Status atualizado:** ativo e contido para a saída da Fase B no Checkpoint 032. Contexto,
inclusão, atores, correlação, tentativas, custos, retrieval, validação e entrega somente poderão ser
abertos nos gates das fases correspondentes.

## ADR-048 — Lookup curricular por Estado e etapa

**Status:** aprovado e implementado no Lote 3B.3

`CurriculumRepository.findActivePackageByState(state)` será substituído por `findActivePackageByStateAndStage(state, stage)`.

A interface receberá `EducationStage` explicitamente, sem alias compatível com a busca antiga. O adapter curricular será inicialmente read-only e usará client SYSTEM injetado. Pacotes deverão ser hidratados com `sourceVersionIds` ordenados; nós serão filtrados por pacote e ordenados por `code`, `version` e `id`.

A decisão foi implementada e integrada por squash merge do PR nº 15 no commit `ad168c6926cb404a5abda5109be4a42d4d0df30b`. O GAP-3B-01 está encerrado.

## ADR-049 — Lote 3B.4 separado em leitura parcial e escrita bloqueada

**Status:** aprovado e implementado integralmente no Lote 3B.4

3B.4A implementará somente `findById`, `findVersion` e `listEvidenceOrigins` com client SYSTEM injetado, colunas explícitas, hidratação integral, ordenação determinística e testes descartáveis.

Como a porta completa também expõe `saveComponent` e `saveVersion`, a fatia read-only será verificável contra um `Pick` dos três métodos. Não serão criados stubs de escrita e não será alegada implementação integral da interface.

Leituras sequenciais são aceitas sem promessa de snapshot forte. Nenhuma RPC/read model é necessária enquanto não existir consumidor com requisito explícito de consistência forte.

O 3B.4B permaneceu bloqueado até decisão contratual, comando transacional, RPC específica,
migration isolada, idempotência, privilégios mínimos, testes de rollback e gates humanos próprios.
Essas condições foram satisfeitas pelos PRs nº 19 a 22.

## ADR-051 — Fronteira tripartida e comandos atômicos da OPP

**Status:** aprovado e integrado pelo Pull Request nº 24 em 11 de agosto de 2026

O `ProductionOrderRepository` será decomposto em leitura, solicitação e transição. `save(order)` e
`appendEvent(event)` serão removidos; criação e transição terão comandos e recibos idempotentes
próprios. A criação será REQUESTER e sempre incluirá o evento `created`. A transição será server-only,
precedida pela política de domínio e executada por RPC estreita com ownership esperado,
compare-and-set e evento derivado.

O sublote 3B.5.1 elevou o contrato para `3.0.0` e foi integrado pelo Pull Request nº 25. O adapter
REQUESTER read-only do 3B.5.2 foi integrado pelo Pull Request nº 26. A migration/RPCs do 3B.5.3 foi
integrada pelo Pull Request nº 27. Os adapters de comando do 3B.5.4 foram integrados pelo Pull
Request nº 28, sem composição ou wiring automático. O Checkpoint 031 encerrou `GAP-3B-03` e o Lote
3B.5.

## ADR-052 — Cobertura mínima explicitamente parcial da OPP

**Status:** aprovado e integrado pelo Pull Request nº 24 em 11 de agosto de 2026

O 3B.5 conecta somente o domínio e o schema já materializados. Os campos normativos ainda ausentes
permanecem em `GAP-3B-07` e não serão antecipados das Fases C, D ou E. O gate de saída da Fase B
poderá reconhecer bloqueio parcial, mas não declarar o contrato normativo integralmente entregue.

## ADR-053 — Saída da Fase B por bloqueio parcial controlado

**Status:** aprovado para formalização no Checkpoint 032 em 11 de agosto de 2026

A Fase B será encerrada após a integração do Checkpoint 032 porque os adapters previstos para o
MVP foram concluídos, as pseudo-transações críticas foram substituídas por fronteiras atômicas
testadas, a integração descartável está verde e nenhuma capacidade exige produção.

`GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07` permanecem ativos. O encerramento ocorre por contenção, não
por resolução. Cada gap mantém proibições, destino futuro e gate de reabertura explícitos. A Fase C
não é iniciada por esta decisão; sua primeira frente deverá ser definida documentalmente como
governança operacional do lifecycle de fontes, mediante autorização humana própria.

## Relação com decisões anteriores

Estas decisões complementam, sem substituir:

- ADR-019 contract-first;
- ADR-022 corpus sem leitura pública direta;
- ADR-030 repositórios como portas;
- ADR-031 domínio puro;
- ADR-033 Supabase SQL canônico;
- ADR-034 deny-by-default;
- ADR-035 adapters em pacote separado;
- ADR-036 requester isolation;
- ADR-038 produção com gate separado;
- ADR-039 append-only.

## Gate após aprovação

Com ADR-040 a ADR-047 aprovadas, pode ser preparada e implementada somente a primeira fatia de código definida para `AuditRepository`, após integração deste PR documental à `main` e em nova branch a partir da `main` integrada.

Qualquer segunda porta, mudança de contrato público, RPC/migration, wiring de produção ou ampliação de escopo exige novo gate humano.

## Gate vigente — integração do encerramento documental da Fase B

O próximo gate é revisar e integrar o Checkpoint 032. Somente após eventual integração, e mediante
nova autorização humana em branch própria, poderá ser definida documentalmente a primeira frente
da Fase C: governança operacional do lifecycle de fontes.

O encerramento da Fase B não inicia a Fase C. Ingestão, produção, API, frontend, retrieval,
agentes, Supabase hospedado e conteúdo real permanecem bloqueados até autorizações próprias.
