# Lote 3B — Adapters Supabase

Data: 7 de agosto de 2026.

## Status

**Definição documental aprovada integralmente por decisão humana em 7 de agosto de 2026. Nenhum adapter foi implementado por este documento. Produção permanece bloqueada.**

Base: `main` no commit `82b5dce90d2cb7437922dfc27062b1f16aa0c0a6`, após integração e checkpoint do Lote 3A.

## Objetivo

Implementar, em etapas posteriores e somente dentro dos gates aprovados, adapters Supabase para as portas de persistência existentes em `@profeplan/knowledge-factory`, preservando:

- domínio puro;
- separação entre contratos, domínio e infraestrutura;
- RLS e privilégio mínimo;
- append-only;
- rastreabilidade;
- testes sem produção;
- gate independente para aplicação da migration no Supabase real.

O Lote 3B **não** cria API pública, frontend, retrieval, embeddings, agentes, PNLD real, currículo real, Gráfica ou integração com Nexus.

---

## 1. Evidências da inspeção do monorepo

### 1.1 Portas atuais

Existem cinco portas:

- `KnowledgeSourceRepository`;
- `PedagogicalComponentRepository`;
- `CurriculumRepository`;
- `ProductionOrderRepository`;
- `AuditRepository`.

Elas continuam agnósticas de SQL, Supabase, HTTP e providers.

### 1.2 Superfície backend canônica observada

O deploy Vercel constrói `apps/web` e expõe funções em `api/` por rewrite `/api/(.*) -> /api/$1`.

O CI atual registra `apps/bff` como stub/stack não implantada no produto real e o exclui de lint/typecheck/build junto com outros pacotes legados.

Decisão aprovada:

> `api/` permanece o composition root server-side do produto atual. O pacote de adapters não dependerá de `api/`; `api/` injetará dependências no pacote em lote futuro de wiring.

### 1.3 Cliente privilegiado existente

Existe `api/_lib/supabaseAdmin.ts`, que:

- usa `@supabase/supabase-js`;
- lê `SUPABASE_URL` e `SUPABASE_SERVICE_ROLE_KEY` do ambiente;
- desativa persistência de sessão e refresh automático;
- exporta um singleton `supabaseAdmin`.

O adapter **não deve importar esse arquivo**, porque isso criaria dependência de `packages/*` para `api/*`.

A reutilização correta é por **injeção de cliente no composition root**.

### 1.4 Logging existente

Existe `@profeplan/logger` com JSON estruturado, `correlationId` via `AsyncLocalStorage` e níveis info/warn/error/audit.

Entretanto, o pacote também usa filesystem síncrono. O próprio runtime Vercel atual possui handlers que usam logger JSON inline porque o logger de pacote não é considerado adequado/disponível nesse contexto serverless.

Decisão aprovada:

> O pacote de adapters não dependerá diretamente de `@profeplan/logger` no primeiro PR. Ele receberá uma interface mínima de telemetria por injeção.

### 1.5 Transações / Unit of Work

Não foi identificada abstração canônica de Unit of Work nem suporte geral a transação multi-call por Supabase JS no monorepo.

Consequência aprovada:

> Nenhum adapter poderá fingir atomicidade por sequência de `.from(...).insert/update(...)` independentes.

Operações multi-tabela que precisam ser atômicas exigirão RPC/função SQL transacional ou nova fronteira explicitamente aprovada.

### 1.6 Testes Supabase

O Lote 3A já fornece `Knowledge Factory DB CI`, que sobe Supabase descartável sem credenciais hospedadas, aplica a migration, testa schema/RLS/rollback e destrói o ambiente.

Também existe no frontend um padrão de query builder Supabase controlado em testes de caracterização. Esse padrão pode servir apenas como referência de test double; o novo pacote deverá possuir helpers próprios e não importar testes do frontend.

Decisão aprovada:

> O Lote 3B reutilizará o stack descartável do Lote 3A e criará testes unitários locais do próprio pacote; não criará um segundo stack de banco.

---

## 2. Pacote aprovado

`packages/knowledge-factory-supabase/`

Workspace futuro:

`@profeplan/knowledge-factory-supabase`

Responsabilidades:

- implementar portas aprovadas;
- mapear snake_case SQL ↔ camelCase dos contratos;
- receber clients Supabase por injeção;
- traduzir erros de provider;
- emitir observabilidade sanitizada;
- manter testes unitários e de integração;
- nunca conter regra pedagógica de domínio.

Não será responsabilidade do pacote:

- ler variáveis de ambiente;
- criar `service_role` diretamente;
- autenticar usuário;
- validar JWT;
- decidir currículo;
- decidir elegibilidade de fonte/componente;
- executar transições pedagógicas;
- expor HTTP;
- aplicar migrations;
- executar retrieval ou IA.

---

## 3. Dependências aprovadas para o primeiro PR

### Runtime

`@supabase/supabase-js`

Motivo: dependência concreta do adapter, já presente no monorepo em `^2.45.4`. No PR de implementação deverá ser declarada diretamente no pacote; não depender de hoisting implícito.

### Internas / contratos

- `@profeplan/knowledge-factory` — interfaces das portas;
- `@profeplan/types` — contratos recebidos/retornados.

Usar `import type` sempre que o símbolo não existir em runtime. A forma de declaração no `package.json` deverá permitir resolução explícita pelo pnpm sem criar dependência circular.

### Não adicionar inicialmente

- ORM;
- Prisma;
- query builder;
- biblioteca de retry;
- biblioteca de transação;
- biblioteca de logging.

Qualquer nova dependência exige aprovação humana.

---

## 4. Modelo de clients e privilégio

### 4.1 SYSTEM context

Cliente Supabase privilegiado criado fora do pacote, server-side, potencialmente com `service_role`.

Uso permitido:

- corpus global curado;
- escrita administrativa controlada;
- auditoria;
- operações internas explicitamente aprovadas.

Uso proibido:

- frontend;
- serialização;
- retorno ao cliente;
- logs;
- fixtures;
- arquivos versionados.

### 4.2 REQUESTER context

Cliente Supabase autenticado no contexto do usuário, para operações privadas nas quais RLS deve participar da defesa em profundidade.

Uso previsto:

- OPP do próprio requester.

O adapter não cria credenciais. Recebe instância já configurada pelo composition root.

### 4.3 Regra de fronteira

O pacote não acessa `process.env` e não importa `api/_lib/supabaseAdmin.ts`.

A estratégia de criação do requester-scoped client deverá ser definida antes da implementação do `ProductionOrderRepository`.

---

## 5. Gaps aprovados como restrições arquitetônicas

A aprovação integral desta definição reconhece os gaps abaixo e aprova suas medidas de contenção. Os gaps permanecem bloqueios onde indicado.

### GAP-3B-01 — lookup curricular sem `stage`

`CurriculumRepository.findActivePackageByState(state)` recebe apenas Estado, enquanto o schema 3A admite um pacote ativo por `(state, stage)`.

**Decisão:** antes do adapter curricular, revisar a porta para receber também `stage`. Nenhuma alteração de contrato ocorre no primeiro PR.

### GAP-3B-02 — componente + versão exige atomicidade

`PedagogicalComponentRepository` expõe `saveComponent` e `saveVersion` separadamente. Criar componente + primeira versão/current version como chamadas HTTP independentes não fornece atomicidade.

**Decisão:** escrita de componente fica bloqueada até comando/RPC transacional aprovado.

### GAP-3B-03 — OPP + evento exige atomicidade

`ProductionOrderRepository` expõe `save(order)` e `appendEvent(event)` separadamente. Uma mudança de estado da OPP e o evento correspondente não devem divergir.

**Decisão:** transições OPP ficam bloqueadas até fronteira transacional e requester context aprovados.

### GAP-3B-04 — lifecycle de fonte incompleto para ingestão

`KnowledgeSourceRepository` permite `save(source)`, mas não grava `SourceVersion`, `SourceSegment` nem `SourcePermissionEvent`.

**Decisão:** implementar somente métodos existentes; ingestão/versionamento completo fica para lote próprio.

### GAP-3B-05 — AuditRepository não round-tripa todo o registro físico

`AuditRepository` trabalha com `DomainEvent`, cujo contrato contém `eventType`, `aggregateType`, `aggregateId`, `occurredAt` e `metadata`. A tabela `kf_audit_events` também persiste `actor_id`, `actor_role`, `correlation_id`, `outcome` e `reason`.

Consequências:

- o adapter pode receber contexto técnico injetado e preencher colunas físicas adicionais ao fazer `append`;
- `listByAggregate()` não pode devolver esses campos extras sem mudança da porta/contrato;
- o primeiro adapter prova persistência, mapeamento, append-only, erro e observabilidade, mas **não conclui uma visão de auditoria enriquecida**.

**Decisão:** não ampliar a porta no primeiro PR. US-013.2 não será declarada integralmente concluída.

---

## 6. Ordem aprovada de implementação

### 3B.1 — AuditRepository

Primeira fatia porque usa uma tabela, não exige transação multi-tabela e prova package boundary, client injection, mapper, error translation, telemetria e CI.

### 3B.2 — KnowledgeSourceRepository

Leitura e `save(source)` existentes, sem inventar ingestão.

### 3B.3 — CurriculumRepository

Somente após correção do GAP-3B-01; inicialmente read-only.

### 3B.4 — PedagogicalComponentRepository

Leituras podem preceder escritas. Escrita fica bloqueada até resolver GAP-3B-02.

### 3B.5 — ProductionOrderRepository

Somente depois de requester-scoped client e atomicidade OPP+evento aprovados.

Estado atualizado em 11 de agosto de 2026: definição específica em
`LOT-3B5-PRODUCTION-ORDER-REPOSITORY-DEFINITION.md`, dividida em contratos/contextos, leitura
REQUESTER, migration/RPCs e adapters de comando. 3B.5.1, 3B.5.2 e 3B.5.3 foram integrados pelos
Pull Requests nº 25, 26 e 27. O 3B.5.4 foi implementado em branch isolada para revisão.
`GAP-3B-03` permanece ativo até integração humana e checkpoint pós-merge; `GAP-3B-07` registra que
a fatia física atual não representa a OPP normativa completa.

---

## 7. Primeiro menor PR do Lote 3B — autorizado após merge deste documento

Branch futura:

`feat/knowledge-factory-supabase-audit-adapter`

Título previsto:

`feat(knowledge-factory): add Supabase audit repository adapter`

Escopo permitido:

```text
packages/knowledge-factory-supabase/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── audit/
│   │   ├── supabase-audit.repository.ts
│   │   └── audit.mapper.ts
│   ├── errors/
│   │   └── persistence-error.ts
│   ├── observability/
│   │   └── persistence-logger.ts
│   └── context/
│       └── supabase-system-context.ts
└── test/
    ├── audit.repository.test.*
    └── audit.integration.test.*
```

Pode haver ajuste mínimo do workflow descartável apenas para executar a suíte TypeScript de integração.

Não incluir outras portas, API, wiring de produção ou migration nova.

---

## 8. Stories afetadas

### Primeiro PR — fatia parcial autorizada

`US-013.2 — persistence/audit adapter infrastructure slice`

O primeiro PR **não** recebe `Done` para US-013.2. Ele prova persistência e navegação básica por aggregate dentro do contrato atual. O GAP-3B-05 impede considerar completa uma visão enriquecida de auditoria.

### Preparadas para lotes seguintes

- US-002.1 — procedência da fonte;
- US-002.2 — autorização/bloqueio;
- US-004.1 — componente canônico;
- US-004.2 — tipologia;
- US-004.3 — versionamento;
- US-006.1 — pacote curricular;
- US-006.2 — vínculos;
- US-010.1 — OPP válida;
- US-010.2 — timeline da OPP.

### Ready for Code após merge documental

Somente:

`US-013.2 — persistence/audit adapter infrastructure slice`

---

## 9. Capacidades que continuam bloqueadas

- API pública da Knowledge Factory;
- frontend;
- agentes;
- Sócrates 2 executável;
- embeddings;
- pgvector;
- retrieval;
- full-text retrieval;
- reranking;
- cache;
- PNLD real;
- currículo MG real;
- currículo RS;
- Gráfica;
- Nexus;
- EPIC-018;
- aplicação do schema 3A em produção.

---

## 10. Produção permanece uma trilha separada

Lote 3B não é pre-flight de produção.

Antes de aplicar migration 3A ao Supabase real continuam obrigatórios: identificação formal do projeto alvo, snapshot/schema, drift analysis, backup/pre-flight, ausência de objetos `kf_*`, executor/comando definidos, plano de falha e autorização humana específica.

Adapters podem ser implementados e testados em ambiente descartável sem tocar produção.

---

## 11. Registro da aprovação

A aprovação humana integral de 7 de agosto de 2026 confirma:

- pacote `@profeplan/knowledge-factory-supabase`;
- injeção de client;
- separação SYSTEM/REQUESTER;
- `api/` apenas como composition root;
- nenhuma dependência direta em `supabaseAdmin.ts`;
- ausência de pseudo-transações;
- erros provider-neutral;
- telemetria injetada e sanitizada;
- reutilização do Supabase descartável;
- AuditRepository como primeiro adapter;
- gaps GAP-3B-01 a GAP-3B-05 e suas contenções;
- US-013.2 tratada apenas como fatia parcial no primeiro PR;
- manutenção do gate separado de produção.

A implementação do primeiro PR só poderá começar após este PR documental ser integrado à `main` e em nova branch criada a partir da `main` integrada.
