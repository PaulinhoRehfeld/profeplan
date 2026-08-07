# Lote 3B — Estratégia de observabilidade

Status: proposta documental.

## Objetivo

Tornar operações de persistência rastreáveis por OPP/aggregate sem registrar conteúdo pedagógico sensível ou credenciais.

## Evidência do monorepo

`@profeplan/logger` já oferece JSON estruturado, `correlationId`, níveis info/warn/error/audit e contexto via `AsyncLocalStorage`.

Também possui características que não devem contaminar diretamente o pacote de adapters:

- dependência de Node `fs`;
- escrita síncrona em arquivo local;
- descoberta de workspace pelo filesystem;
- possibilidade de contexto com `userEmail`.

## Decisão proposta

O pacote `@profeplan/knowledge-factory-supabase` define uma interface mínima de logger injetável.

Exemplo conceitual:

```ts
interface PersistenceLogger {
  info(event: PersistenceLogEvent): void;
  warn(event: PersistenceLogEvent): void;
  error(event: PersistenceLogEvent): void;
}
```

A interface é conceitual nesta fase e não autoriza código.

O composition root poderá adaptá-la ao `@profeplan/logger` existente.

## Campos mínimos

Toda operação relevante deve poder registrar:

- `operation`;
- `adapter`;
- `durationMs`;
- `aggregateId` quando aplicável;
- `correlationId` quando disponível;
- `outcome`: `success | failure`;
- `persistenceErrorCode` em falha;
- contagem de registros quando útil e não sensível.

## Campos proibidos

Não registrar por padrão:

- `service_role`;
- JWT;
- authorization header;
- senha;
- e-mail do professor como identificador principal;
- texto integral de fonte;
- `extracted_text`;
- summary integral de componente;
- theme integral da OPP se puder conter dado sensível;
- payload completo de metadata/auditoria;
- query SQL completa.

## Identificadores

Preferir:

- UUID do aggregate;
- requesterId quando necessário e permitido;
- correlationId;
- operation name.

Evitar PII como chave de correlação.

## Duração

O adapter mede duração ao redor da operação de persistência, sem medir tempo de domínio ou HTTP externo.

## Auditoria versus log operacional

`kf_audit_events` é histórico funcional append-only.

Logs de observabilidade são telemetria operacional.

Uma coisa não substitui a outra.

Não gravar automaticamente todo log operacional em `kf_audit_events`.

## Falhas de logging

Falha do logger não deve corromper a operação de persistência, salvo quando houver requisito regulatório futuro explicitamente aprovado.

## Correlação

O composition root é responsável por iniciar/propagar `correlationId`.

O adapter apenas recebe esse contexto, não inventa correlação global própria quando uma já existe.

## Testes

- sucesso emite operação/duração/outcome;
- falha emite código sanitizado;
- token não aparece;
- payload pedagógico bruto não aparece;
- logger injetado pode ser fake/no-op em unit tests;
- adapter continua testável sem filesystem.