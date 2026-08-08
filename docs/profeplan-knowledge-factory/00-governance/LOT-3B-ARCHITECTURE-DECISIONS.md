# Lote 3B — Decisões arquiteturais aprovadas

Data: 7 de agosto de 2026.

## Status

**Aprovado integralmente por decisão humana em 7 de agosto de 2026.**

A aprovação destas decisões autoriza somente a preparação do primeiro PR de código do Lote 3B dentro do escopo explicitamente aprovado. Não autoriza produção, migration nova, ampliação das portas bloqueadas, retrieval, agentes, PNLD real, currículo real, Gráfica, Nexus ou EPIC-018.

Estado atualizado em 8 de agosto de 2026: os Lotes 3B.1, 3B.2 e 3B.3 foram integrados; GAP-3B-01 foi encerrado; 3B.4 está em definição documental. O texto histórico de autorização do primeiro PR permanece preservado.

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

Escrita bloqueada até RPC/comando aprovado.

### GAP-3B-03 — OPP + evento

Transição persistida exige atomicidade real e requester context definido.

Bloqueada até RPC/comando aprovado.

### GAP-3B-04 — lifecycle de fonte

A porta de fontes não cobre criação de versão, segmento ou evento de permissão.

Adapter não inventará operações de ingestão.

### GAP-3B-05 — auditoria física mais rica que a porta

`AuditRepository` devolve `DomainEvent`, enquanto `kf_audit_events` também possui `actor_id`, `actor_role`, `correlation_id`, `outcome` e `reason`.

O primeiro adapter deverá mapear somente o contrato existente. Contexto adicional poderá ser persistido por dependência/contexto injetado quando aprovado, mas não será prometido em `listByAggregate()`.

US-013.2 permanece apenas em fatia parcial até eventual extensão contratual explícita.

### GAP-3B-06 — escrita de versão não representa evidências e vínculos integralmente

`PedagogicalComponentVersion` contém `sourceEvidenceIds` e `curriculumNodeIds`, mas a porta não oferece criação de `EvidenceOrigin` nem define se `saveVersion()` insere, atualiza ou substitui os vínculos.

3B.4B permanece bloqueado. O adapter não criará side-channel de persistência, método não contratado ou sincronização destrutiva implícita.

## ADR-048 — Lookup curricular por Estado e etapa

**Status:** aprovado e implementado no Lote 3B.3

`CurriculumRepository.findActivePackageByState(state)` será substituído por `findActivePackageByStateAndStage(state, stage)`.

A interface receberá `EducationStage` explicitamente, sem alias compatível com a busca antiga. O adapter curricular será inicialmente read-only e usará client SYSTEM injetado. Pacotes deverão ser hidratados com `sourceVersionIds` ordenados; nós serão filtrados por pacote e ordenados por `code`, `version` e `id`.

A decisão foi implementada e integrada por squash merge do PR nº 15 no commit `ad168c6926cb404a5abda5109be4a42d4d0df30b`. O GAP-3B-01 está encerrado.

## ADR-049 — Lote 3B.4 separado em leitura parcial e escrita bloqueada

**Status:** proposto para o Lote 3B.4 em 8 de agosto de 2026

3B.4A implementará somente `findById`, `findVersion` e `listEvidenceOrigins` com client SYSTEM injetado, colunas explícitas, hidratação integral, ordenação determinística e testes descartáveis.

Como a porta completa também expõe `saveComponent` e `saveVersion`, a fatia read-only será verificável contra um `Pick` dos três métodos. Não serão criados stubs de escrita e não será alegada implementação integral da interface.

Leituras sequenciais são aceitas sem promessa de snapshot forte. Nenhuma RPC/read model é necessária enquanto não existir consumidor com requisito explícito de consistência forte.

3B.4B permanece bloqueado por GAP-3B-02 e GAP-3B-06 até decisão contratual, comando transacional, RPC específica, migration isolada, idempotência, privilégios mínimos, testes de rollback e gate humano próprios.

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

## Gate vigente após os Lotes 3B.1–3B.3

O próximo gate é exclusivamente a revisão humana da definição documental do Lote 3B.4.

Somente após seu squash merge e nova autorização poderá ser aberta a implementação 3B.4A. Permanecem bloqueados 3B.4B, 3B.5, qualquer mudança contratual, RPC/migration, produção, API, frontend, retrieval, agentes e conteúdo real.
