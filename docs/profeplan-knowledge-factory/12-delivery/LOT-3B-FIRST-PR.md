# Lote 3B — Primeiro PR de implementação

## Status

**Proposta documental — aguardando aprovação humana. Nenhum código está autorizado por este arquivo.**

## Objetivo

Validar a arquitetura de adapters Supabase com o menor corte vertical possível, antes de implementar fontes, currículo, componentes ou OPP.

## Adapter escolhido

`AuditRepository`

Motivo:

- uma porta;
- uma tabela (`kf_audit_events`);
- apenas append e leitura;
- sem transação multi-tabela;
- sem alteração de porta;
- sem RLS de requester no primeiro corte;
- sem regra pedagógica;
- prova client injection, mapper, erros, observabilidade e CI descartável.

## Branch futura

`feat/knowledge-factory-supabase-audit-adapter`

## Título previsto

`feat(knowledge-factory): add Supabase audit repository adapter`

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
│   │   └── supabase-system-context.ts
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

Alteração opcional e estritamente necessária:

`.github/workflows/knowledge-factory-db-ci.yml`

somente para executar os testes de integração TypeScript contra o stack descartável já existente.

## Dependências propostas

### Runtime

- `@supabase/supabase-js` na linha de versão já adotada pelo monorepo.

### Workspace/compilação

- `@profeplan/knowledge-factory`;
- `@profeplan/types`.

No início da implementação, confirmar quais símbolos são runtime versus `import type` para declarar apenas dependências reais.

Nenhuma outra dependência externa está autorizada.

## Interface implementada

```text
AuditRepository
├── append(event)
└── listByAggregate(aggregateId)
```

Não alterar a porta.

## Mapeamento

### append

Contrato `DomainEvent` → `public.kf_audit_events`:

- `eventType` → `event_type`;
- `aggregateType` → `aggregate_type`;
- `aggregateId` → `aggregate_id`;
- `occurredAt` → `occurred_at`;
- `metadata` → `metadata`.

Campos físicos não presentes no `DomainEvent`, como `actor_id`, `actor_role`, `correlation_id`, `outcome` e `reason`, não serão inventados a partir de contexto implícito.

Se precisarem ser preenchidos no futuro, isso exige contexto/contrato explicitamente aprovado.

### listByAggregate

SELECT explícito apenas das colunas necessárias para reconstruir `DomainEvent`.

Filtro obrigatório:

`aggregate_id = <id>`

Ordenação:

`occurred_at ASC`, com desempate determinístico por `created_at`/`id` se necessário e documentado na implementação.

## Cliente Supabase

O constructor/factory do adapter recebe um `SupabaseClient` já configurado.

É proibido no pacote:

- `process.env`;
- `createClient()`;
- import de `api/_lib/supabaseAdmin`;
- chave hardcoded;
- placeholder de credencial.

A integração descartável do teste criará o client fora do adapter.

## Append-only

`append()` usa INSERT.

Nunca usar:

- UPSERT;
- UPDATE;
- DELETE.

O adapter não expõe métodos que permitam essas operações.

O trigger físico do Lote 3A continuará testado como defesa final.

## Erros

Implementar apenas a taxonomia aprovada no documento de erros/observabilidade.

O PR deve demonstrar ao menos:

- permission denied → `FORBIDDEN`;
- network/timeout → `UNAVAILABLE`;
- resposta inválida → `INVALID_RESPONSE`;
- desconhecido → `UNKNOWN`.

Não há unique key funcional específica para audit events no schema atual; `CONFLICT` não precisa ser artificialmente provocado neste primeiro adapter.

## Observabilidade

Interface mínima injetada.

O adapter registra somente:

- operação;
- duração;
- outcome;
- aggregate type/id;
- correlation id quando explicitamente fornecido;
- erro estável.

Nunca logar evento completo ou metadata arbitrária.

## Testes unitários

Obrigatórios:

1. mapper contrato → row/payload;
2. mapper row → contrato;
3. optional/null;
4. `append` usa `.insert`, não `.upsert`;
5. `listByAggregate` filtra ID;
6. ordenação determinística;
7. lista vazia retorna `[]`;
8. provider error é traduzido;
9. telemetria success/failure;
10. secret/payload não aparece na telemetria.

## Testes de integração

No Supabase descartável:

1. inserir dois eventos sintéticos de aggregate A;
2. inserir um evento de aggregate B;
3. listar A e obter apenas A em ordem;
4. reconstruir `DomainEvent` corretamente;
5. confirmar persistência em `kf_audit_events`;
6. provar trigger append-only para UPDATE;
7. provar trigger append-only para DELETE;
8. DB lint verde;
9. ambiente destruído ao final.

Nenhum dado real.

## CI

O PR deve passar:

- typecheck do novo pacote;
- unitários do pacote;
- CI geral;
- integração no `Knowledge Factory DB CI` ou composição direta do mesmo stack;
- zero secrets hospedadas necessárias.

## Story

Recebe proposta de:

`US-013.2 — Ready for Code: persistence adapter slice`

O PR não conclui a Story inteira.

## Fora do escopo

- KnowledgeSourceRepository;
- PedagogicalComponentRepository;
- CurriculumRepository;
- ProductionOrderRepository;
- API;
- production wiring;
- migration nova;
- RPC;
- frontend;
- retrieval;
- embeddings;
- agentes;
- PNLD real;
- currículo real;
- Nexus;
- produção.

## Rollback

Rollback de código por revert do PR.

Nenhuma migration, dado real ou configuração de produção será criada.

## Gates de parada

Parar se for necessário:

- modificar `AuditRepository`;
- criar migration/RPC;
- acessar produção;
- usar secret hospedada;
- adicionar dependência além das autorizadas;
- incluir outra porta no mesmo PR;
- logar conteúdo/metadata integral.

## Critério para considerar pronto

Somente quando:

- diff restrito ao escopo;
- todos os testes verdes;
- DB CI descartável verde;
- CI geral verde;
- revisão de secrets/redaction concluída;
- nenhuma produção tocada;
- checkpoint do primeiro adapter criado.

Não fazer merge automático.
