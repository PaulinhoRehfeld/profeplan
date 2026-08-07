# Lote 3B — Decisões arquiteturais propostas

Data: 7 de agosto de 2026.

## Status

**Propostas — aguardando aprovação humana.**

Nenhuma decisão deste documento autoriza implementação, produção ou mudança das portas atuais.

## ADR-040 — Pacote concreto isolado para adapters Supabase

**Status:** proposto

Criar, após aprovação documental:

`packages/knowledge-factory-supabase/`

Workspace:

`@profeplan/knowledge-factory-supabase`

O pacote implementará portas do domínio e mapeará contratos ↔ Supabase, sem regras pedagógicas, HTTP, env ou credenciais.

## ADR-041 — SupabaseClient por injeção e separação SYSTEM/REQUESTER

**Status:** proposto

Adapters recebem `SupabaseClient` já configurado. O pacote não chama `createClient()`, não lê `process.env`, não importa `api/_lib/supabaseAdmin.ts` e não armazena secrets.

Contextos:

- SYSTEM: client server-side privilegiado para corpus global/auditoria;
- REQUESTER: client autenticado sob identidade do usuário para operações privadas sujeitas a RLS, especialmente OPP.

`service_role` não será o padrão para simular professor.

## ADR-042 — `api/` permanece composition root server-side do runtime atual

**Status:** proposto

Enquanto o deploy atual permanecer Vite/Vercel:

- `api/` será a composition root server-side para wiring futuro;
- `packages/*` jamais importarão `api/*`;
- o Lote 3B não migra backend nem cria API da Knowledge Factory.

## ADR-043 — Atomicidade multi-tabela somente por transação real/RPC específica

**Status:** proposto

Chamadas Supabase independentes não serão tratadas como uma transação.

Operações indivisíveis, como componente + versão e OPP + evento, ficam bloqueadas até função PostgreSQL/RPC transacional ou fronteira atômica equivalente, versionada, testada e aprovada.

Não criar Unit of Work genérico fictício.

## ADR-044 — Erros de persistência provider-neutral

**Status:** proposto

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

| Provider | Erro estável |
|---|---|
| `23505` | `CONFLICT` |
| `23503`, `23514`, `23502` | `CONSTRAINT_VIOLATION` |
| `42501` / permission denied | `FORBIDDEN` |
| identidade ausente em requester context | `UNAUTHORIZED` |
| rede/timeout | `UNAVAILABLE` |
| shape incompatível | `INVALID_RESPONSE` |
| desconhecido | `UNKNOWN` |

SQLSTATE, PostgREST error bruto, query, URL, headers, token e payload integral não atravessam para domínio/API/UX.

Retry genérico não será implementado no primeiro PR. Escritas append-only não serão repetidas automaticamente sem idempotência aprovada.

## ADR-045 — Observabilidade injetada e sanitizada

**Status:** proposto

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

**Status:** proposto

Cada adapter terá:

1. testes unitários sem rede;
2. integração contra o stack descartável do `Knowledge Factory DB CI`;
3. testes de isolamento/RLS quando usar REQUESTER context.

Nenhum teste usa project ref, token, service role ou dado de produção.

## ADR-047 — Implementação incremental por porta; AuditRepository primeiro

**Status:** proposto

Ordem inicial:

1. AuditRepository;
2. KnowledgeSourceRepository;
3. CurriculumRepository após corrigir lookup com `stage`;
4. PedagogicalComponentRepository em leitura antes de escrita transacional;
5. ProductionOrderRepository após requester client e RPC de transição.

O primeiro PR implementará somente `AuditRepository`.

## Gaps associados

### GAP-3B-01 — currículo ativo

`CurriculumRepository.findActivePackageByState(state)` é ambíguo porque o banco admite um ativo por `(state, stage)`.

Adapter curricular bloqueado até correção de contrato aprovada.

### GAP-3B-02 — componente + versão

Criação completa exige atomicidade real.

Escrita bloqueada até RPC/comando aprovado.

### GAP-3B-03 — OPP + evento

Transição persistida exige atomicidade real e requester context definido.

Bloqueada até RPC/comando aprovado.

### GAP-3B-04 — lifecycle de fonte

A porta de fontes não cobre criação de versão, segmento ou evento de permissão.

Adapter não inventará operações de ingestão.

## Relação com decisões anteriores

Estas propostas complementam, sem substituir:

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

## Gate

ADR-040 a ADR-047 somente poderão ser promovidas a **aprovado** após manifestação humana explícita. Depois deverão ser consolidadas no `DECISION-LOG.md` antes do primeiro PR de código 3B.