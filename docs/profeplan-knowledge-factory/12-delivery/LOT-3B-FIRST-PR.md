# Lote 3B — Primeiro PR de implementação

## Status

**Proposta documental — aguardando aprovação humana do Lote 3B.**

Este documento não autoriza implementação antes da aprovação das ADRs 040–047.

## Objetivo

Provar a arquitetura de adapters Supabase com a menor fatia vertical possível, sem API, sem produção, sem migration nova e sem tocar nas quatro portas restantes.

## Branch proposta

`feat/knowledge-factory-supabase-audit-adapter`

## Título proposto

`feat(knowledge-factory): add Supabase audit repository adapter`

## Escopo exclusivo

Criar:

`packages/knowledge-factory-supabase/`

Implementar somente:

`AuditRepository`

Métodos:

- `append(event)`;
- `listByAggregate(aggregateId)`.

Tabela única:

`public.kf_audit_events`

Contexto:

SYSTEM client injetado.

## Árvore prevista

```text
packages/knowledge-factory-supabase/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── audit/
│   │   ├── audit.mapper.ts
│   │   └── supabase-audit.repository.ts
│   ├── context/
│   │   └── supabase-system-context.ts
│   ├── errors/
│   │   └── persistence-error.ts
│   └── observability/
│       └── persistence-observer.ts
└── test/
    ├── audit.repository.test.*
    └── audit.integration.test.*
```

A extensão real poderá ajustar nomes sem ampliar responsabilidades.

## Dependências propostas

- `@supabase/supabase-js` explicitamente declarado no workspace;
- contratos de `@profeplan/knowledge-factory` e `@profeplan/types` por `import type` quando aplicável;
- nenhuma biblioteca nova de ORM, logging, retry ou transação.

Qualquer dependência adicional exige parada e autorização humana.

## Regras do adapter

### Client

- recebe `SupabaseClient` pelo construtor/factory;
- não chama `createClient()`;
- não lê `process.env`;
- não importa `api/_lib/supabaseAdmin.ts`;
- não conhece Vercel.

### Audit append

- usa INSERT;
- nunca UPSERT;
- nunca UPDATE;
- nunca DELETE;
- persiste apenas campos allowlisted;
- adiciona contexto técnico somente quando explicitamente fornecido.

### Audit read

- filtra obrigatoriamente `aggregate_id`;
- seleciona somente colunas necessárias;
- ordena deterministicamente por `occurred_at` e desempate por `created_at`/`id` se necessário;
- reconstrói `DomainEvent` sem expor campos técnicos não pertencentes ao domínio.

### Erros

Traduz provider errors para `KnowledgeFactoryPersistenceError` sanitizado.

Nenhum SQLSTATE, URL, header, JWT, key ou payload integral atravessa a fronteira pública do pacote.

### Observabilidade

Observer injetado recebe apenas:

- operação;
- adapter;
- duração;
- aggregate id/type;
- correlation id quando houver;
- outcome;
- erro sanitizado.

Nenhum conteúdo pedagógico ou secret.

## CI

Reutilizar o `Knowledge Factory DB CI` existente.

O mesmo Supabase descartável deverá:

1. aplicar baseline sintética + migration 3A;
2. executar testes SQL existentes;
3. preparar Node 22/pnpm;
4. executar unitários do pacote;
5. executar integração TypeScript do AuditRepository;
6. provar append-only no banco;
7. executar lint DB;
8. destruir o ambiente sem backup.

Não criar stack Supabase hospedado.

## Testes unitários mínimos

1. row → `DomainEvent`;
2. `DomainEvent` → payload de insert;
3. `append()` usa insert;
4. `listByAggregate()` filtra corretamente;
5. ordenação determinística;
6. `23505` → `CONFLICT`;
7. constraint → `CONSTRAINT_VIOLATION`;
8. permission → `FORBIDDEN`;
9. rede/timeout → `UNAVAILABLE`;
10. shape inválido → `INVALID_RESPONSE`;
11. desconhecido → `UNKNOWN`;
12. observer não recebe payload sensível.

## Testes de integração mínimos

1. adapter insere evento sintético;
2. evento pode ser lido pelo aggregate correto;
3. aggregate diferente não aparece;
4. mapper reconstrói `DomainEvent` corretamente;
5. trigger rejeita UPDATE direto;
6. trigger rejeita DELETE direto;
7. ambiente não usa secret hospedada;
8. DB lint segue verde.

## Stories

Somente:

`US-013.2 — Ready for Code: persistence adapter slice`

Nenhuma outra Story recebe autorização de código por este PR.

## Fora do escopo

- KnowledgeSourceRepository;
- CurriculumRepository;
- PedagogicalComponentRepository;
- ProductionOrderRepository;
- requester-scoped client;
- RPC/transação nova;
- migration nova;
- API;
- frontend;
- produção;
- fontes reais;
- currículo real;
- retrieval;
- embeddings;
- agentes;
- Sócrates 2 executável;
- Gráfica;
- Nexus;
- EPIC-018.

## Rollback

Como o PR não altera schema:

- rollback = revert do PR;
- nenhum dado de produção existe;
- nenhum endpoint consome o pacote;
- nenhuma migration precisa ser revertida.

## Gate de saída

O PR só poderá ser marcado pronto para merge quando:

- diff permanecer limitado ao adapter Audit + testes + CI mínimo necessário;
- typecheck verde;
- unitários verdes;
- integração no Supabase descartável verde;
- CI geral verde;
- DB CI verde;
- nenhum secret real;
- nenhuma produção;
- nenhuma segunda porta;
- checkpoint de continuidade criado.
