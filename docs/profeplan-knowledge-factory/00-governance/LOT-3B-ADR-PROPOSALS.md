# Propostas de ADR — Lote 3B

Data: 7 de agosto de 2026.

## Status

**Todas as decisões abaixo são propostas e aguardam aprovação humana.**

Nenhuma proposta autoriza implementação, produção ou alteração das portas existentes.

---

## ADR-040 — Pacote concreto isolado para adapters Supabase

**Status:** proposto para o Lote 3B

### Contexto

ADR-035 já aprovou que adapters Supabase fiquem em pacote separado. O Lote 3B precisa operacionalizar essa fronteira.

### Decisão proposta

Criar, somente após aprovação documental:

`packages/knowledge-factory-supabase/`

Workspace:

`@profeplan/knowledge-factory-supabase`

O pacote implementará portas do domínio e mapeará contratos ↔ Supabase, sem regras pedagógicas, HTTP ou env.

### Consequências

- domínio continua sem I/O;
- Supabase fica isolado;
- adapters podem ser testados separadamente;
- dependências de provider não contaminam `@profeplan/knowledge-factory`.

---

## ADR-041 — SupabaseClient por injeção; pacote não lê segredos

**Status:** proposto para o Lote 3B

### Contexto

O backend atual possui `api/_lib/supabaseAdmin.ts`, mas um pacote de infraestrutura não deve importar composition root nem ler env diretamente.

### Decisão proposta

Adapters recebem `SupabaseClient` já configurado.

O pacote não poderá:

- chamar `createClient()`;
- ler `process.env`;
- importar `api/_lib/supabaseAdmin`;
- armazenar chaves;
- decidir credenciais.

Haverá distinção explícita entre:

- SYSTEM client privilegiado;
- REQUESTER client autenticado/request-scoped.

### Consequências

- `service_role` permanece fora do pacote;
- testes podem injetar cliente descartável;
- wiring e secrets ficam no server-side composition root;
- RLS pode permanecer ativa em fluxos de requester.

---

## ADR-042 — `api/` permanece composition root server-side do runtime atual

**Status:** proposto para o Lote 3B

### Contexto

O deploy Vercel atual encaminha `/api/*` ao diretório raiz `api/`. `apps/bff` é Azure Functions e não possui testes funcionais equivalentes; `packages/auth` usa `next/headers` em seu client server-side.

### Decisão proposta

Enquanto a arquitetura operacional do ProfePlan continuar Vite/Vercel:

- `api/` será a composition root server-side para wiring futuro da Knowledge Factory;
- `packages/*` jamais importarão `api/*`;
- o Lote 3B não migra backend para Azure/BFF;
- nenhuma API da Knowledge Factory será criada ainda.

### Consequências

- evita duplicar runtime;
- preserva direção de dependência;
- não transforma a definição de adapters em refatoração geral do backend.

---

## ADR-043 — Atomicidade multi-tabela somente por transação real/RPC específica

**Status:** proposto para o Lote 3B

### Contexto

Não existe Unit of Work canônico no monorepo e chamadas Supabase JS/PostgREST independentes não formam uma transação compartilhada.

### Decisão proposta

Operações multi-tabela com invariantes não serão implementadas como sequência de chamadas Supabase supostamente atômicas.

Quando atomicidade for necessária:

- função PostgreSQL/RPC estreita;
- migration separada;
- privilégios mínimos;
- testes no Supabase descartável;
- aprovação humana específica.

Não criar Unit of Work genérico fictício.

### Consequências

- transições OPP + evento ficam bloqueadas até RPC;
- criação completa de componente + versão fica bloqueada até fronteira transacional;
- operações simples de uma tabela podem avançar sem RPC.

---

## ADR-044 — Erros de persistência provider-neutral

**Status:** proposto para o Lote 3B

### Decisão proposta

Adapters traduzirão erros Supabase/PostgreSQL para taxonomia estável:

- `NOT_FOUND`;
- `CONFLICT`;
- `CONSTRAINT_VIOLATION`;
- `UNAUTHORIZED`;
- `FORBIDDEN`;
- `UNAVAILABLE`;
- `INVALID_RESPONSE`;
- `UNKNOWN`.

Códigos SQL/PostgREST não serão contratos entre camadas.

### Consequências

- API futura não precisa conhecer provider;
- domínio não importa tipos Supabase;
- logs podem guardar diagnóstico sanitizado sem expor detalhes ao usuário.

---

## ADR-045 — Observabilidade injetada e sanitizada

**Status:** proposto para o Lote 3B

### Contexto

`@profeplan/logger` possui contexto estruturado, mas também usa filesystem síncrono; rotas Vercel atuais usam loggers inline/console.

### Decisão proposta

O adapter define interface mínima de telemetria e recebe implementação por injeção.

Não depender diretamente de logger concreto.

Telemetria inclui somente operação, duração, aggregate id/type, correlation id, outcome e erro estável.

É proibido logar secret, JWT, `extracted_text` ou payload pedagógico integral.

### Consequências

- pacote permanece independente do runtime;
- sink pode evoluir sem alterar adapters;
- reduz risco de vazamento de dados.

---

## ADR-046 — Testes do 3B reutilizam Supabase descartável do Lote 3A

**Status:** proposto para o Lote 3B

### Decisão proposta

Cada adapter terá:

1. testes unitários;
2. integração contra o stack descartável já criado pelo `Knowledge Factory DB CI`;
3. testes de isolamento/RLS quando operar em requester context.

Nenhum teste usa project ref, secret ou dado de produção.

### Consequências

- ambiente reproduzível;
- sem infraestrutura duplicada;
- regressões de schema/RLS e adapter podem ser detectadas juntas.

---

## ADR-047 — Implementação incremental por porta; AuditRepository primeiro

**Status:** proposto para o Lote 3B

### Contexto

Implementar cinco adapters de uma vez aumentaria superfície de erro e anteciparia gaps transacionais.

### Decisão proposta

Sequência inicial:

1. `AuditRepository`;
2. `KnowledgeSourceRepository`;
3. `CurriculumRepository` após corrigir lookup com `stage`;
4. `PedagogicalComponentRepository` em leitura antes de escrita transacional;
5. `ProductionOrderRepository` após requester client e RPC de transição.

O primeiro PR implementará somente `AuditRepository`.

### Consequências

- prova arquitetura com risco mínimo;
- limita blast radius;
- gaps não são escondidos no adapter;
- cada porta recebe gate humano próprio.

---

## Gaps associados às ADRs

### GAP-3B-01

`CurriculumRepository.findActivePackageByState(state)` é ambíguo porque o banco admite um ativo por `(state, stage)`.

Adapter curricular bloqueado até correção aprovada da porta.

### GAP-3B-02

Componente + primeira versão requer atomicidade real.

Escrita completa de componente bloqueada até RPC/comando aprovado.

### GAP-3B-03

Transição de OPP + evento requer atomicidade real.

Transição persistida de OPP bloqueada até RPC/comando aprovado.

### GAP-3B-04

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

ADR-040 a ADR-047 somente poderão ser promovidas a **aprovado** após manifestação humana explícita sobre o pacote documental do Lote 3B.
