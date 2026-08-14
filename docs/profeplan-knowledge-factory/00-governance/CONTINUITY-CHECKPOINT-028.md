# CONTINUITY CHECKPOINT 028 — Sublote 3B.5.2 implementado para revisão

Data: 11 de agosto de 2026.

## Status

**O Sublote 3B.5.2 — adapter REQUESTER read-only do `ProductionOrderRepository` foi implementado em
branch isolada e está preparado para revisão humana. Nenhuma publicação, Pull Request, merge,
migration, RPC, capacidade de comando, wiring, Supabase hospedado ou produção foi realizada.**

## Base e branch

- repositório canônico: `PaulinhoRehfeld/profeplan`;
- branch-base: `main`;
- commit-base: `a25acd014c213ce7552105a538fea5f0bd07037e`;
- origem da base: squash merge do Pull Request nº 25;
- branch técnica: `feat/knowledge-factory-supabase-production-order-requester-readonly`;
- definição vinculante:
  `12-delivery/LOT-3B5-PRODUCTION-ORDER-REPOSITORY-DEFINITION.md`.

## Escopo implementado

### Capacidade read-only

`SupabaseProductionOrderReadRepository` implementa exclusivamente:

- `findById(id)`;
- `listEvents(oppId)`.

A classe é atribuível a `ProductionOrderReadRepository`, mas deliberadamente não implementa
`ProductionOrderRequestRepository`, `ProductionOrderTransitionRepository` nem a composição total
`ProductionOrderRepository`.

### Fronteira REQUESTER

- recebe `SupabaseRequesterContext` por injeção;
- exige `requesterId` não vazio antes de qualquer chamada ao provider;
- não cria client, não lê sessão, token ou ambiente;
- não chama `getUser()` e não renova autenticação;
- não aceita requester por parâmetro dos métodos;
- nunca substitui REQUESTER por SYSTEM;
- não registra requester, client ou credencial na telemetria.

### Leitura e mapeamento

- `findById` consulta `kf_production_orders` por `id` com colunas explícitas;
- OPP ocultada pela RLS permanece indistinguível de ausente e retorna `null`;
- OPP hidratada deve possuir `requester_id` igual ao contexto esperado;
- `listEvents` consulta `kf_production_order_events` por `opp_id`;
- OPP alheia produz lista vazia pela RLS;
- eventos são ordenados por `occurred_at ASC, id ASC`;
- rows e enums inválidos resultam em `INVALID_RESPONSE` provider-neutral;
- mismatch de ownership hidratado resulta em `FORBIDDEN` sanitizado.

## Provas adicionadas

### Unitários e type tests

- superfície exata de dois métodos;
- ausência das capacidades de comando;
- colunas fechadas e mappers estritos;
- SQL `null` convertido somente para opcionais do contrato;
- validação de enums, timestamps, duração e identidade;
- ausência legítima e ocultação RLS;
- rejeição de row com requester incompatível;
- ordenação determinística de eventos;
- identidade ausente falha antes do provider;
- tradução e sanitização de erros;
- telemetria allowlisted sem requester ou credencial;
- inspeção estática contra DML, RPC, criação de client, ambiente e SYSTEM fallback.

### Integração descartável

O teste `production-order.integration.test.mjs` prepara dois usuários sintéticos A/B, OPPs e eventos
em Supabase descartável e comprova:

- A lê somente OPP A e eventos A;
- B lê somente OPP B e eventos B;
- OPP estrangeira retorna `null`;
- eventos estrangeiros retornam lista vazia;
- ordenação por instante e ID;
- contagens de OPPs e eventos não mudam durante as chamadas do adapter.

O stack Supabase/Docker não estava disponível na sessão local. O teste integrado será executado
pelo `Knowledge Factory DB CI`, que sobe ambiente descartável e injeta somente credenciais efêmeras.
Nenhum Supabase hospedado foi usado como substituto.

## Validação local

- Prettier específico: aprovado;
- typecheck de `@profeplan/knowledge-factory-supabase`: aprovado;
- suíte unitária acumulada do pacote: 132/132 aprovada;
- testes unitários novos do adapter: 14 aprovados;
- formatter, lint, typecheck, build e suíte geral equivalentes ao CI: aprovados;
- lockfile: sem alteração de dependência;
- `git diff --check`: aprovado;
- teste integrado: preparado, não executável localmente sem stack descartável.

## Exclusões preservadas

Não fazem parte deste sublote:

- `createProductionOrder` ou `transitionProductionOrder`;
- `.insert()`, `.update()`, `.upsert()` ou `.delete()`;
- qualquer RPC;
- migration, tabela de recibos, grant, policy, trigger ou índice;
- autenticação, parsing de sessão, criação de client ou composition root;
- API, frontend, worker, fila, agente ou material pedagógico real;
- Supabase hospedado, deploy ou produção;
- início do 3B.5.3 ou 3B.5.4;
- encerramento de `GAP-3B-03`, `GAP-3B-07` ou da Fase B;
- merge automático.

## Estado de continuidade

- ✅ Lote 3B.4 integrado e concluído;
- ✅ definição documental do Lote 3B.5 integrada;
- ✅ 3B.5.1 — contratos `3.0.0` e contexto REQUESTER integrado;
- 🔵 3B.5.2 — adapter REQUESTER read-only implementado e em revisão;
- ⬜ 3B.5.3 — migration e RPCs não iniciado;
- ⬜ 3B.5.4 — adapters de comando não iniciado;
- 🟡 `GAP-3B-03` permanece ativo;
- 🟡 `GAP-3B-07` permanece ativo;
- 🟡 Fase B permanece aberta.

## Próximo gate humano

Revisar o diff completo do 3B.5.2, executar os gates gerais e preparar um commit local verificável.
Qualquer push e abertura de Pull Request draft exigirá autorização explícita vinculada ao commit e
ao repositório canônico.

Mesmo após eventual integração do 3B.5.2, o 3B.5.3 permanecerá bloqueado até nova autorização
explícita. Nenhuma autorização de continuidade será inferida.
