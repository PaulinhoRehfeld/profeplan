# Lote 3B — Estratégia de erros de persistência

Status: proposta documental.

## Objetivo

Impedir que códigos, mensagens e detalhes internos do Supabase/PostgreSQL vazem para domínio, API pública ou professor.

## Princípio

O adapter é uma fronteira anticorrupção.

Provider error
→ classificação interna
→ erro de persistência estável
→ camada superior decide resposta

## Tipo proposto

Criar no pacote de adapters um erro de infraestrutura estável, por exemplo:

`KnowledgeFactoryPersistenceError`

com código semântico limitado:

- `CONFLICT`;
- `CONSTRAINT_VIOLATION`;
- `FORBIDDEN`;
- `UNAUTHENTICATED`;
- `NOT_FOUND` quando aplicável a operação que exige existência;
- `UNAVAILABLE`;
- `MAPPING_ERROR`;
- `UNEXPECTED`.

Métodos `find*` cujo contrato atual já prevê ausência continuarão retornando `null` e não lançarão `NOT_FOUND`.

## Mapeamento interno de provider

O adapter poderá reconhecer internamente famílias como:

- unique violation;
- foreign key violation;
- check violation;
- insufficient privilege/RLS;
- PostgREST no-row/multiple-row;
- indisponibilidade/rede.

Códigos SQL/PostgREST poderão existir apenas como metadado interno sanitizado para diagnóstico.

Eles não deverão:

- virar mensagem para o professor;
- integrar contrato público;
- ser expostos diretamente por API;
- incluir query SQL completa;
- incluir credencial;
- incluir payload pedagógico sensível.

## Preservação de causa

O erro pode preservar `cause` em memória para debugging server-side.

Serialização explícita do erro deve omitir:

- stack em resposta externa;
- SQL;
- URL com credenciais;
- headers;
- tokens;
- service role;
- conteúdo integral de source/segment/component.

## Escritas

Erros de constraint não serão tratados como sucesso idempotente sem regra explícita.

Exemplo:

- conflito de chave única em `append` de auditoria não deve ser silenciosamente ignorado;
- violação de FK em evidência deve permanecer falha;
- bloqueio RLS deve ser classificado como `FORBIDDEN`, não `UNEXPECTED`.

## Leituras compostas

Se uma leitura composta precisa de três consultas e uma falha, não retornar contrato parcial.

Resultado permitido:

- objeto completo;
- `null` quando o método prevê ausência;
- erro de persistência traduzido.

## Observabilidade do erro

Log estruturado recomendado:

- operation;
- adapter;
- aggregateId quando existir;
- correlationId;
- durationMs;
- outcome=`failure`;
- persistenceErrorCode;
- providerCode sanitizado opcional;
- sem payload pedagógico bruto.

## Testes mínimos

- erro de unique → `CONFLICT`;
- FK/check → `CONSTRAINT_VIOLATION`;
- RLS/grant → `FORBIDDEN`;
- row ausente em `find*` → `null`;
- resposta incompatível → `MAPPING_ERROR`;
- erro desconhecido → `UNEXPECTED`;
- mensagem pública não contém código SQL, query, token ou secret.