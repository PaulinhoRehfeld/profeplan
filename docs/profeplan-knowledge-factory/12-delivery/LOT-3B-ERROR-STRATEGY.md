# Lote 3B — Estratégia de erros de persistência

## Status

**Proposta documental — aguardando aprovação humana.**

## Objetivo

Impedir que códigos, mensagens e formatos internos do Supabase/PostgreSQL vazem para domínio, API ou UX.

O adapter atua como fronteira anticorrupção:

```text
provider error
→ classificação interna
→ erro estável de persistência
→ camada superior decide a resposta
```

## Taxonomia estável proposta

- `NOT_FOUND`;
- `CONFLICT`;
- `CONSTRAINT_VIOLATION`;
- `UNAUTHORIZED`;
- `FORBIDDEN`;
- `UNAVAILABLE`;
- `INVALID_RESPONSE`;
- `UNKNOWN`.

Métodos `find*` que admitem ausência retornam `null`; indisponibilidade nunca será convertida silenciosamente em `null`.

## Mapeamento mínimo

| Provider | Erro estável |
|---|---|
| `23505` | `CONFLICT` |
| `23503`, `23514`, `23502` | `CONSTRAINT_VIOLATION` |
| `42501` / permission denied | `FORBIDDEN` |
| ausência de identidade no requester context | `UNAUTHORIZED` |
| rede/timeout | `UNAVAILABLE` |
| shape incompatível | `INVALID_RESPONSE` |
| desconhecido | `UNKNOWN` |

Códigos PostgREST adicionais só entram após caso reproduzível.

## Provider error

O erro original poderá ser preservado como `cause` apenas em memória/diagnóstico interno.

Não pode ser:

- contrato entre camadas;
- serializado ao frontend;
- gravado integralmente em auditoria;
- logado sem redaction;
- usado para expor SQL, URL, header, token ou payload.

## Retry

Não haverá retry genérico no primeiro PR.

- leitura idempotente poderá receber política futura;
- append não será repetido sem idempotency key aprovada;
- escrita não idempotente não terá retry automático;
- RPC transacional definirá sua própria política.

## Leituras compostas

Se uma hidratação exige várias leituras e uma falha, o adapter não retorna objeto parcial.

Resultados permitidos:

- contrato completo;
- `null` quando semanticamente permitido;
- erro de persistência traduzido.

## Testes mínimos

- unique → `CONFLICT`;
- FK/check/not-null → `CONSTRAINT_VIOLATION`;
- RLS/privilégio → `FORBIDDEN`;
- row ausente em `find*` → `null`;
- rede → `UNAVAILABLE`;
- resposta incompatível → `INVALID_RESPONSE`;
- erro desconhecido → `UNKNOWN`;
- mensagem exposta não contém SQL, token, secret ou payload integral.
