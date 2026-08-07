# Lote 3B — Estratégia de observabilidade

## Status

**Proposta documental — aguardando aprovação humana.**

## Objetivo

Tornar operações de persistência rastreáveis sem acoplar o pacote de adapters a um logger concreto e sem registrar conteúdo pedagógico sensível ou credenciais.

## Decisão proposta

`@profeplan/knowledge-factory-supabase` receberá uma interface mínima de telemetria por injeção.

Não haverá dependência direta em `@profeplan/logger` no primeiro PR.

Motivo: o logger existente oferece JSON estruturado e correlation context, mas também possui acoplamento Node/filesystem; as rotas Vercel atuais usam logging serverless via console.

## Evento mínimo

Campos permitidos:

- `operation`;
- `adapter`;
- `durationMs`;
- `outcome: success | failure`;
- `aggregateType?`;
- `aggregateId?`;
- `correlationId?`;
- `rowCount?`;
- `persistenceErrorCode?`.

## Campos proibidos

Não registrar:

- service role;
- JWT/access token;
- Authorization header;
- senha;
- `extracted_text`;
- texto integral de fonte;
- conteúdo integral de componente;
- payload integral de OPP;
- metadata arbitrária integral;
- e-mail quando não necessário;
- query SQL completa.

## Correlation ID

A composition root cria/propaga correlação.

O adapter apenas recebe o identificador; não conhece HTTP, `VercelRequest` ou headers.

## Auditoria funcional x telemetria

`kf_audit_events` é histórico funcional persistido e append-only.

Telemetria operacional mede saúde e duração.

Uma não substitui a outra e logs operacionais não serão automaticamente gravados em `kf_audit_events`.

O `AuditRepository` não pode gerar recursivamente um novo evento de auditoria apenas porque registrou telemetria da própria operação.

## Falha de logging

No primeiro PR, falha do sink de telemetria não deve transformar uma persistência bem-sucedida em falha, salvo requisito regulatório futuro explicitamente aprovado.

## Testes mínimos

- success registra operação/duração/outcome;
- failure registra código sanitizado;
- correlation id é preservado;
- token/secret/payload não aparece;
- sink fake/no-op funciona em unit tests;
- adapter permanece testável sem filesystem.
