# Lote 3B — Estratégia de erros e observabilidade

## Status

**Proposta documental — aguardando aprovação humana.**

Este documento não implementa adapters nem altera comportamento do produto.

## 1. Objetivo

A camada `@profeplan/knowledge-factory-supabase` deverá impedir dois acoplamentos indesejados:

1. códigos e formatos Supabase/PostgreSQL vazando para domínio/API;
2. logger/infraestrutura de runtime vazando para o pacote de adapters.

A solução proposta é:

- erros estáveis de persistência;
- telemetria mínima injetada;
- provider bruto confinado à borda;
- redaction obrigatória.

---

## 2. Taxonomia de erros

### Códigos estáveis propostos

- `NOT_FOUND`;
- `CONFLICT`;
- `CONSTRAINT_VIOLATION`;
- `UNAUTHORIZED`;
- `FORBIDDEN`;
- `UNAVAILABLE`;
- `INVALID_RESPONSE`;
- `UNKNOWN`.

### Estrutura conceitual

```ts
interface PersistenceErrorShape {
  code: PersistenceErrorCode;
  operation: string;
  message: string;
  retryable: boolean;
  aggregateType?: string;
  aggregateId?: string;
}
```

A implementação poderá usar uma classe `PersistenceError`, mas o formato público deve permanecer pequeno e provider-neutral.

## 3. Tradução Supabase/PostgreSQL

Mapeamento mínimo proposto:

| Provider | Erro estável | Retry |
|---|---|---:|
| linha ausente em `find*` sem erro | `null`, não erro | não |
| `23505` unique violation | `CONFLICT` | não |
| `23503` foreign key | `CONSTRAINT_VIOLATION` | não |
| `23514` check violation | `CONSTRAINT_VIOLATION` | não |
| `23502` not null | `CONSTRAINT_VIOLATION` | não |
| `42501` / permission denied | `FORBIDDEN` | não |
| sessão/credencial ausente no requester context | `UNAUTHORIZED` | não |
| timeout/fetch/network | `UNAVAILABLE` | sim, somente leitura ou escrita idempotente aprovada |
| shape inesperado | `INVALID_RESPONSE` | não |
| desconhecido | `UNKNOWN` | não por padrão |

Códigos PostgREST adicionais só entram no mapa após teste reproduzível.

## 4. Regras para `find*`

Operação de busca por identidade que legitimamente pode não existir:

- usar semântica `maybeSingle` ou equivalente;
- ausência → `null`;
- múltiplas linhas quando deveria haver uma → `INVALID_RESPONSE`/`CONFLICT` conforme causa;
- falha do provider → exceção estável, nunca `null` silencioso.

Isso evita confundir “não existe” com “banco indisponível”.

## 5. Provider error como causa interna

O objeto original Supabase/PostgREST poderá ser retido apenas como `cause` para diagnóstico interno.

Não pode ser:

- serializado diretamente;
- retornado ao professor;
- incorporado integralmente a audit event;
- logado sem sanitização;
- usado como contrato entre camadas.

Campos permitidos para telemetria técnica quando necessários:

- `code`;
- categoria sanitizada;
- mensagem reduzida/segura;
- operação.

Campos como `details` e `hint` exigem allowlist antes de log.

---

## 6. Retry

O adapter não implementará retry genérico no primeiro PR.

Motivos:

- escrita pode não ser idempotente;
- append-only pode duplicar evento;
- retry automático pode mascarar indisponibilidade;
- provider/HTTP já pode possuir comportamento próprio.

Retry futuro exige decisão por operação.

Por padrão:

- leitura idempotente: elegível para política futura;
- `append`: não repetir sem idempotency key aprovada;
- `insert/update`: não repetir automaticamente;
- RPC transacional: política definida junto do comando.

---

## 7. Interface mínima de observabilidade

O pacote de adapters não dependerá diretamente de `@profeplan/logger`.

Interface conceitual proposta:

```ts
interface PersistenceTelemetry {
  record(event: PersistenceTelemetryEvent): void;
}
```

O evento deverá conter somente campos estruturais:

- `operation`;
- `adapter`;
- `durationMs`;
- `outcome: success | failure`;
- `aggregateType?`;
- `aggregateId?`;
- `correlationId?`;
- `rowCount?`;
- `errorCode?`;
- `retryable?`.

A implementação deverá aceitar um `NoopTelemetry` para testes/uso sem sink.

## 8. Por que não depender diretamente de `@profeplan/logger`

O logger atual possui boas propriedades — JSON estruturado e `AsyncLocalStorage` — mas também escreve em filesystem com `fs.appendFileSync()`.

O backend Vercel atual mantém loggers inline/console em rotas serverless.

Consequência:

- adapter permanece sink-agnostic;
- composition root pode adaptar console, `@profeplan/logger` ou outra solução futura;
- nenhuma decisão de observabilidade prende o pacote ao runtime atual.

## 9. Correlation ID

O adapter recebe `correlationId` via contexto opcional da chamada/composição.

Não deve:

- gerar novo ID a cada método quando o request já possui um;
- procurar header HTTP;
- conhecer `VercelRequest`;
- usar e-mail como correlation id.

A definição do request context completo ocorrerá quando houver serviço/API da Knowledge Factory.

## 10. Redaction obrigatória

Nunca registrar:

- `SUPABASE_SERVICE_ROLE_KEY`;
- anon/publishable keys quando desnecessárias;
- access/refresh token;
- Authorization header;
- JWT;
- senha;
- `extracted_text`;
- texto integral de fonte;
- conteúdo integral de componente;
- conteúdo integral de OPP;
- email/CPF/nome de estudante;
- payload Supabase completo.

Não há dados de estudante no schema 3A, mas a regra permanece preventiva.

## 11. Metadados de auditoria vs logs operacionais

São coisas diferentes.

### `kf_audit_events`

- evidência de negócio/governança;
- persistida;
- append-only;
- consulta por aggregate;
- não deve conter stack trace/provider error bruto.

### Telemetria operacional

- duração e saúde da chamada;
- sink externo/console;
- pode conter código técnico sanitizado;
- não substitui audit event.

O primeiro adapter `AuditRepository` grava auditoria; sua própria telemetria não deve recursivamente gerar novo audit event.

## 12. Primeiro PR — critérios específicos

O PR do `AuditRepository` deverá provar:

1. `append()` produz telemetria `success` sem serializar o evento inteiro;
2. falha produz `failure + errorCode`;
3. correlation id é preservado quando fornecido;
4. provider error é traduzido;
5. `listByAggregate()` diferencia vazio de indisponibilidade;
6. nenhum secret aparece em logs de teste;
7. `NoopTelemetry` funciona;
8. telemetria não grava em banco por si mesma.

## 13. Gate de parada

Parar se a implementação exigir:

- dependência obrigatória em logger concreto;
- log de payload integral para diagnóstico;
- retorno de erro Supabase bruto;
- retry de escrita sem idempotência;
- acesso a env/secret dentro do pacote.