# CONTINUITY CHECKPOINT 027 — Lote 3B.5.1 contratos e contextos

Data: 11 de agosto de 2026.

## Status

**O Lote 3B.5.1 — contratos e contextos foi implementado em branch isolada e está preparado para
revisão humana. Nenhum adapter, migration, RPC, grant, RLS, wiring, Supabase hospedado ou produção
foi alterado. `GAP-3B-03` e `GAP-3B-07` permanecem ativos.**

## Repositório e continuidade

- repositório: `PaulinhoRehfeld/profeplan`;
- branch padrão: `main`;
- branch técnica: `agent/knowledge-factory-lot-3b5-1-contracts`;
- base e merge-base esperados: `dc52b843094236207ab7aa22b12cbb97f02aab11`;
- origem da base: squash merge do Pull Request nº 24;
- definição governante: `12-delivery/LOT-3B5-PRODUCTION-ORDER-REPOSITORY-DEFINITION.md`;
- Pull Request técnico: a registrar após publicação;
- estado inicial exigido: draft.

## Escopo implementado

### Contrato compartilhado 3.0.0

- `KNOWLEDGE_FACTORY_CONTRACT_VERSION` elevado de `2.0.0` para `3.0.0`;
- operações fechadas `create_production_order` e `transition_production_order` publicadas;
- `CreateProductionOrderCommand` publicado sem requester, status ou timestamps derivados;
- `TransitionProductionOrderCommand` publicado com ownership, estado e timestamp esperados;
- `ProductionOrderWriteReceipt` provider-neutral publicado;
- comandos, snapshots e recibo declarados somente leitura;
- lista de operações congelada em runtime;
- fixtures exclusivamente sintéticas adicionadas para criação, transição e recibo.

O contrato `3.0.0` preserva sem alteração a superfície de escrita de componentes aprovada no
contrato `2.0.0`.

### Porta de domínio

- `ProductionOrderReadRepository` contém somente `findById` e `listEvents`;
- `ProductionOrderRequestRepository` contém somente `createProductionOrder`;
- `ProductionOrderTransitionRepository` contém somente `transitionProductionOrder`;
- `ProductionOrderRepository` compõe as três capacidades;
- `save(order)` e `appendEvent(event)` foram removidos sem alias, overload, wrapper ou stub;
- criação e transição retornam `ProductionOrderWriteReceipt`.

### Contexto REQUESTER

- `SupabaseRequesterContext` publicado no pacote de infraestrutura;
- superfície limitada ao `SupabaseClient` injetado e ao `requesterId` que o composition root deverá
  derivar da identidade verificada;
- ambos os campos são somente leitura;
- nenhum token, sessão, env, `createClient()`, `getUser()`, renovação ou cache foi introduzido;
- nenhum adapter utiliza o contexto neste sublote.

### Provas contratuais

- type tests cobrem as superfícies exatas das três capacidades e da composição;
- type tests cobrem assinaturas e recibos dos dois comandos;
- type tests provam que requester, status e timestamps não pertencem ao payload de criação;
- type tests provam imutabilidade e ausência de `save` e `appendEvent`;
- type tests cobrem a superfície mínima e imutável do contexto REQUESTER;
- busca acumulada confirmou ausência de consumidores operacionais dos métodos removidos.

## Validações específicas

- `@profeplan/types`: typecheck verde e 13/13 testes;
- `@profeplan/knowledge-factory`: typecheck verde e 21/21 testes;
- `@profeplan/knowledge-factory-supabase`: typecheck verde e 118/118 testes unitários;
- formatter, lint, typecheck e build equivalentes ao CI geral: verdes;
- `@profeplan/agents`: 178/178 testes acumulados;
- `apps/web`: 87/87 testes acumulados;
- nenhum manifesto, dependência ou lockfile alterado;
- integração de banco não aplicável, pois não há SQL, migration, RPC ou DML.

Os checks remotos deverão ser registrados após a publicação do Pull Request draft.

## Estado dos GAPs

### GAP-3B-03

Permanece ativo. A porta já impede pseudo-transação por métodos independentes, mas o encerramento
ainda exige adapter REQUESTER read-only, RPCs atômicas, grants mínimos, rollback, idempotência,
concorrência, adapters de comando exclusivos das RPCs, integração dos sublotes 3B.5.2 a 3B.5.4 e
checkpoint pós-merge.

### GAP-3B-07

Permanece ativo. O contrato `3.0.0` expressa somente a fatia física mínima já aprovada e não
materializa a OPP normativa completa, atores, sequência, correlação, contexto, inclusão, retrieval,
validação ou entrega.

`GAP-3B-04` e `GAP-3B-05` permanecem ativos e fora deste sublote.

## Itens expressamente ausentes

- adapter ou mapper de OPP;
- query, DML, RPC, migration, tabela de recibos, função, grant, policy, trigger ou índice;
- criação de client, parsing de sessão, autenticação ou composição REQUESTER;
- fallback REQUESTER para SYSTEM;
- alteração de erro provider-neutral ou telemetria;
- API, frontend, composition root, wiring, worker ou Edge Function;
- Supabase hospedado, secret, dado real ou produção;
- início dos sublotes 3B.5.2, 3B.5.3 ou 3B.5.4;
- encerramento de GAP, do Lote 3B.5 ou da Fase B;
- início da Fase C;
- merge ou auto-merge.

## Próximo gate humano

Revisar o Pull Request draft do 3B.5.1 e autorizar — ou não — sua integração controlada.

Mesmo se este sublote for integrado, o 3B.5.2 — adapter REQUESTER read-only permanecerá bloqueado
até nova autorização explícita. Nenhuma continuidade implícita autoriza adapter, migration, RPC,
banco hospedado ou produção.
