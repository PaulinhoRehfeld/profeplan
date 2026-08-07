# Primeiro PR de implementação do Lote 3B

Status: **proposto — bloqueado até aprovação humana da definição documental**.

## Objetivo único

Criar o pacote `@profeplan/knowledge-factory-supabase` e implementar **somente** `AuditRepository` contra `public.kf_audit_events`.

## Branch futura

`feat/knowledge-factory-supabase-audit-adapter`

## Título previsto

`feat(knowledge-factory): add Supabase audit repository adapter`

## Por que AuditRepository primeiro

É a menor fatia que prova a arquitetura inteira sem abrir os riscos das outras portas:

- uma tabela;
- uma gravação append-only;
- uma leitura por aggregate;
- sem multi-table transaction;
- sem RLS requester complexo;
- sem mudança de contrato público;
- sem regra pedagógica;
- sem migration nova.

## Arquivos previstos

```text
packages/knowledge-factory-supabase/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── audit/
│   │   ├── supabase-audit.repository.ts
│   │   └── audit.mapper.ts
│   ├── context/
│   │   └── system-context.ts
│   ├── errors/
│   │   └── persistence-error.ts
│   └── observability/
│       └── persistence-logger.ts
└── test/
    ├── audit.repository.test.*
    ├── audit.mapper.test.*
    └── audit.integration.test.*
```

Alteração adicional permitida, se estritamente necessária:

`.github/workflows/knowledge-factory-db-ci.yml`

somente para executar os testes do novo pacote no ambiente Supabase descartável já existente.

## Dependências propostas

Runtime:

- `@supabase/supabase-js` alinhado à versão já usada pelo monorepo.

Tipos/contratos:

- `@profeplan/knowledge-factory` via `import type` quando possível;
- `@profeplan/types` via `import type` quando possível.

Não adicionar ORM, logger externo, retry library ou transaction library.

## API do adapter

O adapter implementará exatamente a porta existente:

- `append(event)`;
- `listByAggregate(aggregateId)`.

Não adicionar:

- update;
- delete;
- bulk mutation;
- query genérica;
- acesso arbitrário a tabela;
- exposição do client Supabase.

## Client injection

O construtor/factory receberá system context já criado.

O pacote:

- não lê env;
- não conhece secret;
- não importa `api/_lib/supabaseAdmin.ts`;
- não cria client de produção.

## Mapper

`DomainEvent` → `kf_audit_events`:

- `eventType` → `event_type`;
- `aggregateType` → `aggregate_type`;
- `aggregateId` → `aggregate_id`;
- `occurredAt` → `occurred_at`;
- `metadata` → `metadata`.

Campos infra sem equivalente no domínio podem utilizar defaults seguros ou permanecer ausentes conforme schema:

- `actor_id`;
- `actor_role`;
- `correlation_id`;
- `outcome`;
- `reason`.

A inclusão de contexto de ator/correlação deverá ser feita por contexto explícito, sem alterar `DomainEvent` silenciosamente.

## Erros

Implementar classificação mínima:

- conflict;
- constraint;
- forbidden;
- unavailable;
- mapping;
- unexpected.

Nenhum código SQL deverá atravessar a porta.

## Observabilidade

Logger injetado/no-op por padrão de teste.

Campos mínimos:

- operation;
- adapter;
- aggregateId;
- durationMs;
- correlationId quando houver;
- outcome.

Sem metadata pedagógica completa.

## Testes obrigatórios

### Unitários

- mapper ida/volta;
- append usa insert;
- list filtra aggregate;
- list ordena por `occurred_at`;
- ausência de update/delete;
- erro traduzido;
- logger sanitizado.

### Integração descartável

- inserir evento sintético;
- recuperar mesmo aggregate;
- não retornar evento de aggregate diferente;
- comprovar append-only;
- comprovar bloqueio de leitura direta por professor;
- zero produção.

### CI geral

- prettier;
- lint;
- typecheck;
- build aplicável;
- testes.

## Critérios de aceite

1. novo pacote isolado;
2. uma única porta implementada;
3. domínio não importa Supabase;
4. `api/` não é importado pelo pacote;
5. nenhuma credential em código/teste/log;
6. nenhum update/delete para audit events;
7. unit tests verdes;
8. integração descartável verde;
9. CI geral verde;
10. nenhuma migration nova;
11. nenhuma produção;
12. rollback do código é simples revert do PR.

## Stories

`US-013.2 — Ready for Code: AuditRepository persistence adapter slice`

Nenhuma outra Story recebe Ready for Code com este PR.

## Rollback

Revert do PR remove:

- pacote de adapter;
- ajuste de CI relacionado.

Não há rollback de banco porque o PR não cria nem aplica migration.

## Gate de parada

Parar se surgir necessidade de:

- mudar `@profeplan/knowledge-factory`;
- mudar `@profeplan/types`;
- criar migration;
- usar produção;
- adicionar dependência além das aprovadas;
- implementar segunda porta;
- expor API.