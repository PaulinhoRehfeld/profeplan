# Lote 3B — Adapters Supabase

Data: 7 de agosto de 2026.

## Status

**Definição documental — aguardando aprovação humana. Nenhum adapter foi implementado por este documento. Produção permanece bloqueada.**

Base: `main` no commit `82b5dce90d2cb7437922dfc27062b1f16aa0c0a6`, após integração e checkpoint do Lote 3A.

## Objetivo

Implementar, em etapas posteriores e somente após aprovação desta definição, adapters Supabase para as portas de persistência existentes em `@profeplan/knowledge-factory`, preservando:

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

Não foi encontrada, na inspeção do Lote 3B, uma composição Supabase server-side equivalente e consolidada em `apps/bff` que justifique promover o BFF como raiz canônica nesta fase.

Conclusão proposta:

> `api/` permanece o composition root server-side do produto atual. O pacote de adapters não dependerá de `api/`; `api/` injetará dependências no pacote.

### 1.3 Cliente privilegiado existente

Existe `api/_lib/supabaseAdmin.ts`, que:

- usa `@supabase/supabase-js`;
- lê `SUPABASE_URL` e `SUPABASE_SERVICE_ROLE_KEY` do ambiente;
- desativa persistência de sessão e refresh automático;
- exporta um singleton `supabaseAdmin`.

O adapter **não deve importar esse arquivo**, porque isso criaria dependência de `packages/*` para `api/*`.

A reutilização correta é por **injeção de cliente no composition root**.

### 1.4 Logging existente

Existe `@profeplan/logger` com:

- JSON estruturado;
- `correlationId` via `AsyncLocalStorage`;
- níveis info/warn/error/audit.

Entretanto, o pacote também:

- usa `fs`;
- escreve sincronamente em `logs/app.log`;
- é Node-specific;
- permite contexto com `userEmail`.

Conclusão proposta:

> O pacote de adapters não dependerá diretamente de `@profeplan/logger`. Ele receberá um logger mínimo injetado. O composition root poderá adaptar `@profeplan/logger` quando adequado.

### 1.5 Transações / Unit of Work

Não foi identificada abstração canônica de Unit of Work nem suporte geral a transação multi-call por Supabase JS no monorepo.

Consequência:

> Nenhum adapter poderá fingir atomicidade por sequência de `.from(...).insert/update(...)` independentes.

Operações multi-tabela que precisam ser atômicas exigirão RPC/função SQL transacional ou uma nova abstração explicitamente aprovada.

### 1.6 Testes Supabase

O Lote 3A já fornece `Knowledge Factory DB CI`, que sobe Supabase descartável sem credenciais hospedadas, aplica a migration, testa schema/RLS/rollback e destrói o ambiente.

Conclusão proposta:

> O Lote 3B reutilizará esse ambiente descartável; não criará um segundo stack de banco.

---

## 2. Pacote proposto

Pacote aprovado arquiteturalmente desde ADR-035:

`packages/knowledge-factory-supabase/`

Workspace futuro:

`@profeplan/knowledge-factory-supabase`

Responsabilidades:

- implementar portas aprovadas;
- mapear snake_case SQL ↔ camelCase dos contratos;
- receber clientes Supabase por injeção;
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

## 3. Dependências propostas

### Runtime

`@supabase/supabase-js`

Motivo: é a dependência concreta inevitável do adapter e já existe no monorepo na versão `^2.45.4`.

No PR de implementação deverá ser declarada diretamente no pacote; não depender de hoisting implícito.

### Compilação / contratos

- `@profeplan/knowledge-factory` — interfaces das portas;
- `@profeplan/types` — contratos retornados/recebidos.

Sempre que o uso for exclusivamente de tipos, utilizar `import type`.

### Não adicionar inicialmente

- ORM;
- Prisma;
- query builder;
- biblioteca de retry;
- biblioteca de transação;
- biblioteca de logging.

Qualquer nova dependência exige aprovação humana.

---

## 4. Modelo de clientes e privilégio

O Lote 3B terá dois contextos conceituais distintos.

### 4.1 System context

Cliente Supabase privilegiado criado fora do pacote, server-side, com `service_role`.

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

### 4.2 Requester context

Cliente Supabase autenticado no contexto do usuário, para operações privadas nas quais o RLS deve participar da defesa em profundidade.

Uso previsto:

- OPP do próprio requester.

O adapter não cria credenciais. Ele recebe uma instância já configurada pelo composition root.

### 4.3 Regra de fronteira

O pacote não acessa `process.env`.

O pacote não importa `api/_lib/supabaseAdmin.ts`.

O composition root atual poderá passar `supabaseAdmin` para adapters de sistema.

A estratégia de criação do requester-scoped client deverá ser definida antes da implementação do `ProductionOrderRepository`.

---

## 5. Lacunas encontradas nas portas atuais

### GAP-3B-01 — lookup curricular sem `stage`

`CurriculumRepository.findActivePackageByState(state)` recebe apenas Estado.

O schema 3A permite um pacote ativo por `(state, stage)`, portanto MG pode ter simultaneamente um pacote ativo de Fundamental II e um de Ensino Médio.

A consulta apenas por Estado é ambígua.

**Decisão proposta:** antes do adapter curricular, revisar a porta para receber também `stage`.

Nenhuma alteração de contrato será feita nesta definição documental.

### GAP-3B-02 — componente + versão exige atomicidade

`PedagogicalComponentRepository` expõe `saveComponent` e `saveVersion` separadamente.

O schema exige coerência entre `current_version_id` e versão pertencente ao mesmo componente. Criar componente e sua primeira versão como chamadas independentes não fornece atomicidade segura.

**Decisão proposta:** adapter de escrita de componente fica bloqueado até existir comando/RPC transacional aprovado.

### GAP-3B-03 — OPP + evento exige atomicidade

`ProductionOrderRepository` expõe `save(order)` e `appendEvent(event)` separadamente.

Uma mudança de estado da OPP e o evento que a explica não devem divergir.

**Decisão proposta:** escrita de transição OPP fica bloqueada até existir fronteira transacional aprovada.

### GAP-3B-04 — lifecycle de fonte incompleto para ingestão

`KnowledgeSourceRepository` permite `save(source)`, mas não oferece operação de gravação de `SourceVersion`, `SourceSegment` ou `SourcePermissionEvent`.

Isso não impede adapter de leitura nem `save(source)`, porém significa que o Lote 3B não deve inventar métodos de ingestão por fora da porta.

**Decisão proposta:** somente implementar métodos existentes; ingestão/versionamento completo fica para lote próprio.

---

## 6. Ordem proposta de implementação dos adapters

### 3B.1 — AuditRepository

Primeira fatia recomendada.

Razões:

- uma porta;
- uma tabela principal;
- append/list apenas;
- sem transação multi-tabela;
- prova package boundary, Supabase client injection, mapper, error translation, logging e CI;
- baixo risco pedagógico;
- rollback por revert do código, sem migration nova.

### 3B.2 — KnowledgeSourceRepository — leitura + `save(source)` existente

Somente métodos já definidos na porta.

Não adicionar ingestão de versões/segmentos/eventos.

### 3B.3 — CurriculumRepository — após correção do GAP-3B-01

Inicialmente read-only.

### 3B.4 — PedagogicalComponentRepository

Leituras podem preceder escritas.

Escrita fica bloqueada até resolver GAP-3B-02.

### 3B.5 — ProductionOrderRepository

Somente depois de:

- requester-scoped client definido;
- atomicidade OPP+evento definida;
- testes RLS via adapter disponíveis.

---

## 7. Primeiro menor PR do Lote 3B

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

Possível ajuste do workflow existente apenas para incluir a suíte TypeScript de integração no mesmo Supabase descartável.

Não incluir:

- outras quatro portas;
- API;
- production client wiring;
- migration nova;
- banco de produção;
- conteúdo real.

---

## 8. Stories afetadas

### Avança diretamente

- US-013.2 — procedência/auditoria navegável: fatia de auditoria persistida e consultável por aggregate.

### Preparadas para lotes seguintes do 3B

- US-002.1 — procedência da fonte;
- US-002.2 — autorização/bloqueio;
- US-004.1 — componente canônico;
- US-004.2 — tipologia;
- US-004.3 — versionamento;
- US-006.1 — pacote curricular;
- US-006.2 — vínculos;
- US-010.1 — OPP válida;
- US-010.2 — timeline da OPP.

### Ready for Code proposto para o primeiro PR

Somente:

`US-013.2 — persistence adapter slice`

Os demais permanecem bloqueados até os respectivos gaps serem resolvidos.

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

Antes de aplicar migration 3A ao Supabase real continuam obrigatórios:

1. identificação formal do projeto alvo;
2. snapshot/schema atual;
3. drift analysis;
4. backup/pre-flight;
5. ausência de objetos `kf_*`;
6. executor definido;
7. comando exato;
8. plano de falha;
9. autorização humana específica.

Adapters podem ser definidos, implementados e testados em ambiente descartável sem tocar produção.

---

## 11. Critérios de aceite desta definição documental

A definição é aprovada quando houver concordância explícita sobre:

- pacote `@profeplan/knowledge-factory-supabase`;
- injeção de client;
- separação system/requester;
- uso de `api/` apenas como composition root;
- não dependência direta em `supabaseAdmin.ts`;
- ausência de pseudo-transações;
- erro sanitizado;
- logging injetado;
- reutilização do Supabase descartável;
- AuditRepository como primeiro adapter;
- gaps 3B-01 a 3B-04;
- manutenção do gate separado de produção.

Nenhum item deste documento autoriza código antes da aprovação humana.