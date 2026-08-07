# Primeiro PR de implementação do Lote 3B

## Status

**Proposto — bloqueado até aprovação humana da definição documental.**

## Objetivo único

Criar `@profeplan/knowledge-factory-supabase` e implementar **somente** `AuditRepository` contra `public.kf_audit_events`.

## Branch futura

`feat/knowledge-factory-supabase-audit-adapter`

## Título previsto

`feat(knowledge-factory): add Supabase audit repository adapter`

## Por que AuditRepository primeiro

É a menor fatia que prova a arquitetura completa:

- uma porta;
- uma tabela;
- append + leitura;
- append-only;
- sem transação multi-tabela;
- sem alteração de contrato;
- sem API;
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
│   │   ├── audit.mapper.ts
│   │   └── supabase-audit.repository.ts
│   ├── context/
│   │   └── system-context.ts
│   ├── errors/
│   │   ├── persistence-error.ts
│   │   └── translate-supabase-error.ts
│   └── observability/
│       └── persistence-telemetry.ts
└── test/
    ├── audit.mapper.test.*
    ├── audit.repository.test.*
    └── audit.integration.test.*
```

Alteração adicional permitida apenas se estritamente necessária:

`.github/workflows/knowledge-factory-db-ci.yml`

para executar a integração TypeScript no stack descartável já existente.

## Dependências propostas

- `@supabase/supabase-js` alinhado à versão do monorepo;
- `@profeplan/knowledge-factory`;
- `@profeplan/types`.

Usar `import type` sempre que não houver símbolo runtime.

Nenhuma outra dependência externa está autorizada.

## Porta

Implementar exatamente:

- `append(event)`;
- `listByAggregate(aggregateId)`.

Não adicionar update, delete, upsert, bulk mutation ou query genérica.

## Client injection

O adapter recebe client SYSTEM já configurado.

É proibido:

- ler `process.env`;
- chamar `createClient()` no pacote;
- importar `api/_lib/supabaseAdmin`;
- possuir secret/placeholder de credencial.

## Mapper

`DomainEvent` → `kf_audit_events`:

- `eventType` → `event_type`;
- `aggregateType` → `aggregate_type`;
- `aggregateId` → `aggregate_id`;
- `occurredAt` → `occurred_at`;
- `metadata` → `metadata`.

Campos físicos sem equivalente no contrato não serão inventados silenciosamente.

## Erros e observabilidade

Seguir exclusivamente:

- `LOT-3B-ERROR-STRATEGY.md`;
- `LOT-3B-OBSERVABILITY-STRATEGY.md`.

Nenhum código SQL/provider deverá atravessar a porta.

## Testes unitários mínimos

1. mapper ida/volta;
2. append usa insert, nunca upsert;
3. list filtra aggregate;
4. ordenação determinística;
5. lista vazia retorna `[]`;
6. provider error traduzido;
7. telemetria success/failure;
8. redaction de secrets/payloads;
9. classe concreta satisfaz `AuditRepository` sem `any` generalizado.

## Integração descartável

1. inserir eventos sintéticos para aggregate A;
2. inserir evento sintético para aggregate B;
3. listar A sem misturar B;
4. reconstruir `DomainEvent`;
5. confirmar persistência;
6. provar trigger append-only em UPDATE;
7. provar trigger append-only em DELETE;
8. DB lint verde;
9. destruir stack ao final.

## Story

Proposta após aprovação documental:

`US-013.2 — Ready for Code: persistence adapter slice`

Não conclui a Story inteira.

## Fora do escopo

- outras quatro portas;
- API;
- wiring de produção;
- migration/RPC nova;
- frontend;
- retrieval;
- embeddings;
- agentes;
- PNLD/currículo real;
- Gráfica;
- Nexus;
- produção.

## Rollback

Revert do PR. Nenhum rollback de banco.

## Gate de parada

Parar se surgir necessidade de:

- mudar a porta;
- criar migration/RPC;
- acessar produção;
- usar secret hospedada;
- incluir segunda porta;
- adicionar dependência não autorizada.

Não realizar merge automático.
